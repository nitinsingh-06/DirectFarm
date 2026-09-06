import 'package:farmdirect/Authentification/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        // Firebase is checking the current login state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is already logged in
        if (snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: Text(
                'User logged in\nRole checking will be added next',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // User is not logged in
        return const WelcomeScreen();
      },
    );
  }
}