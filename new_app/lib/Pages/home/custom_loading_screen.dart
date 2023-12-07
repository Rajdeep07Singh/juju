import 'package:flutter/material.dart';

class CustomLoadingScreen extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  CustomLoadingScreen({required this.child, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/loading_image.png',
                    width: 100, // Adjust the width as needed
                    height: 100, // Adjust the height as needed
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
      ],
    );
  }
}