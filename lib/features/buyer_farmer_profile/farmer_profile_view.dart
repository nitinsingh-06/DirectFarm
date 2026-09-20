import 'package:flutter/material.dart';

class FarmerProfileScreenview extends StatefulWidget {
  const FarmerProfileScreenview({super.key});

  @override
  State<FarmerProfileScreenview> createState() => _FarmerProfileScreenviewState();
}

class _FarmerProfileScreenviewState extends State<FarmerProfileScreenview> {
  static const Color primaryGreen = Color(0xFF087F5B);
  static const Color lightGreen = Color(0xFFEAF7EF);
  static const Color textColor = Color(0xFF17212B);

  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // HEADER IMAGE
                    _buildHeader(),

                    // PROFILE CONTENT
                    Transform.translate(
                      offset: const Offset(0, -28),
                      child: _buildProfileContent(),
                    ),
                  ],
                ),
              ),
            ),

            // BOTTOM BUTTONS
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return SizedBox(
      height: 185,
      child: Stack(
        children: [
          // Farm image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1501004318641-b39e6451bec6'
              '?auto=format&fit=crop&w=900&q=80',
              fit: BoxFit.cover,
            ),
          ),

          // Slight dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.transparent,
                    Colors.black.withOpacity(0.08),
                  ],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            left: 14,
            top: 12,
            child: _circleButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.pop(context),
            ),
          ),

          // Title
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Farmer Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // More button
          Positioned(
            right: 14,
            top: 12,
            child: _circleButton(
              icon: Icons.more_vert,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            size: 17,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // PROFILE CONTENT
  // ----------------------------------------------------------

  Widget _buildProfileContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PROFILE IMAGE + VERIFIED
          _buildProfileHeader(),

          const SizedBox(height: 8),

          // NAME
          Row(
            children: [
              const Text(
                'Ramesh Singh',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.eco,
                size: 18,
                color: primaryGreen,
              ),
            ],
          ),

          const SizedBox(height: 2),

          const Text(
            'Green Fields Farm',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),

          const SizedBox(height: 2),

          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 12,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 2),
              Text(
                'Tehri Garhwal, Uttarakhand',
                style: TextStyle(
                  fontSize: 9.5,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // RATING + ORDERS
          _buildStats(),

          const SizedBox(height: 8),

          // DESCRIPTION
          _buildQuote(),

          const SizedBox(height: 9),

          // TABS
          _buildTabs(),

          const SizedBox(height: 10),

          // TAB CONTENT
          if (selectedTab == 0)
            _buildAboutTab()
          else if (selectedTab == 1)
            _buildProductsTab()
          else
            _buildReviewsTab(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return SizedBox(
      height: 55,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Profile picture
          Positioned(
            left: 2,
            top: -30,
            child: Container(
              width: 68,
              height: 68,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://images.unsplash.com/photo-1560250097-0b93528c311a'
                  '?auto=format&fit=crop&w=300&q=80',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Verified badge
          Positioned(
            right: 0,
            top: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    size: 13,
                    color: primaryGreen,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Verified Farmer',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // STATS
  // ----------------------------------------------------------

  Widget _buildStats() {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 16,
        ),
        const SizedBox(width: 3),
        const Text(
          '4.8',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          ' (120 reviews)',
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade600,
          ),
        ),

        Container(
          height: 17,
          width: 1,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.grey.shade300,
        ),

        Icon(
          Icons.people,
          size: 14,
          color: Colors.grey.shade700,
        ),
        const SizedBox(width: 4),

        Text(
          '250+ orders',
          style: TextStyle(
            fontSize: 9.5,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // QUOTE
  // ----------------------------------------------------------

  Widget _buildQuote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.eco,
            size: 17,
            color: primaryGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '"Growing fresh and natural produce for a healthier '
              'tomorrow. From our farm to your home."',
              style: TextStyle(
                fontSize: 8.5,
                height: 1.35,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TABS
  // ----------------------------------------------------------

  Widget _buildTabs() {
    final tabs = ['About', 'Products', 'Reviews'];

    return Row(
      children: List.generate(
        tabs.length,
        (index) {
          final selected = selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 7),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected
                          ? primaryGreen
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? primaryGreen
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // ABOUT TAB
  // ----------------------------------------------------------

  Widget _buildAboutTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _infoCard(
                Icons.agriculture,
                'Farm Type',
                'Organic Farming',
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _infoCard(
                Icons.spa,
                'Farm Size',
                '5 Acres',
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        Row(
          children: [
            Expanded(
              child: _infoCard(
                Icons.eco,
                'Crops Grown',
                'Vegetables, Fruits, Grains',
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: _infoCard(
                Icons.calendar_month,
                'Member Since',
                'Jan 2025',
              ),
            ),
          ],
        ),

        const SizedBox(height: 11),

        const Text(
          'About Farm',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          'We grow fresh, chemical-free vegetables and fruits using '
          'sustainable farming practices. Our mission is to provide '
          'healthy food directly from our farm to your home.',
          style: TextStyle(
            fontSize: 8.5,
            height: 1.4,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 3),

        Center(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Read More ⌄',
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                color: primaryGreen,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              size: 14,
              color: primaryGreen,
            ),
          ),

          const SizedBox(width: 7),

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
                    fontSize: 7,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PRODUCTS TAB
  // ----------------------------------------------------------

  Widget _buildProductsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Farm Products',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: lightGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'View fresh vegetables, fruits and grains available '
            'from this farmer.',
            style: TextStyle(
              fontSize: 9,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // REVIEWS TAB
  // ----------------------------------------------------------

  Widget _buildReviewsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),

        _reviewCard(
          'Great quality vegetables.',
          'Buyer',
        ),

        const SizedBox(height: 6),

        _reviewCard(
          'Very fresh and delivered on time.',
          'Buyer',
        ),
      ],
    );
  }

  Widget _reviewCard(
    String review,
    String name,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 13,
              ),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 13,
              ),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 13,
              ),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 13,
              ),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 13,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review,
            style: const TextStyle(
              fontSize: 8.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            name,
            style: TextStyle(
              fontSize: 7.5,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // BOTTOM BUTTONS
  // ----------------------------------------------------------

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          // CHAT
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Open chat
              },
              icon: const Icon(
                Icons.chat_bubble_outline,
                size: 16,
              ),
              label: const Text(
                'Chat',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryGreen,
                side: const BorderSide(
                  color: primaryGreen,
                ),
                minimumSize: const Size(
                  0,
                  38,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(width: 7),

          // VIEW PRODUCTS
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Open farmer products
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 16,
              ),
              label: const Text(
                'View Products',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(
                  0,
                  38,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}