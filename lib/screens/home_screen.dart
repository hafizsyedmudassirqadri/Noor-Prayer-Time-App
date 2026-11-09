import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/prayer_controller.dart';
import '../widgets/prayer_card.dart';

import '../widgets/next_prayer_card.dart';
// import 'monthly_screen.dart';
// import 'qibla_screen.dart';
// import 'settings_screen.dart';

class HomeScreen extends GetView<PrayerController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  title: const Text('Noor Prayer'),
  backgroundColor: Colors.teal,
  foregroundColor: Colors.white,
),

      body: Obx(() {
        // Loading State
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error State
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: controller.fetchPrayerTimes,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final response = controller.prayerResponse.value;

        final prayer = controller.todayPrayer.value;

        // No Data State
        if (response == null || prayer == null) {
          return const Center(
            child: Text('Prayer timings not available for today.'),
          );
        }

        // Display Prayer Timings
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                response.city,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                response.country,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              if (controller.nextPrayer.value != null)
                NextPrayerCard(prayer: controller.nextPrayer.value!),

              const SizedBox(height: 25),

              const SizedBox(height: 25),

              const Text(
                "Today's Prayer Times",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              PrayerCard(title: 'Fajr', time: prayer.fajr),

              PrayerCard(title: 'Sunrise', time: prayer.sunrise),

              PrayerCard(title: 'Dhuhr', time: prayer.dhuhr),

              PrayerCard(title: 'Asr', time: prayer.asr),

              PrayerCard(title: 'Maghrib', time: prayer.maghrib),

              PrayerCard(title: 'Isha', time: prayer.isha),
            ],
          ),
        );
      }),
    );
  }
}
