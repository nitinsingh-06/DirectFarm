import 'package:flutter/material.dart';

class AppLanguageScreen extends StatefulWidget {
  const AppLanguageScreen({super.key});

  @override
  State<AppLanguageScreen> createState() =>
      _AppLanguageScreenState();
}

class _AppLanguageScreenState
    extends State<AppLanguageScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen =
      Color(0xFF006B4F);

  static const Color backgroundColor =
      Color(0xFFF7F9F8);

  static const Color textColor =
      Color(0xFF26332F);

  // ============================================================
  // SELECTED LANGUAGE
  // ============================================================

  String selectedLanguage = "English";

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

            _buildTopBar(),

            // ==================================================
            // LANGUAGE OPTIONS
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  6,
                  10,
                  6,
                  100,
                ),

                child: Column(
                  children: [
                    // ------------------------------------------
                    // ENGLISH
                    // ------------------------------------------

                    _buildLanguageOption(
                      language: "English",
                      value: "English",
                    ),

                    const SizedBox(height: 8),

                    // ------------------------------------------
                    // HINDI
                    // ------------------------------------------

                    _buildLanguageOption(
                      language: "हिन्दी",
                      value: "Hindi",
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // CONFIRM BUTTON
            // ==================================================

            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        16,
        8,
      ),

      child: Row(
        children: [
          // ----------------------------------------------
          // BACK BUTTON
          // ----------------------------------------------

          Container(
            width: 30,
            height: 30,

            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,

              border: Border.all(
                color: const Color(0xFFE1E7E4),
                width: 0.8,
              ),
            ),

            child: IconButton(
              padding: EdgeInsets.zero,

              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: Color(0xFF61706B),
              ),

              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          const SizedBox(width: 10),

          // ----------------------------------------------
          // TITLE
          // ----------------------------------------------

          const Text(
            "App Language",

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LANGUAGE OPTION
  // ============================================================

  Widget _buildLanguageOption({
    required String language,
    required String value,
  }) {
    final bool isSelected =
        selectedLanguage == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });
      },

      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 150),

        width: double.infinity,
        height: 42,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(7),

          border: Border.all(
            color: isSelected
                ? primaryGreen
                : const Color(0xFFE4E8E6),

            width: isSelected ? 1.2 : 0.8,
          ),
        ),

        child: Row(
          children: [
            // ----------------------------------------------
            // LANGUAGE NAME
            // ----------------------------------------------

            Expanded(
              child: Text(
                language,

                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),

            // ----------------------------------------------
            // RADIO BUTTON
            // ----------------------------------------------

            Container(
              width: 17,
              height: 17,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: isSelected
                      ? primaryGreen
                      : const Color(0xFFB8C1BE),

                  width: 1.4,
                ),
              ),

              child: isSelected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,

                        decoration:
                            const BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONFIRM BUTTON
  // ============================================================

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        8,
        10,
      ),

      color: backgroundColor,

      child: SizedBox(
        height: 30,

        child: ElevatedButton(
          onPressed: _confirmLanguage,

          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,

            elevation: 1,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(18),
            ),
          ),

          child: const Text(
            "Confirm Language",

            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CONFIRM LANGUAGE
  // ============================================================

  void _confirmLanguage() {
    // For now, return the selected language
    // to the Profile screen.

    Navigator.pop(
      context,
      selectedLanguage,
    );
  }
}