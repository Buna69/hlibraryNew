import 'package:flutter/material.dart';

class SignInWithEmailAndPasswordFailure {
  get message => null;

   show(BuildContext context, String code) {
    String message;
    switch (code) {
      case 'user-not-found':
        message = 'No user found with this email. Please check your email or sign up.';
        break;
      case 'invalid-email':
        message = 'Invalid email address. Please enter a valid email.';
        break;
      case 'wrong-password':
        message = 'Incorrect password. Please try again.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled. Please contact support for assistance.';
        break;
      case 'user-token-expired':
        message = 'Your session has expired. Please sign in again.';
        break;
      case 'operation-not-allowed':
        message = 'Sign in operation is not allowed. Please contact support.';
        break;
      case 'weak-password':
        message = 'The password is too weak. Please choose a stronger password.';
        break;
      case 'network-request-failed':
        message = 'A network error has occurred. Please check your internet connection.';
        break;
      case 'timeout':
        message = 'The request has timed out. Please try again later.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Please try again later.';
        break;
      default:
        message = 'Invalid email address or Incorrect password.';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
