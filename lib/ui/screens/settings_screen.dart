/**
 * Tên file: settings_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình cài đặt ứng dụng Mộc Kinh, quản lý cấu hình giao diện (Dark Mode) và các tiện ích khác. [WEBVNZ.COM]
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFF3EBE1);
    final textColor = Theme.of(context).colorScheme.onSurface;

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
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),

              _buildListTile(
                icon: Remix.font_size,
                title: 'Kích thước chữ mặc định',
                subtitle: 'Vừa',
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {},
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('TIỆN ÍCH'),
              _buildListTile(
                icon: Remix.notification_badge_line,
                title: 'Nhắc nhở tụng kinh',
                subtitle: 'Đang tắt',
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {},
              ),
              _buildListTile(
                icon: Remix.volume_up_line,
                title: 'Âm thanh không gian',
                cardColor: cardColor,
                textColor: textColor,
                trailing: Switch(
                  value: true,
                  onChanged: (val) {},
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('THÔNG TIN'),
              _buildListTile(
                icon: Remix.information_line,
                title: 'Về ứng dụng Mộc Kinh',
                cardColor: cardColor,
                textColor: textColor,
                onTap: () {},
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
                      color: Colors.grey.withOpacity(0.5),
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mộc Kinh v1.0.0',
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
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
            color: Colors.grey.withOpacity(0.8),
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
            Icon(Remix.arrow_right_s_line, color: Colors.grey.withOpacity(0.6)),
        onTap: onTap,
      ),
    );
  }
}
