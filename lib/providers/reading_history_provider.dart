/**
 * Tên file: reading_history_provider.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Provider quản lý lịch sử đọc kinh, lưu trữ vị trí cuộn (scroll offset) cục bộ với Hive. [WEBVNZ.COM]
 */
library;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReadingHistoryProvider with ChangeNotifier {
  late Box _historyBox;
  bool _isLoaded = false;

  ReadingHistoryProvider() {
    _initBox();
  }

  Future<void> _initBox() async {
    _historyBox = await Hive.openBox('readingHistoryBox');
    _isLoaded = true;
    notifyListeners();
  }

  // Lưu vị trí cuộn
  void saveScrollOffset(String id, double offset) {
    if (!_isLoaded || id.isEmpty) return;
    _historyBox.put(id, offset);
  }

  // Lấy vị trí cuộn
  double getScrollOffset(String id) {
    if (!_isLoaded || id.isEmpty) return 0.0;
    return _historyBox.get(id, defaultValue: 0.0);
  }
}
