import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmdirect/core/provider/buyer_profile_provider.dart';

class BuyerProfileSettingsScreen extends StatefulWidget {
  const BuyerProfileSettingsScreen({super.key});

  @override
  State<BuyerProfileSettingsScreen> createState() =>
      _BuyerProfileSettingsScreenState();
}

class _BuyerProfileSettingsScreenState
    extends State<BuyerProfileSettingsScreen> {
  static const Color primaryGreen = Color(0xFF006B4F);

  static const Color backgroundColor = Color(0xFFF7F9F8);

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController dobController;

  String selectedGender = 'Female';
  @override
  void initState() {
    super.initState();

    final provider = context.read<BuyerProfileProvider>();

    nameController = TextEditingController(text: provider.name);

    emailController = TextEditingController(text: provider.email);

    phoneController = TextEditingController(text: provider.phone);

    dobController = TextEditingController(text: provider.dob);

    selectedGender = provider.gender;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: Consumer<BuyerProfileProvider>(
          builder: (context, profile, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(8, 8, 8, 25),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================
                  Row(
                    children: [
                      // BACK BUTTON
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 13,
                            color: primaryGreen,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        'Profile Settings',
                        style: TextStyle(
                          color: primaryGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ==================================================
                  // PROFILE IMAGE
                  // ==================================================
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await context
                            .read<BuyerProfileProvider>()
                            .pickProfileImage();
                      },
                      child: Consumer<BuyerProfileProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF006B4F),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: provider.profileImage != null
                                  ? Image.file(
                                      provider.profileImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      provider.defaultImage,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // CHANGE PHOTO
                  const Center(
                    child: Text(
                      'Change Profile Photo',
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ==================================================
                  // FULL NAME
                  // ==================================================
                  _fieldLabel('Full Name'),

                  _inputField(
                    controller: nameController,
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 8),

                  // ==================================================
                  // EMAIL
                  // ==================================================
                  _fieldLabel('Email Address'),

                  _inputField(
                    controller: emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 8),

                  // ==================================================
                  // PHONE
                  // ==================================================
                  _fieldLabel('Phone Number'),

                  _inputField(
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 8),

                  // ==================================================
                  // DOB
                  // ==================================================
                  _fieldLabel('Date of Birth'),

                  _inputField(
                    controller: dobController,
                    icon: Icons.calendar_today_outlined,
                    readOnly: true,
                    onTap: _selectDate,
                  ),

                  const SizedBox(height: 8),

                  // ==================================================
                  // GENDER
                  // ==================================================
                  _fieldLabel('Gender'),

                  _genderDropdown(),

                  const SizedBox(height: 28),

                  // ==================================================
                  // SAVE BUTTON
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006B4F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==============================================================
  // DEFAULT IMAGE
  // ==============================================================

  Widget _defaultImage(BuyerProfileProvider profile) {
    return Image.asset(
      profile.defaultImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _defaultIcon();
      },
    );
  }

  Widget _defaultIcon() {
    return Container(
      color: const Color(0xFFE8F7F1),
      child: const Icon(Icons.person, color: primaryGreen, size: 38),
    );
  }

  // ==============================================================
  // FIELD LABEL
  // ==============================================================

  Widget _fieldLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,
            style: const TextStyle(
              color: primaryGreen,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // TEXT FIELD
  // ==============================================================

  Widget _inputField({
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      height: 34,

      child: TextField(
        controller: controller,

        keyboardType: keyboardType,

        readOnly: readOnly,

        onTap: onTap,

        style: const TextStyle(fontSize: 9, color: Colors.black87),

        decoration: InputDecoration(
          filled: true,

          fillColor: Colors.white,

          prefixIcon: Icon(icon, size: 14, color: Colors.grey.shade500),

          prefixIconConstraints: const BoxConstraints(minWidth: 34),

          contentPadding: const EdgeInsets.symmetric(horizontal: 8),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),

            borderSide: const BorderSide(color: primaryGreen, width: 1),
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // GENDER
  // ==============================================================

  Widget _genderDropdown() {
    return Container(
      height: 34,

      padding: const EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(8),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedGender,

          isExpanded: true,

          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Colors.grey.shade500,
          ),

          style: const TextStyle(color: Colors.black87, fontSize: 9),

          items: const [
            DropdownMenuItem(
              value: 'Female',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: Colors.grey),
                  SizedBox(width: 7),
                  Text('Female'),
                ],
              ),
            ),

            DropdownMenuItem(
              value: 'Male',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: Colors.grey),
                  SizedBox(width: 7),
                  Text('Male'),
                ],
              ),
            ),

            DropdownMenuItem(
              value: 'Other',
              child: Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: Colors.grey),
                  SizedBox(width: 7),
                  Text('Other'),
                ],
              ),
            ),
          ],

          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedGender = value;
            });
          },
        ),
      ),
    );
  }

  // ==============================================================
  // DATE PICKER
  // ==============================================================

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime(1998, 4, 12);

    try {
      final parts = dobController.text.split('/');

      if (parts.length == 3) {
        initialDate = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {}

    final DateTime? picked = await showDatePicker(
      context: context,

      initialDate: initialDate,

      firstDate: DateTime(1940),

      lastDate: DateTime.now(),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primaryGreen),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    final day = picked.day.toString().padLeft(2, '0');

    final month = picked.month.toString().padLeft(2, '0');

    final year = picked.year.toString();

    setState(() {
      dobController.text = '$day/$month/$year';
    });
  }

  // ==============================================================
  // SAVE PROFILE
  // ==============================================================
  Future<void> _saveProfile() async {
  final provider =
      context.read<BuyerProfileProvider>();

  final success =
      await provider.saveProfile(
    name: nameController.text,
    email: emailController.text,
    phone: phoneController.text,
    dob: dobController.text,
    gender: selectedGender,
  );

  if (!mounted) return;

  if (success) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Profile saved successfully',
        ),
        backgroundColor: Color(0xFF006B4F),
      ),
    );

    // Go back after saving
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Please fill all required fields',
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
  // ==============================================================
  // MESSAGE
  // ==============================================================

  // void _showMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: primaryGreen,
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }
}
