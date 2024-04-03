import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Path to your logo.png file
              width: 24, // Adjust the width of the logo as needed
              height: 24, // Adjust the height of the logo as needed
              color: Colors.white, // Customize the color of the logo if needed
            ),
            SizedBox(width: 8.0), // Add some spacing
            Text(
              message,
              style: TextStyle(color: Colors.white),
            ), // Your message
          ],
        ),
        backgroundColor: Colors.blue, // Customize the background color of the Snackbar
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  static void showError(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Path to your logo.png file
              width: 24, // Adjust the width of the logo as needed
              height: 24, // Adjust the height of the logo as needed
              color: Colors.white, // Customize the color of the logo if needed
            ),
            SizedBox(width: 8.0), // Add some spacing
            Text(
              message,
              style: TextStyle(color: Colors.white),
            ), // Your error message
          ],
        ),
        backgroundColor: Colors.red, // Customize the background color of the Snackbar for error
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }
}
