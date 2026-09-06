import 'package:farmdirect/Authentification/otp_screen.dart';
import 'package:farmdirect/Authentification/screens/Register_screen/successful_screen.dart';
import 'package:farmdirect/services/auth_service.dart';
import 'package:farmdirect/core/widgets/farmer_crop_selector_widgets.dart';
import 'package:farmdirect/core/widgets/farmer_input_field_widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FarmerRegisterPage extends StatefulWidget {
  const FarmerRegisterPage({super.key});

  @override
  State<FarmerRegisterPage> createState() => _FarmerRegisterPageState();
}

class _FarmerRegisterPageState extends State<FarmerRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController farmNameController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController aadhaarController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ============================================================
  // AUTHENTICATION
  // ============================================================

  bool isEmailAuth = false;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  bool isLoading = false;

  // ============================================================
  // CROPS
  // ============================================================

  Set<String> selectedCrops = {'Wheat'};

  final List<String> crops = ['Wheat', 'Rice', 'Potato', 'Cotton', 'Other'];

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF7CD000);
  static const Color darkGreen = Color(0xFF155B4B);
  static const Color backgroundColor = Color(0xFFF8F9FA);

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    fullNameController.dispose();
    farmNameController.dispose();
    locationController.dispose();
    aadhaarController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================
                  Padding(
                    padding: const EdgeInsets.only(top: 15),

                    child: Row(
                      children: [
                        const Text(
                          'Farmer Register',

                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: darkGreen,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          'Registration',

                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.08),

                  // ==================================================
                  // FULL NAME
                  // ==================================================
                  const FieldLabel(text: 'Full Name'),

                  const SizedBox(height: 5),

                  CustomInputField(
                    controller: fullNameController,
                    hintText: 'e.g. Ramesh Kumar',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // FARM NAME
                  // ==================================================
                  const FieldLabel(text: 'Farm Name / FPO Name'),

                  const SizedBox(height: 5),

                  CustomInputField(
                    controller: farmNameController,
                    hintText: 'e.g. Kumar Organic Farms',
                    icon: Icons.home_outlined,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // LOCATION
                  // ==================================================
                  const FieldLabel(text: 'Location (State, District)'),

                  const SizedBox(height: 5),

                  CustomInputField(
                    controller: locationController,
                    hintText: 'e.g. Uttarakhand, Uttar Pradesh',
                    icon: Icons.location_on_outlined,
                    keyboardType: TextInputType.text,
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // AADHAAR
                  // ==================================================
                  const FieldLabel(text: 'Aadhaar / Gov ID'),

                  const SizedBox(height: 5),

                  CustomInputField(
                    controller: aadhaarController,
                    hintText: '12-digit Aadhaar number',
                    icon: Icons.credit_card_outlined,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 11),

                  // ==================================================
                  // CROPS
                  // ==================================================
                  const FieldLabel(text: 'Major Crops Grown'),

                  const SizedBox(height: 5),

                  CropSelector(
                    crops: crops,
                    selectedCrops: selectedCrops,

                    onChanged: (updatedCrops) {
                      setState(() {
                        selectedCrops = updatedCrops;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // ==================================================
                  // AUTHENTICATION METHOD
                  // ==================================================
                  const FieldLabel(text: 'Choose Authentication Method'),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _authMethodButton(
                          title: 'Phone OTP',
                          icon: Icons.phone_outlined,
                          selected: !isEmailAuth,

                          onPressed: () {
                            setState(() {
                              isEmailAuth = false;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _authMethodButton(
                          title: 'Email',
                          icon: Icons.email_outlined,
                          selected: isEmailAuth,

                          onPressed: () {
                            setState(() {
                              isEmailAuth = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // PHONE
                  // ==================================================
                  if (!isEmailAuth) ...[
                    const FieldLabel(text: 'Phone Number'),

                    const SizedBox(height: 5),

                    _inputField(
                      controller: phoneController,
                      hintText: '+91 9876543210',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ]
                  // ==================================================
                  // EMAIL
                  // ==================================================
                  else ...[
                    const FieldLabel(text: 'Email Address'),

                    const SizedBox(height: 5),

                    _inputField(
                      controller: emailController,
                      hintText: 'example@gmail.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 10),

                    const FieldLabel(text: 'Password'),

                    const SizedBox(height: 5),

                    _inputField(
                      controller: passwordController,
                      hintText: 'Enter password',
                      icon: Icons.lock_outline,
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
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const FieldLabel(text: 'Confirm Password'),

                    const SizedBox(height: 5),

                    _inputField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm password',
                      icon: Icons.lock_outline,
                      obscureText: obscureConfirmPassword,

                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },

                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                  ],

                  // ==================================================
                  // REGISTER BUTTON
                  // ==================================================
                  SizedBox(height: size.height * 0.08),

                  SizedBox(
                    width: double.infinity,
                    height: 40,

                    child: ElevatedButton(
                      onPressed: isLoading ? null : registerFarmer,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.black,
                        elevation: 4,

                        shadowColor: primaryGreen.withOpacity(0.30),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),

                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,

                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Text(
                                  'Register Farmer',

                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                const SizedBox(width: 6),

                                Icon(
                                  isEmailAuth
                                      ? Icons.person_add_alt_1
                                      : Icons.sms_outlined,
                                  size: 16,
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
        ),
      ),
    );
  }

  // ================================================================
  // AUTH METHOD BUTTON
  // ================================================================

  Widget _authMethodButton({
    required String title,
    required IconData icon,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 40,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? primaryGreen : Colors.white,

          foregroundColor: Colors.black,

          elevation: selected ? 2 : 0,

          side: BorderSide(
            color: selected ? primaryGreen : const Color(0xFFE1E5E9),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 16),

            const SizedBox(width: 5),

            Text(
              title,

              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ],
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
    required IconData icon,

    TextInputType? keyboardType,

    bool obscureText = false,

    Widget? suffixIcon,
  }) {
    return SizedBox(
      height: 40,

      child: TextFormField(
        controller: controller,

        keyboardType: keyboardType,

        obscureText: obscureText,

        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }

          return null;
        },

        style: const TextStyle(fontSize: 10, color: Color(0xFF303640)),

        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: const TextStyle(fontSize: 10, color: Color(0xFF969DA7)),

          prefixIcon: Icon(icon, size: 17, color: const Color(0xFF858D99)),

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

            borderSide: const BorderSide(color: Color(0xFFE1E5E9)),
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
  // REGISTER FARMER
  // ================================================================

  Future<void> registerFarmer() async {
    // --------------------------------------------------------------
    // VALIDATE FORM
    // --------------------------------------------------------------

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // --------------------------------------------------------------
    // EMAIL VALIDATION
    // --------------------------------------------------------------

    if (isEmailAuth) {
      final email = emailController.text.trim();

      final password = passwordController.text.trim();

      final confirmPassword = confirmPasswordController.text.trim();

      if (!email.contains('@')) {
        _showMessage('Please enter a valid email address.');
        return;
      }

      if (password.length < 6) {
        _showMessage('Password must be at least 6 characters.');
        return;
      }

      if (password != confirmPassword) {
        _showMessage('Passwords do not match.');
        return;
      }
    }

    // --------------------------------------------------------------
    // PHONE VALIDATION
    // --------------------------------------------------------------

    String phoneNumber = phoneController.text.trim();

    if (!isEmailAuth) {
      final phoneNumber = _formatPhoneNumber(phoneController.text.trim());

      if (phoneNumber.isEmpty) {
        _showMessage('Please enter a valid Indian phone number.');
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ============================================================
      // CREATE REGISTRATION DATA
      // ============================================================

      final Map<String, dynamic> registrationData = {
        'full_name': fullNameController.text.trim(),

        'farm_name': farmNameController.text.trim(),

        'location': locationController.text.trim(),

        'aadhaar': aadhaarController.text.trim(),

        'crops': selectedCrops.toList(),
      };

      // ============================================================
      // EMAIL REGISTRATION
      // ============================================================

      if (isEmailAuth) {
        final email = emailController.text.trim();

        final password = passwordController.text.trim();

        final userCredential = await _authService.registerWithEmail(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;

        if (user == null) {
          throw Exception('Firebase user was not created.');
        }

        debugPrint('Farmer Firebase account created.');

        debugPrint('Firebase UID: ${user.uid}');

        /*
         * IMPORTANT:
         *
         * We will send:
         *
         * Firebase UID
         * role = farmer
         * email
         * registrationData
         *
         * to FastAPI in the next backend task.
         */

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(builder: (_) => const SuccessScreen()),
        );

        return;
      }

      // ============================================================
      // PHONE OTP REGISTRATION
      // ============================================================

      await _authService.sendOTP(
        phoneNumber: phoneNumber,

        // ----------------------------------------------------------
        // OTP SENT
        // ----------------------------------------------------------
        onCodeSent: (String verificationId) {
          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) => OtpScreen(
                verificationId: verificationId,

                phoneNumber: phoneNumber,

                mode: 'register',

                role: 'farmer',

                registrationData: registrationData,
              ),
            ),
          );
        },

        // ----------------------------------------------------------
        // OTP ERROR
        // ----------------------------------------------------------
        onError: (FirebaseAuthException error) {
          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          _showMessage(_firebaseErrorMessage(error));
        },

        // ----------------------------------------------------------
        // AUTOMATIC VERIFICATION
        // ----------------------------------------------------------
        onAutoVerified: (PhoneAuthCredential credential) async {
          try {
            final userCredential = await FirebaseAuth.instance
                .signInWithCredential(credential);

            final User? user = userCredential.user;

            if (user == null) {
              throw Exception('Firebase user not found.');
            }

            debugPrint('Phone automatically verified.');

            debugPrint('Firebase UID: ${user.uid}');

            /*
             * IMPORTANT:
             *
             * Normally Android may automatically
             * verify the OTP.
             *
             * The Firebase account is now created.
             *
             * FastAPI/PostgreSQL registration will
             * be added in the backend step.
             */

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            Navigator.pushReplacement(
              context,

              MaterialPageRoute(builder: (_) => const SuccessScreen()),
            );
          } catch (e) {
            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            _showMessage('Automatic verification failed.');
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(_firebaseErrorMessage(e));
    } catch (e) {
      debugPrint('Farmer registration error: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage('Something went wrong. Please try again.');
    }
  }

  // ================================================================
  // FORMAT PHONE NUMBER
  // ================================================================

  String _formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[\s\-()]'), '');

    if (phone.startsWith('+91')) {
      if (phone.length == 13) {
        return phone;
      }

      return '';
    }

    if (phone.startsWith('91') && phone.length == 12) {
      return '+$phone';
    }

    if (phone.length == 10) {
      return '+91$phone';
    }

    return '';
  }

  // ================================================================
  // FIREBASE ERROR MESSAGE
  // ================================================================

  String _firebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-phone-number':
        return 'Please enter a valid phone number.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'quota-exceeded':
        return 'OTP limit exceeded. Please try again later.';

      case 'operation-not-allowed':
        return 'This authentication method is not enabled.';

      case 'network-request-failed':
        return 'Check your internet connection.';

      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak.';

      default:
        return error.message ?? 'Authentication failed.';
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

// ====================================================================
// FIELD LABEL
// ====================================================================

class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: Color(0xFF28313D),
      ),
    );
  }
}
