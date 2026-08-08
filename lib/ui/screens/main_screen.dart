/// Tên file: main_screen.dart
/// Tên tác giả: La Văn Thanh
/// Mô tả: Màn hình chính chứa thanh điều hướng, cập nhật giao diện hiển thị danh sách Đã lưu cho BookmarkScreen. Đã thêm tab Tu Tập. [WEBVNZ.COM]
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import 'home_screen.dart';
import 'explore_screen.dart';
import 'practice_screen.dart'; // Import màn hình Tu Tập mới
import 'settings_screen.dart';
import '../../providers/bookmark_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const PracticeScreen(), // Thêm màn hình Tu Tập vào vị trí thứ 3
    const BookmarkScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBarColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            backgroundColor: navBarColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: isDark
                ? Colors.grey.shade600
                : Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11, // Giảm nhẹ font size để vừa 5 tab
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Remix.book_read_line),
                activeIcon: Icon(Remix.book_read_fill, size: 26),
                label: 'Mục lục',
              ),
              BottomNavigationBarItem(
                icon: Icon(Remix.compass_3_line),
                activeIcon: Icon(Remix.compass_3_fill, size: 26),
                label: 'Khám phá',
              ),
              BottomNavigationBarItem(
                icon: Icon(Remix.leaf_line), // Icon cho tab Tu Tập
                activeIcon: Icon(Remix.leaf_fill, size: 26),
                label: 'Tu Tập',
              ),
              BottomNavigationBarItem(
                icon: Icon(Remix.bookmark_line),
                activeIcon: Icon(Remix.bookmark_fill, size: 26),
                label: 'Đã lưu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Remix.settings_4_line),
                activeIcon: Icon(Remix.settings_4_fill, size: 26),
                label: 'Cài đặt',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Màn hình Bookmark (Đã lưu) được kết nối với Provider
class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final savedList = bookmarkProvider.bookmarkedList;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final iconBgColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF3EBE1);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: const Text('Kinh Đã Lưu')),
      body: savedList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Remix.bookmark_3_line,
                    size: 64,
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có bài kinh nào được lưu.',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: savedList.length,
                  itemBuilder: (context, index) {
                    final item = savedList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/reader',
                          arguments: item,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14.0),
                        padding: const EdgeInsets.all(20.0),
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
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: iconBgColor,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Icon(
                                Remix.heart_3_fill,
                                color: Colors.redAccent,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item['desc'] ?? '',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
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
            ),
    );
  }
}
