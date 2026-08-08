/**
 * Tên file: practice_provider.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Provider quản lý Nhật ký tu tập và Chuỗi ngày liên tục (Streak), sử dụng Hive để lưu trữ. [WEBVNZ.COM]
 */
library;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PracticeProvider with ChangeNotifier {
  late Box _practiceBox;
  bool _isLoaded = false;

  // Danh sách các mốc thời gian tu tập
  List<DateTime> _practiceLogs = [];
  int _currentStreak = 0;

  bool get isLoaded => _isLoaded;
  List<DateTime> get practiceLogs => _practiceLogs;
  int get currentStreak => _currentStreak;

  PracticeProvider() {
    _initBox();
  }

  Future<void> _initBox() async {
    _practiceBox = await Hive.openBox('practiceBox');
    _loadLogs();
    _calculateStreak();
    _isLoaded = true;
    notifyListeners();
  }

  void _loadLogs() {
    final logs = _practiceBox.get('logs', defaultValue: <dynamic>[]);
    _practiceLogs = logs.map((e) => DateTime.parse(e.toString())).toList();
  }

  // Lưu lịch sử tu tập (gọi khi hoàn thành việc đọc hoặc khi thoát màn hình đọc)
  void logPractice() {
    final now = DateTime.now();

    if (_practiceLogs.isNotEmpty) {
      final lastLog = _practiceLogs.last;
      // Chỉ tính 1 lần ghi nhận mỗi ngày để tránh trùng lặp
      if (lastLog.year == now.year &&
          lastLog.month == now.month &&
          lastLog.day == now.day) {
        return;
      }
    }

    _practiceLogs.add(now);
    _practiceBox.put(
      'logs',
      _practiceLogs.map((e) => e.toIso8601String()).toList(),
    );
    _calculateStreak();
    notifyListeners();
  }

  void _calculateStreak() {
    if (_practiceLogs.isEmpty) {
      _currentStreak = 0;
      return;
    }

    int streak = 1;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    DateTime lastDate = _practiceLogs.last;
    lastDate = DateTime(lastDate.year, lastDate.month, lastDate.day);

    final difference = today.difference(lastDate).inDays;

    // Nếu lần cuối tu tập cách đây hơn 1 ngày, chuỗi liên tục bị đứt
    if (difference > 1) {
      _currentStreak = 0;
      return;
    }

    // Đếm ngược để tính chuỗi ngày liên tiếp
    for (int i = _practiceLogs.length - 1; i > 0; i--) {
      final current = _practiceLogs[i];
      final previous = _practiceLogs[i - 1];

      final currentDate = DateTime(current.year, current.month, current.day);
      final previousDate = DateTime(
        previous.year,
        previous.month,
        previous.day,
      );

      if (currentDate.difference(previousDate).inDays == 1) {
        streak++;
      } else if (currentDate.difference(previousDate).inDays > 1) {
        break;
      }
    }
    _currentStreak = streak;
  }
}
