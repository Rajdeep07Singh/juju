import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyClubsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          'My Clubs',
          style: TextStyle(color: Colors.white, // Set the font color to white
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: getCurrentUser(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No Data'));
          }

          User user = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              // Add logic to refresh data
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.displayName ?? "Guest",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            user.email ?? "",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey),
                  FutureBuilder(
                    future: _firestore.collection('users').doc(user.uid).get(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return Center(child: Text('No additional data found'));
                      }

                      List<dynamic>? clubs = snapshot.data!.get('Clubs');

                      if (clubs == null || clubs.isEmpty) {
                        return Center(child: Text('You are not a member of any clubs.'));
                      }

                      return DataTable(
                        headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22   , color: Colors.black), // You can adjust color as needed
                        dataTextStyle: TextStyle(fontSize: 18),
                        columns: [
                          DataColumn(
                            label: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Clubs',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                        rows: clubs
                            .map(
                              (club) => DataRow(cells: [
                            DataCell(
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("->     " + club.toString()),
                              ),
                            ),
                          ]),
                        )
                            .toList(),
                      );


                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}