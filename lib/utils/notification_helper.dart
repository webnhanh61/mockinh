/**
 * Tên file: notification_helper.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Cấu hình và quản lý hệ thống thông báo nhắc nhở tụng kinh tự động mỗi ngày (Local Notifications). [WEBVNZ.COM]
 */
library;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Khởi tạo múi giờ
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // Lên lịch nhắc nhở tụng kinh theo giờ và phút tùy chọn
  static Future<void> scheduleDailyReminder(int hour, int minute) async {
    await _notificationsPlugin.zonedSchedule(
      0,
      'Đã đến giờ hành trì',
      'Mời bạn dành vài phút tĩnh tâm và tụng kinh để giữ tâm an lạc.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'moc_kinh_reminder',
          'Nhắc nhở hành trì',
          channelDescription: 'Thông báo nhắc nhở tụng kinh hàng ngày',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Hủy toàn bộ thông báo
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  // Tính toán thời điểm thông báo tiếp theo
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
