import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/prayer_day.dart';
import '../services/notification_service.dart';
import 'prayer_controller.dart';

class NotificationController extends GetxController {
  final NotificationService _service = NotificationService();
  Worker? _prayerResponseWorker;

  final prayerNotifications = <String, bool>{
    'fajr': false,
    'dhuhr': false,
    'asr': false,
    'maghrib': false,
    'isha': false,
  }.obs;

  final isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  // Initialize service and load saved settings
  Future<void> initializeController() async {
    try {
      await _service.initialize();

      final prefs = await SharedPreferences.getInstance();

      for (final prayer in prayerNotifications.keys.toList()) {
        prayerNotifications[prayer] = prefs.getBool('notify_$prayer') ?? false;
      }

      isReady.value = true;

      final prayerController = Get.find<PrayerController>();

      _prayerResponseWorker = ever(prayerController.prayerResponse, (_) {
        scheduleEnabledPrayers();
      });

      await scheduleEnabledPrayers();

      if (prayerNotifications.values.any((value) => value)) {
        await _service.requestPermissions();
        await scheduleEnabledPrayers();
      }
    } catch (e, stackTrace) {
  print('NOTIFICATION INIT ERROR: ========================= $e');
  print(stackTrace);
}
  }

  // Turn a prayer notification ON or OFF
  Future<void> togglePrayer(String prayer, bool enabled) async {
    if (!prayerNotifications.containsKey(prayer)) return;

    prayerNotifications[prayer] = enabled;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('notify_$prayer', enabled);

    if (enabled) {
      await _service.requestPermissions();
    }

    await scheduleEnabledPrayers();
  }

  // Schedule all enabled prayer notifications
  Future<void> scheduleEnabledPrayers() async {
    if (!isReady.value) return;

    final prayerController = Get.find<PrayerController>();
    final response = prayerController.prayerResponse.value;

    if (response == null) return;

    for (final prayer in prayerNotifications.keys) {
      await _schedulePrayer(prayer: prayer, days: response.days);
    }
  }

  // Schedule one prayer for all available API dates
  Future<void> _schedulePrayer({
    required String prayer,
    required List<PrayerDay> days,
  }) async {
    final prayerIndex = [
      'fajr',
      'dhuhr',
      'asr',
      'maghrib',
      'isha',
    ].indexOf(prayer);

    if (prayerIndex == -1) return;

    for (final day in days) {
      final notificationId = _notificationId(day.date, prayerIndex);

      // Cancel the old notification before updating it
      await _service.cancelNotification(notificationId);

      if (prayerNotifications[prayer] != true) {
        continue;
      }

      final prayerTime = _parsePrayerDateTime(
        day.date,
        _getPrayerTime(day, prayer),
      );

      if (prayerTime == null) continue;

      await _service.scheduleNotification(
        id: notificationId,
        title: 'Noor Prayer',
        body: 'It is time for ${_prayerName(prayer)} prayer.',
        scheduledTime: prayerTime,
      );
    }
  }

  // Get the selected prayer time from API model
  String _getPrayerTime(PrayerDay day, String prayer) {
    switch (prayer) {
      case 'fajr':
        return day.fajr;
      case 'dhuhr':
        return day.dhuhr;
      case 'asr':
        return day.asr;
      case 'maghrib':
        return day.maghrib;
      case 'isha':
        return day.isha;
      default:
        return '';
    }
  }

  // Convert API date and time into DateTime
  DateTime? _parsePrayerDateTime(String date, String time) {
    final parsedDate = DateTime.tryParse(date);
    if (parsedDate == null) return null;

    final match = RegExp(
      r'^(\d{1,2}):(\d{2})(?:\s*(AM|PM))?$',
      caseSensitive: false,
    ).firstMatch(time.trim());

    if (match == null) return null;

    int hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)?.toUpperCase();

    if (minute > 59 || hour > 23) return null;

    if (period != null) {
      if (hour < 1 || hour > 12) return null;

      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }
    }

    return DateTime(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
      hour,
      minute,
    );
  }

  // Generate a unique ID for each date and prayer
 int _notificationId(String date, int prayerIndex) {
  final parsedDate = DateTime.parse(date);

  final dayNumber =
      parsedDate.millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;

  return dayNumber * 10 + prayerIndex;
}

  String _prayerName(String prayer) {
    switch (prayer) {
      case 'fajr':
        return 'Fajr';
      case 'dhuhr':
        return 'Dhuhr';
      case 'asr':
        return 'Asr';
      case 'maghrib':
        return 'Maghrib';
      case 'isha':
        return 'Isha';
      default:
        return prayer;
    }
  }

  @override
  void onClose() {
    _prayerResponseWorker?.dispose();
    super.onClose();
  }
}
