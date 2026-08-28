import 'package:farmdirect/Authentification/screens/login_screen.dart';
import 'package:farmdirect/core/widgets/featurecard.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFA),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            children: [
              // Heading
              const SizedBox(height: 25),

              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to FarmDirect',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D5745),
                  ),
                ),
              ),

              const SizedBox(height: 115),

              // Feature cards
              const FeatureCard(
                icon: Icons.verified_user_outlined,
                title: 'Fresh From Farm',
                description: 'Direct harvest dispatch within hours',
              ),

              const SizedBox(height: 14),

              const FeatureCard(
                icon: Icons.currency_rupee,
                title: 'Fair & Honest Prices',
                description: 'Better earnings for farmers, savings for buyers',
              ),

              const SizedBox(height: 14),

              const FeatureCard(
                icon: Icons.block_outlined,
                title: 'No Middlemen',
                description: 'Direct interaction, completely transparent',
              ),

              // Takes remaining space
              const Spacer(),

              // Get Started button
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                },
                child: Container(
                  height: 41,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF80D000),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF123D32),
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          size: 19,
                          color: Color(0xFF123D32),
                        ),
                      ],
                    ),
                 
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

