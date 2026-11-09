import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Initialize notification system
  Future<void> initialize() async {
    // Load timezone database
    tz_data.initializeTimeZones();

    // Get device timezone
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    // Set local timezone
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));

    // Android initialization settings
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Combined initialization settings
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    // Initialize plugin
    await _notifications.initialize(settings: initializationSettings);
  }

  // Request notification permissions
  Future<void> requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Notification permission
      await androidPlugin.requestNotificationsPermission();

      // Exact alarm permission
      await androidPlugin.requestExactAlarmsPermission();
    }
  }

  // Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    final notificationTime = tz.TZDateTime.from(scheduledTime, tz.local);

    // Don't schedule past notifications
    if (!notificationTime.isAfter(now)) {
      return;
    }

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_channel',
        'Prayer Notifications',
        channelDescription: 'Prayer time reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: notificationTime,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Cancel a specific notification

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id: id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
