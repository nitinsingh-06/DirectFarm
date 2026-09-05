import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:farmdirect/services/auth_service.dart';
import 'package:farmdirect/features/farmer/dashboard/dashboard_screen.dart';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  final AuthService _authService = AuthService();

  bool isLoading = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    debugPrint('VERIFY OTP BUTTON PRESSED');

    if (otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit OTP')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final userCredential = await _authService.verifyOTP(
        verificationId: widget.verificationId,
        otp: otpController.text.trim(),
      );

      if (!mounted) return;

      final user = userCredential.user;

      if (user == null) {
        throw Exception('Firebase user not found');
      }

      debugPrint('Firebase Login Successful');
      debugPrint('Firebase UID: ${user.uid}');
      debugPrint('Phone: ${user.phoneNumber}');

      debugPrint('Getting Firebase ID Token...');

      final String? idToken = await user.getIdToken();

      if (idToken == null) {
        throw Exception('Unable to get Firebase ID token');
      }

      debugPrint('ID Token obtained successfully');

      final response = await http
          .post(
            Uri.parse('http://127.0.0.1:8000/auth/verify'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'id_token': idToken}),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('FastAPI Status: ${response.statusCode}');
      debugPrint('FastAPI Response: ${response.body}');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FarmerDashboard()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('AUTH ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Authentication failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            Text(
              'OTP sent to ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _verifyOTP,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Verify OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
