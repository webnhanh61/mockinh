/**
 * Tên file: explore_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình khám phá các chủ đề kinh và lời Phật dạy, bổ sung hiển thị ngày Âm lịch hiện tại (Sử dụng package lunar). [WEBVNZ.COM]
 */
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remixicon/remixicon.dart';
import 'package:lunar/lunar.dart'; // Sử dụng thư viện lunar mới

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _isLoading = true;
  String _lunarDateString = '';

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Thiền Định',
      'icon': Remix.leaf_line,
      'color': 0xFF5B7065,
      'kinhList': <Map<String, dynamic>>[],
    },
    {
      'title': 'Cầu An',
      'icon': Remix.heart_3_line,
      'color': 0xFF8B5A2B,
      'kinhList': <Map<String, dynamic>>[],
    },
    {
      'title': 'Sám Hối',
      'icon': Remix.water_flash_line,
      'color': 0xFF6B705C,
      'kinhList': <Map<String, dynamic>>[],
    },
    {
      'title': 'Trí Tuệ',
      'icon': Remix.lightbulb_flash_line,
      'color': 0xFFD4A373,
      'kinhList': <Map<String, dynamic>>[],
    },
  ];

  @override
  void initState() {
    super.initState();
    _calculateLunarDate();
    _loadKinhData();
  }

  // Hàm tính toán và định dạng ngày âm lịch hôm nay
  void _calculateLunarDate() {
    final now = DateTime.now();
    final lunar = Lunar.fromDate(now);

    setState(() {
      _lunarDateString =
          'Ngày ${lunar.getDay()} tháng ${lunar.getMonth()} năm Âm lịch';
    });
  }

  Future<void> _loadKinhData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/datas/kinh_phat.json',
      );
      final List<dynamic> data = json.decode(response);

      for (var kinh in data) {
        final kinhMap = kinh as Map<String, dynamic>;
        final String categoryName = kinhMap['category'] ?? '';

        for (var cat in _categories) {
          if (cat['title'] == categoryName) {
            (cat['kinhList'] as List<Map<String, dynamic>>).add(kinhMap);
            break;
          }
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Lỗi đọc file JSON ở màn hình Khám phá: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Hiển thị Lịch Âm
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, left: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Remix.calendar_2_line,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _lunarDateString,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

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
                          ? Colors.black.withValues(alpha: 0.5)
                          : const Color(0xFF8B5A2B).withValues(alpha: 0.3),
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
                      color: Colors.white.withValues(alpha: 0.5),
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
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Chủ Đề Tìm Kiếm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              _isLoading
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            childAspectRatio: 1.5,
                          ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: cardColor,
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
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16.0),
                              onTap: () {
                                _showCategoryKinhSheet(
                                  context,
                                  cat,
                                  isDark,
                                  cardColor,
                                  textColor,
                                );
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
                                          ? Color(
                                              cat['color'],
                                            ).withValues(alpha: 0.9)
                                          : Color(cat['color']),
                                      size: 28,
                                    ),
                                    const Spacer(),
                                    Text(
                                      cat['title'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: textColor,
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

  void _showCategoryKinhSheet(
    BuildContext context,
    Map<String, dynamic> category,
    bool isDark,
    Color bgColor,
    Color textColor,
  ) {
    final List<Map<String, dynamic>> kinhList =
        category['kinhList'] as List<Map<String, dynamic>>;
    final iconBgColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF3EBE1);

    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade600
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Icon(category['icon'], color: Color(category['color'])),
                        const SizedBox(width: 12),
                        Text(
                          'Chủ đề: ${category['title']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Expanded(
                    child: kinhList.isEmpty
                        ? Center(
                            child: Text(
                              'Đang cập nhật nội dung...',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600,
                                fontSize: 15,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            itemCount: kinhList.length,
                            itemBuilder: (context, index) {
                              final item = kinhList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    '/reader',
                                    arguments: item,
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12.0),
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF333333)
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.transparent
                                          : Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: iconBgColor,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Icon(
                                          Remix.book_open_line,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          size: 22,
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['desc'] ?? '',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: isDark
                                                    ? Colors.grey.shade400
                                                    : Colors.grey.shade600,
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
            );
          },
        );
      },
    );
  }
}
