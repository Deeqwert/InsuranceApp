import 'dart:async';
import 'package:flutter/material.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/screens/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColors.background_white
        ),
        child:Center(
          child:
          Image.asset(
            'assets/images/logo_image_shadow.png',
            fit: BoxFit.cover,
            width: 100,height: 100,
          ),
        )
      ),
    );
  }
}
