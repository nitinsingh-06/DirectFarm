import 'dart:async';

import 'package:farmdirect/Authentification/screens/welcome_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/buyer_dashboard_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 1),
      _checkLoginStatus,
    );
  }

  // ============================================================
  // CHECK LOGIN STATUS
  // ============================================================

  Future<void> _checkLoginStatus() async {

    if (!mounted) return;

    // Firebase tells us whether the user is authenticated
    final firebaseUser =
        FirebaseAuth.instance.currentUser;

    // ==========================================================
    // USER NOT LOGGED IN
    // ==========================================================

    if (firebaseUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );

      return;
    }

    // ==========================================================
    // USER IS ALREADY LOGGED IN
    // ==========================================================

    final prefs =
        await SharedPreferences.getInstance();

    final role =
        prefs.getString('user_role');

    debugPrint('================================');
    debugPrint('AUTO LOGIN');
    debugPrint('Firebase UID: ${firebaseUser.uid}');
    debugPrint('Saved Role: $role');
    debugPrint('================================');

    // ==========================================================
    // BUYER
    // ==========================================================

    if (role == 'buyer') {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerDashboard(),
        ),
      );

      return;
    }

    // ==========================================================
    // FARMER
    // ==========================================================

    if (role == 'farmer') {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FarmerDashboard(),
        ),
      );

      return;
    }

    // ==========================================================
    // ROLE NOT FOUND
    // ==========================================================

    // Sign out so the user can login again
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF005238),
          child: Column(
            children: [

              const SizedBox(height: 50),

              Image.asset(
                "assets/images/logo.png",
                width: 120,
              ),

              const Spacer(),

              Image.asset(
                'assets/images/landscape.png',
                width: 250,
                fit: BoxFit.contain,
              ),

              const Spacer(),

              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "EMPOWERING INDIA'S FARMER",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF69D0A1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}