/// Tên file: notification_helper.dart
/// Tên tác giả: La Văn Thanh
/// Mô tả: Cấu hình và quản lý hệ thống thông báo nhắc nhở. Đã bổ sung hàm xin quyền hiển thị hộp thoại Runtime Permission trên Android 13+. [WEBVNZ.COM]
library;

import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true, // iOS tự động xin quyền ở đây
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

  // Hàm hiển thị hộp thoại xin quyền trên Android
  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      // Xin quyền hiển thị thông báo (Android 13+)
      final bool? grantedNotification = await androidImplementation
          ?.requestNotificationsPermission();

      // Xin quyền báo thức chính xác để không bị trễ giờ (Android 12+)
      await androidImplementation?.requestExactAlarmsPermission();

      return grantedNotification ?? false;
    }
    return true;
  }

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

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

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
