import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/Pages/LoginAndSignup/login.dart';
import 'package:new_app/Pages/home/activity.dart';
import 'package:new_app/Pages/home/admin.dart';
import 'package:new_app/Pages/home/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:new_app/Pages/home/custom_loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return CustomLoadingScreen(
                    isLoading: false, // Set to true if you want to show loading
                    child: HomePage(
                      currentIndex: 1,
                      profileType: snapshot.data!['profileType'].toString(),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final int currentIndex;
  final String profileType;
  const HomePage(
      {super.key, required this.currentIndex, required this.profileType});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int currentIndex;
  late String profileType;
  final List<Widget> _pages = [
    const ActivityPage(),
    const ProfilePage(),
    const AdminPage(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
    profileType = widget.profileType;
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: _pages[currentIndex],

        bottomNavigationBar: CurvedNavigationBar(

          index: currentIndex,
          height: 57,
          color: Colors.deepPurpleAccent,

          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),

          items: profileType == 'Admin'
              ? [
            _buildNavItem(Icons.event, 'Activity'),
            _buildNavItem(Icons.person, 'Profile'),
            _buildNavItem(Icons.admin_panel_settings, 'Admin'),
          ]
              : [
            _buildNavItem(Icons.event, 'Activity'),
            _buildNavItem(Icons.person, 'Profile'),
          ],
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
Widget _buildNavItem(IconData icon, String text) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 1), // Adjust the bottom padding as needed
        child: Icon(icon, size: 30),
      ),
      Text(
        text,
        style: TextStyle(fontSize: 12), // Adjust the font size as needed
      ),
    ],
  );
}