
import 'package:farmdirect/Authentification/otp_screen.dart';
import 'package:farmdirect/Authentification/screens/Register_screen/successful_screen.dart';
import 'package:farmdirect/services/auth_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BuyerRegisterScreen extends StatefulWidget {
  const BuyerRegisterScreen({super.key});

  @override
  State<BuyerRegisterScreen> createState() =>
      _BuyerRegisterScreenState();
}

class _BuyerRegisterScreenState
    extends State<BuyerRegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController addressController =
      TextEditingController();

  final TextEditingController cityController =
      TextEditingController();

  final TextEditingController pincodeController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

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
  // COLORS
  // ============================================================

  static const Color primaryGreen =
      Color(0xFF80D000);

  static const Color darkGreen =
      Color(0xFF075B4A);

  static const Color backgroundColor =
      Color(0xFFF8F9FA);

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            17,
            14,
            17,
            30,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // ==================================================
                // HEADER
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Buyer Register',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w800,
                        color: darkGreen,
                      ),
                    ),

                    Text(
                      'Registration',

                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight:
                            FontWeight.w600,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // ==================================================
                // NAME
                // ==================================================

                _buildTextField(
                  label:
                      'Full Name / Company Name',

                  hint:
                      'e.g. FreshMart Retail',

                  icon:
                      Icons.person_outline,

                  controller:
                      nameController,
                ),

                const SizedBox(height: 13),

                // ==================================================
                // EMAIL
                // ==================================================

                _buildTextField(
                  label:
                      'Email Address',

                  hint:
                      'e.g. procurement@freshmart.com',

                  icon:
                      Icons.mail_outline,

                  controller:
                      emailController,

                  keyboardType:
                      TextInputType.emailAddress,
                ),

                const SizedBox(height: 13),

                // ==================================================
                // ADDRESS
                // ==================================================

                _buildTextField(
                  label:
                      'Delivery / Warehouse Address',

                  hint:
                      'Street, Sector, Warehousing Zone',

                  icon:
                      Icons.location_on_outlined,

                  controller:
                      addressController,
                ),

                const SizedBox(height: 13),

                // ==================================================
                // CITY + PINCODE
                // ==================================================

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Expanded(
                      child:
                          _buildSmallTextField(
                        label: 'City',

                        hint:
                            'e.g. New Delhi',

                        controller:
                            cityController,
                      ),
                    ),

                    const SizedBox(width: 13),

                    Expanded(
                      child:
                          _buildSmallTextField(
                        label: 'Pincode',

                        hint:
                            'e.g. 110001',

                        controller:
                            pincodeController,

                        keyboardType:
                            TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ==================================================
                // AUTHENTICATION METHOD
                // ==================================================

                const Text(
                  'Choose Authentication Method',

                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        Color(0xFF263238),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    Expanded(
                      child:
                          _authMethodButton(
                        title: 'Phone OTP',

                        icon:
                            Icons.phone_outlined,

                        selected:
                            !isEmailAuth,

                        onPressed: () {
                          setState(() {
                            isEmailAuth =
                                false;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child:
                          _authMethodButton(
                        title: 'Email',

                        icon:
                            Icons.email_outlined,

                        selected:
                            isEmailAuth,

                        onPressed: () {
                          setState(() {
                            isEmailAuth =
                                true;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ==================================================
                // PHONE AUTH
                // ==================================================

                if (!isEmailAuth) ...[

                  const Text(
                    'Phone Number',

                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Color(0xFF263238),
                    ),
                  ),

                  const SizedBox(height: 5),

                  _buildTextField(
                    label: '',
                    hint:
                        '+91 9876543210',

                    icon:
                        Icons.phone_outlined,

                    controller:
                        phoneController,

                    keyboardType:
                        TextInputType.phone,
                  ),
                ]

                // ==================================================
                // EMAIL AUTH
                // ==================================================

                else ...[

                  const Text(
                    'Password',

                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Color(0xFF263238),
                    ),
                  ),

                  const SizedBox(height: 5),

                  _buildPasswordField(
                    controller:
                        passwordController,

                    hint:
                        'Enter password',

                    obscureText:
                        obscurePassword,

                    onVisibilityPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },
                  ),

                  const SizedBox(height: 13),

                  const Text(
                    'Confirm Password',

                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Color(0xFF263238),
                    ),
                  ),

                  const SizedBox(height: 5),

                  _buildPasswordField(
                    controller:
                        confirmPasswordController,

                    hint:
                        'Confirm password',

                    obscureText:
                        obscureConfirmPassword,

                    onVisibilityPressed: () {
                      setState(() {
                        obscureConfirmPassword =
                            !obscureConfirmPassword;
                      });
                    },
                  ),
                ],

                const SizedBox(height: 45),

                // ==================================================
                // REGISTER BUTTON
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 40,

                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : _registerBuyer,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          primaryGreen,

                      foregroundColor:
                          const Color(
                              0xFF123400),

                      elevation: 4,

                      shadowColor:
                          primaryGreen
                              .withOpacity(
                                  0.25),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                                22),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,

                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,

                              color:
                                  Colors.black,
                            ),
                          )

                        : Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              const Text(
                                'Register as Buyer',

                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),

                              const SizedBox(
                                  width: 7),

                              Icon(
                                isEmailAuth
                                    ? Icons
                                        .person_add_alt_1_outlined
                                    : Icons
                                        .sms_outlined,

                                size: 17,
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // TEXT FIELD
  // ================================================================

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,

    TextInputType keyboardType =
        TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        if (label.isNotEmpty)
          Text(
            label,

            style: const TextStyle(
              fontSize: 10.5,
              fontWeight:
                  FontWeight.w600,
              color:
                  Color(0xFF263238),
            ),
          ),

        if (label.isNotEmpty)
          const SizedBox(height: 5),

        SizedBox(
          height: 38,

          child: TextFormField(
            controller: controller,

            keyboardType:
                keyboardType,

            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Required';
              }

              return null;
            },

            style: const TextStyle(
              fontSize: 11.5,
              color:
                  Color(0xFF374151),
            ),

            decoration:
                InputDecoration(
              hintText: hint,

              hintStyle:
                  const TextStyle(
                fontSize: 11.5,
                color:
                    Color(0xFF8B949E),
              ),

              prefixIcon: Icon(
                icon,

                size: 17,

                color:
                    const Color(
                        0xFF7B8794),
              ),

              prefixIconConstraints:
                  const BoxConstraints(
                minWidth: 38,
                minHeight: 38,
              ),

              filled: true,

              fillColor:
                  Colors.white,

              contentPadding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 10,
                vertical: 0,
              ),

              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        8),

                borderSide:
                    const BorderSide(
                  color:
                      Color(0xFFE1E5E9),
                ),
              ),

              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        8),

                borderSide:
                    const BorderSide(
                  color:
                      primaryGreen,
                  width: 1.2,
                ),
              ),

              errorBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        8),

                borderSide:
                    const BorderSide(
                  color:
                      Colors.redAccent,
                ),
              ),

              focusedErrorBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        8),

                borderSide:
                    const BorderSide(
                  color:
                      Colors.redAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // SMALL FIELD
  // ================================================================

  Widget _buildSmallTextField({
    required String label,
    required String hint,
    required TextEditingController controller,

    TextInputType keyboardType =
        TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          label,

          style: const TextStyle(
            fontSize: 10.5,
            fontWeight:
                FontWeight.w600,
            color:
                Color(0xFF263238),
          ),
        ),

        const SizedBox(height: 5),

        SizedBox(
          height: 38,

          child: TextFormField(
            controller:
                controller,

            keyboardType:
                keyboardType,

            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Required';
              }

              return null;
            },

            style: const TextStyle(
              fontSize: 11.5,
              color:
                  Color(0xFF374151),
            ),

            decoration:
                InputDecoration(
              hintText:
                  hint,

              hintStyle:
                  const TextStyle(
                fontSize: 11.5,
                color:
                    Color(0xFF8B949E),
              ),

              filled: true,

              fillColor:
                  Colors.white,

              contentPadding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 11,
                vertical: 0,
              ),

              enabledBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        8),

                borderSide:
                    const BorderSide(
                  color:
                      Color(0xFFE1E5E9),
                ),
              ),

              focusedBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        8),

                borderSide:
                    const BorderSide(
                  color:
                      primaryGreen,
                  width: 1.2,
                ),
              ),

              errorBorder:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                        8),

                borderSide:
                    const BorderSide(
                  color:
                      Colors.redAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // PASSWORD FIELD
  // ================================================================

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscureText,
    required VoidCallback onVisibilityPressed,
  }) {
    return SizedBox(
      height: 38,

      child: TextFormField(
        controller:
            controller,

        obscureText:
            obscureText,

        validator: (value) {
          if (value == null ||
              value.trim().isEmpty) {
            return 'Required';
          }

          return null;
        },

        style: const TextStyle(
          fontSize: 11.5,
          color:
              Color(0xFF374151),
        ),

        decoration:
            InputDecoration(
          hintText:
              hint,

          hintStyle:
              const TextStyle(
            fontSize: 11.5,
            color:
                Color(0xFF8B949E),
          ),

          prefixIcon: const Icon(
            Icons.lock_outline,
            size: 17,
            color:
                Color(0xFF7B8794),
          ),

          suffixIcon:
              IconButton(
            onPressed:
                onVisibilityPressed,

            icon: Icon(
              obscureText
                  ? Icons
                      .visibility_outlined
                  : Icons
                      .visibility_off_outlined,

              size: 17,
            ),
          ),

          filled: true,

          fillColor:
              Colors.white,

          contentPadding:
              const EdgeInsets
                  .symmetric(
            horizontal: 10,
            vertical: 0,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    8),

            borderSide:
                const BorderSide(
              color:
                  Color(0xFFE1E5E9),
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    8),

            borderSide:
                const BorderSide(
              color:
                  primaryGreen,
              width: 1.2,
            ),
          ),

          errorBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    8),

            borderSide:
                const BorderSide(
              color:
                  Colors.redAccent,
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
        onPressed:
            onPressed,

        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              selected
                  ? primaryGreen
                  : Colors.white,

          foregroundColor:
              Colors.black,

          elevation:
              selected ? 2 : 0,

          side: BorderSide(
            color: selected
                ? primaryGreen
                : const Color(
                    0xFFE1E5E9),
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
                    20),
          ),
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 16,
            ),

            const SizedBox(width: 5),

            Text(
              title,

              style:
                  const TextStyle(
                fontSize: 10,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // REGISTER BUYER
  // ================================================================

  Future<void> _registerBuyer() async {

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

      final email =
          emailController.text.trim();

      final password =
          passwordController.text.trim();

      final confirmPassword =
          confirmPasswordController
              .text
              .trim();

      if (!email.contains('@')) {
        _showMessage(
          'Please enter a valid email address.',
        );

        return;
      }

      if (password.length < 6) {
        _showMessage(
          'Password must be at least 6 characters.',
        );

        return;
      }

      if (password != confirmPassword) {
        _showMessage(
          'Passwords do not match.',
        );

        return;
      }
    }

    // --------------------------------------------------------------
    // PHONE
    // --------------------------------------------------------------

    String phoneNumber =
        phoneController.text.trim();

    if (!isEmailAuth) {

      phoneNumber =
          _formatPhoneNumber(
        phoneNumber,
      );

      if (phoneNumber.isEmpty) {
        _showMessage(
          'Please enter a valid Indian phone number.',
        );

        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {

      // ============================================================
      // BUYER DATA
      // ============================================================

      final Map<String, dynamic>
          registrationData = {

        'name':
            nameController.text.trim(),

        'email':
            emailController.text.trim(),

        'delivery_address':
            addressController.text.trim(),

        'city':
            cityController.text.trim(),

        'pincode':
            pincodeController.text.trim(),
      };

      // ============================================================
      // EMAIL REGISTRATION
      // ============================================================

      if (isEmailAuth) {

        final userCredential =
            await _authService
                .registerWithEmail(
          email:
              emailController.text.trim(),

          password:
              passwordController.text.trim(),
        );

        final User? user =
            userCredential.user;

        if (user == null) {
          throw Exception(
            'Firebase user was not created.',
          );
        }

        debugPrint(
          'Buyer Firebase account created.',
        );

        debugPrint(
          'Firebase UID: ${user.uid}',
        );

        /*
         * FastAPI/PostgreSQL profile
         * registration will be connected
         * after our final database schema
         * is ready.
         */

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder: (_) =>
                const SuccessScreen(),
          ),
        );

        return;
      }

      // ============================================================
      // PHONE OTP REGISTRATION
      // ============================================================

      await _authService.sendOTP(

        phoneNumber:
            phoneNumber,

        // ----------------------------------------------------------
        // OTP SENT
        // ----------------------------------------------------------

        onCodeSent:
            (String verificationId) {

          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  OtpScreen(

                verificationId:
                    verificationId,

                phoneNumber:
                    phoneNumber,

                mode:
                    'register',

                // IMPORTANT:
                // Database role for Buyer
                // is "customer".

                role:
                    'customer',

                registrationData:
                    registrationData,
              ),
            ),
          );
        },

        // ----------------------------------------------------------
        // ERROR
        // ----------------------------------------------------------

        onError:
            (FirebaseAuthException error) {

          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          _showMessage(
            _firebaseErrorMessage(
              error,
            ),
          );
        },

        // ----------------------------------------------------------
        // AUTOMATIC VERIFICATION
        // ----------------------------------------------------------

        onAutoVerified:
            (PhoneAuthCredential credential)
                async {

          try {

            final userCredential =
                await FirebaseAuth
                    .instance
                    .signInWithCredential(
              credential,
            );

            final User? user =
                userCredential.user;

            if (user == null) {
              throw Exception(
                'Firebase user not found.',
              );
            }

            debugPrint(
              'Buyer phone automatically verified.',
            );

            debugPrint(
              'Firebase UID: ${user.uid}',
            );

            /*
             * FastAPI/PostgreSQL registration
             * will be connected after the
             * final database schema.
             */

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            Navigator.pushReplacement(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    const SuccessScreen(),
              ),
            );

          } catch (e) {

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            _showMessage(
              'Automatic verification failed.',
            );
          }
        },
      );

    } on FirebaseAuthException catch (e) {

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        _firebaseErrorMessage(e),
      );

    } catch (e) {

      debugPrint(
        'Buyer registration error: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showMessage(
        'Something went wrong. Please try again.',
      );
    }
  }

  // ================================================================
  // PHONE FORMAT
  // ================================================================

  String _formatPhoneNumber(
    String phone,
  ) {

    phone = phone.replaceAll(
      RegExp(r'[\s\-()]'),
      '',
    );

    if (phone.startsWith('+91')) {

      if (phone.length == 13) {
        return phone;
      }

      return '';
    }

    if (phone.startsWith('91') &&
        phone.length == 12) {
      return '+$phone';
    }

    if (phone.length == 10) {
      return '+91$phone';
    }

    return '';
  }

  // ================================================================
  // FIREBASE ERROR
  // ================================================================

  String _firebaseErrorMessage(
    FirebaseAuthException error,
  ) {

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
        return error.message ??
            'Authentication failed.';
    }
  }

  // ================================================================
  // MESSAGE
  // ================================================================

  void _showMessage(
    String message,
  ) {

    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content:
              Text(message),
        ),
      );
  }
}

