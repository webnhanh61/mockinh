/**
 * Tên file: settings_provider.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Provider quản lý trạng thái cài đặt của ứng dụng (Dark Mode) và lưu trữ cục bộ với Hive. [WEBVNZ.COM]
 */

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider with ChangeNotifier {
  // Biến lưu trạng thái Dark Mode
  bool _isDarkMode = false;

  // Getter
  bool get isDarkMode => _isDarkMode;

  // Key để lưu vào Hive
  final String _themeKey = "isDarkMode";
  late Box _settingsBox;

  SettingsProvider() {
    _loadSettings();
  }

  // Khởi tạo và nạp dữ liệu từ Hive
  Future<void> _loadSettings() async {
    _settingsBox = await Hive.openBox('settingsBox');
    // Nếu chưa từng lưu, mặc định là false (Light mode)
    _isDarkMode = _settingsBox.get(_themeKey, defaultValue: false);
    notifyListeners(); // Cập nhật UI lần đầu
  }

  // Hàm chuyển đổi theme
  void toggleTheme(bool value) {
    _isDarkMode = value;
    _settingsBox.put(_themeKey, value); // Lưu xuống Hive
    notifyListeners(); // Thông báo cho toàn bộ app đổi màu ngay lập tức
  }
}
