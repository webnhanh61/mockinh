/**
 * Tên file: settings_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình cài đặt ứng dụng Mộc Kinh. Đã tích hợp trọn vẹn giao diện cấu hình Âm thanh không gian (Volume & Tracks). [WEBVNZ.COM]
 */
library;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import '../../providers/settings_provider.dart';
import '../../providers/audio_provider.dart'; // Import thêm AudioProvider

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF3EBE1);
    final textColor = Theme.of(context).colorScheme.onSurface;

    // Tìm tên bài nhạc đang phát để hiển thị làm subtitle
    String currentTrackName = '';
    if (audioProvider.isLoaded) {
      final currentTrack = audioProvider.audioTracks.firstWhere(
        (track) => track['id'] == audioProvider.selectedTrack,
        orElse: () => {'name': 'Không xác định'},
      );
      currentTrackName = currentTrack['name'] ?? '';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cài Đặt')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildSectionTitle('GIAO DIỆN & TRẢI NGHIỆM'),

              _buildListTile(
                icon: Remix.moon_line,
                title: 'Chế độ nền tối (Dark Mode)',
                cardColor: cardColor,
                textColor: textColor,
                trailing: Switch(
                  value: settingsProvider.isDarkMode,
                  onChanged: (val) {
                    settingsProvider.toggleTheme(val);
                  },
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                ),
              ),

              _buildListTile(
                icon: Remix.font_size,
                title: 'Kích thước chữ mặc định',
                subtitle: settingsProvider.fontSizeLabel,
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {
                  _showFontSizeSheet(
                    context,
                    cardColor,
                    textColor,
                    settingsProvider,
                  );
                },
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('TIỆN ÍCH'),

              _buildListTile(
                icon: Remix.notification_badge_line,
                title: 'Nhắc nhở tụng kinh',
                subtitle: settingsProvider.isReminderEnabled
                    ? settingsProvider.reminderTimeLabel
                    : 'Đang tắt',
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {
                  _showTimePickerSheet(
                    context,
                    cardColor,
                    textColor,
                    settingsProvider,
                  );
                },
                trailing: Switch(
                  value: settingsProvider.isReminderEnabled,
                  onChanged: (val) {
                    settingsProvider.toggleReminder(val);
                  },
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                ),
              ),

              _buildListTile(
                icon: Remix.volume_up_line,
                title: 'Âm thanh không gian',
                subtitle: audioProvider.isAudioEnabled
                    ? currentTrackName
                    : 'Đang tắt',
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {
                  _showAudioSettingsSheet(
                    context,
                    cardColor,
                    textColor,
                    audioProvider,
                  );
                },
                trailing: Switch(
                  value: audioProvider.isAudioEnabled,
                  onChanged: (val) {
                    audioProvider.toggleAudio(val);
                  },
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('THÔNG TIN'),
              _buildListTile(
                icon: Remix.information_line,
                title: 'Về ứng dụng Mộc Kinh',
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {
                  _showAboutAppDialog(context, cardColor, textColor);
                },
              ),
              _buildListTile(
                icon: Remix.star_line,
                title: 'Đánh giá ứng dụng',
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {},
              ),
              const SizedBox(height: 40),

              Center(
                child: Column(
                  children: [
                    Icon(
                      Remix.leaf_line,
                      color: Colors.grey.withValues(alpha: 0.5),
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mộc Kinh v1.0.0',
                      style: TextStyle(
                        color: Colors.grey.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 8.0, top: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.withValues(alpha: 0.8),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required Color cardColor,
    required Color textColor,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 4.0,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(icon, color: const Color(0xFF8B5A2B), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: TextStyle(color: Colors.grey.shade600))
            : null,
        trailing:
            trailing ??
            Icon(
              Remix.arrow_right_s_line,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
        onTap: onTap,
      ),
    );
  }

  void _showAudioSettingsSheet(
    BuildContext context,
    Color bgColor,
    Color textColor,
    AudioProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tùy chỉnh Âm thanh',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Thanh trượt âm lượng
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Icon(
                        Remix.volume_down_line,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: provider.volume,
                          min: 0.0,
                          max: 1.0,
                          activeColor: Theme.of(context).primaryColor,
                          inactiveColor: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.2),
                          onChanged: (value) {
                            provider.setVolume(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Remix.volume_up_fill,
                        color: Colors.grey.shade500,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // Danh sách bài nhạc
                ...provider.audioTracks.map((track) {
                  final isSelected = provider.selectedTrack == track['id'];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    title: Text(
                      track['name']!,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : textColor,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(
                      Remix.music_2_line,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade500,
                    ),
                    trailing: isSelected
                        ? Icon(
                            Remix.check_line,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    onTap: () {
                      provider.changeTrack(track['id']!);
                      if (!provider.isAudioEnabled) {
                        provider.toggleAudio(true); // Tự động bật nếu đang tắt
                      }
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTimePickerSheet(
    BuildContext context,
    Color bgColor,
    Color textColor,
    SettingsProvider provider,
  ) {
    int selectedHour = provider.reminderHour;
    int selectedMinute = provider.reminderMinute;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 320,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        'Chọn giờ nhắc nhở',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.updateReminderTime(
                            selectedHour,
                            selectedMinute,
                          );
                          if (!provider.isReminderEnabled) {
                            provider.toggleReminder(true);
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Xong',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedHour,
                          ),
                          itemExtent: 50.0,
                          selectionOverlay:
                              CupertinoPickerDefaultSelectionOverlay(
                                background: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.1),
                              ),
                          onSelectedItemChanged: (int index) {
                            selectedHour = index;
                          },
                          children: List<Widget>.generate(24, (int index) {
                            return Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedMinute,
                          ),
                          itemExtent: 50.0,
                          selectionOverlay:
                              CupertinoPickerDefaultSelectionOverlay(
                                background: Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.1),
                              ),
                          onSelectedItemChanged: (int index) {
                            selectedMinute = index;
                          },
                          children: List<Widget>.generate(60, (int index) {
                            return Center(
                              child: Text(
                                index.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFontSizeSheet(
    BuildContext context,
    Color bgColor,
    Color textColor,
    SettingsProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Chọn kích thước chữ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildFontSizeOption(context, 'Nhỏ', 18.0, textColor, provider),
                _buildFontSizeOption(
                  context,
                  'Vừa (Mặc định)',
                  24.0,
                  textColor,
                  provider,
                ),
                _buildFontSizeOption(context, 'Lớn', 32.0, textColor, provider),
                _buildFontSizeOption(
                  context,
                  'Rất Lớn',
                  40.0,
                  textColor,
                  provider,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFontSizeOption(
    BuildContext context,
    String label,
    double size,
    Color textColor,
    SettingsProvider provider,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      title: Text(label, style: TextStyle(color: textColor, fontSize: 16)),
      leading: Icon(
        Remix.font_size,
        color: provider.fontSize == size
            ? Theme.of(context).primaryColor
            : textColor,
      ),
      trailing: provider.fontSize == size
          ? Icon(Remix.check_line, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        provider.setFontSize(size);
        Navigator.pop(context);
      },
    );
  }

  void _showAboutAppDialog(
    BuildContext context,
    Color bgColor,
    Color textColor,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            children: [
              Icon(Remix.leaf_line, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text('Về Mộc Kinh', style: TextStyle(color: textColor)),
            ],
          ),
          content: Text(
            'Mộc Kinh là ứng dụng đọc kinh Phật được thiết kế tối giản, loại bỏ những yếu tố dư thừa để mang lại trải nghiệm đọc tĩnh tâm và an lạc nhất.\n\n'
            'Phiên bản: 1.0.0\n'
            'Phát triển bởi: WebVNZ\n'
            'Bản quyền © 2026',
            style: TextStyle(color: textColor, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Đóng',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
