import 'package:farmdirect/Authentification/screens/login_screen.dart';
import 'package:farmdirect/core/provider/theme_provider.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/order/order_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/about_us_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/app_language_selector.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/notification_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/payment_method_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/saved_address_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/wishlist_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/farmer_profile/farm_help_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmdirect/core/provider/buyer_profile_provider.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/buyer_profile_setting.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF006B4F);

  static const Color backgroundColor = Color(0xFFF7F9F8);

  static const Color textColor = Color(0xFF26332F);

  static const Color secondaryTextColor = Color(0xFF7A8581);

  static const Color lightGreen = Color(0xFFEAF7F2);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BuyerProfileProvider>().loadProfile();
    });
  }

  // ==================================== ========================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            children: [
              // ==================================================
              // PROFILE HEADER
              // ==================================================
              Consumer<BuyerProfileProvider>(
                builder: (context, profile, child) {
                  return _profileHeader(profile);
                },
              ),

              const SizedBox(height: 14),

              // ==================================================
              // PERSONAL & SECURITY
              // ==================================================
              _buildSectionTitle("PERSONAL & SECURITY"),

              _buildSettingsCard(
                children: [
                  // ------------------------------------------------
                  // PROFILE SETTINGS
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.person_outline,
                    title: "Profile Settings",
                    onTap: _openProfileSettings,
                  ),

                  // ------------------------------------------------
                  // SAVED ADDRESSES
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.location_on_outlined,
                    title: "Saved Addresses",
                    trailing: _buildBadge("Home, Work"),
                    onTap: () {
                      // TODO:
                      // Open Saved Addresses Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavedAddressesScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------------
                  // MY ORDERS
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    trailing: _buildBadge("2 Active"),
                    onTap: () {
                      // TODO:
                      // Open My Orders Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------------
                  // WISHLIST
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.favorite_border,
                    title: "Wishlist & Saved Farms",
                    onTap: () {
                      // TODO:
                      // Open Wishlist Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WishlistScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------------
                  // PAYMENT METHODS
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.credit_card_outlined,
                    title: "Payment Methods",
                    onTap: () {
                      // TODO:
                      // Open Payment Methods Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentMethodsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ==================================================
              // PREFERENCES & SUPPORT
              // ==================================================
              _buildSectionTitle("PREFERENCES & SUPPORT"),

              _buildSettingsCard(
                children: [
                  // ------------------------------------------------
                  // NOTIFICATIONS
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.notifications_none,
                    title: "Notifications",
                    onTap: () {
                      // TODO:
                      // Open Notifications Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificationSettingsScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------------
                  // LANGUAGE
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.language,
                    title: "Language",
                    subtitle: "English",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppLanguageScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------------
                  // APPEARANCE
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.phone_android_outlined,
                    title: "Appearance",
                    onTap: () {
                      _showAppearanceDialog();
                    },
                  ),

                  // ------------------------------------------------
                  // HELP & SUPPORT
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {
                      // TODO:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HelpSupportScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------------
                  // ABOUT US
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.info_outline,
                    title: "About Us",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AboutUsScreen(),
                        ),
                      );
                    },
                  ),

                  // ------------------------------------------------
                  // LOGOUT
                  // ------------------------------------------------
                  _buildSettingsItem(
                    icon: Icons.logout,
                    title: "Logout",
                    isLogout: true,
                    onTap: _showLogoutDialog,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _profileHeader(BuyerProfileProvider profile) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),

      decoration: const BoxDecoration(
        color: primaryGreen,

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),

      child: Row(
        children: [
          // ======================================================
          // PROFILE IMAGE
          // ======================================================
          Container(
            width: 62,
            height: 62,

            padding: const EdgeInsets.all(2),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(color: Colors.white, width: 2),
            ),

            child: ClipOval(
              child: profile.profileImage != null
                  ? Image.file(
                      profile.profileImage!,
                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          profile.defaultImage,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(profile.defaultImage, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(width: 14),

          // ======================================================
          // PROFILE INFORMATION
          // ======================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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

                const SizedBox(height: 4),

                Text(
                  profile.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),

                const SizedBox(height: 3),

                Text(
                  profile.phone,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                ),

                const SizedBox(height: 3),

                Text(
                  profile.userId != null
                      ? 'Buyer ID: ${profile.userId}'
                      : 'Buyer ID: Loading...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // ======================================================
          // EDIT BUTTON
          // ======================================================
          IconButton(
            onPressed: _openProfileSettings,

            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 19,
            ),
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
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 7),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          title,

          style: const TextStyle(
            color: primaryGreen,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(11),

        border: Border.all(color: const Color(0xFFE5E9E7), width: 0.7),
      ),

      child: Column(children: children),
    );
  }

  // ============================================================
  // SETTINGS ITEM
  // ============================================================

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,

    String? subtitle,

    Widget? trailing,

    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(10),

      child: Container(
        height: subtitle != null ? 48 : 43,

        padding: const EdgeInsets.symmetric(horizontal: 10),

        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFECEFED), width: 0.6),
          ),
        ),

        child: Row(
          children: [
            // ==================================================
            // ICON
            // ==================================================
            Container(
              width: 27,
              height: 27,

              decoration: BoxDecoration(
                color: isLogout ? const Color(0xFFFFE8E8) : lightGreen,

                borderRadius: BorderRadius.circular(7),
              ),

              child: Icon(
                icon,

                size: 16,

                color: isLogout ? Colors.red : primaryGreen,
              ),
            ),

            const SizedBox(width: 10),

            // ==================================================
            // TITLE + SUBTITLE
            // ==================================================
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,

                      color: isLogout ? Colors.red : textColor,
                    ),
                  ),

                  if (subtitle != null) ...[
                    const SizedBox(height: 1),

                    Text(
                      subtitle,

                      style: const TextStyle(
                        fontSize: 8,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ==================================================
            // BADGE
            // ==================================================
            if (trailing != null) ...[trailing, const SizedBox(width: 5)],

            // ==================================================
            // ARROW
            // ==================================================
            const Icon(Icons.chevron_right, size: 17, color: Color(0xFF78827E)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BADGE
  // ============================================================

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),

      decoration: BoxDecoration(
        color: const Color(0xFF075B49),

        borderRadius: BorderRadius.circular(7),
      ),

      child: Text(
        text,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 7,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ============================================================
  // OPEN PROFILE SETTINGS
  // ============================================================

  Future<void> _openProfileSettings() async {
    await Navigator.push(
      context,

      MaterialPageRoute(builder: (_) => const BuyerProfileSettingsScreen()),
    );

    if (!mounted) return;

    await context.read<BuyerProfileProvider>().loadProfile();
  }

  // ============================================================
  // APPEARANCE DIALOG
  // ============================================================
  void _showAppearanceDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final themeProvider = context.read<ThemeProvider>();

        return AlertDialog(
          title: const Text("Appearance"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.light_mode_outlined),
                title: const Text("Light"),
                onTap: () {
                  themeProvider.setTheme(ThemeMode.light);

                  Navigator.pop(dialogContext);
                },
              ),

              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                title: const Text("Dark"),
                onTap: () {
                  themeProvider.setTheme(ThemeMode.dark);

                  Navigator.pop(dialogContext);
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text("System Default"),
                onTap: () {
                  themeProvider.setTheme(ThemeMode.system);

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
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: double.infinity,

            padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================================
                // LOGOUT ICON
                // ==================================================
                Container(
                  width: 44,
                  height: 44,

                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE5E5),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.logout,
                    color: Color(0xFFFF4545),
                    size: 22,
                  ),
                ),

                const SizedBox(height: 13),

                // ==================================================
                // TITLE
                // ==================================================
                const Text(
                  "Confirm Logout",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF26332F),
                  ),
                ),

                const SizedBox(height: 7),

                // ==================================================
                // DESCRIPTION
                // ==================================================
                const Text(
                  "Are you sure you want to logout?",

                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 9, color: Color(0xFF7E8985)),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LOGOUT BUTTON
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 37,

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);

                      _performLogout();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4545),

                      foregroundColor: Colors.white,

                      elevation: 1,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    child: const Text(
                      "Logout",

                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ==================================================
                // CANCEL BUTTON
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 37,

                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },

                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF747E7A),

                      side: const BorderSide(
                        color: Color(0xFF8B9591),
                        width: 1,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    child: const Text(
                      "Cancel",

                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // ============================================================
  // PERFORM LOGOUT
  // ============================================================

  void _performLogout() {
    // TODO:
    // Clear login/session data here.
    //
    // Example:
    // await yourAuthProvider.logout();
    //
    // Then navigate to your login screen.

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Logged out successfully")));
  }
}
