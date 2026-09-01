import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/buyer_profile_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmdirect/core/provider/buyer_profile_provider.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({
    super.key,
  });

  @override
  State<BuyerProfileScreen> createState() =>
      _BuyerProfileScreenState();
}

class _BuyerProfileScreenState
    extends State<BuyerProfileScreen> {

  static const Color primaryGreen =
      Color(0xFF006B4F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F9F8),

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),

          child: Column(
            children: [

              // ==================================================
              // HEADER
              // ==================================================

              Consumer<BuyerProfileProvider>(
                builder: (
                  context,
                  profile,
                  child,
                ) {
                  return _profileHeader(
                    profile,
                  );
                },
              ),

              const SizedBox(height: 18),

              // ==================================================
              // REST OF YOUR PROFILE UI
              // ==================================================

              // Personal & Security
              // Preferences & Support
              // Logout
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _profileHeader(
    BuyerProfileProvider profile,
  ) {
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
          bottomLeft:
              Radius.circular(20),
          bottomRight:
              Radius.circular(20),
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

            padding:
                const EdgeInsets.all(2),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),

            child: ClipOval(
              child:
                  profile.profileImage !=
                          null
                      ? Image.file(
                          profile
                              .profileImage!,
                          fit:
                              BoxFit.cover,

                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Image.asset(
                              profile
                                  .defaultImage,
                              fit:
                                  BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          profile.defaultImage,
                          fit:
                              BoxFit.cover,
                        ),
            ),
          ),

          const SizedBox(width: 14),

          // ======================================================
          // PROFILE INFORMATION
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // NAME
                Text(
                  profile.name,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // EMAIL
                Text(
                  profile.email,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 3),

                // PHONE
                Text(
                  profile.phone,

                  style:
                      const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // EDIT
          // ======================================================

          IconButton(
            onPressed:
                _openProfileSettings,

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
  // OPEN SETTINGS AND REFRESH
  // ============================================================

  Future<void>
      _openProfileSettings() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const BuyerProfileSettingsScreen(),
      ),
    );

    // IMPORTANT
    if (!mounted) return;

    await context
        .read<BuyerProfileProvider>()
        .loadProfile();
  }
}