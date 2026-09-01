import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() =>
      _HelpSupportScreenState();
}

class _HelpSupportScreenState
    extends State<HelpSupportScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen =
      Color(0xFF006B4F);

  static const Color darkGreen =
      Color(0xFF075B49);

  static const Color backgroundColor =
      Color(0xFFF7F9F8);

  static const Color textColor =
      Color(0xFF26332F);

  static const Color secondaryTextColor =
      Color(0xFF8A9491);

  static const Color borderColor =
      Color(0xFFE3E8E5);

  static const Color reportRed =
      Color(0xFFFF4646);

  // ============================================================
  // VARIABLES
  // ============================================================

  int? expandedIndex;

  final TextEditingController searchController =
      TextEditingController();

  // ============================================================
  // FAQ DATA
  // ============================================================

  final List<Map<String, String>> faqs = [
    {
      "question": "How to order from certified farms?",
      "answer":
          "Go to the marketplace tab, browse fresh categories, "
          "select your desired item, check the farm verification "
          "badge, and click \"Add to Cart\". Follow checkout to "
          "place your order directly.",
    },
    {
      "question": "Payment issues & refund status",
      "answer":
          "Check your payment status from My Orders. "
          "If the payment was deducted but the order was not "
          "created, contact customer support.",
    },
    {
      "question": "How does direct farm delivery work?",
      "answer":
          "Products are sourced directly from certified farms "
          "and delivered to your selected address.",
    },
    {
      "question": "Returns, cancellations & refunds",
      "answer":
          "You can check the cancellation and refund options "
          "from your order details. Refund timing depends on "
          "the payment method.",
    },
  ];

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
            // MAIN CONTENT
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  6,
                  2,
                  6,
                  100,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    // ------------------------------------------
                    // SEARCH
                    // ------------------------------------------

                    _buildSearchBox(),

                    const SizedBox(height: 12),

                    // ------------------------------------------
                    // FAQ TITLE
                    // ------------------------------------------

                    _buildSectionTitle(
                      "FREQUENTLY ASKED QUESTIONS / सामान्य प्रश्न",
                    ),

                    const SizedBox(height: 5),

                    // ------------------------------------------
                    // FAQ CARD
                    // ------------------------------------------

                    _buildFaqCard(),

                    const SizedBox(height: 18),

                    // ------------------------------------------
                    // CONTACT TITLE
                    // ------------------------------------------

                    _buildSectionTitle(
                      "CONTACT CUSTOMER CARE / संपर्क करें",
                    ),

                    const SizedBox(height: 7),

                    // ------------------------------------------
                    // CONTACT OPTIONS
                    // ------------------------------------------

                    _buildContactOptions(),
                  ],
                ),
              ),
            ),

            // ==================================================
            // REPORT PROBLEM BUTTON
            // ==================================================

            _buildReportButton(),
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
                color: borderColor,
                width: 0.8,
              ),
            ),

            child: IconButton(
              padding: EdgeInsets.zero,

              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 13,
                color: Color(0xFF68746F),
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
            "Help & Support",

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH BOX
  // ============================================================

  Widget _buildSearchBox() {
    return Container(
      height: 35,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(7),

        border: Border.all(
          color: borderColor,
          width: 0.8,
        ),
      ),

      child: TextField(
        controller: searchController,

        style: const TextStyle(
          fontSize: 9,
          color: textColor,
        ),

        decoration: const InputDecoration(
          border: InputBorder.none,

          hintText:
              "Search FAQs, payments, delivery support...",

          hintStyle: TextStyle(
            fontSize: 9,
            color: secondaryTextColor,
          ),

          prefixIcon: Icon(
            Icons.search,
            size: 16,
            color: Color(0xFF8A9491),
          ),

          prefixIconConstraints:
              BoxConstraints(
            minWidth: 34,
          ),

          contentPadding:
              EdgeInsets.symmetric(
            vertical: 9,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 1,
      ),

      child: Text(
        title,

        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w800,
          color: primaryGreen,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // ============================================================
  // FAQ CARD
  // ============================================================

  Widget _buildFaqCard() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(10),

        border: Border.all(
          color: borderColor,
          width: 0.8,
        ),
      ),

      child: Column(
        children: List.generate(
          faqs.length,
          (index) {
            return _buildFaqItem(
              index,
              faqs[index]["question"]!,
              faqs[index]["answer"]!,
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // FAQ ITEM
  // ============================================================

  Widget _buildFaqItem(
    int index,
    String question,
    String answer,
  ) {
    final bool isExpanded =
        expandedIndex == index;

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              expandedIndex =
                  isExpanded ? null : index;
            });
          },

          child: Container(
            constraints:
                const BoxConstraints(
              minHeight: 37,
            ),

            padding:
                const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 8,
            ),

            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center,

              children: [
                // ------------------------------------------
                // QUESTION
                // ------------------------------------------

                Expanded(
                  child: Text(
                    question,

                    style:
                        const TextStyle(
                      fontSize: 9,
                      fontWeight:
                          FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),

                // ------------------------------------------
                // ARROW
                // ------------------------------------------

                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,

                  size: 16,

                  color:
                      const Color(0xFF7C8783),
                ),
              ],
            ),
          ),
        ),

        // ==================================================
        // ANSWER
        // ==================================================

        if (isExpanded)
          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.fromLTRB(
              9,
              0,
              9,
              10,
            ),

            child: Text(
              answer,

              style: const TextStyle(
                fontSize: 8,
                height: 1.35,
                color: secondaryTextColor,
              ),
            ),
          ),

        // ==================================================
        // DIVIDER
        // ==================================================

        if (index < faqs.length - 1)
          const Divider(
            height: 1,
            thickness: 0.6,
            color: borderColor,
          ),
      ],
    );
  }

  // ============================================================
  // CONTACT OPTIONS
  // ============================================================

  Widget _buildContactOptions() {
    return Row(
      children: [
        // ==================================================
        // CALL SUPPORT
        // ==================================================

        Expanded(
          child: _buildContactCard(
            icon: Icons.phone_outlined,
            title: "Call Support",
            subtitle: "1800-456-FARM",
            onTap: _callSupport,
          ),
        ),

        const SizedBox(width: 7),

        // ==================================================
        // LIVE CHAT
        // ==================================================

        Expanded(
          child: _buildContactCard(
            icon: Icons.chat_bubble_outline,
            title: "Live Chat",
            subtitle: "Instant reply",
            onTap: _openLiveChat,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CONTACT CARD
  // ============================================================

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(8),

      child: Container(
        height: 58,

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(8),

          border: Border.all(
            color: borderColor,
            width: 0.8,
          ),
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            // ------------------------------------------
            // ICON
            // ------------------------------------------

            Icon(
              icon,
              size: 17,
              color: primaryGreen,
            ),

            const SizedBox(height: 2),

            // ------------------------------------------
            // TITLE
            // ------------------------------------------

            Text(
              title,

              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),

            const SizedBox(height: 1),

            // ------------------------------------------
            // SUBTITLE
            // ------------------------------------------

            Text(
              subtitle,

              style: const TextStyle(
                fontSize: 7,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REPORT PROBLEM BUTTON
  // ============================================================

  Widget _buildReportButton() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        8,
        7,
        8,
        10,
      ),

      color: backgroundColor,

      child: SizedBox(
        height: 32,

        child: ElevatedButton(
          onPressed: _reportProblem,

          style:
              ElevatedButton.styleFrom(
            backgroundColor: reportRed,
            foregroundColor: Colors.white,

            elevation: 1,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(18),
            ),
          ),

          child: const Text(
            "Report a Problem",

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
  // CALL SUPPORT
  // ============================================================

  void _callSupport() {
    // TODO:
    // Add url_launcher here to make the call.
    //
    // Example number:
    // 1800-456-FARM

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Calling FarmDirect Support...",
        ),
      ),
    );
  }

  // ============================================================
  // LIVE CHAT
  // ============================================================

  void _openLiveChat() {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Opening Live Chat...",
        ),
      ),
    );
  }

  // ============================================================
  // REPORT PROBLEM
  // ============================================================

  void _reportProblem() {
    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,

      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.all(20),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                "Report a Problem",

                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.bold,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Tell us what went wrong and "
                "our support team will help you.",
                style: TextStyle(
                  fontSize: 11,
                  color:
                      secondaryTextColor,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                maxLines: 4,

                decoration:
                    InputDecoration(
                  hintText:
                      "Describe your problem...",

                  hintStyle:
                      const TextStyle(
                    fontSize: 11,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 40,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(
                      this.context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Problem reported successfully.",
                        ),
                      ),
                    );
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        primaryGreen,

                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),

                  child: const Text(
                    "Submit Report",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}