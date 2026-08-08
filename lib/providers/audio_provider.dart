/**
 * Tên file: audio_provider.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Provider quản lý Âm thanh không gian (Nhạc thiền/âm thanh nền), hỗ trợ phát lặp lại và lưu trạng thái vào Hive. [WEBVNZ.COM]
 */
library;

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AudioProvider with ChangeNotifier {
  late Box _audioBox;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isAudioEnabled = false;
  double _volume = 0.5;
  String _selectedTrack = 'thien_nhien.mp3';
  bool _isLoaded = false;

  bool get isAudioEnabled => _isAudioEnabled;
  double get volume => _volume;
  String get selectedTrack => _selectedTrack;
  bool get isLoaded => _isLoaded;

  // Danh sách các âm thanh có sẵn (Sếp nhớ chép các file MP3 tương ứng vào thư mục assets/audios/)
  final List<Map<String, String>> audioTracks = [
    {'id': 'thien_nhien.mp3', 'name': 'Suối róc rách & Chim hót'},
    {'id': 'mua_roi.mp3', 'name': 'Tiếng mưa rơi tịnh tâm'},
    {'id': 'chuong_mo.mp3', 'name': 'Tiếng chuông & Gõ mõ'},
    {'id': 'nhac_thien.mp3', 'name': 'Nhạc thiền vô ưu'},
  ];

  AudioProvider() {
    _initBox();
  }

  Future<void> _initBox() async {
    _audioBox = await Hive.openBox('audioBox');
    _isAudioEnabled = _audioBox.get('isAudioEnabled', defaultValue: false);
    _volume = _audioBox.get('volume', defaultValue: 0.5);
    _selectedTrack = _audioBox.get(
      'selectedTrack',
      defaultValue: 'thien_nhien.mp3',
    );

    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // Phát lặp lại vô tận
    await _audioPlayer.setVolume(_volume);

    _isLoaded = true;

    // Tự động phát nhạc nếu trước đó người dùng đang bật
    if (_isAudioEnabled) {
      _playAudio();
    }
    notifyListeners();
  }

  Future<void> toggleAudio(bool value) async {
    _isAudioEnabled = value;
    _audioBox.put('isAudioEnabled', value);

    if (value) {
      await _playAudio();
    } else {
      await _audioPlayer.stop();
    }
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    _volume = value;
    _audioBox.put('volume', value);
    await _audioPlayer.setVolume(value);
    notifyListeners();
  }

  Future<void> changeTrack(String trackId) async {
    _selectedTrack = trackId;
    _audioBox.put('selectedTrack', trackId);

    if (_isAudioEnabled) {
      await _playAudio(); // Phát luôn bài mới nếu đang bật
    }
    notifyListeners();
  }

  Future<void> _playAudio() async {
    try {
      // AudioPlayer mặc định sẽ tìm trong thư mục assets/
      await _audioPlayer.play(AssetSource('audios/$_selectedTrack'));
    } catch (e) {
      debugPrint("Lỗi phát âm thanh nền: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
