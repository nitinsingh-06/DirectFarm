
import 'package:farmdirect/core/provider/buyer_profile_provider.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/buyer_profile_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmdirect/core/provider/farmer_profile_provider.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  static const Color primaryGreen = Color(0xFF006B4F);
  static const Color lightGreen = Color(0xFFEAF7F2);
  static const Color backgroundColor = Color(0xFFF7F9F8);

  @override
  void initState() {
    super.initState();

    // Load saved name and profile image
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BuyerProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ----------------------------------------------------------
      // SCROLLABLE PROFILE SCREEN
      // ----------------------------------------------------------
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profile, child) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // ------------------------------------------------
                  // PROFILE HEADER
                  // ------------------------------------------------
                  _profileHeader(profile),

                  const SizedBox(height: 18),

                  // ------------------------------------------------
                  // PERSONAL & SECURITY
                  // ------------------------------------------------
                  _sectionTitle(
                    'PERSONAL & SECURITY',
                  ),

                  _settingsCard(
                    children: [
                      _settingTile(
                        icon: Icons.person_outline,
                        title: 'Profile Settings',
                        subtitle: 'Manage your profile',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const BuyerProfileSettingsScreen(),
                            ),
                          );
                        },
                      ),

                      _divider(),

                      _settingTile(
                        icon: Icons.location_on_outlined,
                        title: 'Saved Addresses',
                        subtitle: 'Manage delivery addresses',
                        badge: '2',
                        onTap: () {
                          _showComingSoon(
                            'Saved Addresses',
                          );
                        },
                      ),

                      _divider(),

                      _settingTile(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        subtitle: 'View your orders',
                        badge: '2 Active',
                        onTap: () {
                          _showComingSoon(
                            'My Orders',
                          );
                        },
                      ),

                      _divider(),

                      _settingTile(
                        icon: Icons.favorite_border,
                        title: 'Wishlist & Saved Farms',
                        subtitle: 'Your favourite products',
                        onTap: () {
                          _showComingSoon(
                            'Wishlist & Saved Farms',
                          );
                        },
                      ),

                      _divider(),

                      _settingTile(
                        icon: Icons.credit_card_outlined,
                        title: 'Payment Methods',
                        subtitle: 'Manage payment options',
                        onTap: () {
                          _showComingSoon(
                            'Payment Methods',
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // PREFERENCES & SUPPORT
                  // ------------------------------------------------
                  _sectionTitle(
                    'PREFERENCES & SUPPORT',
                  ),

                  _settingsCard(
                    children: [
                      _settingTile(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        subtitle: 'Manage notifications',
                        onTap: () {
                          _showComingSoon(
                            'Notifications',
                          );
                        },
                      ),

                      _divider(),

                      _settingTile(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: 'English',
                        onTap: () {
                          _showLanguageDialog();
                        },
                      ),

                      _divider(),

                      _settingTile(
                        icon: Icons.phone_android_outlined,
                        title: 'Appearance',
                        subtitle: 'Light',
                        onTap: () {
                          _showAppearanceDialog();
                        },
                      ),

                      _divider(),

                      _settingTile(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'Get help with FarmDirect',
                        onTap: () {
                          _showComingSoon(
                            'Help & Support',
                          );
                        },
                      ),

                      _divider(),

                      _settingTile(
                        icon: Icons.info_outline,
                        title: 'About Us',
                        subtitle: 'About FarmDirect',
                        onTap: () {
                          _showAboutDialog();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // LOGOUT
                  // ------------------------------------------------
                  _logoutTile(),

                  const SizedBox(height: 25),

                  Text(
                    'FarmDirect',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==============================================================
  // PROFILE HEADER
  // ==============================================================

  Widget _profileHeader(ProfileProvider profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        20,
      ),
      decoration: const BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // PROFILE IMAGE
          Container(
            width: 62,
            height: 62,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: profile.profileImage != null
                  ? Image.file(
                      profile.profileImage!,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return _defaultImage();
                      },
                    )
                  : Image.asset(
                      profile.defaultImage,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return _defaultImage();
                      },
                    ),
            ),
          ),

          const SizedBox(width: 14),

          // NAME
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Buyer Account',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 3),

                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white70,
                      size: 12,
                    ),
                    SizedBox(width: 3),
                    Text(
                      'FarmDirect Buyer',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // EDIT
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const BuyerProfileSettingsScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultImage() {
    return Container(
      color: lightGreen,
      child: const Icon(
        Icons.person,
        color: primaryGreen,
        size: 34,
      ),
    );
  }

  // ==============================================================
  // SECTION TITLE
  // ==============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: primaryGreen,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // SETTINGS CARD
  // ==============================================================

  Widget _settingsCard({
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ==============================================================
  // SETTING TILE
  // ==============================================================

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: primaryGreen,
                size: 18,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF303030),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 6),
            ],

            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade500,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 58,
      ),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey.shade200,
      ),
    );
  }

  // ==============================================================
  // LOGOUT
  // ==============================================================

  Widget _logoutTile() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: _showLogoutDialog,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 11,
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                  size: 18,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade500,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==============================================================
  // LANGUAGE
  // ==============================================================

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: primaryGreen,
                ),
                title: const Text('English'),
                trailing: const Icon(
                  Icons.check,
                  color: primaryGreen,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.language,
                  color: primaryGreen,
                ),
                title: const Text('हिन्दी'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ==============================================================
  // APPEARANCE
  // ==============================================================

  void _showAppearanceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Appearance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.light_mode_outlined,
                  color: primaryGreen,
                ),
                title: const Text('Light'),
                trailing: const Icon(
                  Icons.check,
                  color: primaryGreen,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.dark_mode_outlined,
                  color: primaryGreen,
                ),
                title: const Text('Dark'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: primaryGreen,
                ),
                title: const Text('System Default'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ==============================================================
  // ABOUT
  // ==============================================================

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'About FarmDirect',
            style: TextStyle(
              color: primaryGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'FarmDirect connects farmers directly '
            'with buyers and makes agricultural '
            'products easier to discover and purchase.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: primaryGreen,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==============================================================
  // LOGOUT
  // ==============================================================

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
              ),
              onPressed: () {
                Navigator.pop(context);

                // Put your authentication logout
                // method here.
              },
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

  // ==============================================================
  // COMING SOON
  // ==============================================================

  void _showComingSoon(String screenName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$screenName is coming soon',
        ),
        backgroundColor: primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
