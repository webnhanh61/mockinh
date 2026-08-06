/**
 * Tên file: home_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình mục lục danh sách các bài kinh, giao diện tương thích hoàn toàn với chế độ Dark Mode. [WEBVNZ.COM]
 */

import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart'; // Import Remix Icon

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dữ liệu danh sách kinh giả lập
    final List<Map<String, String>> kinhList = [
      {
        'title': 'Chú Đại Bi',
        'desc': 'Thiên Thủ Thiên Nhãn Vô Ngại Đại Bi Tâm Đà La Ni',
      },
      {
        'title': 'Bát Nhã Ba La Mật Đa Tâm Kinh',
        'desc': 'Kinh điển ngắn gọn về trí tuệ cứu cánh',
      },
      {
        'title': 'Kinh Phổ Môn',
        'desc': 'Phẩm Phổ Môn - Kinh Diệu Pháp Liên Hoa',
      },
      {
        'title': 'Kinh Dược Sư',
        'desc': 'Tiêu tai diệt tội, cầu thọ, giải trừ bệnh tật',
      },
      {
        'title': 'Kinh A Di Đà',
        'desc': 'Tán thán cảnh giới Tây Phương Cực Lạc',
      },
      {
        'title': 'Kinh Vu Lan Bồn',
        'desc': 'Báo hiếu công ơn sinh thành, độ thoát vong linh',
      },
    ];

    // Xác định màu sắc theo Theme hiện tại
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final iconBgColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF3EBE1);
    final textColor = Theme.of(context).colorScheme.onSurface;
    final hintColor = isDark ? Colors.grey.shade500 : Colors.grey.shade400;

    return Scaffold(
      appBar: AppBar(title: const Text('Mộc Kinh')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Thanh tìm kiếm
              Container(
                margin: const EdgeInsets.only(bottom: 24.0, top: 8.0),
                decoration: BoxDecoration(
                  color: cardColor, // Sử dụng màu thẻ động
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: textColor), // Đổi màu chữ khi gõ
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm tựa kinh...',
                    hintStyle: TextStyle(color: hintColor, fontSize: 15),
                    prefixIcon: Icon(
                      Remix.search_line,
                      color: hintColor,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),

              // Danh sách bài kinh
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: kinhList.length,
                  itemBuilder: (context, index) {
                    final item = kinhList[index];
                    return GestureDetector(
                      onTap: () {
                        // Truyền object sang màn đọc kinh
                        Navigator.pushNamed(
                          context,
                          '/reader',
                          arguments: item, // Truyền Map thay vì String
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: cardColor, // Sử dụng màu thẻ động
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                isDark ? 0.2 : 0.03,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: iconBgColor, // Màu nền icon động
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Icon(
                                Remix.book_open_line,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary, // Màu icon theo Theme
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: textColor, // Màu chữ tiêu đề động
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['desc']!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors
                                                .grey
                                                .shade600, // Màu chữ mô tả động
                                      height: 1.4,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
