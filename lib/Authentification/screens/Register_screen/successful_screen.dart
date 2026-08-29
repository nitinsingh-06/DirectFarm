import 'package:farmdirect/Authentification/screens/comming_soon.dart';
import 'package:farmdirect/core/widgets/animations/successful_register.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D5A46),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Separate animation class
              const SuccessAnimation(),

              const SizedBox(height: 28),

              const Text(
                'Success!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Your FarmDirect account is verified.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8CC3B4),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(flex: 4),

              // Dashboard button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ComingSoonScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8DD500),
                    foregroundColor: const Color(0xFF073D30),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Go to Dashboard',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.home_outlined,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

