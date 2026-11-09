import 'package:flutter/material.dart';

class PrayerCard extends StatelessWidget {

  final String title;
  final String time;

  const PrayerCard({
    super.key,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),

      child: ListTile(

        leading: const Icon(
          Icons.mosque,
          color: Colors.teal,
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        trailing: Text(
          time,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}