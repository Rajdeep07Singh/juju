import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  final Map<String, dynamic> activity;

  AnnouncementDetailsPage({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blueGrey,
      appBar: AppBar(backgroundColor: Colors.white,
        title: Text('Announcement Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${activity['title'] ?? 'N/A'}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Date: ${_formatDate(activity['date']) ?? 'N/A'}',
                style: TextStyle(fontSize: 18,color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                'Details: ${activity['details'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16,color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _formatDate(Timestamp? date) {
    if (date == null) return null;
    // Assuming date is a Timestamp, you may need to adjust this based on your data structure
    DateTime dateTime = date.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}