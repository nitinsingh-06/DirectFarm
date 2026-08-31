import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
              'About Us',
              style: TextStyle(
                color: Color(0xFF075B47),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 1),

           
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
            13,
            16,
            13,
            25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ======================================================
              // LOGO / BRAND
              // ======================================================

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F2),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.eco,
                        color: Color(0xFF075B47),
                        size: 38,
                      ),
                    ),

                    const SizedBox(height: 9),

                    const Text(
                      'FarmDirect',
                      style: TextStyle(
                        color: Color(0xFF075B47),
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'From Farm to Market, Directly.',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ======================================================
              // ABOUT FARM DIRECT
              // ======================================================

              _sectionTitle('About FarmDirect'),

              const SizedBox(height: 7),

              _contentCard(
                child: const Text(
                  'FarmDirect is a digital platform designed to connect farmers directly with buyers. We help farmers showcase their products, receive orders and build direct relationships with buyers across Uttarakhand.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ======================================================
              // OUR MISSION
              // ======================================================

              _sectionTitle('Our Mission'),

              const SizedBox(height: 7),

              _contentCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _iconBox(Icons.flag_outlined),

                    const SizedBox(width: 10),

                    const Expanded(
                      child: Text(
                        'Our mission is to make agricultural trade simpler, transparent and more accessible by helping farmers reach genuine buyers directly.',
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.5,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ======================================================
              // WHAT WE DO
              // ======================================================

              _sectionTitle('What We Do'),

              const SizedBox(height: 7),

              _featureCard(
                icon: Icons.eco_outlined,
                title: 'For Farmers',
                description:
                    'List agricultural products, manage orders and connect directly with buyers.',
              ),

              const SizedBox(height: 7),

              _featureCard(
                icon: Icons.shopping_bag_outlined,
                title: 'For Buyers',
                description:
                    'Discover fresh agricultural products and connect with verified farmers.',
              ),

              const SizedBox(height: 7),

              _featureCard(
                icon: Icons.handshake_outlined,
                title: 'Direct Connection',
                description:
                    'Reduce unnecessary intermediaries and encourage transparent agricultural trade.',
              ),

              const SizedBox(height: 18),

              // ======================================================
              // VERSION
              // ======================================================

              Center(
                child: Column(
                  children: const [
                    Text(
                      'FarmDirect',
                      style: TextStyle(
                        color: Color(0xFF075B47),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Color(0xFF8A949C),
                        fontSize: 8,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'Made for farmers and buyers',
                      style: TextStyle(
                        color: Color(0xFF8A949C),
                        fontSize: 7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF075B47),
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  // ============================================================
  // CONTENT CARD
  // ============================================================

  Widget _contentCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE2E6E8),
        ),
      ),
      child: child,
    );
  }

  // ============================================================
  // ICON BOX
  // ============================================================

  Widget _iconBox(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7F2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF075B47),
        size: 18,
      ),
    );
  }

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE2E6E8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconBox(icon),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 8,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}