/**
 * Tên file: settings_provider.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Provider quản lý trạng thái cài đặt của ứng dụng (Dark Mode, Kích thước chữ, Giờ Nhắc nhở) và lưu trữ cục bộ với Hive. [WEBVNZ.COM]
 */
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

  // Hàm Bật/Tắt nhắc nhở tụng kinh
  void toggleReminder(bool value) {
    _isReminderEnabled = value;
    _settingsBox.put(_reminderKey, value);

    if (value) {
      NotificationHelper.scheduleDailyReminder(_reminderHour, _reminderMinute);
    } else {
      NotificationHelper.cancelAllNotifications();
    }

    notifyListeners();
  }

  // Hàm cập nhật giờ nhắc nhở
  void updateReminderTime(int hour, int minute) {
    _reminderHour = hour;
    _reminderMinute = minute;
    _settingsBox.put(_reminderHourKey, hour);
    _settingsBox.put(_reminderMinuteKey, minute);

    if (_isReminderEnabled) {
      // Cập nhật lại lịch báo thức nếu đang bật
      NotificationHelper.scheduleDailyReminder(hour, minute);
    }

    notifyListeners();
  }

  // Lấy nhãn thời gian hiển thị (VD: 19:30 hàng ngày)
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
