import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedTab = 0;

  final List<String> tabs = [
    "All Orders",
    "Processing",
    "Shipped",
    "Delivered",
    "Cancelled",
  ];

  // ============================================================
  // DEMO ORDER DATA
  // UI ONLY - BACKEND WILL BE CONNECTED LATER
  // ============================================================

  final List<Map<String, dynamic>> orders = [
    {
      "id": "#FD1258",
      "date": "12 Dec 2024, 10:24 AM",
      "status": "Delivered",
      "farmer": "Ramesh Singh",
      "location": "Dehradun, Uttarakhand",
      "items": "4 items",
      "total": "₹210",
      "action": "Buy Again",
      "images": [
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=200",
        "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200",
        "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=200",
        "https://images.unsplash.com/photo-1445282768818-728615cc910a?w=200",
      ],
      "quantities": ["2", "1", "1", "1"],
    },
    {
      "id": "#FD1247",
      "date": "8 Dec 2024, 3:15 PM",
      "status": "Processing",
      "farmer": "Suresh Negi",
      "location": "Rishikesh, Uttarakhand",
      "items": "3 items",
      "total": "₹320",
      "action": "Cancel Order",
      "images": [
        "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=200",
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=200",
        "https://images.unsplash.com/photo-1563298723-dcfebaa392e3?w=200",
      ],
      "quantities": ["2", "1", "1"],
    },
    {
      "id": "#FD1236",
      "date": "3 Dec 2024, 9:40 AM",
      "status": "Shipped",
      "farmer": "Anita Rawat",
      "location": "Haridwar, Uttarakhand",
      "items": "3 items",
      "total": "₹150",
      "action": "Track Order",
      "images": [
        "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=200",
        "https://images.unsplash.com/photo-1568584711075-3d021a7c3ca3?w=200",
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=200",
      ],
      "quantities": ["1", "1", "2"],
    },
    {
      "id": "#FD1221",
      "date": "28 Nov 2024, 6:20 PM",
      "status": "Cancelled",
      "farmer": "Vikram Thapa",
      "location": "Roorkee, Uttarakhand",
      "items": "2 items",
      "total": "₹90",
      "action": "Buy Again",
      "images": [
        "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200",
        "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200",
      ],
      "quantities": ["2", "1"],
    },
    {
      "id": "#FD1210",
      "date": "22 Nov 2024, 11:10 AM",
      "status": "Delivered",
      "farmer": "Mohan Singh",
      "location": "Dehradun, Uttarakhand",
      "items": "3 items",
      "total": "₹280",
      "action": "Buy Again",
      "images": [
        "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=200",
        "https://images.unsplash.com/photo- 香蕉?w=200",
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=200",
      ],
      "quantities": ["3", "2", "1"],
    },
    {
      "id": "#FD1198",
      "date": "18 Nov 2024, 4:30 PM",
      "status": "Processing",
      "farmer": "Deepak Rawat",
      "location": "Mussoorie, Uttarakhand",
      "items": "5 items",
      "total": "₹390",
      "action": "Cancel Order",
      "images": [
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200",
        "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=200",
      ],
      "quantities": ["2", "3"],
    },
  ];

  // ============================================================
  // FILTER ORDERS
  // ============================================================

  List<Map<String, dynamic>> get filteredOrders {
    if (selectedTab == 0) {
      return orders;
    }

    final selectedStatus = tabs[selectedTab];

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

            // TOP HEADER
            _buildHeader(),

            // STATUS TABS
            _buildTabs(),

            // SCROLLABLE ORDERS
            Expanded(
              child: filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        10,
                        8,
                        10,
                        20,
                      ),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(
                          filteredOrders[index],
                        );
                      },
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
      padding: const EdgeInsets.fromLTRB(
        11,
        7,
        10,
        5,
      ),
      color: const Color(0xFFF7FAF8),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // TITLE
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
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFF718079),
                  ),
                ),
              ],
            ),
          ),

          // SEARCH
          _headerButton(
            icon: Icons.search_rounded,
            onTap: () {},
          ),

          const SizedBox(width: 7),

          // CART
          Stack(
            clipBehavior: Clip.none,
            children: [

              _headerButton(
                icon: Icons.shopping_cart_outlined,
                onTap: () {},
              ),

              Positioned(
                right: -3,
                top: -4,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4D55),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "3",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.w800,
                      ),
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

  Widget _headerButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: const BoxDecoration(
          color: Color(0xFFEFF5F2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: const Color(0xFF263238),
        ),
      ),
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs() {
    return Container(
      height: 39,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1ED),
        borderRadius: BorderRadius.circular(9),
      ),

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        itemBuilder: (context, index) {

          final bool selected =
              selectedTab == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = index;
              });
            },

            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 180,
              ),

              margin: const EdgeInsets.all(3),

              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF087C59)
                    : Colors.transparent,

                borderRadius:
                    BorderRadius.circular(7),
              ),

              alignment: Alignment.center,

              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: selected
                      ? Colors.white
                      : const Color(0xFF61716A),
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

  Widget _buildOrderCard(
    Map<String, dynamic> order,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 9,
      ),

      padding: const EdgeInsets.fromLTRB(
        9,
        8,
        9,
        7,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFE4EAE7),
          width: 0.7,
        ),

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

          // =====================================================
          // ORDER HEADER
          // =====================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
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
                      order["date"],
                      style: const TextStyle(
                        fontSize: 7,
                        color: Color(0xFF718079),
                      ),
                    ),
                  ],
                ),
              ),

              _buildStatusBadge(
                order["status"],
              ),

              const SizedBox(width: 5),

              const Icon(
                Icons.chevron_right_rounded,
                size: 17,
                color: Color(0xFF7C8984),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // =====================================================
          // PRODUCTS + TOTAL
          // =====================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // PRODUCT IMAGES
              Expanded(
                flex: 6,
                child: _buildProductImages(
                  order,
                ),
              ),

              const SizedBox(width: 8),

              // VERTICAL DIVIDER
              Container(
                width: 1,
                height: 42,
                color: const Color(0xFFE1E6E3),
              ),

              const SizedBox(width: 9),

              // TOTAL
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 4),

                    Text(
                      order["items"],
                      style: const TextStyle(
                        fontSize: 7.5,
                        color: Color(0xFF718079),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      order["total"],
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

          // =====================================================
          // FARMER + ACTION BUTTONS
          // =====================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,

            children: [

              // FARMER
              Expanded(
                child: Row(
                  children: [

                    Container(
                      width: 28,
                      height: 28,
                      decoration:
                          const BoxDecoration(
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
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            order["farmer"],
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w700,
                              color: Color(0xFF263238),
                            ),
                          ),

                          const SizedBox(height: 1),

                          Text(
                            order["location"],
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
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

              // FIRST ACTION
              _buildActionButton(
                text: order["action"],
                filled: false,
                onTap: () {},
              ),

              const SizedBox(width: 5),

              // DETAILS
              _buildActionButton(
                text: "View Details",
                filled: true,
                onTap: () {},
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

  Widget _buildProductImages(
    Map<String, dynamic> order,
  ) {
    final List images = order["images"];
    final List quantities = order["quantities"];

    return SizedBox(
      height: 43,

      child: Row(
        children: List.generate(
          images.length,
          (index) {

            return Padding(
              padding: EdgeInsets.only(
                right: index == images.length - 1
                    ? 0
                    : 5,
              ),

              child: Stack(
                children: [

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(6),

                    child: Image.network(
                      images[index],
                      width: 43,
                      height: 43,
                      fit: BoxFit.cover,

                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          width: 43,
                          height: 43,
                          color: const Color(
                            0xFFEAF1ED,
                          ),
                          child: const Icon(
                            Icons.image_outlined,
                            size: 18,
                            color: Color(
                              0xFF94A19B,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // QUANTITY BADGE
                  Positioned(
                    right: 2,
                    bottom: 2,

                    child: Container(
                      width: 15,
                      height: 15,

                      decoration:
                          const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),

                      child: Center(
                        child: Text(
                          quantities[index],
                          style:
                              const TextStyle(
                            fontSize: 7,
                            fontWeight:
                                FontWeight.w800,
                            color: Color(
                              0xFF263238,
                            ),
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
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _buildStatusBadge(
    String status,
  ) {
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
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 11,
            color: textColor,
          ),

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

        padding: const EdgeInsets.symmetric(
          horizontal: 9,
        ),

        decoration: BoxDecoration(
          color: filled
              ? const Color(0xFF087C59)
              : Colors.white,

          borderRadius: BorderRadius.circular(7),

          border: Border.all(
            color: const Color(0xFF087C59),
            width: 0.8,
          ),
        ),

        alignment: Alignment.center,

        child: Text(
          text,
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w700,
            color: filled
                ? Colors.white
                : const Color(0xFF263238),
          ),
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

          const Text(
            "No Orders Found",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Your orders will appear here.",
            style: TextStyle(
              fontSize: 8,
              color: Color(0xFF7B8782),
            ),
          ),
        ],
      ),
    );
  }


}