import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Login/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_)=> const LoginPage()
        ),
      );
    });


  }
  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
        body: Padding(padding: EdgeInsets.only(bottom: 50), child: Align( alignment: Alignment.center,
          child: Image(height: 250,
            image: AssetImage('assets/images/logo.png',),
          ),),)
    );
  }
}