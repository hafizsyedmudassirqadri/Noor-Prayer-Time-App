import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/prayer_controller.dart';

class MonthlyScreen extends GetView<PrayerController> {
  const MonthlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Timetable'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: Obx(() {
        final response = controller.prayerResponse.value;

        if (controller.isLoading.value && response == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (response == null) {
          return const Center(
            child: Text('Prayer timetable not available.'),
          );
        }

        if (response.days.isEmpty) {
          return const Center(
            child: Text('No prayer timings found.'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Colors.teal.shade100,
              ),
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Fajr')),
                DataColumn(label: Text('Sunrise')),
                DataColumn(label: Text('Dhuhr')),
                DataColumn(label: Text('Asr')),
                DataColumn(label: Text('Maghrib')),
                DataColumn(label: Text('Isha')),
              ],
              rows: response.days.map((day) {
                final parsedDate = DateTime.tryParse(day.date);

                final displayDate = parsedDate == null
                    ? day.date
                    : DateFormat('dd MMM').format(parsedDate);

                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        displayDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataCell(Text(day.fajr)),
                    DataCell(Text(day.sunrise)),
                    DataCell(Text(day.dhuhr)),
                    DataCell(Text(day.asr)),
                    DataCell(Text(day.maghrib)),
                    DataCell(Text(day.isha)),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}