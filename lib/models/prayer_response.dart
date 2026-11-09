import 'prayer_day.dart';

class PrayerResponse {
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final String timezone;
  final double qiblaDegrees;
  final String madhab;
  final List<PrayerDay> days;

  PrayerResponse({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.qiblaDegrees,
    required this.madhab,
    required this.days,
  });

  factory PrayerResponse.fromJson(Map<String, dynamic> json) {
    return PrayerResponse(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timezone: json['timezone'] ?? '',
      qiblaDegrees:
          (json['qibla_degrees_from_north'] as num).toDouble(),
      madhab: json['madhab'] ?? '',

      days: (json['days'] as List)
          .map((day) => PrayerDay.fromJson(day))
          .toList(),
    );
  }
}