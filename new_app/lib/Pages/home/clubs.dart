import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllClubs extends StatelessWidget {
  // Function to get all clubs from Firestore
  Future<List<Map<String, dynamic>>> getAllClubs() async {
    try {
      // Replace 'clubs' with the actual collection name in your Firestore database
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('clubs').get();

      // Extract data from each document
      List<Map<String, dynamic>> clubs = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> doc) => doc.data()!)
          .toList();

      return clubs;
    } catch (e) {
      print('Error fetching clubs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Clubs'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllClubs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No clubs found'));
          }

          // Display the list of clubs
          List<Map<String, dynamic>> clubs = snapshot.data!;
          return ListView.builder(
            itemCount: clubs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> club = clubs[index];

              List<String> coordinators = club['Coordinators'] != null
                  ? List<String>.from(club['Coordinators'])
                  : [];

              return ListTile(
                title: Text(club['name'] ?? 'N/A'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(club['desc'] ?? 'N/A'),
                    Text('Coordinators: ${coordinators.join(', ')}'),
                  ],
                ),
                // Display the photo using the 'photourl'
                leading: club['photourl'] != null
                    ? Image.network(
                  club['photourl'],
                  width: 50, // Adjust the size as needed
                  height: 50,
                )
                    : Container(),
                onTap: () {
                  // Implement navigation to a new page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClubDetailsPage(club: club),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ClubDetailsPage extends StatelessWidget {
  final Map<String, dynamic> club;

  ClubDetailsPage({required this.club});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(club['name'] ?? 'Club Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${club['desc'] ?? 'N/A'}'),
            Text('Coordinators: ${(club['Coordinators'] as List<dynamic>? ?? []).join(', ')}'),
            // You can display additional club details here
          ],
        ),
      ),
    );
  }
}
