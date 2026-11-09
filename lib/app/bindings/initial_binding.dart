import 'package:get/get.dart';

import '../../services/prayer_api_service.dart';
import '../../repositories/prayer_repository.dart';
import '../../controllers/prayer_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/notification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register API Service
    Get.lazyPut<PrayerApiService>(() => PrayerApiService());

    // Register Repository
    Get.lazyPut<PrayerRepository>(
      () => PrayerRepository(apiService: Get.find<PrayerApiService>()),
    );

    // Register Controller
    Get.lazyPut<PrayerController>(
      () => PrayerController(repository: Get.find<PrayerRepository>()),
    );

    Get.put<NotificationController>(NotificationController(), permanent: true);

    Get.put<NavigationController>(NavigationController(), permanent: true);

    Get.put<SettingsController>(SettingsController(), permanent: true);
  }
}
