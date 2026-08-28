import 'package:farmdirect/Authentification/screens/forget_password_screen.dart';
import 'package:farmdirect/Authentification/screens/select_role_screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;

  // Colors
  static const Color primaryGreen = Color(0xFF78D000);
  static const Color darkGreen = Color(0xFF155B4B);
  static const Color background = Color(0xFFF8F9FA);
  static const Color borderColor = Color(0xFFE5E5E5);
  static const Color hintColor = Color(0xFF9AA0AA);

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

                    // ---------------- LOGIN TITLE ----------------
                    const Padding(
                      padding: EdgeInsets.only(top: 18),
                      child: InkWell(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: darkGreen,
                          ),
                        ),
                      ),
                    ),

                    // Space
                    SizedBox(height: size.height * 0.13),

                    // ---------------- PHONE / EMAIL ----------------
                    const Text(
                      'Phone Number / Email',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF28313D),
                      ),
                    ),

                    const SizedBox(height: 6),

                    _inputField(
                      controller: phoneController,
                      hintText: 'e.g.+91 9876543210',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter phone number or email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // ---------------- PASSWORD ----------------
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF28313D),
                      ),
                    ),

                    const SizedBox(height: 6),

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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8),

                    // ---------------- REMEMBER / FORGOT ----------------

                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                            activeColor: primaryGreen,
                            side: const BorderSide(
                              color: Color(0xFFDDE1E5),
                            ),
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

                        const Spacer(),

                        GestureDetector(
                          onTap: () {
                            // Forgot password
                          },
                          child: InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPasswordScreen())),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: darkGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    

                    // ---------------- LOGIN BUTTON ----------------
                    SizedBox(height: size.height * 0.155),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.black,
                          elevation: 4,
                          shadowColor: primaryGreen.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.login,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ---------------- OR CONTINUE ----------------

                    const Center(
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF969CA4),
                        ),
                      ),
                    ),

                    const SizedBox(height: 11),

                    // ---------------- GOOGLE BUTTON ----------------

                    SizedBox(
                      width: double.infinity,
                      height: 34,
                      child: OutlinedButton(
                        onPressed: () {
                          // Google login
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: borderColor,
                          ),
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

                    // ---------------- REGISTER ----------------
                    Center(
                      child: GestureDetector(
                        onTap: () {

                         Navigator.push(context,MaterialPageRoute(builder: (context)=>ChooseRoleScreen()));
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF858C95),
                            ),
                            children: [
                              TextSpan(
                                text: 'New here? ',
                              ),
                              TextSpan(
                                text: 'Register Now /',
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

  // ---------------- INPUT FIELD ----------------

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      height: 35,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF303640),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 10,
            color: hintColor,
          ),
          prefixIcon: Icon(
            prefixIcon,
            size: 17,
            color: const Color(0xFF858D99),
          ),
          suffixIcon: suffixIcon,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: primaryGreen,
              width: 1.2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- LOGIN ----------------

  void _login() {
    if (_formKey.currentState!.validate()) {
      debugPrint('Phone/Email: ${phoneController.text}');
      debugPrint('Password: ${passwordController.text}');
    }
  }
}