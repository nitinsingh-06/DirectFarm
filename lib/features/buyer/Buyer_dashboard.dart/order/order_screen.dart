import 'package:farmdirect/core/provider/buyer_profile_provider.dart';
import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/marketplace/add_to_cart.dart';
import 'package:farmdirect/services/api_services.dart';
import 'package:flutter/material.dart';

import 'package:farmdirect/config/api_config.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // ============================================================
  // SELECTED TAB
  // ============================================================

  int selectedTab = 0;

  // ============================================================
  // LOADING STATE
  // ============================================================

  bool isLoading = true;
  String? errorMessage;

  // ============================================================
  // ORDERS
  // ============================================================

  List<Map<String, dynamic>> orders = [];

  // ============================================================
  // ORDER TABS
  // ============================================================

  final List<String> tabs = [
    "All Orders",
    "Processing",
    "Shipped",
    "Delivered",
    "Cancelled",
  ];

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // ============================================================
  // LOAD ORDERS FROM FASTAPI
  // ============================================================

  Future<void> _loadOrders() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          errorMessage = null;
        });
      }

      final result = await ApiService.getMyOrders();

      final List<Map<String, dynamic>> convertedOrders = [];

      for (final item in result) {
        if (item is Map<String, dynamic>) {
          convertedOrders.add(_convertOrder(item));
        }
      }

      if (!mounted) return;

      setState(() {
        orders = convertedOrders;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("LOAD ORDERS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // CONVERT BACKEND ORDER TO EXISTING UI FORMAT
  // ============================================================

  Map<String, dynamic> _convertOrder(Map<String, dynamic> order) {
    final List<dynamic> items = order["items"] is List ? order["items"] : [];

    final Map<String, dynamic> firstItem =
        items.isNotEmpty && items.first is Map<String, dynamic>
        ? items.first as Map<String, dynamic>
        : {};

    final String status = _formatStatus(order["status"]?.toString());

    final List<String> images = [];

    final List<String> quantities = [];

    for (final item in items) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      // --------------------------------------------------------
      // IMAGE
      // --------------------------------------------------------

      final String imageUrl = item["image_url"]?.toString() ?? "";

      if (imageUrl.isEmpty) {
        images.add("");
      } else if (imageUrl.startsWith("http")) {
        images.add(imageUrl);
      } else {
        images.add("${ApiConfig.baseUrl}$imageUrl");
      }

      // --------------------------------------------------------
      // QUANTITY
      // --------------------------------------------------------

      quantities.add("${item["quantity"] ?? 1}");
    }

    // ----------------------------------------------------------
    // FARM
    // ----------------------------------------------------------

    String farm = firstItem["farm"]?.toString() ?? "";

    if (farm.isEmpty) {
      farm = "FarmDirect Farmer";
    }

    // ----------------------------------------------------------
    // LOCATION
    // ----------------------------------------------------------

    String location = firstItem["location"]?.toString() ?? "";

    if (location.isEmpty) {
      location = "India";
    }

    // ----------------------------------------------------------
    // TOTAL
    // ----------------------------------------------------------

    final double total = _toDouble(order["total_amount"]);

    return {
      "id": "#${order["order_number"] ?? order["order_id"] ?? ""}",

      "date": _formatOrderDate(order["created_at"]),

      "status": status,

      "farmer": farm,

      "location": location,

      "items": "${items.length} ${items.length == 1 ? "item" : "items"}",

      "total": "₹${_formatAmount(total)}",

      "action": _getAction(status),

      "images": images,

      "quantities": quantities,

      // Keep original backend response.
      "orderData": order,
    };
  }

  // ============================================================
  // STATUS CONVERSION
  // ============================================================

  String _formatStatus(String? status) {
    switch (status?.toLowerCase()) {
      case "processing":
      case "confirmed":
      case "pending":
        return "Processing";

      case "shipped":
        return "Shipped";

      case "delivered":
        return "Delivered";

      case "cancelled":
      case "canceled":
        return "Cancelled";

      default:
        return "Processing";
    }
  }

  // ============================================================
  // ACTION BASED ON STATUS
  // ============================================================

  String _getAction(String status) {
    switch (status) {
      case "Processing":
        return "Cancel Order";

      case "Shipped":
        return "Track Order";

      case "Delivered":
      case "Cancelled":
        return "Buy Again";

      default:
        return "View Details";
    }
  }

  // ============================================================
  // DOUBLE CONVERSION
  // ============================================================

  double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString()) ?? 0;
  }

  // ============================================================
  // AMOUNT FORMAT
  // ============================================================

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0);
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatOrderDate(dynamic date) {
    if (date == null) {
      return "";
    }

    final DateTime? parsed = DateTime.tryParse(date.toString());

    if (parsed == null) {
      return date.toString();
    }

    const List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final int hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;

    final String minute = parsed.minute.toString().padLeft(2, "0");

    final String period = parsed.hour >= 12 ? "PM" : "AM";

    return "${parsed.day} "
        "${months[parsed.month - 1]} "
        "${parsed.year}, "
        "$hour:$minute $period";
  }

  // ============================================================
  // FILTERED ORDERS
  // ============================================================

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedTab == 0) {
      return orders;
    }

    final String selectedStatus = tabs[selectedTab];

    return orders.where((order) {
      return order["status"] == selectedStatus;
    }).toList();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF8),

      body: SafeArea(
        child: Column(
          children: [
            // ----------------------------------------------------
            // HEADER
            // ----------------------------------------------------
            _buildHeader(),

            // ----------------------------------------------------
            // TABS
            // ----------------------------------------------------
            _buildTabs(),

            // ----------------------------------------------------
            // CONTENT
            // ----------------------------------------------------
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent() {
    // ----------------------------------------------------------
    // LOADING
    // ----------------------------------------------------------

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF087C59)),
      );
    }

    // ----------------------------------------------------------
    // ERROR
    // ----------------------------------------------------------

    if (errorMessage != null) {
      return _buildErrorState();
    }

    // ----------------------------------------------------------
    // EMPTY
    // ----------------------------------------------------------

    if (filteredOrders.isEmpty) {
      return _buildEmptyState();
    }

    // ----------------------------------------------------------
    // ORDERS
    // ----------------------------------------------------------

    return RefreshIndicator(
      color: const Color(0xFF087C59),

      onRefresh: _loadOrders,

      child: Scrollbar(
        thumbVisibility: true,
        radius: const Radius.circular(10),

        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),

          padding: const EdgeInsets.fromLTRB(10, 8, 10, 20),

          itemCount: filteredOrders.length,

          itemBuilder: (context, index) {
            return _buildOrderCard(filteredOrders[index]);
          },
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 65,
              height: 65,

              decoration: const BoxDecoration(
                color: Color(0xFFFFE9EB),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.error_outline_rounded,
                size: 30,
                color: Color(0xFFD93643),
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              "Unable to Load Orders",

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF263238),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              errorMessage ?? "",
              textAlign: TextAlign.center,

              maxLines: 4,

              overflow: TextOverflow.ellipsis,

              style: const TextStyle(fontSize: 8, color: Color(0xFF7B8782)),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 38,

              child: ElevatedButton(
                onPressed: _loadOrders,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087C59),

                  foregroundColor: Colors.white,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                child: const Text(
                  "Retry",

                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      height: 67,

      padding: const EdgeInsets.fromLTRB(11, 7, 10, 5),

      color: const Color(0xFFF7FAF8),

      child: Row(
        children: [
          // ----------------------------------------------------
          // TITLE
          // ----------------------------------------------------
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "My Orders",

                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF17252C),
                  ),
                ),

                SizedBox(height: 1),

                Text(
                  "Track and manage your orders",

                  style: TextStyle(fontSize: 8, color: Color(0xFF718079)),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------
          // SEARCH
          // ----------------------------------------------------
          _headerButton(icon: Icons.search_rounded, onTap: _showSearchMessage),

          const SizedBox(width: 7),

          // ----------------------------------------------------
          // CART
          // ----------------------------------------------------
          // ----------------------------------------------------
          // CART
          // ----------------------------------------------------
         Consumer<BuyerProfileProvider>(
                  builder: (context, profile, child) {
                    final name = profile.name.trim();

                    final firstLetter = name.isNotEmpty
                        ? name[0].toUpperCase()
                        : "U";

                    final imageUrl = profile.fullProfileImageUrl;

                    return Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF80D000),
                          width: 1.8,
                        ),
                      ),
                      child: ClipOval(
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _profileFallback(firstLetter);
                                },
                              )
                            : _profileFallback(firstLetter),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER BUTTON
  // ============================================================

  Widget _headerButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 35,
        height: 35,

        decoration: const BoxDecoration(
          color: Color(0xFFEFF5F2),
          shape: BoxShape.circle,
        ),

        child: Icon(icon, size: 18, color: const Color(0xFF263238)),
      ),
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs() {
    return Container(
      height: 39,

      margin: const EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        color: const Color(0xFFEAF1ED),

        borderRadius: BorderRadius.circular(9),
      ),

      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        physics: const BouncingScrollPhysics(),

        itemCount: tabs.length,

        itemBuilder: (context, index) {
          final bool selected = selectedTab == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = index;
              });
            },

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              margin: const EdgeInsets.all(3),

              padding: const EdgeInsets.symmetric(horizontal: 14),

              decoration: BoxDecoration(
                color: selected ? const Color(0xFF087C59) : Colors.transparent,

                borderRadius: BorderRadius.circular(7),
              ),

              alignment: Alignment.center,

              child: Text(
                tabs[index],

                style: TextStyle(
                  fontSize: 8,

                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,

                  color: selected ? Colors.white : const Color(0xFF61716A),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),

      padding: const EdgeInsets.fromLTRB(9, 8, 9, 7),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFE4EAE7), width: 0.7),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),

            blurRadius: 5,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        children: [
          // ====================================================
          // ORDER HEADER
          // ====================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Order ${order["id"]}",

                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17252C),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      order["date"] ?? "",

                      style: const TextStyle(
                        fontSize: 7,
                        color: Color(0xFF718079),
                      ),
                    ),
                  ],
                ),
              ),

              _buildStatusBadge(order["status"] ?? "Processing"),

              const SizedBox(width: 4),

              const Icon(
                Icons.chevron_right_rounded,

                size: 17,

                color: Color(0xFF7C8984),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // ====================================================
          // PRODUCTS + TOTAL
          // ====================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(flex: 6, child: _buildProductImages(order)),

              const SizedBox(width: 7),

              Container(width: 1, height: 43, color: const Color(0xFFE1E6E3)),

              const SizedBox(width: 8),

              Expanded(
                flex: 3,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 4),

                    Text(
                      order["items"] ?? "0 items",

                      style: const TextStyle(
                        fontSize: 7.5,
                        color: Color(0xFF718079),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      order["total"] ?? "₹0",

                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF087C59),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // ====================================================
          // FARMER + ACTIONS
          // ====================================================
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,

                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF3EE),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person_rounded,

                        size: 16,

                        color: Color(0xFF087C59),
                      ),
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            order["farmer"] ?? "Farmer",

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF263238),
                            ),
                          ),

                          const SizedBox(height: 1),

                          Text(
                            order["location"] ?? "India",

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 6.5,
                              color: Color(0xFF7B8782),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 5),

              _buildActionButton(
                text: order["action"] ?? "View Details",

                filled: false,

                onTap: () {
                  _handleOrderAction(order, order["action"] ?? "View Details");
                },
              ),

              const SizedBox(width: 5),

              _buildActionButton(
                text: "View Details",

                filled: true,

                onTap: () {
                  _showOrderDetails(order);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT IMAGES
  // ============================================================

  Widget _buildProductImages(Map<String, dynamic> order) {
    final List<dynamic> images = order["images"] is List ? order["images"] : [];

    final List<dynamic> quantities = order["quantities"] is List
        ? order["quantities"]
        : [];

    if (images.isEmpty) {
      return Container(
        height: 43,

        decoration: BoxDecoration(
          color: const Color(0xFFEAF1ED),

          borderRadius: BorderRadius.circular(6),
        ),

        child: const Icon(
          Icons.image_outlined,
          size: 18,
          color: Color(0xFF94A19B),
        ),
      );
    }

    return SizedBox(
      height: 43,

      child: ListView.builder(
        scrollDirection: Axis.horizontal,

        physics: const BouncingScrollPhysics(),

        itemCount: images.length,

        itemBuilder: (context, index) {
          final String imageUrl = images[index].toString();

          final String quantity = index < quantities.length
              ? quantities[index].toString()
              : "1";

          return Padding(
            padding: EdgeInsets.only(right: index == images.length - 1 ? 0 : 5),

            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),

                  child: imageUrl.isEmpty
                      ? Container(
                          width: 43,
                          height: 43,

                          color: const Color(0xFFEAF1ED),

                          child: const Icon(
                            Icons.image_outlined,
                            size: 18,
                            color: Color(0xFF94A19B),
                          ),
                        )
                      : Image.network(
                          imageUrl,

                          width: 43,
                          height: 43,

                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 43,
                              height: 43,

                              color: const Color(0xFFEAF1ED),

                              child: const Icon(
                                Icons.image_outlined,
                                size: 18,
                                color: Color(0xFF94A19B),
                              ),
                            );
                          },
                        ),
                ),

                // ----------------------------------------------
                // QUANTITY
                // ----------------------------------------------
                Positioned(
                  right: 2,
                  bottom: 2,

                  child: Container(
                    width: 15,
                    height: 15,

                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),

                    child: Center(
                      child: Text(
                        quantity,

                        style: const TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF263238),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _buildStatusBadge(String status) {
    Color background;
    Color textColor;
    IconData icon;

    switch (status) {
      case "Delivered":
        background = const Color(0xFFE5F5EB);

        textColor = const Color(0xFF087C59);

        icon = Icons.local_shipping_rounded;

        break;

      case "Processing":
        background = const Color(0xFFE8F1FF);

        textColor = const Color(0xFF2875D8);

        icon = Icons.inventory_2_rounded;

        break;

      case "Shipped":
        background = const Color(0xFFFFF1D5);

        textColor = const Color(0xFFAD7100);

        icon = Icons.local_shipping_rounded;

        break;

      case "Cancelled":
        background = const Color(0xFFFFE9EB);

        textColor = const Color(0xFFD62F3D);

        icon = Icons.cancel_rounded;

        break;

      default:
        background = const Color(0xFFEAF1ED);

        textColor = const Color(0xFF087C59);

        icon = Icons.info_outline;

        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),

      decoration: BoxDecoration(
        color: background,

        borderRadius: BorderRadius.circular(7),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, size: 11, color: textColor),

          const SizedBox(width: 3),

          Text(
            status,

            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  Widget _buildActionButton({
    required String text,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 27,

        padding: const EdgeInsets.symmetric(horizontal: 9),

        decoration: BoxDecoration(
          color: filled ? const Color(0xFF087C59) : Colors.white,

          borderRadius: BorderRadius.circular(7),

          border: Border.all(color: const Color(0xFF087C59), width: 0.8),
        ),

        alignment: Alignment.center,

        child: Text(
          text,

          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w700,

            color: filled ? Colors.white : const Color(0xFF263238),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HANDLE ORDER ACTION
  // ============================================================

  void _handleOrderAction(Map<String, dynamic> order, String action) {
    switch (action) {
      case "Track Order":
        _showTrackOrder(order);
        break;

      case "Cancel Order":
        _showCancelConfirmation(order);
        break;

      case "Buy Again":
        _buyAgain(order);
        break;

      case "View Details":
        _showOrderDetails(order);
        break;
    }
  }

  // ============================================================
  // ORDER DETAILS
  // ============================================================
  void _showOrderDetails(Map<String, dynamic> order) {
    final dynamic rawOrderData = order["orderData"];

    final Map<String, dynamic> orderData = rawOrderData is Map<String, dynamic>
        ? rawOrderData
        : {};

    final List<dynamic> items = orderData["items"] is List
        ? orderData["items"]
        : [];

    final double subtotal = _toDouble(orderData["subtotal"]);

    final double deliveryFee = _toDouble(orderData["delivery_fee"]);

    final double discount = _toDouble(orderData["discount"]);

    final double totalAmount = _toDouble(orderData["total_amount"]);

    final String paymentMethod =
        orderData["payment_method"]?.toString() ?? "N/A";

    final String paymentStatus =
        orderData["payment_status"]?.toString() ?? "N/A";

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          minChildSize: 0.55,
          maxChildSize: 0.95,

          expand: false,

          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),

              child: Column(
                children: [
                  // =================================================
                  // HEADER
                  // =================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),

                    child: Column(
                      children: [
                        _buildSheetHandle(),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "Order ${order["id"]}",

                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF17252C),
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    order["date"] ?? "",

                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF718079),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _buildStatusBadge(order["status"] ?? "Processing"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // =================================================
                  // SCROLLABLE CONTENT
                  // =================================================
                  Expanded(
                    child: ListView(
                      controller: scrollController,

                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 25),

                      children: [
                        // ==========================================
                        // FARM INFORMATION
                        // ==========================================
                        _buildDetailsSectionTitle("Farmer Information"),

                        const SizedBox(height: 10),

                        _buildInfoCard(
                          icon: Icons.agriculture_rounded,

                          title: order["farmer"] ?? "Farmer",

                          subtitle: order["location"] ?? "India",
                        ),

                        const SizedBox(height: 20),

                        // ==========================================
                        // PRODUCTS
                        // ==========================================
                        _buildDetailsSectionTitle("Ordered Products"),

                        const SizedBox(height: 10),

                        if (items.isEmpty)
                          const Text(
                            "No product information available.",
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF718079),
                            ),
                          )
                        else
                          ...items.map((item) {
                            if (item is! Map<String, dynamic>) {
                              return const SizedBox();
                            }

                            return _buildOrderItem(item);
                          }),

                        const SizedBox(height: 20),

                        // ==========================================
                        // PRICE SUMMARY
                        // ==========================================
                        _buildDetailsSectionTitle("Price Summary"),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAF8),

                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(color: const Color(0xFFE4EAE7)),
                          ),

                          child: Column(
                            children: [
                              _priceRow("Subtotal", subtotal),

                              const SizedBox(height: 9),

                              _priceRow("Delivery Fee", deliveryFee),

                              const SizedBox(height: 9),

                              _priceRow("Discount", discount, isDiscount: true),

                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 11),

                                child: Divider(height: 1),
                              ),

                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Total Amount",

                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF263238),
                                      ),
                                    ),
                                  ),

                                  Text(
                                    "₹${_formatAmount(totalAmount)}",

                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF087C59),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==========================================
                        // PAYMENT
                        // ==========================================
                        _buildDetailsSectionTitle("Payment Information"),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(color: const Color(0xFFE4EAE7)),
                          ),

                          child: Column(
                            children: [
                              _detailRow("Payment Method", paymentMethod),

                              _detailRow("Payment Status", paymentStatus),

                              if (orderData["note"] != null &&
                                  orderData["note"].toString().isNotEmpty)
                                _detailRow(
                                  "Note",
                                  orderData["note"].toString(),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==========================================
                        // ORDER INFORMATION
                        // ==========================================
                        _buildDetailsSectionTitle("Order Information"),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(color: const Color(0xFFE4EAE7)),
                          ),

                          child: Column(
                            children: [
                              _detailRow(
                                "Order ID",
                                orderData["order_number"]?.toString() ??
                                    order["id"].toString(),
                              ),

                              _detailRow(
                                "Order Status",
                                order["status"]?.toString() ?? "Processing",
                              ),

                              _detailRow(
                                "Address ID",
                                orderData["address_id"]?.toString() ?? "N/A",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ==========================================
                        // CLOSE
                        // ==========================================
                        SizedBox(
                          width: double.infinity,

                          height: 45,

                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF087C59),

                              foregroundColor: Colors.white,

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            child: const Text(
                              "Close",

                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  // ============================================================
  // DETAILS SECTION TITLE
  // ============================================================

  Widget _buildDetailsSectionTitle(String title) {
    return Text(
      title,

      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Color(0xFF17252C),
      ),
    );
  }

  // ============================================================
  // ORDER ITEM
  // ============================================================

  Widget _buildOrderItem(Map<String, dynamic> item) {
    final String name = item["product_name"]?.toString() ?? "Product";

    final String unit = item["unit"]?.toString() ?? "";

    final int quantity = int.tryParse(item["quantity"]?.toString() ?? "1") ?? 1;

    final double price = _toDouble(item["price"]);

    final double totalPrice = _toDouble(item["total_price"]);

    String imageUrl = item["image_url"]?.toString() ?? "";

    if (imageUrl.isNotEmpty && !imageUrl.startsWith("http")) {
      imageUrl = "${ApiConfig.baseUrl}$imageUrl";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(11),

        border: Border.all(color: const Color(0xFFE4EAE7)),
      ),

      child: Row(
        children: [
          // ------------------------------------------------------
          // IMAGE
          // ------------------------------------------------------
          ClipRRect(
            borderRadius: BorderRadius.circular(8),

            child: imageUrl.isEmpty
                ? Container(
                    width: 55,
                    height: 55,

                    color: const Color(0xFFEAF1ED),

                    child: const Icon(
                      Icons.image_outlined,
                      color: Color(0xFF94A19B),
                    ),
                  )
                : Image.network(
                    imageUrl,

                    width: 55,
                    height: 55,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 55,
                        height: 55,

                        color: const Color(0xFFEAF1ED),

                        child: const Icon(
                          Icons.image_outlined,
                          color: Color(0xFF94A19B),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(width: 10),

          // ------------------------------------------------------
          // PRODUCT INFORMATION
          // ------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "₹${_formatAmount(price)} / $unit",

                  style: const TextStyle(fontSize: 8, color: Color(0xFF718079)),
                ),

                const SizedBox(height: 3),

                Text(
                  "Quantity: $quantity",

                  style: const TextStyle(fontSize: 8, color: Color(0xFF718079)),
                ),
              ],
            ),
          ),

          // ------------------------------------------------------
          // TOTAL
          // ------------------------------------------------------
          Text(
            "₹${_formatAmount(totalPrice)}",

            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF087C59),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRICE ROW
  // ============================================================

  Widget _priceRow(String title, double amount, {bool isDiscount = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,

            style: const TextStyle(fontSize: 9, color: Color(0xFF718079)),
          ),
        ),

        Text(
          isDiscount && amount > 0
              ? "-₹${_formatAmount(amount)}"
              : "₹${_formatAmount(amount)}",

          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,

            color: isDiscount && amount > 0
                ? const Color(0xFF087C59)
                : const Color(0xFF263238),
          ),
        ),
      ],
    );
  }
  // ============================================================
  // FARMER / INFO CARD
  // ============================================================

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF8),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFFE4EAE7)),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: const BoxDecoration(
              color: Color(0xFFE5F3EC),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: const Color(0xFF087C59), size: 22),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,

                  style: const TextStyle(fontSize: 8, color: Color(0xFF718079)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  
  // ================================================================
  // PROFILE FALLBACK
  // ================================================================

  Widget _profileFallback(String letter) {
    return Container(
      color: const Color(0xFFE8F5E9),

      alignment: Alignment.center,

      child: Text(
        letter,

        style: const TextStyle(
          color: Color(0xFF075B4A),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(fontSize: 9, color: Color(0xFF718079)),
            ),
          ),

          Flexible(
            child: Text(
              value,

              textAlign: TextAlign.right,

              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Color(0xFF263238),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRACK ORDER
  // ============================================================

  void _showTrackOrder(Map<String, dynamic> order) {
    final String status = order["status"] ?? "Processing";

    final bool processing =
        status == "Processing" || status == "Shipped" || status == "Delivered";

    final bool shipped = status == "Shipped" || status == "Delivered";

    final bool delivered = status == "Delivered";

    showModalBottomSheet(
      context: context,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 25),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildSheetHandle(),

              const SizedBox(height: 18),

              Text(
                "Track Order ${order["id"]}",

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF17252C),
                ),
              ),

              const SizedBox(height: 20),

              _trackingStep(
                icon: Icons.check_circle_rounded,

                title: "Order Placed",

                subtitle: "Your order has been placed",

                completed: true,
              ),

              _trackingLine(),

              _trackingStep(
                icon: Icons.inventory_2_rounded,

                title: "Order Processing",

                subtitle: "Your order is being prepared",

                completed: processing,
              ),

              _trackingLine(),

              _trackingStep(
                icon: Icons.local_shipping_rounded,

                title: "Shipped",

                subtitle: shipped
                    ? "Your order is on the way"
                    : "Waiting for shipment",

                completed: shipped,
              ),

              _trackingLine(),

              _trackingStep(
                icon: Icons.home_rounded,

                title: "Delivered",

                subtitle: delivered
                    ? "Order delivered successfully"
                    : "Waiting for delivery",

                completed: delivered,
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }
  // ============================================================
  // TRACKING STEP
  // ============================================================

  Widget _trackingStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool completed,
  }) {
    return Row(
      children: [
        Icon(
          icon,

          size: 25,

          color: completed ? const Color(0xFF087C59) : const Color(0xFFB5BFBA),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: completed
                      ? const Color(0xFF263238)
                      : const Color(0xFF89958F),
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,

                style: const TextStyle(fontSize: 7.5, color: Color(0xFF89958F)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TRACKING LINE
  // ============================================================

  Widget _trackingLine() {
    return Container(
      margin: const EdgeInsets.only(left: 11),

      height: 18,
      width: 2,

      color: const Color(0xFFD8E5DE),
    );
  }

  // ============================================================
  // CANCEL ORDER
  // ============================================================

  void _showCancelConfirmation(Map<String, dynamic> order) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          title: const Text(
            "Cancel Order?",

            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),

          content: Text(
            "Are you sure you want to cancel ${order["id"]}?",

            style: const TextStyle(fontSize: 10, color: Color(0xFF68756F)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "No",

                style: TextStyle(color: Color(0xFF68756F)),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                final dynamic orderData = order["orderData"];

                if (orderData is! Map<String, dynamic>) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Order information is unavailable."),
                    ),
                  );

                  return;
                }

                final int? orderId = int.tryParse(
                  orderData["order_id"]?.toString() ?? "",
                );

                if (orderId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid order ID.")),
                  );

                  return;
                }

                // ----------------------------------------------------------
                // SHOW LOADING
                // ----------------------------------------------------------

                showDialog(
                  context: context,

                  barrierDismissible: false,

                  builder: (_) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF087C59),
                      ),
                    );
                  },
                );

                try {
                  // --------------------------------------------------------
                  // CALL FASTAPI
                  // --------------------------------------------------------

                  await ApiService.cancelOrder(orderId);

                  // Close loading
                  if (mounted) {
                    Navigator.pop(context);
                  }

                  // --------------------------------------------------------
                  // REFRESH FROM DATABASE
                  // --------------------------------------------------------

                  await _loadOrders();

                  // --------------------------------------------------------
                  // SUCCESS
                  // --------------------------------------------------------

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Order cancelled successfully."),

                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  // Close loading
                  if (mounted) {
                    Navigator.pop(context);
                  }

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst("Exception: ", ""),
                      ),

                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD93643),

                foregroundColor: Colors.white,
              ),

              child: const Text("Cancel Order"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUY AGAIN
  // ============================================================
  Future<void> _buyAgain(Map<String, dynamic> order) async {
    final dynamic rawOrderData = order["orderData"];

    if (rawOrderData is! Map<String, dynamic>) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order information is unavailable.")),
      );
      return;
    }

    final List<dynamic> items = rawOrderData["items"] is List
        ? rawOrderData["items"]
        : [];

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No products found in this order.")),
      );
      return;
    }

    // ------------------------------------------------------------
    // SHOW LOADING
    // ------------------------------------------------------------

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF087C59)),
        );
      },
    );

    try {
      final cart = context.read<CartProvider>();

      int addedProducts = 0;

      // ----------------------------------------------------------
      // ADD EVERY PRODUCT FROM THE OLD ORDER
      // ----------------------------------------------------------

      for (final rawItem in items) {
        if (rawItem is! Map<String, dynamic>) {
          continue;
        }

        final int? productId = int.tryParse(
          rawItem["product_id"]?.toString() ?? "",
        );

        if (productId == null) {
          continue;
        }

        final String name = rawItem["product_name"]?.toString() ?? "Product";

        final double price = _toDouble(rawItem["price"]);

        final String unit = rawItem["unit"]?.toString() ?? "";

        String image = rawItem["image_url"]?.toString() ?? "";

        if (image.isNotEmpty && !image.startsWith("http")) {
          image = "${ApiConfig.baseUrl}$image";
        }

        final String farm = rawItem["farm"]?.toString() ?? "";

        final String location = rawItem["location"]?.toString() ?? "";

        final int quantity =
            int.tryParse(rawItem["quantity"]?.toString() ?? "1") ?? 1;

        // --------------------------------------------------------
        // ADD PRODUCT
        // --------------------------------------------------------

        for (int i = 0; i < quantity; i++) {
          await cart.addToCart(
            productId: productId,
            name: name,
            price: price,
            unit: unit,
            image: image,
            farm: farm,
            location: location,
          );
        }

        addedProducts++;
      }

      // ----------------------------------------------------------
      // CLOSE LOADING
      // ----------------------------------------------------------

      if (mounted) {
        Navigator.pop(context);
      }

      if (!mounted) return;

      if (addedProducts == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to add products to cart.")),
        );

        return;
      }

      // ----------------------------------------------------------
      // SUCCESS
      // ----------------------------------------------------------

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$addedProducts product${addedProducts == 1 ? "" : "s"} added to cart.",
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "VIEW CART",
            textColor: Colors.white,
            onPressed: _openCart,
          ),
        ),
      );
    } catch (e) {
      // ----------------------------------------------------------
      // CLOSE LOADING
      // ----------------------------------------------------------

      if (mounted) {
        Navigator.pop(context);
      }

      if (!mounted) return;

      debugPrint("BUY AGAIN ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _showSearchMessage() {
    showSearch(
      context: context,

      delegate: OrderSearchDelegate(orders: orders),
    );
  }

  // ============================================================
  // CART
  // ============================================================

  // ============================================================
  // SHEET HANDLE
  // ============================================================

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,

        decoration: BoxDecoration(
          color: const Color(0xFFD8DEDB),

          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 65,
            height: 65,

            decoration: const BoxDecoration(
              color: Color(0xFFE7F3EC),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.receipt_long_outlined,

              size: 30,

              color: Color(0xFF087C59),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            selectedTab == 0
                ? "No Orders Found"
                : "No ${tabs[selectedTab]} Orders",

            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Your orders will appear here.",

            style: TextStyle(fontSize: 8, color: Color(0xFF7B8782)),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// SEARCH DELEGATE
// =================================================================

class OrderSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> orders;

  OrderSearchDelegate({required this.orders});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = "";
          },

          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, "");
      },

      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults();
  }

  // ============================================================
  // SEARCH RESULTS
  // ============================================================

  Widget _buildResults() {
    final results = orders.where((order) {
      final String text =
          "${order["id"]} "
          "${order["farmer"]} "
          "${order["location"]} "
          "${order["status"]}";

      return text.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No orders found"));
    }

    return ListView.builder(
      itemCount: results.length,

      itemBuilder: (context, index) {
        final order = results[index];

        return ListTile(
          leading: const Icon(
            Icons.receipt_long_outlined,

            color: Color(0xFF087C59),
          ),

          title: Text("Order ${order["id"]}"),

          subtitle: Text(
            "${order["farmer"]} • "
            "${order["status"]}",
          ),

          trailing: Text(
            order["total"] ?? "₹0",

            style: const TextStyle(
              fontWeight: FontWeight.w700,

              color: Color(0xFF087C59),
            ),
          ),
        );
      },
    );
  }
}
