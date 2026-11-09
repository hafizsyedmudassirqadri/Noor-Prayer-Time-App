import 'package:get/get.dart';

import '../models/prayer_response.dart';
import '../models/prayer_day.dart';
import '../repositories/prayer_repository.dart';

import 'dart:async';

import '../models/next_prayer.dart';

class PrayerController extends GetxController {
  // Next Prayer
  final Rxn<NextPrayer> nextPrayer = Rxn<NextPrayer>();

  // Countdown Timer
  Timer? countdownTimer;

  final PrayerRepository repository;

  PrayerController({required this.repository});

  // Loading State
  final isLoading = false.obs;

  // Error State
  final errorMessage = ''.obs;

  // API Response
  final Rxn<PrayerResponse> prayerResponse = Rxn<PrayerResponse>();

  // Today's Prayer Timings
  final Rxn<PrayerDay> todayPrayer = Rxn<PrayerDay>();

  final RxString selectedCitySlug = 'karachi'.obs;

  // Fetch Prayer Times
  Future<void> fetchPrayerTimes({String? citySlug}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (citySlug != null) {
        selectedCitySlug.value = citySlug;
      }

      final response = await repository.getPrayerTimes(
        citySlug: selectedCitySlug.value,
      );

      prayerResponse.value = response;

      final today = DateTime.now();
      final todayDate =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      PrayerDay? todayData;

      for (final day in response.days) {
        if (day.date == todayDate) {
          todayData = day;
          break;
        }
      }

      todayPrayer.value = todayData;

      if (todayData != null) {
        startCountdown();
      } else {
        nextPrayer.value = null;
        countdownTimer?.cancel();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> changeCity(String citySlug) async {
  if (selectedCitySlug.value == citySlug) return;

  await fetchPrayerTimes(citySlug: citySlug);
}

  String formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  PrayerDay? findPrayerDay(String date) {
    final response = prayerResponse.value;

    if (response == null) return null;

    for (final day in response.days) {
      if (day.date == date) {
        return day;
      }
    }

    return null;
  }

  DateTime? createPrayerDateTime(DateTime date, String time) {
    final parts = time.split(':');

    if (parts.length < 2) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return null;

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  void calculateNextPrayer() {
    final now = DateTime.now();

    // API se aaj ki date ka data find karo.
    final todayDate = formatDate(now);
    final todayData = findPrayerDay(todayDate);

    todayPrayer.value = todayData;

    if (todayData == null) {
      nextPrayer.value = null;
      return;
    }

    // Sirf 5 obligatory prayers check hongi.
    final prayers = [
      {'name': 'Fajr', 'time': todayData.fajr},
      {'name': 'Dhuhr', 'time': todayData.dhuhr},
      {'name': 'Asr', 'time': todayData.asr},
      {'name': 'Maghrib', 'time': todayData.maghrib},
      {'name': 'Isha', 'time': todayData.isha},
    ];

    for (final prayer in prayers) {
      final prayerDateTime = createPrayerDateTime(now, prayer['time']!);

      if (prayerDateTime == null) continue;

      if (prayerDateTime.isAfter(now)) {
        nextPrayer.value = NextPrayer(
          name: prayer['name']!,
          prayerDateTime: prayerDateTime,
          remainingTime: prayerDateTime.difference(now),
        );

        return;
      }
    }

    // Aaj ki tamam prayers guzar chuki hain.
    // Ab API se kal ka actual Fajr time find karo.
    final tomorrow = now.add(const Duration(days: 1));
    final tomorrowData = findPrayerDay(formatDate(tomorrow));

    if (tomorrowData == null) {
      nextPrayer.value = null;
      return;
    }

    final tomorrowFajr = createPrayerDateTime(tomorrow, tomorrowData.fajr);

    if (tomorrowFajr == null) {
      nextPrayer.value = null;
      return;
    }

    nextPrayer.value = NextPrayer(
      name: 'Fajr',
      prayerDateTime: tomorrowFajr,
      remainingTime: tomorrowFajr.difference(now),
    );
  }

  void startCountdown() {
    countdownTimer?.cancel();

    calculateNextPrayer();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      calculateNextPrayer();
    });
  }

  @override
  void onInit() {
    super.onInit();

    fetchPrayerTimes();
  }

  @override
  void onClose() {
    countdownTimer?.cancel();

    super.onClose();
  }
}
