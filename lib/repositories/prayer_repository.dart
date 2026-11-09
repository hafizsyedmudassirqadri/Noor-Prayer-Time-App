import '../models/prayer_response.dart';
import '../services/prayer_api_service.dart';

class PrayerRepository {
  final PrayerApiService apiService;

  PrayerRepository({
    required this.apiService,
  });

  Future<PrayerResponse> getPrayerTimes({
    required String citySlug,
  }) async {
    return await apiService.fetchPrayerTimes(
      citySlug: citySlug,
    );
  }
}