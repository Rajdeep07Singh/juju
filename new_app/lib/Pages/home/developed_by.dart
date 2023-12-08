import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class DevelopedByPage extends StatelessWidget {
  // Function to get all clubs from Firestore
  Future<List<Map<String, dynamic>>> getAllClubs() async {
    try {
      // Replace 'clubs' with the actual collection name in your Firestore database
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Developed by').get();

      // Extract data from each document
      List<Map<String, dynamic>> clubs = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> doc) => doc.data()!)
          .toList();

      return clubs;
    } catch (e) {
      print('Error fetching developers: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Developers'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllClubs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('NO developers'));
          }

          // Display the list of clubs
          List<Map<String, dynamic>> clubs = snapshot.data!;
          return ListView.builder(
            itemCount: clubs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> club = clubs[index];



              return ListTile(
                title: Text(club['name'] ?? 'N/A'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(club['role'] ?? 'N/A'),

                  ],
                ),
                // Display the photo using the 'photourl'
                leading: club['photourl'] != null
                    ? Image.network(
                  club['photourl'],
                  width: 100, // Adjust the size as needed
                  height: 100,
                )
                    : Container(),
              );
            },
          );
        },
      ),
    );
  }
}



