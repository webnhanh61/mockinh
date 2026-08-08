/**
 * Tên file: home_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình mục lục danh sách các bài kinh, tải dữ liệu động từ file JSON và xử lý tính năng tìm kiếm, tương thích Dark Mode. [WEBVNZ.COM]
 */
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart'; // Import Remix Icon

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Danh sách gốc chứa toàn bộ kinh tải từ JSON
  List<Map<String, dynamic>> _kinhList = [];

  // Danh sách dùng để hiển thị (thay đổi khi tìm kiếm)
  List<Map<String, dynamic>> _filteredList = [];

  // Trạng thái tải dữ liệu
  bool _isLoading = true;

  // Controller cho thanh tìm kiếm
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadKinhData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Hàm đọc dữ liệu từ file JSON
  Future<void> _loadKinhData() async {
    try {
      // Đọc file từ thư mục assets
      final String response = await rootBundle.loadString(
        'assets/datas/kinh_phat.json',
      );
      // Chuyển đổi JSON string thành List
      final List<dynamic> data = json.decode(response);

      setState(() {
        _kinhList = data.cast<Map<String, dynamic>>();
        _filteredList = _kinhList; // Ban đầu hiển thị toàn bộ
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Lỗi đọc file JSON: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hàm xử lý tìm kiếm
  void _filterKinh(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredList = _kinhList;
      });
    } else {
      setState(() {
        _filteredList = _kinhList.where((kinh) {
          final title = kinh['title'].toString().toLowerCase();
          final desc = kinh['desc'].toString().toLowerCase();
          final searchLower = query.toLowerCase();

          return title.contains(searchLower) || desc.contains(searchLower);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.04,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterKinh,
                  style: TextStyle(color: textColor), // Đổi màu chữ khi gõ
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm tựa kinh...',
                    hintStyle: TextStyle(color: hintColor, fontSize: 15),
                    prefixIcon: Icon(
                      Remix.search_line,
                      color: hintColor,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Remix.close_circle_line,
                              color: hintColor,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _filterKinh('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),

              // Danh sách bài kinh
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : _filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Remix.file_search_line,
                              size: 48,
                              color: Colors.grey.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Không tìm thấy bài kinh nào.',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: _filteredList.length,
                        itemBuilder: (context, index) {
                          final item = _filteredList[index];
                          return GestureDetector(
                            onTap: () {
                              // Truyền object sang màn đọc kinh
                              Navigator.pushNamed(
                                context,
                                '/reader',
                                arguments:
                                    item, // Truyền toàn bộ Map JSON sang Reader
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
                                    color: Colors.black.withValues(
                                      alpha: isDark ? 0.2 : 0.03,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary, // Màu icon theo Theme
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'] ?? '',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                textColor, // Màu chữ tiêu đề động
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item['desc'] ?? '',
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
