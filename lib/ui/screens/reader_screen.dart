/**
 * Tên file: reader_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình đọc kinh tự động cuộn chữ, tối ưu hiển thị font chữ và màu sắc cho Dark Mode. [WEBVNZ.COM]
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart'; // Import Remix Icon
import 'dart:async'; // Bổ sung thư viện cho Timer

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({Key? key}) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool _isMenuVisible = true;
  double _fontSize = 24.0;
  double _scrollSpeed = 1.0;

  // --- Biến cho Auto-scroll ---
  late ScrollController _scrollController;
  bool _isUserScrolling = false;
  Timer? _resumeTimer;
  // ----------------------------

  @override
  void initState() {
    super.initState();
    // Bật chế độ Immersive để ẩn thanh trạng thái và thanh điều hướng
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    // Trả lại thanh trạng thái bình thường khi thoát khỏi màn hình đọc
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Dọn dẹp bộ nhớ
    _scrollController.dispose();
    _resumeTimer?.cancel();

    super.dispose();
  }

  // Hàm quản lý Auto-scroll bằng animateTo (mượt hơn và không xung đột Physics)
  void _updateAutoScroll({bool forceStop = false}) {
    if (!mounted || !_scrollController.hasClients) return;

    // Nếu người dùng đang tự vuốt tay, KHÔNG can thiệp
    if (_isUserScrolling) return;

    // Dừng cuộn tự động nếu: Menu đang mở, tốc độ = 0, hoặc bị buộc dừng
    if (forceStop || _isMenuVisible || _scrollSpeed == 0) {
      _scrollController.jumpTo(_scrollController.offset);
      return;
    }

    // Tính toán khoảng cách để tự động cuộn
    final maxExtent = _scrollController.position.maxScrollExtent;
    final currentOffset = _scrollController.offset;
    final distance = maxExtent - currentOffset;

    if (distance > 0) {
      // Tốc độ 1.0 tương đương ~ 30px / giây
      final durationSeconds = distance / (_scrollSpeed * 30);
      if (durationSeconds > 0) {
        _scrollController.animateTo(
          maxExtent,
          duration: Duration(milliseconds: (durationSeconds * 1000).toInt()),
          curve: Curves.linear,
        );
      }
    }
  }

  void _toggleMenu() {
    setState(() {
      _isMenuVisible = !_isMenuVisible;
    });
    _updateAutoScroll(); // Bật/tắt cuộn khi ẩn/hiện menu
  }

  void _showSettingsSheet() {
    // Xác định màu nền BottomSheet theo theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBgColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;

    showModalBottomSheet(
      context: context,
      backgroundColor: sheetBgColor, // Màu nền động
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
                        color: textColor, // Chữ động theo theme
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Chỉnh cỡ chữ
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
                            value: _fontSize,
                            min: 16.0,
                            max: 48.0,
                            activeColor: Theme.of(context).colorScheme.primary,
                            inactiveColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            onChanged: (value) {
                              setModalState(() => _fontSize = value);
                              setState(() => _fontSize = value);
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

                    // Chỉnh tốc độ cuộn
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
                            inactiveColor: Colors.teal.withOpacity(0.2),
                            onChanged: (value) {
                              setModalState(() => _scrollSpeed = value);
                              setState(() {
                                _scrollSpeed = value;
                                _updateAutoScroll(); // Cập nhật cuộn ngay khi kéo thanh tốc độ
                              });
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nhận dữ liệu dưới dạng Map<String, dynamic>
    final Map<String, dynamic>? kinhData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final title = kinhData?['title'] ?? 'Nội dung kinh';
    final content = kinhData?['content'] ?? 'Nội dung đang được cập nhật...';

    // Xác định màu chữ động theo theme cho toàn bộ văn bản kinh
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Nội dung kinh dạng cuộn
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
                    _updateAutoScroll();
                    _resumeTimer?.cancel();
                  } else if (notification is ScrollEndNotification) {
                    if (_isUserScrolling) {
                      _resumeTimer = Timer(const Duration(seconds: 2), () {
                        if (mounted) {
                          _isUserScrolling = false;
                          _updateAutoScroll();
                        }
                      });
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
                          fontSize: _fontSize + 4,
                          fontWeight: FontWeight.bold,
                          color: textColor, // Đổi màu chữ theo theme
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        content, // Nội dung động
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: _fontSize,
                          height: 2.0,
                          color: textColor, // Đổi màu chữ theo theme
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Thanh trạng thái tuỳ chỉnh (AppBar ảo)
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
                    Colors.black.withOpacity(
                      0.6,
                    ), // Tăng nhẹ opacity để nổi bật nút back
                    Colors.black.withOpacity(0.0),
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
            ),
          ),
        ],
      ),
    );
  }
}
