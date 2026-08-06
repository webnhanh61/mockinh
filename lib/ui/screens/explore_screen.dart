/**
 * Tên file: explore_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình khám phá các chủ đề kinh và lời Phật dạy, tương thích hoàn toàn giao diện Dark Mode. [WEBVNZ.COM]
 */

import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dữ liệu chủ đề giả lập
    final List<Map<String, dynamic>> categories = [
      {'title': 'Thiền Định', 'icon': Remix.leaf_line, 'color': 0xFF5B7065},
      {'title': 'Cầu An', 'icon': Remix.heart_3_line, 'color': 0xFF8B5A2B},
      {'title': 'Sám Hối', 'icon': Remix.water_flash_line, 'color': 0xFF6B705C},
      {
        'title': 'Trí Tuệ',
        'icon': Remix.lightbulb_flash_line,
        'color': 0xFFD4A373,
      },
    ];

    // Xác định màu sắc theo Theme hiện tại
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('Khám Phá')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lời Phật dạy (Trích dẫn trong ngày)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5A2B), Color(0xFF6B4521)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.5)
                          : const Color(0xFF8B5A2B).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Remix.double_quotes_l,
                      color: Colors.white.withOpacity(0.5),
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hàng ngàn ngọn nến có thể được thắp sáng từ một ngọn nến duy nhất, và cuộc đời của ngọn nến ấy sẽ không bị tàn lụi. Hạnh phúc không bao giờ cạn đi khi được chia sẻ.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '- Đức Phật -',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Chủ đề kinh
              Text(
                'Chủ Đề Tìm Kiếm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Đổi màu chữ theo theme
                ),
              ),
              const SizedBox(height: 16),

              // Grid hiển thị các chủ đề
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor, // Đổi màu thẻ theo theme
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          // TODO: Mở màn hình danh sách kinh theo chủ đề
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                cat['icon'],
                                color: isDark
                                    ? Color(cat['color']).withOpacity(0.9)
                                    : Color(cat['color']),
                                size: 28,
                              ),
                              const Spacer(),
                              Text(
                                cat['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: textColor, // Đổi màu chữ theo theme
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
