

// https://prayertime.info/api/pakistan/lahore.json



class ApiConstants {
  static const String baseUrl =
      'https://prayertime.info/api';

  static String prayerTimeUrl(String citySlug) {
    return '$baseUrl/pakistan/$citySlug.json';
  }
}