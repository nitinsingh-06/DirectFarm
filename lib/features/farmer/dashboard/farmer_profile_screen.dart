import 'dart:io';

import 'package:farmdirect/Authentification/screens/comming_soon.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int) onBottomNavTap;

  const ProfileScreen({
    super.key,
    required this.onBottomNavTap,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  // ============================================================
  // PICK PROFILE IMAGE
  // ============================================================

  Future<void> _pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      
    );

    if (image == null) return;

    setState(() {
      _profileImage = File(image.path);
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ========================================================
          // PROFILE HEADER
          // ========================================================

          _buildProfileHeader(),

          // ========================================================
          // SCROLLABLE PROFILE CONTENT
          // ========================================================

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                10,
                10,
                10,
                15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // MY PROFILE
                  // ==================================================

                  _buildSectionTitle(
                    'MY PROFILE',
                  ),

                  const SizedBox(height: 6),

                  _buildMenuGroup(
                    children: [
                      _buildMenuItem(
                        icon: Icons.person_outline,
                        title: 'Profile Settings',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ComingSoonScreen(),
                            ),
                          );
                        },
                      ),

                      _buildDivider(),

                      _buildMenuItem(
                        icon: Icons.eco_outlined,
                        title: 'Farm Details',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ComingSoonScreen(),
                            ),
                          );
                        },
                      ),

                      _buildDivider(),

                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Farm Location',
                        trailing: 'Rohini, New Delhi',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ComingSoonScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // QUICK ACCESS
                  // ==================================================

                  _buildSectionTitle(
                    'QUICK ACCESS ',
                  ),

                  const SizedBox(height: 6),

                  _buildMenuGroup(
                    children: [
                      _buildMenuItem(
                        icon: Icons.inventory_2_outlined,
                        title: 'My Products',
                        trailing: '24 New',
                        trailingColor:
                            const Color(0xFF08795D),
                        onTap: () {
                          widget.onBottomNavTap(1);
                        },
                      ),

                      _buildDivider(),

                      _buildMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        trailing: '8 New',
                        trailingColor:
                            const Color(0xFF08795D),
                        onTap: () {
                          widget.onBottomNavTap(2);
                        },
                      ),

                      _buildDivider(),

                      _buildMenuItem(
                        icon: Icons.currency_rupee,
                        title: 'Earnings & Payouts',
                        trailing: '₹1,45,000',
                        onTap: () {
                          widget.onBottomNavTap(3);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // APP SETTINGS
                  // ==================================================

                  _buildSectionTitle(
                    'APP SETTINGS',
                  ),

                  const SizedBox(height: 6),

                  _buildMenuGroup(
                    children: [
                      // ----------------------------------------------
                      // NOTIFICATIONS
                      // ----------------------------------------------

                      _buildMenuItem(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ComingSoonScreen(),
                            ),
                          );
                        },
                      ),

                      _buildDivider(),

                      // ----------------------------------------------
                      // APP LANGUAGE
                      // ----------------------------------------------

                      _buildMenuItem(
                        icon: Icons.language,
                        title: 'App Language',
                        trailing: 'हिंदी (Hindi)',
                        onTap: () {
                          _showLanguageDialog();
                        },
                      ),

                      _buildDivider(),

                      // ----------------------------------------------
                      // APPEARANCE
                      // ----------------------------------------------

                      _buildMenuItem(
                        icon: Icons.phone_android_outlined,
                        title: 'Appearance',
                        trailing: 'System Default',
                        onTap: () {
                          _showAppearanceDialog();
                        },
                      ),

                      _buildDivider(),

                      // ----------------------------------------------
                      // HELP & SUPPORT
                      // ----------------------------------------------

                      _buildMenuItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ComingSoonScreen(),
                            ),
                          );
                        },
                      ),

                      _buildDivider(),

                      // ----------------------------------------------
                      // ABOUT US
                      // ----------------------------------------------

                      _buildMenuItem(
                        icon: Icons.info_outline,
                        title: 'About Us',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ComingSoonScreen(),
                            ),
                          );
                        },
                      ),

                      _buildDivider(),

                      // ----------------------------------------------
                      // LOGOUT
                      // ----------------------------------------------

                      _buildMenuItem(
                        icon: Icons.logout,
                        title: 'Logout',
                        iconColor: const Color(0xFFE55353),
                        titleColor: const Color(0xFFE55353),
                        showArrow: false,
                        onTap: () {
                          _showLogoutDialog();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      color: const Color(0xFF075B47),
      child: Row(
        children: [
          // ========================================================
          // PROFILE PICTURE
          // ========================================================

          GestureDetector(
            onTap: _pickProfileImage,
            child: Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFB8D9A8),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: _profileImage != null
                        ? Image.file(
                            _profileImage!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/profile.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                              return Container(
                                color:
                                    const Color(0xFFE7F2ED),
                                child: const Icon(
                                  Icons.person,
                                  color:
                                      Color(0xFF075B47),
                                  size: 25,
                                ),
                              );
                            },
                          ),
                  ),
                ),

                // Small camera icon
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF075B47),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 9,
                      color: Color(0xFF075B47),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ========================================================
          // NAME
          // ========================================================

          const Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Romesh Kumar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'Farm ID: #83422',
                style: TextStyle(
                  fontSize: 8,
                  color: Color(0xFFD1E8E1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 7.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF54706A),
        ),
      ),
    );
  }

  // ============================================================
  // MENU GROUP
  // ============================================================

  Widget _buildMenuGroup({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE8ECEF),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailing,
    Color? trailingColor,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 42,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
          ),
          child: Row(
            children: [
              // ====================================================
              // ICON
              // ====================================================

              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: (iconColor ??
                          const Color(0xFF08795D))
                      .withOpacity(0.08),
                  borderRadius:
                      BorderRadius.circular(7),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: iconColor ??
                      const Color(0xFF08795D),
                ),
              ),

              const SizedBox(width: 9),

              // ====================================================
              // TITLE
              // ====================================================

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: titleColor ??
                        const Color(0xFF38434A),
                  ),
                ),
              ),

              // ====================================================
              // TRAILING TEXT
              // ====================================================

              if (trailing != null)
                Text(
                  trailing,
                  style: TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w500,
                    color: trailingColor ??
                        const Color(0xFF737B82),
                  ),
                ),

              // ====================================================
              // ARROW
              // ====================================================

              if (showArrow) ...[
                const SizedBox(width: 5),

                const Icon(
                  Icons.chevron_right,
                  size: 15,
                  color: Color(0xFF929AA0),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 43,
      endIndent: 8,
      color: Color(0xFFF0F2F3),
    );
  }

  // ============================================================
  // LANGUAGE DIALOG
  // ============================================================

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'App Language',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'English',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                title: const Text(
                  'हिंदी (Hindi)',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // APPEARANCE DIALOG
  // ============================================================

  void _showAppearanceDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'System Default',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                title: const Text(
                  'Light',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                },
              ),
              ListTile(
                title: const Text(
                  'Dark',
                  style: TextStyle(fontSize: 13),
                ),
                onTap: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // LOGOUT DIALOG
  // ============================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Add your actual logout logic here.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFE55353),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}