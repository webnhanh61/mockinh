/// Tên file: settings_provider.dart
/// Tên tác giả: La Văn Thanh
/// Mô tả: Provider quản lý trạng thái cài đặt của ứng dụng. Gọi hiển thị hộp thoại xin quyền trước khi kích hoạt Nhắc nhở. [WEBVNZ.COM]
library;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/notification_helper.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 24.0;
  bool _isReminderEnabled = false;
  int _reminderHour = 19;
  int _reminderMinute = 30;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  bool get isReminderEnabled => _isReminderEnabled;
  int get reminderHour => _reminderHour;
  int get reminderMinute => _reminderMinute;

  final String _themeKey = "isDarkMode";
  final String _fontSizeKey = "fontSize";
  final String _reminderKey = "isReminderEnabled";
  final String _reminderHourKey = "reminderHour";
  final String _reminderMinuteKey = "reminderMinute";

  late Box _settingsBox;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settingsBox = await Hive.openBox('settingsBox');

    _isDarkMode = _settingsBox.get(_themeKey, defaultValue: false);
    _fontSize = _settingsBox.get(_fontSizeKey, defaultValue: 24.0);
    _isReminderEnabled = _settingsBox.get(_reminderKey, defaultValue: false);
    _reminderHour = _settingsBox.get(_reminderHourKey, defaultValue: 19);
    _reminderMinute = _settingsBox.get(_reminderMinuteKey, defaultValue: 30);

    notifyListeners();
  }

  void toggleTheme(bool value) {
    _isDarkMode = value;
    _settingsBox.put(_themeKey, value);
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    _settingsBox.put(_fontSizeKey, size);
    notifyListeners();
  }

  // Sửa thành async để xin quyền khi bật thông báo
  Future<void> toggleReminder(bool value) async {
    if (value) {
      // 1. Hiển thị hộp thoại xin quyền từ người dùng
      await NotificationHelper.requestPermission();

      // 2. Sau đó mới lên lịch
      NotificationHelper.scheduleDailyReminder(_reminderHour, _reminderMinute);
    } else {
      NotificationHelper.cancelAllNotifications();
    }

    _isReminderEnabled = value;
    _settingsBox.put(_reminderKey, value);
    notifyListeners();
  }

  void updateReminderTime(int hour, int minute) {
    _reminderHour = hour;
    _reminderMinute = minute;
    _settingsBox.put(_reminderHourKey, hour);
    _settingsBox.put(_reminderMinuteKey, minute);

    if (_isReminderEnabled) {
      NotificationHelper.scheduleDailyReminder(hour, minute);
    }

    notifyListeners();
  }

  String get reminderTimeLabel {
    final h = _reminderHour.toString().padLeft(2, '0');
    final m = _reminderMinute.toString().padLeft(2, '0');
    return '$h:$m hàng ngày';
  }

  String get fontSizeLabel {
    if (_fontSize <= 18.0) return 'Nhỏ';
    if (_fontSize <= 24.0) return 'Vừa';
    if (_fontSize <= 32.0) return 'Lớn';
    return 'Rất Lớn';
  }
}
