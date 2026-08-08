/**
 * Tên file: bookmark_provider.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Provider quản lý trạng thái lưu (Bookmark) các bài kinh, lưu trữ cục bộ bằng Hive. [WEBVNZ.COM]
 */
library;

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BookmarkProvider with ChangeNotifier {
  late Box _bookmarkBox;
  bool _isLoaded = false;

  BookmarkProvider() {
    _initBox();
  }

  Future<void> _initBox() async {
    _bookmarkBox = await Hive.openBox('bookmarkBox');
    _isLoaded = true;
    notifyListeners();
  }

  // Lấy toàn bộ danh sách kinh đã lưu
  List<Map<String, dynamic>> get bookmarkedList {
    if (!_isLoaded) return [];
    // Ép kiểu dữ liệu từ Hive về dạng Map
    return _bookmarkBox.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  // Kiểm tra xem bài kinh đã được lưu chưa (dựa vào id)
  bool isBookmarked(String id) {
    if (!_isLoaded) return false;
    return _bookmarkBox.containsKey(id);
  }

  // Thêm hoặc Xóa bookmark
  void toggleBookmark(Map<String, dynamic> kinhData) {
    final String id = kinhData['id'];

    if (_bookmarkBox.containsKey(id)) {
      _bookmarkBox.delete(id); // Xóa nếu đã có
    } else {
      _bookmarkBox.put(id, kinhData); // Thêm nếu chưa có
    }
    notifyListeners(); // Cập nhật UI
  }
}
