// ============================================================
// FARMER HOME SCREEN
// ============================================================

import 'package:farmdirect/core/provider/farmer_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onAddProduct;
  final VoidCallback? onManageProducts;
  final VoidCallback? onViewOrders;
  final VoidCallback? onViewEarnings;
  final VoidCallback? onProfile;

  const HomeScreen({
    super.key,
    required this.onAddProduct,
    this.onManageProducts,
    this.onViewOrders,
    this.onViewEarnings,
    this.onProfile,
  });

  static const green = Color(0xFF087C59);
  static const darkGreen = Color(0xFF075B46);
  static const lightGreen = Color(0xFFEAF8F0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _header(),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7, 8, 7, 15),
                child: Column(
                  children: [
                    _promoBanner(),

                    const SizedBox(height: 7),

                    _statistics(),

                    const SizedBox(height: 9),

                    _quickActions(),

                    const SizedBox(height: 9),

                    _recentOrders(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header() {
    return Consumer<ProfileProvider>(
      builder: (context, profile, _) {
        final name = profile.name.trim().isEmpty
            ? 'Farmer'
            : profile.name.trim();

        final letter = name[0].toUpperCase();

        return Container(
          height: 76,

          padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/farmer_header_background.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(17),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Namaste,',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      '$name 🌾',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFB5D85A),
                          size: 8,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Farm ID: #${profile.farmId}',
                          style: const TextStyle(
                            color: Color(0xFFB5D85A),
                            fontSize: 7,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Notification
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.12),
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 6,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile======================================
              GestureDetector(
                onTap: onProfile,
                child: Container(
                  width: 38,
                  height: 38,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFB7D95D),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: profile.fullProfileImageUrl.isNotEmpty
                        ? Image.network(
                            profile.fullProfileImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return _letter(letter);
                            },
                          )
                        : _letter(letter),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _letter(String letter) {
    return Container(
      color: const Color(0xFFE7F5E9),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: const TextStyle(
          color: darkGreen,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // PROMO BANNER
  // ============================================================

  Widget _promoBanner() {
    return Container(
      height: 69,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/promo_banner.png'),
          fit: BoxFit.cover,
        ),
        color: const Color(0xFFF0FAF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDCEDE3)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 10,
            top: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grow More',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Sell Directly',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Text(
                  'Earn Better',
                  style: TextStyle(
                    color: green,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Connect with buyers across India',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 5.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================
  Widget _statistics() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      childAspectRatio: 1.65,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _stat(
          icon: Icons.inventory_2_outlined,
          title: 'Total Products',
          value: '24',
          bottom: '+4 this month',
          color: const Color(0xFF087C59),
          bg: const Color(0xFFE5F7EC),

          backgroundImage: 'assets/images/total_products_bg.png',

          imageAsset: 'assets/images/vegetable_crate.png',
        ),

        _stat(
          icon: Icons.shopping_cart_outlined,
          title: 'Active Orders',
          value: '8',
          bottom: '+2 this week',
          color: const Color(0xFFB46A24),
          bg: const Color(0xFFFFEEDD),

          backgroundImage: 'assets/images/active_orders_bg.png',

          imageAsset: 'assets/images/delivery_box.png',
        ),

        _stat(
          icon: Icons.currency_rupee,
          title: 'Month Earnings',
          value: '₹45,200',
          bottom: '+18% last month',
          color: const Color(0xFF079A75),
          bg: const Color(0xFFE3F8EF),

          backgroundImage: 'assets/images/month_earnings_bg.png',

          imageAsset: 'assets/images/earnings_chart.png',
        ),

        _stat(
          icon: Icons.star,
          title: 'Rating',
          value: '4.8',
          bottom: 'From 120+ buyers',
          color: const Color(0xFF6044B4),
          bg: const Color(0xFFECE5FF),

          backgroundImage: 'assets/images/rating_bg.png',

          imageAsset: 'assets/images/buyer_rating.png',
        ),
      ],
    );
  }

  Widget _stat({
    required IconData icon,
    required String title,
    required String value,
    required String bottom,
    required Color color,
    required Color bg,
    required String backgroundImage,
    String? imageAsset,
  }) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E8EA), width: 0.7),
      ),
      child: Stack(
        children: [
          // =====================================================
          // BACKGROUND IMAGE
          // =====================================================
          Positioned.fill(
            child: Image.asset(backgroundImage, fit: BoxFit.cover),
          ),

          // =====================================================
          // CONTENT
          // =====================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 7, 7, 6),
            child: Stack(
              children: [
                // =================================================
                // RIGHT SIDE IMAGE
                // =================================================
                if (imageAsset != null)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    width: 62,
                    height: 50,
                    child: Image.asset(imageAsset, fit: BoxFit.contain),
                  ),

                // =================================================
                // TEXT + ICON
                // =================================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------
                    // TOP ROW
                    // ---------------------------------------------
                    Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: bg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 12, color: color),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFF263238),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.chevron_right,
                          size: 13,
                          color: Color(0xFF607078),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // ---------------------------------------------
                    // VALUE
                    // ---------------------------------------------
                    Text(
                      value,
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 1),

                    // ---------------------------------------------
                    // BOTTOM
                    // ---------------------------------------------
                    Row(
                      children: [
                        Icon(Icons.trending_up, color: color, size: 10),

                        const SizedBox(width: 2),

                        Flexible(
                          child: Text(
                            bottom,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: color,
                              fontSize: 7.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _quickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bolt, size: 14, color: darkGreen),
            const SizedBox(width: 3),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onManageProducts,
              child: const Text(
                'See All ›',
                style: TextStyle(
                  fontSize: 6.5,
                  color: green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            Expanded(
              child: _action(
                icon: Icons.add_circle_outline,
                title: 'Add Product',
                subtitle: 'List new product',
                dark: true,
                onTap: onAddProduct,
              ),
            ),

            const SizedBox(width: 5),
            Expanded(
              child: _action(
                icon: Icons.shopping_bag_outlined,
                title: 'View Orders',
                subtitle: 'Check order status',
                onTap: onViewOrders,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: _action(
                icon: Icons.bar_chart,
                title: 'View Earnings',
                subtitle: 'See detailed report',
                onTap: onViewEarnings,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _action({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    bool dark = false,
  }) {
    return Material(
      color: dark ? darkGreen : Colors.white,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: dark ? darkGreen : const Color(0xFFE4E8E9),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: dark ? const Color(0xFFB7D95A) : green,
              ),
              const SizedBox(height: 3),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dark ? Colors.white : const Color(0xFF384248),
                  fontSize: 6.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: dark ? Colors.white70 : const Color(0xFF90999E),
                  fontSize: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // RECENT ORDERS
  // ============================================================

  Widget _recentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: darkGreen,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onViewOrders,
              child: const Text(
                'See All Orders ›',
                style: TextStyle(
                  fontSize: 6.5,
                  color: green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        _order(
          buyer: 'Suresh Kumar (Bulk Buyer)',
          product: '200 kg • Basmati Rice',
          location: 'Saharanpur, Uttar Pradesh',
          status: 'New',
          statusColor: const Color(0xFFE0F7EA),
          statusText: const Color(0xFF168653),
          icon: Icons.rice_bowl_outlined,
          iconColor: const Color(0xFF8B7045),
          time: 'Today, 10:30 AM',
        ),

        const SizedBox(height: 5),

        _order(
          buyer: 'FreshMart Agra',
          product: '500 kg • Red Potatoes',
          location: 'Agra, Uttar Pradesh',
          status: 'Shipped',
          statusColor: const Color(0xFFE0EDFF),
          statusText: const Color(0xFF3978D0),
          icon: Icons.circle,
          iconColor: const Color(0xFFE57373),
          time: 'Yesterday, 4:15 PM',
        ),

        const SizedBox(height: 5),

        _order(
          buyer: 'Organic Hub Delhi',
          product: '50 kg • Fresh Tomatoes',
          location: 'New Delhi, Delhi',
          status: 'Pending',
          statusColor: const Color(0xFFFFEEC8),
          statusText: const Color(0xFFE09A00),
          icon: Icons.circle,
          iconColor: const Color(0xFFE05252),
          time: 'Yesterday, 2:30 PM',
        ),
      ],
    );
  }

  Widget _order({
    required String buyer,
    required String product,
    required String location,
    required String status,
    required Color statusColor,
    required Color statusText,
    required IconData icon,
    required Color iconColor,
    required String time,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onViewOrders,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 54,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE4E8EA)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buyer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF30383D),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      product,
                      style: const TextStyle(
                        fontSize: 6,
                        color: Color(0xFF737D82),
                      ),
                    ),

                    const SizedBox(height: 1),

                    Text(
                      location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 5,
                        color: Color(0xFF9AA1A5),
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 5.5,
                        color: statusText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 4.8,
                      color: Color(0xFF9AA1A5),
                    ),
                  ),
                ],
              ),

              const Icon(
                Icons.chevron_right,
                size: 13,
                color: Color(0xFF9BA3A7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
