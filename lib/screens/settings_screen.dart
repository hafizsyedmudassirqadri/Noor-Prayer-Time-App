
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/settings_controller.dart';
import '../controllers/prayer_controller.dart';
import '../controllers/notification_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // APPEARANCE
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Obx(
            () => SwitchListTile(
              secondary: Icon(
                controller.isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              title: const Text('Dark Mode'),
              subtitle: const Text('Change app appearance'),
              value: controller.isDarkMode.value,
              onChanged: controller.toggleTheme,
            ),
          ),

          const Divider(height: 30),

          // LOCATION
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Obx(() {
            final prayerController =
                Get.find<PrayerController>();

            return DropdownButtonFormField<String>(
              initialValue: prayerController.selectedCitySlug.value,

              decoration: const InputDecoration(
                labelText: 'Select City',
                prefixIcon: Icon(Icons.location_city),
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(
                  value: 'karachi',
                  child: Text('Karachi'),
                ),
                DropdownMenuItem(
                  value: 'lahore',
                  child: Text('Lahore'),
                ),
                DropdownMenuItem(
                  value: 'islamabad',
                  child: Text('Islamabad'),
                ),
                DropdownMenuItem(
                  value: 'peshawar',
                  child: Text('Peshawar'),
                ),
                DropdownMenuItem(
                  value: 'quetta',
                  child: Text('Quetta'),
                ),
              ],

              onChanged: (citySlug) async {
                if (citySlug != null) {
                  await controller.selectCity(citySlug);
                }
              },
            );
          }),

          const Divider(height: 30),

          // PRAYER NOTIFICATIONS
          const Text(
            'Prayer Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Enable reminders for your daily prayers.',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 10),

          _buildPrayerNotificationTile(
            prayer: 'fajr',
            title: 'Fajr',
            subtitle: 'Fajr prayer reminder',
            icon: Icons.wb_twilight,
          ),

          _buildPrayerNotificationTile(
            prayer: 'dhuhr',
            title: 'Dhuhr',
            subtitle: 'Dhuhr prayer reminder',
            icon: Icons.wb_sunny_outlined,
          ),

          _buildPrayerNotificationTile(
            prayer: 'asr',
            title: 'Asr',
            subtitle: 'Asr prayer reminder',
            icon: Icons.sunny,
          ),

          _buildPrayerNotificationTile(
            prayer: 'maghrib',
            title: 'Maghrib',
            subtitle: 'Maghrib prayer reminder',
            icon: Icons.wb_twilight,
          ),

          _buildPrayerNotificationTile(
            prayer: 'isha',
            title: 'Isha',
            subtitle: 'Isha prayer reminder',
            icon: Icons.nightlight_round,
          ),

          const Divider(height: 30),

          // ABOUT
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const ListTile(
            leading: Icon(Icons.mosque),
            title: Text('Noor Prayer'),
            subtitle: Text('Prayer Times Application'),
          ),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Prayer Times API'),
            subtitle: const Text('prayertime.info'),
            onTap: () {
              Get.to(() => const ApiInfoScreen());
            },
          ),
        ],
      ),
    );
  }

  // Reusable notification switch
  Widget _buildPrayerNotificationTile({
    required String prayer,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final notificationController =
        Get.find<NotificationController>();

    return Obx(() {
      final enabled =
          notificationController.prayerNotifications[prayer] ?? false;

      return SwitchListTile(
        secondary: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        value: enabled &&
            notificationController.isReady.value,
        onChanged: notificationController.isReady.value
            ? (value) {
                notificationController.togglePrayer(
                  prayer,
                  value,
                );
              }
            : null,
      );
    });
  }
}

// API INFORMATION SCREEN
class ApiInfoScreen extends StatelessWidget {
  const ApiInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Information'),
      ),

      body: const Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prayer Times Data',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12),

            Text(
              'Prayer timings are provided by prayertime.info.',
            ),

            SizedBox(height: 12),

            Text('License: CC BY 4.0'),

            SizedBox(height: 12),

            SelectableText(
              'https://prayertime.info/ms/pakistan/',
            ),
          ],
        ),
      ),
    );
  }
}
