import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_portal_rakomsis/ui/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoggedin();

  }
  void checkLoggedin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var token = localStorage.getString('token');

    if (token != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    }else{
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              "assets/images/logo.png",
              width: 200.0,
              height: 120.0,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}