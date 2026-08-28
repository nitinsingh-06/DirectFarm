import 'package:farmdirect/Authentification/screens/Register_screen/buyer_register.dart';
import 'package:farmdirect/Authentification/screens/Register_screen/farmer_register.dart';
import 'package:farmdirect/core/widgets/select_role_cardwidgets.dart';
import 'package:flutter/material.dart';

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  String selectedRole = 'farmer';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- TITLE ----------------
              SizedBox(height: size.height * 0.035),

              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF075B48),
                ),
              ),

              // Space between title and cards
              SizedBox(height: size.height * 0.19),

              // ---------------- FARMER CARD ----------------
              RoleCard(
                title: 'Farmer / FPO',
                description:
                    'Sell crops directly, get fair prices, and secure\nfast digital payments.',
                icon: Icons.agriculture_outlined,
                selected: selectedRole == 'farmer',
                onTap: () {
                  setState(() {
                    selectedRole = 'farmer';

                  });
                },
              ),

              const SizedBox(height: 15),

              // ---------------- BUYER CARD ----------------
              RoleCard(
                title: 'Buyer / Bulk Buyer',
                description:
                    'Source directly from Indian farms with\ntransparent logistics.',
                icon: Icons.shopping_bag_outlined,
                selected: selectedRole == 'buyer',
                onTap: () {
                  setState(() {
                    selectedRole = 'buyer';
                  });
                },
              ),

              // Push button to bottom
              const Spacer(),

              // ---------------- CONTINUE BUTTON ----------------
              SizedBox(
                width: double.infinity,
                height: 43,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedRole == 'farmer') {
                      debugPrint('Farmer selected');
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>FarmerRegisterPage()),);
                    } else {
                      debugPrint('Buyer selected');
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BuyerRegisterScreen()),);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF82D000),
                    foregroundColor: const Color(0xFF073D2F),
                    elevation: 3,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- BOTTOM SPACE ----------------
              SizedBox(height: size.height * 0.075),
            ],
          ),
        ),
      ),
    );
  }
}
