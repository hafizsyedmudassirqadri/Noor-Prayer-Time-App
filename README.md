# Noor Prayer 🕌

**A Flutter-based Islamic prayer times application designed to make daily prayer schedules easier to access.**

Noor Prayer is a mobile application built with Flutter and Dart. It provides daily prayer timings, a monthly prayer timetable, next prayer countdown, Qibla direction, and customizable prayer notifications — all within a clean and simple interface.

The project was developed to explore Flutter application development, REST API integration, state management with GetX, and local notifications.

## ✨ Features

- **Daily Prayer Times** – View the five daily prayer timings: Fajr, Dhuhr, Asr, Maghrib, and Isha.
- **Next Prayer Countdown** – See how much time remains until the next prayer.
- **Monthly Prayer Timetable** – Access prayer schedules throughout the month.
- **Qibla Direction** – View the Qibla bearing in degrees.
- **Qibla Compass** – Compass functionality on devices equipped with a compatible magnetometer sensor.
- **Prayer Notifications** – Enable or disable individual notifications for each of the five daily prayers.
- **City Selection** – Select from supported Pakistani cities.
- **Dark & Light Themes** – Switch between dark and light appearance.
- **Bottom Navigation** – Easily navigate between the main sections of the application.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI development |
| Dart | Application programming language |
| GetX | State management and dependency injection |
| REST API | Fetching prayer time data |
| HTTP | API communication |
| SharedPreferences | Saving local user preferences |
| flutter_local_notifications | Local prayer notifications |
| flutter_compass | Device compass sensor access |
| Timezone | Scheduling timezone-aware notifications |

## 📡 API & Data Source

Prayer time information is retrieved from:

**[PrayerTime.info](https://prayertime.info/)**

Example API endpoint:

`https://prayertime.info/api/pakistan/karachi.json`

The application uses this API to retrieve prayer schedules and related Qibla information.

## 📱 Screens

The application includes the following main sections:

- Home – Daily prayer timings and next prayer countdown.
- Monthly – Monthly prayer timetable.
- Qibla – Qibla bearing and compass interface.
- Settings – Theme, city selection, and prayer notification preferences.

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites

Make sure you have installed:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Android SDK
- Git

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/hafizsyedmudassirqadri/Noor-Prayer-Time-App.git
```

**2. Navigate to the project directory**

```bash
cd noor_prayer_app
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Run the application**

```bash
flutter run
```

## 📂 Project Structure

```text
lib/
├── app/
│   └── bindings/
│       └── initial_binding.dart
│
├── controllers/
│   ├── prayer_controller.dart
│   ├── settings_controller.dart
│   ├── navigation_controller.dart
│   └── notification_controller.dart
│
├── models/
│   ├── prayer_day.dart
│   ├── prayer_response.dart
│   └── next_prayer.dart
│
├── repositories/
│   └── prayer_repository.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── monthly_screen.dart
│   ├── qibla_screen.dart
│   ├── settings_screen.dart
│   └── main_navigation_screen.dart
│
├── services/
│   ├── prayer_api_service.dart
│   └── notification_service.dart
│
└── main.dart
```

## 🔔 Notification Permissions

Prayer notifications require the appropriate Android permissions.

Depending on the Android version and device settings, the application may request:

- Notification permission.
- Exact alarm permission.

Notifications may not work as expected if the required permissions are denied or restricted by the device.

## 🧭 Qibla Compass Compatibility

The Qibla bearing can be displayed independently of the device compass.

Live compass functionality requires a compatible magnetometer sensor. Devices without this hardware may display the Qibla bearing but cannot provide live compass rotation.

## 📌 Future Improvements

Possible improvements for future versions include:

- Automatic location detection.
- Support for more cities and countries.
- Additional prayer calculation methods.
- Improved compass calibration and device compatibility.
- More notification customization options.

## 🙏 Acknowledgements

Prayer time data is provided by [PrayerTime.info](https://prayertime.info/).

This project uses data made available under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license. Appropriate attribution is provided to the data source.

## 👨‍💻 Developer

Hafiz Syed Muddassir Hassan

Developed as a personal Flutter learning project.

If you find this project useful, feel free to explore the source code, report issues, or suggest improvements.

---

**Built with Flutter & Dart ❤️**