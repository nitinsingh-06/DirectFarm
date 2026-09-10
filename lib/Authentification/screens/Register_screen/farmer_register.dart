import 'dart:convert';

import 'package:farmdirect/Authentification/otp_screen.dart';
import 'package:farmdirect/Authentification/screens/Register_screen/successful_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:farmdirect/config/api_config.dart';

class FarmerRegisterPage extends StatefulWidget {
  const FarmerRegisterPage({super.key});

  @override
  State<FarmerRegisterPage> createState() => _FarmerRegisterPageState();
}

class _FarmerRegisterPageState extends State<FarmerRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController =
      TextEditingController();

  final TextEditingController farmNameController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController aadhaarController =
      TextEditingController();

  final TextEditingController phoneController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isEmailAuth = false;
  bool isLoading = false;

  Set<String> selectedCrops = {'Wheat'};

  final List<String> crops = [
    'Wheat',
    'Rice',
    'Potato',
    'Cotton',
    'Other',
  ];

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
  // CREATE FARMER PROFILE
  // ============================================================

  Future<void> createFarmerProfile(int userId) async {
    debugPrint('Creating Farmer profile...');

    final Uri profileUrl = Uri.parse(
      '${ApiConfig.baseUrl}/farmer-profile/',
    );

    final Map<String, dynamic> profileData = {
      'user_id': userId,
      'farm_name': farmNameController.text.trim(),
      'location': locationController.text.trim(),
      'aadhaar': aadhaarController.text.trim(),
      'crops': selectedCrops.toList(),
    };

    debugPrint(
      'Farmer profile data: $profileData',
    );

    final response = await http.post(
      profileUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(profileData),
    ).timeout(
      const Duration(seconds: 10),
    );

    debugPrint(
      'Farmer profile status: ${response.statusCode}',
    );

    debugPrint(
      'Farmer profile response: ${response.body}',
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Farmer profile creation failed: '
        '${response.body}',
      );
    }

    debugPrint(
      'Farmer profile saved successfully',
    );
  }

  // ============================================================
  // FARMER REGISTRATION
  // ============================================================

  Future<void> registerFarmer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCrops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select at least one crop',
          ),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ========================================================
      // EMAIL REGISTRATION
      // ========================================================

      if (isEmailAuth) {
        debugPrint(
          'Starting Farmer Email Registration...',
        );

        // ------------------------------------------------------
        // STEP 1: CREATE FIREBASE USER
        // ------------------------------------------------------

        final UserCredential credential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        final User? user = credential.user;

        if (user == null) {
          throw Exception(
            'Firebase user creation failed',
          );
        }

        debugPrint(
          'Firebase Farmer UID: ${user.uid}',
        );

        // ------------------------------------------------------
        // STEP 2: GET FIREBASE ID TOKEN
        // ------------------------------------------------------

        final String? idToken =
            await user.getIdToken();

        if (idToken == null) {
          throw Exception(
            'Could not get Firebase ID token',
          );
        }

        debugPrint(
          'Firebase ID token received',
        );

        // ------------------------------------------------------
        // STEP 3: REGISTER USER IN FASTAPI
        // ------------------------------------------------------

        final Uri url = Uri.parse(
          '${ApiConfig.baseUrl}/auth/register',
        );

        debugPrint(
          'Sending Farmer registration to: $url',
        );

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'id_token': idToken,
            'firebase_uid': user.uid,
            'role': 'farmer',
            'phone': null,
            'name': fullNameController.text.trim(),
            'email': emailController.text.trim(),
          }),
        ).timeout(
          const Duration(seconds: 10),
        );

        debugPrint(
          'FastAPI registration status: '
          '${response.statusCode}',
        );

        debugPrint(
          'FastAPI registration response: '
          '${response.body}',
        );

        // ------------------------------------------------------
        // STEP 4: CHECK USER REGISTRATION
        // ------------------------------------------------------

        if (response.statusCode < 200 ||
            response.statusCode >= 300) {
          String errorMessage =
              'Backend registration failed';

          try {
            final responseData =
                jsonDecode(response.body);

            if (responseData is Map &&
                responseData['detail'] != null) {
              errorMessage =
                  responseData['detail'].toString();
            }
          } catch (_) {}

          throw Exception(errorMessage);
        }

        debugPrint(
          'Farmer saved in users table',
        );

        // ------------------------------------------------------
        // STEP 5: GET USER ID
        // ------------------------------------------------------

        final Map<String, dynamic> userData =
            jsonDecode(response.body);

        final dynamic userIdValue =
            userData['user_id'];

        if (userIdValue == null) {
          throw Exception(
            'Backend did not return user_id',
          );
        }

        final int userId =
            int.parse(userIdValue.toString());

        debugPrint(
          'Created Farmer user_id: $userId',
        );

        // ------------------------------------------------------
        // STEP 6: CREATE FARMER PROFILE
        // ------------------------------------------------------

        await createFarmerProfile(userId);

        // ------------------------------------------------------
        // STEP 7: SUCCESS
        // ------------------------------------------------------

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const SuccessScreen(),
          ),
        );
      }

      // ========================================================
      // PHONE OTP REGISTRATION
      // ========================================================

      else {
        final String phone =
            phoneController.text.trim();

        if (phone.isEmpty) {
          throw Exception(
            'Please enter your phone number',
          );
        }

        // ------------------------------------------------------
        // FORMAT PHONE NUMBER
        // ------------------------------------------------------

        String formattedPhone = phone;

        if (!formattedPhone.startsWith('+')) {
          formattedPhone = '+91$formattedPhone';
        }

        debugPrint(
          'Starting Farmer Phone OTP registration...',
        );

        debugPrint(
          'Phone number: $formattedPhone',
        );

        // ------------------------------------------------------
        // REGISTRATION DATA
        // ------------------------------------------------------

        final Map<String, dynamic> registrationData = {
          'full_name':
              fullNameController.text.trim(),

          'farm_name':
              farmNameController.text.trim(),

          'location':
              locationController.text.trim(),

          'aadhaar':
              aadhaarController.text.trim(),

          'crops':
              selectedCrops.toList(),
        };

        // ------------------------------------------------------
        // SEND OTP
        // ------------------------------------------------------

        await _auth.verifyPhoneNumber(
          phoneNumber: formattedPhone,

          // ====================================================
          // AUTOMATIC VERIFICATION
          // ====================================================

          verificationCompleted:
              (PhoneAuthCredential credential) async {
            debugPrint(
              'Phone verification completed automatically.',
            );

            try {
              final UserCredential
                  userCredential =
                  await _auth.signInWithCredential(
                credential,
              );

              final User? user =
                  userCredential.user;

              if (user == null) {
                throw Exception(
                  'Firebase user not found.',
                );
              }

              final String? idToken =
                  await user.getIdToken();

              if (idToken == null) {
                throw Exception(
                  'Unable to get Firebase ID token.',
                );
              }

              // ------------------------------------------------
              // REGISTER USER
              // ------------------------------------------------

              final response =
                  await http.post(
                Uri.parse(
                  '${ApiConfig.baseUrl}/auth/register',
                ),
                headers: {
                  'Content-Type':
                      'application/json',
                },
                body: jsonEncode({
                  'id_token': idToken,
                  'firebase_uid': user.uid,
                  'role': 'farmer',
                  'phone': formattedPhone,
                  'name':
                      fullNameController.text.trim(),
                }),
              ).timeout(
                const Duration(seconds: 10),
              );

              debugPrint(
                'Automatic registration status: '
                '${response.statusCode}',
              );

              debugPrint(
                'Automatic registration response: '
                '${response.body}',
              );

              if (response.statusCode < 200 ||
                  response.statusCode >= 300) {
                throw Exception(
                  'Registration failed: '
                  '${response.body}',
                );
              }

              final Map<String, dynamic>
                  userData =
                  jsonDecode(response.body);

              final int userId =
                  int.parse(
                userData['user_id'].toString(),
              );

              // ------------------------------------------------
              // CREATE FARMER PROFILE
              // ------------------------------------------------

              await createFarmerProfile(
                userId,
              );

              if (!mounted) return;

              setState(() {
                isLoading = false;
              });

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SuccessScreen(),
                ),
              );
            } catch (e) {
              debugPrint(
                'Automatic verification error: $e',
              );

              if (!mounted) return;

              setState(() {
                isLoading = false;
              });

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    'Registration failed: $e',
                  ),
                ),
              );
            }
          },

          // ====================================================
          // VERIFICATION FAILED
          // ====================================================

          verificationFailed:
              (FirebaseAuthException error) {
            debugPrint(
              'Phone verification failed.',
            );

            debugPrint(
              'Error code: ${error.code}',
            );

            debugPrint(
              'Error message: ${error.message}',
            );

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content: Text(
                  error.message ??
                      'Phone verification failed',
                ),
              ),
            );
          },

          // ====================================================
          // OTP SENT
          // ====================================================

          codeSent: (
            String verificationId,
            int? resendToken,
          ) {
            debugPrint(
              'OTP sent successfully.',
            );

            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  verificationId:
                      verificationId,

                  phoneNumber:
                      formattedPhone,

                  mode: 'register',

                  role: 'farmer',

                  registrationData:
                      registrationData,
                ),
              ),
            );
          },

          // ====================================================
          // OTP TIMEOUT
          // ====================================================

          codeAutoRetrievalTimeout:
              (String verificationId) {
            debugPrint(
              'OTP auto retrieval timeout.',
            );
          },
        );
      }
    }

    // ==========================================================
    // FIREBASE ERROR
    // ==========================================================

    on FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase Farmer registration error: '
        '${e.code}',
      );

      debugPrint(
        'Firebase error message: '
        '${e.message}',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                'Firebase registration failed',
          ),
        ),
      );
    }

    // ==========================================================
    // GENERAL ERROR
    // ==========================================================

    catch (e) {
      debugPrint(
        'Farmer registration error: $e',
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
              'Exception: ',
              '',
            ),
          ),
        ),
      );
    }
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Farmer Registration',
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,

              children: [
                const SizedBox(height: 10),

                // ==================================================
                // TITLE
                // ==================================================

                const Text(
                  'Create Farmer Account',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 26,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Register your farm with FarmDirect',
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // FULL NAME
                // ==================================================

                TextFormField(
                  controller:
                      fullNameController,

                  decoration:
                      inputDecoration(
                    label: 'Full Name',
                    icon: Icons.person,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // FARM NAME
                // ==================================================

                TextFormField(
                  controller:
                      farmNameController,

                  decoration:
                      inputDecoration(
                    label: 'Farm Name',
                    icon:
                        Icons.agriculture,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your farm name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // LOCATION
                // ==================================================

                TextFormField(
                  controller:
                      locationController,

                  decoration:
                      inputDecoration(
                    label: 'Farm Location',
                    icon:
                        Icons.location_on,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter your farm location';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // AADHAAR
                // ==================================================

                TextFormField(
                  controller:
                      aadhaarController,

                  keyboardType:
                      TextInputType.number,

                  maxLength: 12,

                  decoration:
                      inputDecoration(
                    label: 'Aadhaar Number',
                    icon: Icons.badge,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter Aadhaar number';
                    }

                    if (value.trim().length !=
                        12) {
                      return 'Aadhaar must be 12 digits';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 5),

                // ==================================================
                // CROPS
                // ==================================================

                const Text(
                  'Crops You Grow',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children:
                      crops.map((crop) {
                    final bool isSelected =
                        selectedCrops
                            .contains(crop);

                    return FilterChip(
                      label: Text(crop),

                      selected:
                          isSelected,

                      onSelected:
                          (selected) {
                        setState(() {
                          if (selected) {
                            selectedCrops
                                .add(crop);
                          } else {
                            selectedCrops
                                .remove(crop);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // AUTH METHOD
                // ==================================================

                const Text(
                  'Registration Method',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text(
                          'Phone OTP',
                        ),

                        selected:
                            !isEmailAuth,

                        onSelected:
                            (selected) {
                          if (selected) {
                            setState(() {
                              isEmailAuth =
                                  false;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ChoiceChip(
                        label: const Text(
                          'Email',
                        ),

                        selected:
                            isEmailAuth,

                        onSelected:
                            (selected) {
                          if (selected) {
                            setState(() {
                              isEmailAuth =
                                  true;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ==================================================
                // PHONE
                // ==================================================

                if (!isEmailAuth)
                  TextFormField(
                    controller:
                        phoneController,

                    keyboardType:
                        TextInputType.phone,

                    decoration:
                        inputDecoration(
                      label:
                          'Phone Number',
                      icon: Icons.phone,
                      hint:
                          '10 digit mobile number',
                    ),

                    validator: (value) {
                      if (!isEmailAuth) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Please enter phone number';
                        }

                        if (value.trim()
                                .length !=
                            10) {
                          return 'Enter a valid 10 digit number';
                        }
                      }

                      return null;
                    },
                  ),

                if (!isEmailAuth)
                  const SizedBox(height: 16),

                // ==================================================
                // EMAIL
                // ==================================================

                TextFormField(
                  controller:
                      emailController,

                  keyboardType:
                      TextInputType
                          .emailAddress,

                  decoration:
                      inputDecoration(
                    label: 'Email',
                    icon: Icons.email,
                  ),

                  validator: (value) {
                    if (isEmailAuth) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter email';
                      }

                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // PASSWORD
                // ==================================================

                if (isEmailAuth)
                  TextFormField(
                    controller:
                        passwordController,

                    obscureText: true,

                    decoration:
                        inputDecoration(
                      label: 'Password',
                      icon: Icons.lock,
                    ),

                    validator: (value) {
                      if (isEmailAuth) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Please enter password';
                        }

                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                      }

                      return null;
                    },
                  ),

                if (isEmailAuth)
                  const SizedBox(height: 16),

                // ==================================================
                // CONFIRM PASSWORD
                // ==================================================

                if (isEmailAuth)
                  TextFormField(
                    controller:
                        confirmPasswordController,

                    obscureText: true,

                    decoration:
                        inputDecoration(
                      label:
                          'Confirm Password',
                      icon:
                          Icons.lock_outline,
                    ),

                    validator: (value) {
                      if (isEmailAuth) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Please confirm password';
                        }

                        if (value !=
                            passwordController
                                .text) {
                          return 'Passwords do not match';
                        }
                      }

                      return null;
                    },
                  ),

                const SizedBox(height: 30),

                // ==================================================
                // REGISTER BUTTON
                // ==================================================

                SizedBox(
                  height: 55,

                  child:
                      ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : registerFarmer,

                    child: isLoading
                        ? const SizedBox(
                            height: 25,
                            width: 25,

                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEmailAuth
                                ? 'Register Farmer'
                                : 'Send OTP',

                            style:
                                const TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
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
    );
  }
}