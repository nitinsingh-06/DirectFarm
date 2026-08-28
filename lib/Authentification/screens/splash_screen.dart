import 'dart:async';
import 'package:farmdirect/Authentification/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFF005238),
          child: Column(
            children: [

              SizedBox(height: 50,),

              Image.asset("assets/images/logo.png", width: 100),

              // const SizedBox(height: 130),
              Spacer(),
              Image.asset(
                'assets/images/landscape.png',
                width: 250,
                fit: BoxFit.contain,
              ),
              // const SizedBox(height: 290),
              Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "EMPOWERING INDIA'S FARMER",
                  style: TextStyle(fontSize: 14, color: Color(0xFF69D0A1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

