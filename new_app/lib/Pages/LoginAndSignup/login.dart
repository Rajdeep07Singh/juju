import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/Pages/LoginAndSignup/signup.dart';
import 'package:new_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.only(top: size.height * 0.1),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 105, 104, 104),
                Color.fromARGB(255, 62, 62, 62),
                Colors.black
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.10,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 800),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.04),
              FadeInUp(

                duration: Duration(milliseconds: 1200),
                child: SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.08,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 150, 150, 150),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                duration: Duration(milliseconds: 1600),
                child: SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.08,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 150, 150, 150),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: size.height* 0.03),
              FadeInUp(
                duration: Duration(milliseconds: 2000),
                child: SizedBox(
                  height: size.height*0.055,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );
                      }
                      String val = await Auth.signinUser(
                        emailController.text,
                        passwordController.text,
                      );
                      if (context.mounted) Navigator.pop(context);
                      if (val == 'success') {
                        String ptype = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then(
                              (value) => value.data()!['profileType'].toString(),
                        );

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                currentIndex: 1,
                                profileType: ptype,
                              ),
                            ),
                          );
                        }
                        val = 'Signed in';
                      }
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(val.toString())),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.white),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(height: size.height * 0.15),
              FadeInUp(
                duration: Duration(milliseconds: 2400),
                child: Container(
                  color: const Color.fromARGB(255, 62, 62, 62),
                  width: size.width,
                  height: (size.height * 0.09)+10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Don’t have an account ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: size.width*0.01),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}