import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen =
      Color(0xFF006B4F);

  static const Color logoGreen =
      Color(0xFF82D600);

  static const Color backgroundColor =
      Color(0xFFF7F9F8);

  static const Color textColor =
      Color(0xFF26332F);

  static const Color secondaryTextColor =
      Color(0xFF7E8985);

  static const Color borderColor =
      Color(0xFFE1E7E4);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // TOP BAR
            // ==================================================

            // _buildTopBar(context),
            

            // ==================================================
            // MAIN CONTENT
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  7,
                  10,
                  7,
                  15,
                ),

                child: Column(
                  children: [
                    // ------------------------------------------
                    // LOGO
                    // ------------------------------------------

                    // _buildLogo(),
                    Image.asset('assets/images/logo.png',width: 90,height: 90,),

                    const SizedBox(height: 5),

                    // ------------------------------------------
                    // APP NAME
                    // ------------------------------------------

                    const Text(
                      "FarmDirect",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: primaryGreen,
                      ),
                    ),

                    const SizedBox(height: 3),

                    // ------------------------------------------
                    // TAGLINE
                    // ------------------------------------------

                    const Text(
                      "Connecting Farmers Directly to Consumers",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: primaryGreen,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ------------------------------------------
                    // OUR VISION
                    // ------------------------------------------

                    _buildInformationCard(
                      title: "Our Vision",
                      content:
                          "To create an ecosystem where Indian farmers receive "
                          "fair compensation instantly for their hard work, and "
                          "families in urban centers enjoy the freshest, organic "
                          "harvest straight from the roots.",
                    ),

                    const SizedBox(height: 10),

                    // ------------------------------------------
                    // OUR STORY
                    // ------------------------------------------

                    _buildInformationCard(
                      title: "Our Story",
                      content:
                          "Founded in 2026, FarmDirect was born from a simple "
                          "observation: middle-men dilute the rewards of "
                          "farming. By leveraging state-of-the-art logistics "
                          "and real-time fair trade technology, we empower "
                          "over 10,000+ local Indian farmers today.",
                    ),

                    const SizedBox(height: 12),

                    // ------------------------------------------
                    // FOLLOW OUR JOURNEY
                    // ------------------------------------------

                    _buildFollowSection(),

                    const SizedBox(height: 18),

                    // ------------------------------------------
                    // RATE + SHARE
                    // ------------------------------------------

                    _buildActionButtons(),

                    const SizedBox(height: 12),

                    // ------------------------------------------
                    // VERSION
                    // ------------------------------------------

                    const Text(
                      "FarmDirect App • version v1.0.0",
                      style: TextStyle(
                        fontSize: 7,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationCard({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        10,
        10,
        10,
        11,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(11),

        border: Border.all(
          color: borderColor,
          width: 0.8,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ----------------------------------------------
          // TITLE
          // ----------------------------------------------

          Text(
            title,

            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: primaryGreen,
            ),
          ),

          const SizedBox(height: 7),

          // ----------------------------------------------
          // CONTENT
          // ----------------------------------------------

          Text(
            content,

            style: const TextStyle(
              fontSize: 8,
              height: 1.35,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOLLOW OUR JOURNEY
  // ============================================================

  Widget _buildFollowSection() {
    return Column(
      children: [
        const Text(
          "Follow Our Journey",

          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: secondaryTextColor,
          ),
        ),

        const SizedBox(height: 7),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            _buildSocialButton(
              icon: Icons.camera_alt_outlined,
              onTap: () {
                // TODO:
                // Open Instagram
              },
            ),

            const SizedBox(width: 9),

            _buildSocialButton(
              icon: Icons.alternate_email,
              onTap: () {
                // TODO:
                // Open Twitter / X
              },
            ),

            const SizedBox(width: 9),

            _buildSocialButton(
              icon: Icons.play_arrow,
              onTap: () {
                // TODO:
                // Open YouTube
              },
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // SOCIAL BUTTON
  // ============================================================

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(20),

      child: Container(
        width: 28,
        height: 28,

        decoration: BoxDecoration(
          color: Colors.white,

          shape: BoxShape.circle,

          border: Border.all(
            color: borderColor,
            width: 0.8,
          ),
        ),

        child: Icon(
          icon,
          size: 14,
          color: primaryGreen,
        ),
      ),
    );
  }

  // ============================================================
  // RATE + SHARE BUTTONS
  // ============================================================

  Widget _buildActionButtons() {
    return Row(
      children: [
        // ----------------------------------------------
        // RATE US
        // ----------------------------------------------

        Expanded(
          child: _buildOutlineButton(
            title: "Rate Us",
            onTap: () {
              // TODO:
              // Open Play Store rating
            },
          ),
        ),

        const SizedBox(width: 8),

        // ----------------------------------------------
        // SHARE APP
        // ----------------------------------------------

        Expanded(
          child: _buildOutlineButton(
            title: "Share App",
            onTap: () {
              // TODO:
              // Add share functionality
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OUTLINE BUTTON
  // ============================================================

  Widget _buildOutlineButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 36,

      child: OutlinedButton(
        onPressed: onTap,

        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,

          side: const BorderSide(
            color: primaryGreen,
            width: 1,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),

        child: Text(
          title,

          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}