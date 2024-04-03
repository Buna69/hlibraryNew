import 'package:flutter/material.dart';

class SignUpWithEmailAndPasswordFailure {
  get message => null;

   show(BuildContext context, String code) {
    String message;
    switch (code) {
      case 'weak-password':
        message = 'Please enter a stronger password.';
        break;
      case 'invalid-email':
        message = 'Email is not valid or badly formatted.';
        break;
      case 'email-already-in-use':
        message = 'An account already exists for that email.';
        break;
      case 'operation-not-allowed':
        message = 'Operation is not allowed.';
        break;
      case 'user-disabled':
        message = 'This user has been disabled.';
        break;
      default:
        message = 'An unknown error has occurred.';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );

  }
}
