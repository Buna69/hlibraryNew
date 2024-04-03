import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlibrary/AppPage/app_page.dart';
import 'package:hlibrary/StartPage/SignUp/signup_page.dart';
import '../../../../StartPage/Login/login_page.dart';
import 'Exceptions/signin_email_failure.dart';
import 'Exceptions/signup_email_failure.dart';


class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();


  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  String? get code => null;


  //Will be load when app launches this func will be called and set the firebaseUser state
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }


  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginPage());
    } else {
      Get.offAll(() => const AppPage());
    }
  }



  //FUNC
  Future<void> createUserWithEmailAndPassword(
      String email,
      String password,
      {Function? onSuccess}
      ) async {
    try {
      // Your authentication logic here
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(() => const AppPage()) : Get.to(() => const SignUpPage());

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Account created'),
          duration:  Duration(seconds: 1), // Display for 1 second
        ),
      );

      onSuccess?.call(); // Call the onSuccess callback if provided
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure();
      ex.show(Get.context!, e.code); // Pass the BuildContext along with the error code
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
  }


  Future<void> loginWithEmailAndPassword(
      String email,
      String password,
      {Function? onSuccess}
      ) async {

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(() => const AppPage()) : Get.to(() => const LoginPage());
      
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Logged in'),
          duration:  Duration(seconds: 1), // Display for 1 second
        ),
      );

      onSuccess?.call(); // Call the onSuccess callback if provided
    } on FirebaseAuthException catch (e) {
      final ex = SignInWithEmailAndPasswordFailure();
      ex.show(Get.context!, e.code); // Pass the BuildContext along with the error code
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      final ex = SignInWithEmailAndPasswordFailure();
      print('FIREBASE AUTH EXCEPTION - ${ex.show}');
      throw ex;
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => const LoginPage());
  }
}
