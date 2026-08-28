import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      final phone = phoneController.text.trim();

      debugPrint("OTP sent to: $phone");

      // Add your OTP API/navigation here.
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
                  15,
                  18,
                  15,
                  100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // =========================
                    // TITLE
                    // =========================
                    const Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF075B4A),
                      ),
                    ),

                    // =========================
                    // IMAGE / SECURITY ICON
                    // =========================
                    const SizedBox(height: 89),

                    Center(
                      child: Container(
                        width: 130,
                        height: 102,
                        color: Colors.white,
                        child: Image.asset(
                          "assets/images/resetpassword.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // =========================
                    // DESCRIPTION
                    // =========================
                    const SizedBox(height: 22),

                    const Text(
                      "Enter your registered mobile number below to\n"
                      "receive a secure 6-digit OTP code.",
                      style: TextStyle(
                        fontSize: 9.5,
                        height: 1.35,
                        color: Color(0xFF737B86),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    // =========================
                    // LABEL
                    // =========================
                    const SizedBox(height: 20),

                    const Text(
                      "Registered Phone Number",
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF263238),
                      ),
                    ),

                    const SizedBox(height: 5),

                    // =========================
                    // PHONE FIELD
                    // =========================
                    SizedBox(
                      height: 34,
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF374151),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your phone number";
                          }

                          if (value.trim().length < 10) {
                            return "Enter a valid phone number";
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "e.g. +91 9876543210",
                          hintStyle: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF8B949E),
                          ),

                          prefixIcon: const Icon(
                            Icons.phone_outlined,
                            size: 16,
                            color: Color(0xFF7B8794),
                          ),

                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 37,
                            minHeight: 34,
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

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // =========================
              // SEND OTP BUTTON
              // =========================
              Positioned(
                left: 15,
                right: 15,
                bottom: 16,
                child: GestureDetector(
                  onTap: _sendOtp,
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF80D000),
                      borderRadius: BorderRadius.circular(22),

                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF80D000)
                              .withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Send OTP",
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF123400),
                          ),
                        ),

                        SizedBox(width: 6),

                        Icon(
                          Icons.shield_outlined,
                          size: 15,
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