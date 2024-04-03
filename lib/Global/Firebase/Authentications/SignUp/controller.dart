import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Repository/authentication_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();

  void registerUser() {
    AuthenticationRepository.instance.createUserWithEmailAndPassword(
        email.text,
        password.text,
        onSuccess: () {
          // Clear text fields
          email.clear();
          password.clear();
          username.clear();
        }
    );
  }
}
