import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Repository/authentication_repository.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  void login() {
    AuthenticationRepository.instance.loginWithEmailAndPassword(
        email.text,
        password.text,

        onSuccess: () {
          email.clear();
          password.clear();
        }
    );
  }
}
