// ============================================================
// FARMER HOME SCREEN
// ============================================================

import 'dart:convert';

import 'package:farmdirect/config/api_config.dart';
import 'package:farmdirect/core/provider/farmer_profile_provider.dart';
import 'package:farmdirect/features/farmer/dashboard/FARMER%20ORDER/farmer_order_management_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onAddProduct;
  final VoidCallback? onManageProducts;
  final VoidCallback? onViewOrders;
  final VoidCallback? onViewEarnings;
  final VoidCallback? onViewRatings;
  final VoidCallback? onProfile;

  /// Used by Recent Orders to open one exact order.
  final void Function(FarmerOrder order)? onViewOrder;

  const HomeScreen({
    super.key,
    required this.onAddProduct,
    this.onManageProducts,
    this.onViewOrders,
    this.onViewEarnings,
    this.onViewRatings,
    this.onProfile,
    this.onViewOrder,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const green = Color(0xFF087C59);
  static const darkGreen = Color(0xFF075B46);
  static const lightGreen = Color(0xFFEAF8F0);

  // ============================================================
  // RECENT ORDERS
  // ============================================================

  List<FarmerOrder> _recentOrdersList = [];

  bool _recentOrdersLoading = true;

  String? _recentOrdersError;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadRecentOrders();
  }

  // ============================================================
  // LOAD REAL FARMER ORDERS
  // ============================================================

  Future<void> _loadRecentOrders() async {
    try {
      if (!mounted) return;

      setState(() {
        _recentOrdersLoading = true;
        _recentOrdersError = null;
      });

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Farmer is not logged in.');
      }

      final idToken = await user.getIdToken(true);

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Unable to get Firebase ID token.');
      }

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/orders/farmer/my-orders',
      ).replace(queryParameters: {'id_token': idToken});

      debugPrint('========================================');
      debugPrint('FARMER DASHBOARD RECENT ORDERS');
      debugPrint('URL: $uri');

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('RESPONSE: ${response.body}');
      debugPrint('========================================');

      if (response.statusCode != 200) {
        String message = 'Failed to load recent orders.';

        try {
          final body = jsonDecode(response.body);

          if (body is Map && body['detail'] != null) {
            message = body['detail'].toString();
          }
        } catch (_) {}

        throw Exception(message);
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map || decoded['orders'] is! List) {
        throw Exception('Invalid farmer orders response.');
      }

      final loadedOrders = (decoded['orders'] as List)
          .whereType<Map>()
          .map((item) => FarmerOrder.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      if (!mounted) return;

      setState(() {
        _recentOrdersList = loadedOrders.take(3).toList();
        _recentOrdersLoading = false;
        _recentOrdersError = null;
      });
    } catch (e) {
      debugPrint('FARMER DASHBOARD ORDER ERROR: $e');

      if (!mounted) return;

      setState(() {
        _recentOrdersLoading = false;
        _recentOrdersError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _header(),

          Expanded(
            child: RefreshIndicator(
              color: green,
              onRefresh: _loadRecentOrders,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(7, 8, 7, 15),
                  child: Column(
                    children: [
                      _promoBanner(),

                      const SizedBox(height: 7),

                      _statistics(context),

                      const SizedBox(height: 9),

                      // _quickActions(),
                      const SizedBox(height: 9),

                      _recentOrders(),
                    ],
                  ),
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

        debugPrint('🔥 DASHBOARD PROFILE NAME = "${profile.name}"');

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

              // ==================================================
              // NOTIFICATION
              // ==================================================
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

              // ==================================================
              // PROFILE
              // ==================================================
              GestureDetector(
                onTap: widget.onProfile,
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
        image: const DecorationImage(
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

  Widget _statistics(BuildContext context) {
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
          onTap: widget.onManageProducts,
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
          onTap: () async {
            if (widget.onViewOrders != null) {
              widget.onViewOrders!();
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FarmerOrderManagementScreen(),
                ),
              );
              if (mounted) {
                _loadRecentOrders();
              }
            }
          },
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
          onTap: widget.onViewEarnings,
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
          onTap: widget.onViewRatings,
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
    VoidCallback? onTap,
    String? imageAsset,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
                      child: IgnorePointer(
                        child: Image.asset(imageAsset, fit: BoxFit.contain),
                      ),
                    ),

                  // =================================================
                  // TEXT + ICON
                  // =================================================
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      Text(
                        value,
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 1),

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
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  // Widget _quickActions() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           const Icon(
  //             Icons.bolt,
  //             size: 14,
  //             color: darkGreen,
  //           ),
  //           const SizedBox(width: 3),
  //           const Text(
  //             'Quick Actions',
  //             style: TextStyle(
  //               fontSize: 11,
  //               fontWeight: FontWeight.w800,
  //             ),
  //           ),
  //           const Spacer(),
  //           GestureDetector(
  //             onTap: widget.onManageProducts,
  //             child: const Text(
  //               'See All ›',
  //               style: TextStyle(
  //                 fontSize: 6.5,
  //                 color: green,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //
  //       const SizedBox(height: 5),
  //
  //       Row(
  //         children: [
  //           Expanded(
  //             child: _action(
  //               icon: Icons.add_circle_outline,
  //               title: 'Add Product',
  //               subtitle: 'List new product',
  //               dark: true,
  //               onTap: widget.onAddProduct,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget _action({
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   required VoidCallback? onTap,
  //   bool dark = false,
  // }) {
  //   return Material(
  //     color: dark ? darkGreen : Colors.white,
  //     borderRadius: BorderRadius.circular(7),
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: BorderRadius.circular(7),
  //       child: Container(
  //         height: 58,
  //         padding: const EdgeInsets.symmetric(
  //           horizontal: 3,
  //           vertical: 5,
  //         ),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(7),
  //           border: Border.all(
  //             color: dark
  //                 ? darkGreen
  //                 : const Color(0xFFE4E8E9),
  //           ),
  //         ),
  //         child: Column(
  //           mainAxisAlignment:
  //               MainAxisAlignment.center,
  //           children: [
  //             Icon(
  //               icon,
  //               size: 16,
  //               color: dark
  //                   ? const Color(0xFFB7D95A)
  //                   : green,
  //             ),
  //
  //             const SizedBox(height: 3),
  //
  //             Text(
  //               title,
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: dark
  //                     ? Colors.white
  //                     : const Color(0xFF384248),
  //                 fontSize: 6.5,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //
  //             const SizedBox(height: 1),
  //
  //             Text(
  //               subtitle,
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: dark
  //                     ? Colors.white70
  //                     : const Color(0xFF90999E),
  //                 fontSize: 5,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              onTap: widget.onViewOrders,
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

        // ========================================================
        // LOADING
        // ========================================================
        if (_recentOrdersLoading)
          _recentOrdersLoadingWidget()
        // ========================================================
        // ERROR
        // ========================================================
        else if (_recentOrdersError != null)
          _recentOrdersErrorWidget()
        // ========================================================
        // EMPTY
        // ========================================================
        else if (_recentOrdersList.isEmpty)
          _noRecentOrdersWidget()
        // ========================================================
        // REAL ORDERS
        // ========================================================
        else
          ..._recentOrdersList.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: _order(
                order: order,
                buyer: order.buyerName,
                imageUrl: order.imageUrl,

                product: '${order.quantity} • ${order.productName}',

                location: order.address,

                status: order.status,

                statusColor: _statusBackground(order.status),

                statusText: _statusForeground(order.status),

                icon: _productIcon(order.productName),

                iconColor: _productIconColor(order.productName),

                time: '${order.date}, ${order.time}',
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // RECENT ORDERS LOADING
  // ============================================================

  Widget _recentOrdersLoadingWidget() {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E8EA)),
      ),
      child: const Center(
        child: SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(strokeWidth: 2, color: green),
        ),
      ),
    );
  }

  // ============================================================
  // NO ORDERS
  // ============================================================

  Widget _noRecentOrdersWidget() {
    return Container(
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E8EA)),
      ),
      child: const Center(
        child: Text(
          'No recent orders',
          style: TextStyle(
            fontSize: 7,
            color: Color(0xFF9AA1A5),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ORDER ERROR
  // ============================================================

  Widget _recentOrdersErrorWidget() {
    return Container(
      height: 54,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E8EA)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 15,
            color: Colors.redAccent,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(
              _recentOrdersError ?? 'Unable to load orders',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 6.5, color: Color(0xFF737D82)),
            ),
          ),

          GestureDetector(
            onTap: _loadRecentOrders,
            child: const Icon(Icons.refresh_rounded, size: 15, color: green),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BACKGROUND
  // ============================================================

  Color _statusBackground(String status) {
    switch (status) {
      case 'Confirmed':
        return const Color(0xFFDDF7E9);

      case 'Shipped':
        return const Color(0xFFE0EDFF);

      case 'Delivered':
        return const Color(0xFFE0F7EA);

      case 'Rejected':
      case 'Cancelled':
        return const Color(0xFFFFE1E1);

      case 'Pending':
      default:
        return const Color(0xFFFFEEC8);
    }
  }

  // ============================================================
  // STATUS TEXT
  // ============================================================

  Color _statusForeground(String status) {
    switch (status) {
      case 'Confirmed':
        return const Color(0xFF08745E);

      case 'Shipped':
        return const Color(0xFF3978D0);

      case 'Delivered':
        return const Color(0xFF168653);

      case 'Rejected':
      case 'Cancelled':
        return const Color(0xFFD93C3C);

      case 'Pending':
      default:
        return const Color(0xFFE09A00);
    }
  }

  // ============================================================
  // PRODUCT ICON
  // ============================================================

  IconData _productIcon(String productName) {
    final name = productName.toLowerCase();

    if (name.contains('rice')) {
      return Icons.rice_bowl_outlined;
    }

    if (name.contains('potato')) {
      return Icons.circle;
    }

    if (name.contains('tomato')) {
      return Icons.circle;
    }

    if (name.contains('wheat')) {
      return Icons.grass_rounded;
    }

    if (name.contains('ghee')) {
      return Icons.local_drink_outlined;
    }

    return Icons.agriculture_outlined;
  }

  // ============================================================
  // PRODUCT ICON COLOR
  // ============================================================

  Color _productIconColor(String productName) {
    final name = productName.toLowerCase();

    if (name.contains('rice')) {
      return const Color(0xFF8B7045);
    }

    if (name.contains('potato')) {
      return const Color(0xFFE57373);
    }

    if (name.contains('tomato')) {
      return const Color(0xFFE05252);
    }

    if (name.contains('wheat')) {
      return const Color(0xFFC49A50);
    }

    if (name.contains('ghee')) {
      return const Color(0xFFE1A72F);
    }

    return const Color(0xFF7A8B55);
  }

  // ============================================================
  // ORDER CARD
  // ============================================================
Widget _order({
  required FarmerOrder order,
  required String buyer,
  required String product,
  required String location,
  required String status,
  required Color statusColor,
  required Color statusText,
  required IconData icon,
  required Color iconColor,
  required String time,
  required String? imageUrl,
}) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: () {
        if (widget.onViewOrder != null) {
          widget.onViewOrder!(order);
        } else {
          widget.onViewOrders?.call();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE4E8EA),
          ),
        ),
        child: Row(
          children: [
            // PRODUCT IMAGE
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F1),
                borderRadius: BorderRadius.circular(6),
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildOrderImage(
                imageUrl: imageUrl,
                icon: icon,
                iconColor: iconColor,
              ),
            ),

            const SizedBox(width: 7),

            // ORDER INFORMATION
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

            // STATUS + TIME
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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


Widget _buildOrderImage({
  required String? imageUrl,
  required IconData icon,
  required Color iconColor,
}) {
  if (imageUrl == null || imageUrl.trim().isEmpty) {
    return Icon(
      icon,
      color: iconColor,
      size: 22,
    );
  }

  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      debugPrint(
        'DASHBOARD RECENT ORDER IMAGE ERROR: $imageUrl',
      );

      return Icon(
        icon,
        color: iconColor,
        size: 22,
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }

      return Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: darkGreen,
          ),
        ),
      );
    },
  );
}
}
