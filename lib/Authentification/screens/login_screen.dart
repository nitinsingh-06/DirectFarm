import 'dart:convert';

import 'package:farmdirect/Authentification/otp_screen.dart';
import 'package:farmdirect/Authentification/screens/comming_soon.dart';
import 'package:farmdirect/Authentification/screens/select_role_screen.dart';
import 'package:farmdirect/config/api_config.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/buyer_dashboard_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/dashboard_screen.dart';
import 'package:farmdirect/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  // ============================================================
  // STATES
  // ============================================================

  bool isEmailLogin = false;
  bool obscurePassword = true;

  bool isSendingOtp = false;
  bool isEmailLoading = false;

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF78D000);
  static const Color darkGreen = Color(0xFF155B4B);
  static const Color background = Color(0xFFF8F9FA);
  static const Color borderColor = Color(0xFFE5E5E5);
  static const Color hintColor = Color(0xFF9AA0AA);

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.paddingOf(context).vertical,
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // LOGIN TITLE
                    // ==================================================
                    const Padding(
                      padding: EdgeInsets.only(top: 18),

                      child: Text(
                        'Login',

                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: darkGreen,
                        ),
                      ),
                    ),

                    // ==================================================
                    // SPACE
                    // ==================================================
                    SizedBox(height: size.height * 0.10),

                    // ==================================================
                    // PHONE / EMAIL SWITCH
                    // ==================================================
                    Row(
                      children: [
                        Expanded(
                          child: _loginTypeButton(
                            title: 'Phone',
                            selected: !isEmailLogin,

                            onPressed: () {
                              setState(() {
                                isEmailLogin = false;
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: _loginTypeButton(
                            title: 'Email',
                            selected: isEmailLogin,

                            onPressed: () {
                              setState(() {
                                isEmailLogin = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // PHONE LOGIN
                    // ==================================================
                    if (!isEmailLogin) ...[
                      const Text(
                        'Phone Number',

                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF28313D),
                        ),
                      ),

                      const SizedBox(height: 5),

                      _inputField(
                        controller: phoneController,
                        hintText: 'e.g. +91 9876543210',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                    ]
                    // ==================================================
                    // EMAIL LOGIN
                    // ==================================================
                    else ...[
                      const Text(
                        'Email Address',

                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF28313D),
                        ),
                      ),

                      const SizedBox(height: 5),

                      _inputField(
                        controller: emailController,
                        hintText: 'e.g. example@gmail.com',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Password',

                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF28313D),
                        ),
                      ),

                      const SizedBox(height: 5),

                      _inputField(
                        controller: passwordController,
                        hintText: 'Enter password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: obscurePassword,

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },

                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,

                            size: 18,

                            color: const Color(0xFF7E8794),
                          ),
                        ),
                      ),
                    ],

                    // ==================================================
                    // REMEMBER ME
                    // ==================================================
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,

                          child: Checkbox(
                            value: true,

                            onChanged: (value) {},

                            activeColor: primaryGreen,

                            side: const BorderSide(color: Color(0xFFDDE1E5)),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        const Text(
                          'Remember me',

                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF9299A3),
                          ),
                        ),
                      ],
                    ),

                    // ==================================================
                    // LOGIN BUTTON
                    // ==================================================
                    SizedBox(height: size.height * 0.13),

                    SizedBox(
                      width: double.infinity,
                      height: 40,

                      child: ElevatedButton(
                        onPressed: isEmailLogin
                            ? (isEmailLoading ? null : _loginWithEmail)
                            : (isSendingOtp ? null : _loginWithPhone),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.black,

                          elevation: 4,

                          shadowColor: primaryGreen.withOpacity(0.35),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),

                        child: isEmailLogin
                            ? (isEmailLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,

                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        SizedBox(width: 6),

                                        Icon(Icons.login, size: 16),
                                      ],
                                    ))
                            : (isSendingOtp
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,

                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,

                                      children: [
                                        Text(
                                          'Send OTP',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),

                                        SizedBox(width: 6),

                                        Icon(Icons.sms_outlined, size: 16),
                                      ],
                                    )),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ==================================================
                    // OR CONTINUE
                    // ==================================================
                    const Center(
                      child: Text(
                        'Or continue with',

                        style: TextStyle(fontSize: 9, color: Color(0xFF969CA4)),
                      ),
                    ),

                    const SizedBox(height: 11),

                    // ==================================================
                    // GOOGLE
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 34,

                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => ComingSoonScreen(),
                            ),
                          );
                        },

                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,

                          side: const BorderSide(color: borderColor),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.g_mobiledata,
                              size: 20,
                              color: Colors.black,
                            ),

                            SizedBox(width: 4),

                            Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF313740),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ==================================================
                    // REGISTER
                    // ==================================================
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (context) => ChooseRoleScreen(),
                            ),
                          );
                        },

                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF858C95),
                            ),

                            children: [
                              TextSpan(text: 'New here? '),

                              TextSpan(
                                text: 'Register Now',
                                style: TextStyle(
                                  color: darkGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // LOGIN TYPE BUTTON
  // ================================================================

  Widget _loginTypeButton({
    required String title,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 38,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? primaryGreen : Colors.white,

          foregroundColor: selected ? Colors.black : darkGreen,

          elevation: selected ? 2 : 0,

          side: BorderSide(color: selected ? primaryGreen : borderColor),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        child: Text(
          title,

          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // ================================================================
  // INPUT FIELD
  // ================================================================

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,

    TextInputType? keyboardType,

    bool obscureText = false,

    Widget? suffixIcon,
  }) {
    return SizedBox(
      height: 40,

      child: TextField(
        controller: controller,

        keyboardType: keyboardType,

        obscureText: obscureText,

        style: const TextStyle(fontSize: 10, color: Color(0xFF303640)),

        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: const TextStyle(fontSize: 10, color: hintColor),

          prefixIcon: Icon(
            prefixIcon,
            size: 17,
            color: const Color(0xFF858D99),
          ),

          suffixIcon: suffixIcon,

          prefixIconConstraints: const BoxConstraints(minWidth: 40),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),

          filled: true,

          fillColor: Colors.white,

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: const BorderSide(color: borderColor),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: const BorderSide(color: primaryGreen, width: 1.2),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: const BorderSide(color: Colors.redAccent),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // MAIN LOGIN SWITCH
  // ================================================================

  Future<void> _loginWithPhone() async {
    if (phoneController.text.trim().isEmpty) {
      _showMessage('Please enter your phone number');
      return;
    }

    String phoneNumber = phoneController.text.trim();

    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+91$phoneNumber';
    }

    setState(() {
      isSendingOtp = true;
    });

    try {
      await _authService.sendOTP(
        phoneNumber: phoneNumber,

        // ----------------------------------------------------------
        // OTP SENT
        // ----------------------------------------------------------
        onCodeSent: (verificationId) {
          if (!mounted) return;

          setState(() {
            isSendingOtp = false;
          });

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,

                phoneNumber: phoneNumber,
              ),
            ),
          );
        },

        // ----------------------------------------------------------
        // OTP ERROR
        // ----------------------------------------------------------
        onError: (error) {
          if (!mounted) return;

          setState(() {
            isSendingOtp = false;
          });

          String message;

          switch (error.code) {
            case 'invalid-phone-number':
              message = 'Please enter a valid phone number.';
              break;

            case 'too-many-requests':
              message = 'Too many attempts. Please try again later.';
              break;

            case 'quota-exceeded':
              message = 'OTP limit exceeded. Please try again later.';
              break;

            case 'operation-not-allowed':
              message = 'Phone authentication is not enabled.';
              break;

            case 'network-request-failed':
              message = 'Check your internet connection.';
              break;

            default:
              message = error.message ?? 'Unable to send OTP.';
          }

          _showMessage(message);
        },

        // ----------------------------------------------------------
        // AUTOMATIC VERIFICATION
        // ----------------------------------------------------------
        onAutoVerified: (PhoneAuthCredential credential) async {
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);

            if (!mounted) return;

            setState(() {
              isSendingOtp = false;
            });

            // IMPORTANT:
            // Do not navigate to FarmerDashboard here.
            //
            // AuthGate will detect the Firebase user.
            // Later AuthGate will check the user's role
            // from PostgreSQL and open the correct dashboard.
          } catch (e) {
            if (!mounted) return;

            setState(() {
              isSendingOtp = false;
            });

            _showMessage('Authentication failed: $e');
          }
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSendingOtp = false;
      });

      _showMessage('Something went wrong: $e');
    }
  }

  // ================================================================
  // EMAIL LOGIN
  // ================================================================
  Future<void> _loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      _showMessage('Please enter your email address');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Please enter your password');
      return;
    }

    setState(() {
      isEmailLoading = true;
    });

    try {
      // ============================================================
      // 1. FIREBASE LOGIN
      // ============================================================

      final UserCredential credential = await _authService.loginWithEmail(
        email: email,
        password: password,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase login failed');
      }

      print('Firebase login successful');
      print('Firebase UID: ${firebaseUser.uid}');

      // ============================================================
      // 2. GET FIREBASE ID TOKEN
      // ============================================================

      final String? idToken = await firebaseUser.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Could not get Firebase ID token');
      }

      print('Firebase ID token received');

      // ============================================================
      // 3. LOGIN TO FASTAPI
      // ============================================================

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      print('FastAPI status: ${response.statusCode}');
      print('FastAPI response: ${response.body}');

      // ============================================================
      // 4. CHECK RESPONSE
      // ============================================================

      if (response.statusCode != 200) {
        String message = 'FarmDirect login failed';

        try {
          final data = jsonDecode(response.body);

          if (data['detail'] != null) {
            message = data['detail'].toString();
          }
        } catch (_) {}

        throw Exception(message);
      }

      // ============================================================
      // 5. GET EXISTING USER DATA
      // ============================================================

      final Map<String, dynamic> data = jsonDecode(response.body);

      final int userId = data['user_id'];

      final String role = data['role']?.toString() ?? '';

      final String name = data['name']?.toString() ?? '';

      final String? userEmail = data['email']?.toString();

      final String? userPhone = data['phone']?.toString();

      print('PostgreSQL user ID: $userId');
      print('User role: $role');
      print('User name: $name');

      // ============================================================
      // 6. SAVE EXISTING USER ID
      // ============================================================

      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('user_id', userId);

      await prefs.setString('user_role', role);

      await prefs.setString('profile_name', name);

      if (userEmail != null && userEmail.isNotEmpty) {
        await prefs.setString('user_email', userEmail);
      }

      if (userPhone != null && userPhone.isNotEmpty) {
        await prefs.setString('user_phone', userPhone);
      }

      print('Login data saved successfully');

      // ============================================================
      // 7. STOP LOADING
      // ============================================================

      if (!mounted) return;

      setState(() {
        isEmailLoading = false;
      });

      // ============================================================
      // 8. GO TO NEXT SCREEN
      // ============================================================
      if (role == 'buyer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BuyerDashboard()),
        );
      } else if (role == 'farmer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FarmerDashboard()),
        );
      } else {
        _showMessage('Unknown user role: $role');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        isEmailLoading = false;
      });

      print('Firebase error: ${e.code}');
      print('Firebase message: ${e.message}');

      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;

        case 'user-not-found':
          message = 'No account found with this email.';
          break;

        case 'wrong-password':
          message = 'Incorrect password.';
          break;

        case 'invalid-credential':
          message = 'Incorrect email or password.';
          break;

        case 'user-disabled':
          message = 'This account has been disabled.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        case 'network-request-failed':
          message = 'Check your internet connection.';
          break;

        default:
          message = e.message ?? 'Unable to login.';
      }

      _showMessage(message);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isEmailLoading = false;
      });

      print('LOGIN ERROR: $e');

      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }
  // ================================================================
  // MESSAGE
  // ================================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
