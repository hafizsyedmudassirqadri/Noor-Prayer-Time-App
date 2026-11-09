import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/prayer_controller.dart';

class SettingsController extends GetxController {
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
  }

  // Saved theme load karna
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;

    applyTheme();

    final savedCity = prefs.getString('selectedCity') ?? 'karachi';

    if (savedCity != 'karachi') {
      await Get.find<PrayerController>().changeCity(savedCity);
    }
  }

  // Theme change karna
  Future<void> toggleTheme(bool value) async {
    isDarkMode.value = value;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDarkMode', value);

    applyTheme();
  }

  Future<void> selectCity(String citySlug) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selectedCity', citySlug);

    await Get.find<PrayerController>().changeCity(citySlug);
  }

  // App ki theme apply karna
  void applyTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
