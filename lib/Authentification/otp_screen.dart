import 'dart:convert';

import 'package:farmdirect/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:farmdirect/services/auth_service.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  // ============================================================
  // FIREBASE OTP DATA
  // ============================================================

  final String verificationId;
  final String phoneNumber;

  // ============================================================
  // AUTH MODE
  // ============================================================
  //
  // login    → existing user
  // register → new user
  //

  final String mode;

  // ============================================================
  // USER ROLE
  // ============================================================
  //
  // farmer
  // buyer
  //

  final String? role;

  // ============================================================
  // REGISTRATION DATA
  // ============================================================
  //
  // Farmer/Buyer profile data
  //

  final Map<String, dynamic>? registrationData;

  const OtpScreen(
    {
    super.key,

    required this.verificationId,
    required this.phoneNumber,

    this.mode = 'login',
    this.role,
    this.registrationData,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  // ============================================================
  // CONTROLLER
  // ============================================================

  final TextEditingController otpController =
      TextEditingController();

  // ============================================================
  // AUTH SERVICE
  // ============================================================

  final AuthService _authService = AuthService();

  // ============================================================
  // STATE
  // ============================================================

  bool isLoading = false;

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<void> _verifyOTP() async {

    final otp = otpController.text.trim();

    // ------------------------------------------------------------
    // OTP VALIDATION
    // ------------------------------------------------------------

    if (otp.length != 6) {
      _showMessage(
        'Please enter a 6-digit OTP.',
      );

      return;
    }

    // ------------------------------------------------------------
    // LOADING
    // ------------------------------------------------------------

    setState(() {
      isLoading = true;
    });

    try {

      // ==========================================================
      // STEP 1
      // VERIFY OTP WITH FIREBASE
      // ==========================================================

      final userCredential =
          await _authService.verifyOTP(
        verificationId:
            widget.verificationId,

        otp: otp,
      );

      final user = userCredential.user;

      // ----------------------------------------------------------
      // CHECK FIREBASE USER
      // ----------------------------------------------------------

      if (user == null) {
        throw Exception(
          'Firebase user not found.',
        );
      }

      debugPrint(
        'Firebase authentication successful.',
      );

      debugPrint(
        'Firebase UID: ${user.uid}',
      );

      // ==========================================================
      // STEP 2
      // GET FIREBASE ID TOKEN
      // ==========================================================

      final String? idToken =
          await user.getIdToken();

      if (idToken == null) {
        throw Exception(
          'Unable to get Firebase ID token.',
        );
      }

      debugPrint(
        'Firebase ID token obtained.',
      );

      // ==========================================================
      // STEP 3
      // CHECK MODE
      // ==========================================================

      if (widget.mode == 'register') {

        await _registerUser(
          user: user,
          idToken: idToken,
        );

      } else {

        await _loginUser(
          idToken: idToken,
        );
      }

    } catch (e) {

      debugPrint(
        'OTP AUTH ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        'Authentication failed: $e',
      );
    }
  }

  // ============================================================
  // REGISTER USER
  // ============================================================

  Future<void> _registerUser({
    required dynamic user,
    required String idToken,
  }) async {

    // ------------------------------------------------------------
    // ROLE CHECK
    // ------------------------------------------------------------

    if (widget.role == null) {
      throw Exception(
        'User role is missing.',
      );
    }

    // ------------------------------------------------------------
    // CREATE REQUEST DATA
    // ------------------------------------------------------------

    final Map<String, dynamic> requestData = {

      // Firebase authentication
      'id_token': idToken,

      'firebase_uid': user.uid,

      // User role
      'role': widget.role,

      // Authentication phone
      'phone': widget.phoneNumber,

      // Farmer/Buyer profile
      ...?widget.registrationData,
    };

    debugPrint(
      'Registering user with role: ${widget.role}',
    );

    // ==========================================================
    // SEND TO FASTAPI
    // ==========================================================

    final response = await http
        .post(
          Uri.parse(
            '${ApiConfig.baseUrl}/auth/register',
          ),

          headers: {
            'Content-Type': 'application/json',
          },

          body: jsonEncode(
            requestData,
          ),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    debugPrint(
      'Registration status: ${response.statusCode}',
    );

    debugPrint(
      'Registration response: ${response.body}',
    );

    // ==========================================================
    // CHECK RESPONSE
    // ==========================================================

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {

      throw Exception(
        'Registration failed: ${response.body}',
      );
    }

    // ==========================================================
    // SUCCESS
    // ==========================================================

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    _showMessage(
      'Registration successful!',
    );

    // ------------------------------------------------------------
    // IMPORTANT
    // ------------------------------------------------------------
    //
    // We don't manually open FarmerDashboard or BuyerDashboard.
    //
    // Later AuthGate will determine:
    //
    // farmer → FarmerDashboard
    // buyer  → BuyerDashboard
    //
    // ------------------------------------------------------------

    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  // ============================================================
  // LOGIN USER
  // ============================================================

  Future<void> _loginUser({
    required String idToken,
  }) async {

    // ==========================================================
    // SEND TOKEN TO FASTAPI
    // ==========================================================

    final response = await http
        .post(
          Uri.parse(
            '${ApiConfig.baseUrl}/auth/register',
          ),

          headers: {
            'Content-Type': 'application/json',
          },

          body: jsonEncode({
            'id_token': idToken,
          }),
        )

        .timeout(
          const Duration(seconds: 10),
        );

    debugPrint(
      'Login verification status: ${response.statusCode}',
    );

    debugPrint(
      'Login verification response: ${response.body}',
    );

    // ==========================================================
    // CHECK RESPONSE
    // ==========================================================

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {

      throw Exception(
        'Login verification failed: ${response.body}',
      );
    }

    // ==========================================================
    // SUCCESS
    // ==========================================================

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    _showMessage(
      'Login successful!',
    );

    // ------------------------------------------------------------
    // IMPORTANT
    // ------------------------------------------------------------
    //
    // Don't navigate directly to FarmerDashboard.
    //
    // AuthGate will eventually check the user's role.
    //
    // ------------------------------------------------------------

    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(
    String message,
  ) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Verify OTP',
        ),
      ),

      body: SafeArea(

        child: Padding(
          padding:
              const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(
                height: 40,
              ),

              // ==================================================
              // OTP MESSAGE
              // ==================================================

              Text(
                'OTP sent to ${widget.phoneNumber}',

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // ==================================================
              // MODE
              // ==================================================

              Text(
                widget.mode == 'register'
                    ? 'Verify your phone to complete registration.'
                    : 'Verify your phone to login.',

                textAlign:
                    TextAlign.center,

                style:
                    TextStyle(
                  fontSize: 13,
                  color:
                      Colors.grey.shade600,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // ==================================================
              // OTP FIELD
              // ==================================================

              TextField(
                controller:
                    otpController,

                keyboardType:
                    TextInputType.number,

                maxLength: 6,

                textAlign:
                    TextAlign.center,

                style:
                    const TextStyle(
                  fontSize: 20,
                  letterSpacing: 8,
                ),

                decoration:
                    const InputDecoration(
                  labelText:
                      'Enter OTP',

                  border:
                      OutlineInputBorder(),

                  counterText: '',
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ==================================================
              // VERIFY BUTTON
              // ==================================================

              SizedBox(
                width:
                    double.infinity,

                height: 50,

                child:
                    ElevatedButton(

                  onPressed:
                      isLoading
                          ? null
                          : _verifyOTP,

                  child:
                      isLoading

                          ? const SizedBox(
                              height: 22,
                              width: 22,

                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )

                          : Text(
                              widget.mode ==
                                      'register'
                                  ? 'Verify & Register'
                                  : 'Verify OTP',
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
