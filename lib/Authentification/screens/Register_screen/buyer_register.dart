// ignore_for_file: unused_element

import 'package:farmdirect/Authentification/screens/Register_screen/successful_screen.dart';
import 'package:flutter/material.dart';

class BuyerRegisterScreen extends StatefulWidget {
  const BuyerRegisterScreen({super.key});

  @override
  State<BuyerRegisterScreen> createState() => _BuyerRegisterScreenState();
}

class _BuyerRegisterScreenState extends State<BuyerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF263238),
          ),
        ),

        const SizedBox(height: 5),

        SizedBox(
          height: 38,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF374151),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF8B949E),
              ),
              prefixIcon: Icon(
                icon,
                size: 17,
                color: const Color(0xFF7B8794),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 38,
                minHeight: 38,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFE1E5E9),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFE1E5E9),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF80D000),
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF263238),
          ),
        ),

        const SizedBox(height: 5),

        SizedBox(
          height: 38,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF374151),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF8B949E),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFE1E5E9),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFE1E5E9),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF80D000),
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _registerBuyer() {
    if (_formKey.currentState!.validate()) {
      // Registration logic here
      debugPrint("Buyer registration submitted");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  17,
                  14,
                  17,
                  100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================
                    // HEADER
                    // =========================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Buyer Register",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF075B4A),
                          ),
                        ),

                        Text(
                          "Step 1 of 2",
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    // Space before form
                    const SizedBox(height: 103),

                    // =========================
                    // FULL NAME
                    // =========================
                    _buildTextField(
                      label: "Full Name / Company Name",
                      hint: "e.g. FreshMart Retail",
                      icon: Icons.person_outline,
                      controller: nameController,
                    ),

                    const SizedBox(height: 13),

                    // =========================
                    // EMAIL
                    // =========================
                    _buildTextField(
                      label: "Email Address",
                      hint: "e.g. procurement@freshmart.com",
                      icon: Icons.mail_outline,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 13),

                    // =========================
                    // ADDRESS
                    // =========================
                    _buildTextField(
                      label: "Delivery / Warehouse Address",
                      hint: "Street, Sector, Warehousing Zone",
                      icon: Icons.location_on_outlined,
                      controller: addressController,
                    ),

                    const SizedBox(height: 13),

                    // =========================
                    // CITY + PINCODE
                    // =========================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildSmallTextField(
                            label: "City",
                            hint: "e.g. New Delhi",
                            controller: cityController,
                          ),
                        ),

                        const SizedBox(width: 13),

                        Expanded(
                          child: _buildSmallTextField(
                            label: "Pincode",
                            hint: "e.g. 110001",
                            controller: pincodeController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // =========================
              // BOTTOM REGISTER BUTTON
              // =========================
              Positioned(
                left: 17,
                right: 17,
                bottom: 18,
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SuccessScreen()));
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF80D000),
                      borderRadius: BorderRadius.circular(22),

                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF80D000).withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Register as Buyer",
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF123400),
                              ),
                            ),

                
                          ],
                        ),

                        const SizedBox(width: 7),

                        const Icon(
                          Icons.person_add_alt_1_outlined,
                          size: 17,
                          color: Color(0xFF123400),
                        ),
                      ],
                    ),
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