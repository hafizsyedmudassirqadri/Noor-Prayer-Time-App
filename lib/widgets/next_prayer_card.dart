import 'package:flutter/material.dart';

import '../models/next_prayer.dart';

class NextPrayerCard extends StatelessWidget {

  final NextPrayer prayer;

  const NextPrayerCard({
    super.key,
    required this.prayer,
  });

  String formatDuration(Duration duration) {

    final hours = duration.inHours;

    final minutes = duration.inMinutes.remainder(60);

    final seconds = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(

        color: Colors.teal.shade700,

        borderRadius: BorderRadius.circular(20),

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            'NEXT PRAYER',
            style: TextStyle(
              color: Colors.white70,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            prayer.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Time Remaining',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            formatDuration(prayer.remainingTime),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}