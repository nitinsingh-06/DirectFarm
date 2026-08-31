import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How to list and sell my organic crops?',
      'answer':
          'Simply click “Add Product” on your home screen or products catalog. Fill in crop details, prices per kg or quintal, upload farm photos and save. It will immediately appear on buyer marketplace!',
    },
    {
      'question': 'How do payouts and secure bank transfers work?',
      'answer':
          'Your payment is securely processed after the order is completed. The payout is transferred to your registered bank account.',
    },
    {
      'question': 'What is the delivery and logistics process?',
      'answer':
          'After an order is confirmed, the delivery and logistics process is coordinated according to the selected delivery option.',
    },
    {
      'question': 'Filling and updating Aadhaar details?',
      'answer':
          'You can update your Aadhaar information from your profile and account settings.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

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
                  size: 18,
                ),
              ),
            ),
          ),
        ),

        titleSpacing: 3,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Help & Support',
              style: TextStyle(
                color: Color(0xFF075B47),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: 1),

            Text(
              'मदद और सहायता',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            7,
            9,
            7,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ======================================================
              // SEARCH
              // ======================================================

              _buildSearchBox(),

              const SizedBox(height: 9),

              // ======================================================
              // TOP FAQ TAG
              // ======================================================

              const Text(
                'TOP FAQS',
                style: TextStyle(
                  color: Color(0xFF075B47),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              // ======================================================
              // FAQ LIST
              // ======================================================

              _buildFaqList(),

              const SizedBox(height: 11),

              // ======================================================
              // DIRECT CONTACT
              // ======================================================

              const Text(
                'DIRECT CONTACT',
                style: TextStyle(
                  color: Color(0xFF075B47),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              _buildContactCard(),

              const SizedBox(height: 45),

              // ======================================================
              // REPORT PROBLEM
              // ======================================================

              _buildReportButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH BOX
  // ============================================================

  Widget _buildSearchBox() {
    return Container(
  height: 29,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(6),
    border: Border.all(
      color: const Color(0xFFE2E6E8),
      width: 1,
    ),
  ),
  child: const TextField(
    style: TextStyle(
      fontSize: 13,
      color: Color(0xFF374151),
    ),
    decoration: InputDecoration(
      border: InputBorder.none,

      prefixIcon: Icon(
        Icons.search,
        size: 15,
        color: Color(0xFF89939C),
      ),

      hintText: 'Search topics, issues, guide...',
      hintStyle: TextStyle(
        fontSize: 10,
        color: Color(0xFF89939C),
      ),

      contentPadding: EdgeInsets.symmetric(
        vertical: 5,
      ),

      // Removes default TextField spacing
      isDense: true,

      prefixIconConstraints: BoxConstraints(
        minWidth: 32,
        minHeight: 27,
      ),
    ),
  ),
);
  }

  // ============================================================
  // FAQ LIST
  // ============================================================

  Widget _buildFaqList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE2E6E8),
        ),
      ),
      child: Column(
        children: List.generate(
          _faqs.length,
          (index) {
            final faq = _faqs[index];

            final bool expanded =
                _expandedIndex == index;

            return Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_expandedIndex == index) {
                        _expandedIndex = null;
                      } else {
                        _expandedIndex = index;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 7,
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Text(
                            faq['question']!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Icon(
                          expanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 13,
                          color: const Color(0xFF65717A),
                        ),
                      ],
                    ),
                  ),
                ),

                if (expanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      8,
                      0,
                      22,
                      8,
                    ),
                    child: Text(
                      faq['answer']!,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        color: Color(0xFF69747D),
                      ),
                    ),
                  ),

                if (index != _faqs.length - 1)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE7EAEC),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // CONTACT CARD
  // ============================================================

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE2E6E8),
        ),
      ),
      child: Column(
        children: [

          // ======================================================
          // TOLL FREE
          // ======================================================

          Row(
            children: [
              _contactIcon(
                Icons.phone_outlined,
              ),

              const SizedBox(width: 7),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Toll-Free Helpline',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Text(
                      '1800-300-8843',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF66727A),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 21,
                child: ElevatedButton(
                  onPressed: () {
                    _showMessage(
                      'Calling toll-free helpline...',
                    );
                    Navigator.pop(context,'calling');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF075B47),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 9,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Call',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // ======================================================
          // WHATSAPP
          // ======================================================

          Row(
            children: [
              _contactIcon(
                Icons.chat_bubble_outline,
              ),

              const SizedBox(width: 7),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WhatsApp Support',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Text(
                      'Bilingual Chat Help',
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFF66727A),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 21,
                child: OutlinedButton(
                  onPressed: () {
                    _showMessage(
                      'Opening WhatsApp support...',
                    );
                    Navigator.pop(context,'chat');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF075B47),
                    side: const BorderSide(
                      color: Color(0xFF8AC9B6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 9,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Chat',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTACT ICON
  // ============================================================

  Widget _contactIcon(IconData icon) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF075B47),
        size: 14,
      ),
    );
  }

  // ============================================================
  // REPORT BUTTON
  // ============================================================

  Widget _buildReportButton() {
    return SizedBox(
      width: double.infinity,
      height: 24,
      child: OutlinedButton(
        onPressed: () {
          _showReportDialog();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE5484D),
          side: const BorderSide(
            color: Color(0xFFFF6B70),
          ),
          backgroundColor: const Color(0xFFFFF3F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text(
          'Report a Problem',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // REPORT DIALOG
  // ============================================================

  void _showReportDialog() {
    final TextEditingController controller =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Report a Problem',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe your problem...',
              border: OutlineInputBorder(),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                _showMessage(
                  'Problem reported successfully',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF075B47),
              ),
              child: const Text(
                'Submit',
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