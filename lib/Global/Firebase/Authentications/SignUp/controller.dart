import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlibrary/Global/Firebase/Authentications/Repository/authentication_repository.dart';
import 'package:hlibrary/Global/Firebase/Authentications/Repository/user_repository.dart';

import '../Models/user_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final UserRepository userRepo = Get.put(UserRepository());

  Future<void> registerUser(String username, String email, String password) async {
    try {
      // Create the user in Firebase Authentication
      var authResult = await AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password);

      // Generate a unique ID for the user
      var userId = authResult.user!.uid;

      // Store user data in Firestore
      await userRepo.addUser(
        UserModel(
          id: userId, // Set the ID for the user
          username: username,
          email: email,
        ),
      );

      // Clear text fields
      this.email.clear();
      this.password.clear();
      this.username.clear();
    } catch (e) {
      print("Error registering user: $e");
      // Handle error here
      throw e; // Rethrow the exception to propagate it further if needed
    }
  }
}
