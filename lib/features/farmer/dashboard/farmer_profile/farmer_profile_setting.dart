import 'package:farmdirect/core/provider/farmer_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FarmerProfileSettings extends StatefulWidget {
  const FarmerProfileSettings({super.key});

  @override
  State<FarmerProfileSettings> createState() => _FarmerProfileSettingsState();
}

class _FarmerProfileSettingsState extends State<FarmerProfileSettings> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController(
    text: '',
  );

  final TextEditingController _emailController = TextEditingController(
    text: '',
  );

  final TextEditingController _bioController = TextEditingController(text: '');
  @override
  void initState() {
    super.initState();

    final profile = context.read<ProfileProvider>();

    _nameController.text = profile.name;
    _phoneController.text = profile.phone;
    _emailController.text = profile.email;
    _bioController.text = profile.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF075B47),
                  size: 19,
                ),
              ),
            ),
          ),
        ),

        title: const Text(
          'Profile Settings',
          style: TextStyle(
            color: Color(0xFF075B47),
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),

        titleSpacing: 4,

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE8E8E8)),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(7, 14, 7, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // PROFILE IMAGE
              // ==================================================
              Consumer<ProfileProvider>(
                builder: (context, profile, child) {
                  final String name = profile.name.trim();

                  final String firstLetter = name.isNotEmpty
                      ? name[0].toUpperCase()
                      : 'U';

                  final String imageUrl = profile.fullProfileImageUrl;

                  return Center(
                    child: GestureDetector(
                      onTap: () async {
                        await profile.pickProfileImage();
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF075B47),
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: 68,
                                      height: 68,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return _buildFirstLetter(
                                              firstLetter,
                                            );
                                          },
                                    )
                                  : _buildFirstLetter(firstLetter),
                            ),
                          ),

                          // Camera button
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF075B47),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              
              const SizedBox(height: 18),

              // ==================================================
              // FULL NAME
              // ==================================================
              _buildLabel('Full Name'),

              _buildTextField(controller: _nameController),

              const SizedBox(height: 13),

              // ==================================================
              // PHONE
              // ==================================================
              _buildLabel('Phone Number'),

              _buildTextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 13),

              // ==================================================
              // EMAIL
              // ==================================================
              _buildLabel('Email Address'),

              _buildTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 13),

              // ==================================================
              // BIO
              // ==================================================
              _buildLabel('Bio / About Yourself'),

              _buildBioField(),

              const SizedBox(height: 75),
            ],
          ),
        ),
      ),

      // ========================================================
      // SAVE BUTTON
      // ========================================================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(7, 7, 7, 9),
          child: SizedBox(
            height: 33,
            child: ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();

                final success = await context
                    .read<ProfileProvider>()
                    .updateProfile(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      email: _emailController.text,
                      bio: _bioController.text,
                    );

                if (!context.mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                    ),
                  );

                  await Future.delayed(const Duration(milliseconds: 500));

                  if (!context.mounted) return;

                  Navigator.pop(context, 'save changes');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update profile')),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075B47),
                foregroundColor: Colors.white,
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Color(0xFF27343A),
        ),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,

        style: const TextStyle(fontSize: 10, color: Color(0xFF39444A)),

        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE1E5E7)),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE1E5E7)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF075B47)),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BIO
  // ============================================================

  Widget _buildBioField() {
    return TextField(
      controller: _bioController,
      maxLines: 4,

      style: const TextStyle(
        fontSize: 10,
        height: 1.25,
        color: Color(0xFF39444A),
      ),

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.all(10),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE1E5E7)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE1E5E7)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF075B47)),
        ),
      ),
    );
  }

  //===================
  // Build First Letter
  //===================

  Widget _buildFirstLetter(String firstLetter) {
    return Container(
      color: const Color(0xFFE8F5E9),
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: const TextStyle(
          color: Color(0xFF075B4A),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
