
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';

import '../controllers/prayer_controller.dart';

class QiblaScreen extends GetView<PrayerController> {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Compass'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final response = controller.prayerResponse.value;

        if (response == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final qiblaBearing = response.qiblaDegrees;

        return LayoutBuilder(
          builder: (context, constraints) {
            final compassSize = math.min(
              constraints.maxWidth - 48,
              280.0,
            );

            return StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                final heading = snapshot.data?.heading;

                if (snapshot.hasError || heading == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Compass sensor available nahi hai.\n'
                        'Physical device par check karein.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                // Phone heading ko 0-360 degrees mein normalize karein.
                final normalizedHeading =
                    (heading % 360 + 360) % 360;

                // Phone ki current direction se Qibla ka angle.
                final direction =
                    (qiblaBearing - normalizedHeading + 360) % 360;

                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            response.city,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Qibla Direction',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Responsive compass.
                          Container(
                            width: compassSize,
                            height: compassSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.teal.shade50,
                              border: Border.all(
                                color: Colors.teal,
                                width: 3,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const Positioned(
                                  top: 12,
                                  child: Text(
                                    'N',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),

                                Transform.rotate(
                                  angle: direction * math.pi / 180,
                                  child: Icon(
                                    Icons.navigation,
                                    size: compassSize * 0.36,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          Text(
                            '${qiblaBearing.toStringAsFixed(1)}° from North',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Phone Heading: '
                            '${normalizedHeading.toStringAsFixed(1)}°',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 22),

                          const Text(
                            'Phone ko dheere se ghumayein '
                            'aur arrow ko Qibla direction mein align karein.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
