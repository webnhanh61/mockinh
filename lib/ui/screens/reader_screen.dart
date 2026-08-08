/**
 * Tên file: reader_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình đọc kinh tự động cuộn chữ, ghi nhớ vị trí đọc khi thoát ra, tích hợp Wakelock, Bookmark, Hẹn giờ tắt và ghi nhận Nhật ký tu tập. [WEBVNZ.COM]
 */
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'dart:async';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../providers/settings_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/reading_history_provider.dart';
import '../../providers/practice_provider.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool _isMenuVisible = true;
  double _scrollSpeed = 1.0;

  // --- Biến cho Auto-scroll và History ---
  late ScrollController _scrollController;
  bool _isUserScrolling = false;
  Timer? _resumeTimer;
  Timer? _initialTimer;
  bool _isInit = false;
  String _kinhId = '';
  late ReadingHistoryProvider _historyProvider;
  late PracticeProvider _practiceProvider;

  // --- Biến cho Hẹn giờ tắt ---
  Timer? _sleepTimer;
  int _sleepMinutesRemaining = 0;
  bool _isSleepTimerActive = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WakelockPlus.enable();

    _initialTimer = Timer(const Duration(milliseconds: 1250), () {
      if (mounted && _isMenuVisible) {
        _toggleMenu();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final Map<String, dynamic>? kinhData =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _kinhId = kinhData?['id'] ?? '';

      _historyProvider = Provider.of<ReadingHistoryProvider>(
        context,
        listen: false,
      );
      _practiceProvider = Provider.of<PracticeProvider>(context, listen: false);

      final savedOffset = _historyProvider.getScrollOffset(_kinhId);

      _scrollController = ScrollController(initialScrollOffset: savedOffset);
      _isInit = true;
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WakelockPlus.disable();

    // Lưu lại vị trí cuộn và ghi nhận nhật ký tu tập trước khi đóng
    if (_scrollController.hasClients && _kinhId.isNotEmpty) {
      _historyProvider.saveScrollOffset(_kinhId, _scrollController.offset);
      _practiceProvider.logPractice();
    }

    _scrollController.dispose();
    _resumeTimer?.cancel();
    _initialTimer?.cancel();
    _sleepTimer?.cancel();

    super.dispose();
  }

  void _updateAutoScroll({bool forceStop = false}) {
    if (!mounted || !_scrollController.hasClients) return;

    if (forceStop || _isMenuVisible || _scrollSpeed == 0 || _isUserScrolling) {
      _scrollController.jumpTo(_scrollController.offset);
      return;
    }

    final maxExtent = _scrollController.position.maxScrollExtent;
    final currentOffset = _scrollController.offset;
    final distance = maxExtent - currentOffset;

    if (distance > 0) {
      final durationMs = (distance / (_scrollSpeed * 30) * 1000).toInt();
      if (durationMs > 0) {
        _scrollController.animateTo(
          maxExtent,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.linear,
        );
      }
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
    _updateAutoScroll();
  }

  // Khởi động bộ đếm hẹn giờ tắt
  void _startSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    setState(() {
      _sleepMinutesRemaining = minutes;
      _isSleepTimerActive = true;
    });

    _sleepTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _sleepMinutesRemaining--;
      });

      if (_sleepMinutesRemaining <= 0) {
        timer.cancel();
        _handleSleepTimeout();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sẽ tự động tắt sau $minutes phút nữa.'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Xử lý khi hết giờ
  void _handleSleepTimeout() {
    // Lưu lại trạng thái
    if (_scrollController.hasClients && _kinhId.isNotEmpty) {
      _historyProvider.saveScrollOffset(_kinhId, _scrollController.offset);
      _practiceProvider.logPractice();
    }

    // Thoát về trang trước
    Navigator.of(context).pop();
  }

  void _showSettingsSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBgColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cài đặt hiển thị',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Icon(
                          Remix.font_size,
                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Slider(
                            value: settingsProvider.fontSize,
                            min: 16.0,
                            max: 48.0,
                            activeColor: Theme.of(context).colorScheme.primary,
                            inactiveColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.2),
                            onChanged: (value) {
                              setModalState(() {});
                              settingsProvider.setFontSize(value);

                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  _updateAutoScroll();
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Remix.font_size_2,
                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                          size: 28,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Icon(
                          Remix.speed_mini_fill,
                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Slider(
                            value: _scrollSpeed,
                            min: 0.0,
                            max: 5.0,
                            activeColor: Colors.teal,
                            inactiveColor: Colors.teal.withValues(alpha: 0.2),
                            onChanged: (value) {
                              setModalState(() => _scrollSpeed = value);
                              setState(() {
                                _scrollSpeed = value;
                              });
                              _updateAutoScroll();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Remix.rocket_2_fill,
                          color: isDark ? Colors.grey.shade400 : Colors.grey,
                          size: 24,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Text(
                      'Hẹn giờ tắt',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTimerOption(15, setModalState),
                        _buildTimerOption(30, setModalState),
                        _buildTimerOption(45, setModalState),
                        _buildTimerOption(60, setModalState),
                        if (_isSleepTimerActive)
                          GestureDetector(
                            onTap: () {
                              _sleepTimer?.cancel();
                              setState(() {
                                _isSleepTimerActive = false;
                                _sleepMinutesRemaining = 0;
                              });
                              setModalState(() {});
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Hủy',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimerOption(int minutes, StateSetter setModalState) {
    final bool isSelected =
        _isSleepTimerActive &&
        _sleepMinutesRemaining > 0 &&
        _sleepMinutesRemaining <= minutes &&
        (_sleepMinutesRemaining > minutes - 15 || minutes == 15);
    return GestureDetector(
      onTap: () {
        _startSleepTimer(minutes);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          '${minutes}p',
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? kinhData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String title = kinhData?['title'] ?? 'Nội dung kinh';
    final String content =
        kinhData?['content'] ?? 'Nội dung đang được cập nhật...';

    final textColor = Theme.of(context).colorScheme.onSurface;
    final fontSize = Provider.of<SettingsProvider>(context).fontSize;
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);

    final bool isSaved = bookmarkProvider.isBookmarked(_kinhId);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Nội dung kinh
          GestureDetector(
            onTap: _toggleMenu,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollStartNotification &&
                      notification.dragDetails != null) {
                    _isUserScrolling = true;
                    _resumeTimer?.cancel();
                  } else if (notification is ScrollEndNotification) {
                    if (_isUserScrolling) {
                      _isUserScrolling = false;
                      _resumeTimer = Timer(
                        const Duration(milliseconds: 1250),
                        () {
                          if (mounted) _updateAutoScroll();
                        },
                      );
                    }
                  }
                  return false;
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 80.0,
                    bottom: 120.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize + 4,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        content,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 2.0,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Thanh trạng thái (Menu ảo)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _isMenuVisible ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 32,
                bottom: 12,
                left: 8,
                right: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Remix.arrow_left_s_line,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      if (_isSleepTimerActive)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Remix.timer_line,
                                color: Colors.orangeAccent,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_sleepMinutesRemaining p',
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      IconButton(
                        icon: Icon(
                          isSaved ? Remix.heart_3_fill : Remix.heart_3_line,
                          color: isSaved ? Colors.redAccent : Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          if (kinhData != null) {
                            bookmarkProvider.toggleBookmark(kinhData);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Remix.settings_4_line,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _showSettingsSheet,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
