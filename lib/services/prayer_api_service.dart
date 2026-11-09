import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/prayer_response.dart';

class PrayerApiService {
  Future<PrayerResponse> fetchPrayerTimes({required String citySlug}) async {
    final url = Uri.parse(ApiConstants.prayerTimeUrl(citySlug));

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      return PrayerResponse.fromJson(data);
    } else {
      throw Exception('Failed to load prayer times: ${response.statusCode}');
    }
  }
}
