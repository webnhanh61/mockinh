/**
 * Tên file: main_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình chính chứa thanh điều hướng BottomNavigationBar, đã tích hợp đổi màu động theo Dark Mode. [WEBVNZ.COM]
 */

import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart'; // Import Remix Icon

// Đảm bảo import đầy đủ 4 màn hình của 4 tab
import 'home_screen.dart';
import 'explore_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Danh sách này phải có CHÍNH XÁC 4 màn hình
  final List<Widget> _screens = [
    const HomeScreen(), // Tab 1 (Index 0)
    const ExploreScreen(), // Tab 2 (Index 1)
    const BookmarkScreen(), // Tab 3 (Index 2)
    const SettingsScreen(), // Tab 4 (Index 3)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ Sáng/Tối để đổi màu thanh điều hướng
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.4)
        : Colors.black.withOpacity(0.05);

    return Scaffold(
      // IndexedStack giúp giữ state của các tab
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBarColor, // Sử dụng màu động
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
            backgroundColor: navBarColor, // Sử dụng màu động
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Theme.of(
              context,
            ).colorScheme.primary, // Đổi màu icon đang chọn theo Theme
            unselectedItemColor: isDark
                ? Colors.grey.shade600
                : Colors.grey.shade400,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
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

// Màn hình Bookmark (Đã lưu) tạm thời
class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kinh Đã Lưu')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Remix.bookmark_3_line,
              size: 64,
              color: Colors.grey.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có bài kinh nào được lưu.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
