import 'package:flutter/material.dart';

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
  // DEMO ORDERS
  // UI ONLY
  // LATER THIS CAN COME FROM FASTAPI + POSTGRESQL
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
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=300",
        "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300",
        "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300",
        "https://images.unsplash.com/photo-1445282768818-728615cc910a?w=300",
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
        "https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300",
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=300",
        "https://images.unsplash.com/photo-1563298723-dcfebaa392e3?w=300",
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
        "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300",
        "https://images.unsplash.com/photo-1568584711075-3d021a7c3ca3?w=300",
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=300",
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
        "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300",
        "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300",
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
        "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=300",
        "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300",
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=300",
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
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300",
        "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=300",
      ],
      "quantities": ["2", "3"],
    },

    {
      "id": "#FD1185",
      "date": "15 Nov 2024, 1:20 PM",
      "status": "Shipped",
      "farmer": "Rajendra Singh",
      "location": "Doiwala, Uttarakhand",
      "items": "4 items",
      "total": "₹245",
      "action": "Track Order",
      "images": [
        "https://images.unsplash.com/photo-1445282768818-728615cc910a?w=300",
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=300",
        "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=300",
      ],
      "quantities": ["1", "2", "1"],
    },
  ];

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

            // HEADER
            _buildHeader(),

            // TABS
            _buildTabs(),

            // SCROLLABLE ORDERS
            Expanded(
              child: filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : Scrollbar(
                      thumbVisibility: true,
                      radius: const Radius.circular(10),

                      child: ListView.builder(
                        physics:
                            const BouncingScrollPhysics(),

                        padding: const EdgeInsets.fromLTRB(
                          10,
                          8,
                          10,
                          20,
                        ),

                        itemCount:
                            filteredOrders.length,

                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return _buildOrderCard(
                            filteredOrders[index],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),

      // FIXED BOTTOM NAVIGATION
      bottomNavigationBar:
          _buildBottomNavigation(),
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
        children: [

          // TITLE
          const Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  "My Orders",

                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        Color(0xFF17252C),
                  ),
                ),

                SizedBox(height: 1),

                Text(
                  "Track and manage your orders",

                  style: TextStyle(
                    fontSize: 8,
                    color:
                        Color(0xFF718079),
                  ),
                ),
              ],
            ),
          ),

          // SEARCH
          _headerButton(
            icon: Icons.search_rounded,
            onTap: () {
              _showSearchMessage();
            },
          ),

          const SizedBox(width: 7),

          // CART
          Stack(
            clipBehavior: Clip.none,
            children: [

              _headerButton(
                icon:
                    Icons.shopping_cart_outlined,
                onTap: () {
                  _showCartMessage();
                },
              ),

              Positioned(
                right: -3,
                top: -4,

                child: Container(
                  width: 15,
                  height: 15,

                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xFFFF4D55),
                    shape:
                        BoxShape.circle,
                  ),

                  child: const Center(
                    child: Text(
                      "3",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight:
                            FontWeight.w800,
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

        decoration:
            const BoxDecoration(
          color:
              Color(0xFFEFF5F2),
          shape:
              BoxShape.circle,
        ),

        child: Icon(
          icon,
          size: 18,
          color:
              const Color(0xFF263238),
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
        borderRadius:
            BorderRadius.circular(9),
      ),

      child: ListView.builder(
        scrollDirection:
            Axis.horizontal,

        physics:
            const BouncingScrollPhysics(),

        itemCount: tabs.length,

        itemBuilder: (
          context,
          index,
        ) {
          final bool selected =
              selectedTab == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = index;
              });
            },

            child: AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 180,
              ),

              margin:
                  const EdgeInsets.all(3),

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
              ),

              decoration:
                  BoxDecoration(
                color: selected
                    ? const Color(
                        0xFF087C59,
                      )
                    : Colors.transparent,

                borderRadius:
                    BorderRadius.circular(7),
              ),

              alignment:
                  Alignment.center,

              child: Text(
                tabs[index],

                style: TextStyle(
                  fontSize: 8,

                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,

                  color: selected
                      ? Colors.white
                      : const Color(
                          0xFF61716A,
                        ),
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

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color:
              const Color(0xFFE4EAE7),
          width: 0.7,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.025,
            ),
            blurRadius: 5,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        children: [

          // ======================================================
          // ORDER HEADER
          // ======================================================

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

                      style:
                          const TextStyle(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(0xFF17252C),
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      order["date"],

                      style:
                          const TextStyle(
                        fontSize: 7,
                        color:
                            Color(0xFF718079),
                      ),
                    ),
                  ],
                ),
              ),

              // STATUS
              _buildStatusBadge(
                order["status"],
              ),

              const SizedBox(width: 4),

              const Icon(
                Icons.chevron_right_rounded,
                size: 17,
                color:
                    Color(0xFF7C8984),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // ======================================================
          // PRODUCTS + TOTAL
          // ======================================================

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              // PRODUCT IMAGES
              Expanded(
                flex: 6,

                child:
                    _buildProductImages(
                  order,
                ),
              ),

              const SizedBox(width: 7),

              // DIVIDER
              Container(
                width: 1,
                height: 43,
                color:
                    const Color(
                  0xFFE1E6E3,
                ),
              ),

              const SizedBox(width: 8),

              // TOTAL
              Expanded(
                flex: 3,

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      order["items"],

                      style:
                          const TextStyle(
                        fontSize: 7.5,
                        color:
                            Color(0xFF718079),
                      ),
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      order["total"],

                      style:
                          const TextStyle(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(0xFF087C59),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // ======================================================
          // FARMER + ACTIONS
          // ======================================================

          Row(
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
                        color:
                            Color(0xFFEAF3EE),
                        shape:
                            BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person_rounded,
                        size: 16,
                        color:
                            Color(0xFF087C59),
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

                            style:
                                const TextStyle(
                              fontSize: 8,
                              fontWeight:
                                  FontWeight.w700,
                              color:
                                  Color(0xFF263238),
                            ),
                          ),

                          const SizedBox(
                            height: 1,
                          ),

                          Text(
                            order["location"],

                            maxLines: 1,

                            overflow:
                                TextOverflow.ellipsis,

                            style:
                                const TextStyle(
                              fontSize: 6.5,
                              color:
                                  Color(0xFF7B8782),
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

                onTap: () {
                  _handleOrderAction(
                    order,
                    order["action"],
                  );
                },
              ),

              const SizedBox(width: 5),

              // VIEW DETAILS
              _buildActionButton(
                text: "View Details",
                filled: true,

                onTap: () {
                  _showOrderDetails(
                    order,
                  );
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

  Widget _buildProductImages(
    Map<String, dynamic> order,
  ) {
    final List images =
        order["images"];

    final List quantities =
        order["quantities"];

    return SizedBox(
      height: 43,

      child: Row(
        children: List.generate(
          images.length,
          (index) {

            return Padding(
              padding:
                  EdgeInsets.only(
                right:
                    index ==
                            images.length - 1
                        ? 0
                        : 5,
              ),

              child: Stack(
                children: [

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      6,
                    ),

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

                          color:
                              const Color(
                            0xFFEAF1ED,
                          ),

                          child:
                              const Icon(
                            Icons
                                .image_outlined,
                            size: 18,
                            color:
                                Color(
                              0xFF94A19B,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // QUANTITY
                  Positioned(
                    right: 2,
                    bottom: 2,

                    child: Container(
                      width: 15,
                      height: 15,

                      decoration:
                          const BoxDecoration(
                        color:
                            Colors.white,
                        shape:
                            BoxShape.circle,
                      ),

                      child: Center(
                        child: Text(
                          quantities[index],

                          style:
                              const TextStyle(
                            fontSize: 7,
                            fontWeight:
                                FontWeight.w800,
                            color:
                                Color(
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
        background =
            const Color(0xFFE5F5EB);
        textColor =
            const Color(0xFF087C59);
        icon =
            Icons.local_shipping_rounded;
        break;

      case "Processing":
        background =
            const Color(0xFFE8F1FF);
        textColor =
            const Color(0xFF2875D8);
        icon =
            Icons.inventory_2_rounded;
        break;

      case "Shipped":
        background =
            const Color(0xFFFFF1D5);
        textColor =
            const Color(0xFFAD7100);
        icon =
            Icons.local_shipping_rounded;
        break;

      case "Cancelled":
        background =
            const Color(0xFFFFE9EB);
        textColor =
            const Color(0xFFD62F3D);
        icon =
            Icons.cancel_rounded;
        break;

      default:
        background =
            const Color(0xFFEAF1ED);
        textColor =
            const Color(0xFF087C59);
        icon =
            Icons.info_outline;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 5,
      ),

      decoration:
          BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(7),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

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
              fontWeight:
                  FontWeight.w700,
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

        padding:
            const EdgeInsets.symmetric(
          horizontal: 9,
        ),

        decoration:
            BoxDecoration(
          color: filled
              ? const Color(0xFF087C59)
              : Colors.white,

          borderRadius:
              BorderRadius.circular(7),

          border: Border.all(
            color:
                const Color(0xFF087C59),
            width: 0.8,
          ),
        ),

        alignment:
            Alignment.center,

        child: Text(
          text,

          style: TextStyle(
            fontSize: 7,
            fontWeight:
                FontWeight.w700,
            color: filled
                ? Colors.white
                : const Color(
                    0xFF263238,
                  ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HANDLE ORDER ACTION
  // ============================================================

  void _handleOrderAction(
    Map<String, dynamic> order,
    String action,
  ) {
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
    }
  }

  // ============================================================
  // VIEW DETAILS
  // ============================================================

  void _showOrderDetails(
    Map<String, dynamic> order,
  ) {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor:
          Colors.transparent,

      builder: (context) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            25,
          ),

          decoration:
              const BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              _buildSheetHandle(),

              const SizedBox(height: 18),

              Text(
                "Order ${order["id"]}",

                style:
                    const TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      Color(0xFF17252C),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                order["date"],

                style:
                    const TextStyle(
                  fontSize: 9,
                  color:
                      Color(0xFF718079),
                ),
              ),

              const SizedBox(height: 18),

              _detailRow(
                "Status",
                order["status"],
              ),

              _detailRow(
                "Farmer",
                order["farmer"],
              ),

              _detailRow(
                "Location",
                order["location"],
              ),

              _detailRow(
                "Items",
                order["items"],
              ),

              _detailRow(
                "Total",
                order["total"],
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 42,

                child:
                    ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                      0xFF087C59,
                    ),

                    foregroundColor:
                        Colors.white,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        9,
                      ),
                    ),
                  ),

                  child: const Text(
                    "Close",

                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 11,
      ),

      child: Row(
        children: [

          Expanded(
            child: Text(
              title,

              style:
                  const TextStyle(
                fontSize: 9,
                color:
                    Color(0xFF718079),
              ),
            ),
          ),

          Text(
            value,

            style:
                const TextStyle(
              fontSize: 9,
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(0xFF263238),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TRACK ORDER
  // ============================================================

  void _showTrackOrder(
    Map<String, dynamic> order,
  ) {
    showModalBottomSheet(
      context: context,

      backgroundColor:
          Colors.transparent,

      builder: (context) {
        return Container(
          padding:
              const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            25,
          ),

          decoration:
              const BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),

          child: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              _buildSheetHandle(),

              const SizedBox(height: 18),

              Text(
                "Track Order ${order["id"]}",

                style:
                    const TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      Color(0xFF17252C),
                ),
              ),

              const SizedBox(height: 20),

              _trackingStep(
                icon:
                    Icons.check_circle_rounded,
                title:
                    "Order Placed",
                subtitle:
                    "Your order has been placed",
                completed: true,
              ),

              _trackingLine(),

              _trackingStep(
                icon:
                    Icons.inventory_2_rounded,
                title:
                    "Order Packed",
                subtitle:
                    "Farmer has packed your products",
                completed: true,
              ),

              _trackingLine(),

              _trackingStep(
                icon:
                    Icons.local_shipping_rounded,
                title:
                    "Shipped",
                subtitle:
                    "Your order is on the way",
                completed: true,
              ),

              _trackingLine(),

              _trackingStep(
                icon:
                    Icons.home_rounded,
                title:
                    "Delivered",
                subtitle:
                    "Waiting for delivery",
                completed: false,
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
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

          color: completed
              ? const Color(0xFF087C59)
              : const Color(0xFFB5BFBA),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,

                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                  color: completed
                      ? const Color(
                          0xFF263238,
                        )
                      : const Color(
                          0xFF89958F,
                        ),
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,

                style:
                    const TextStyle(
                  fontSize: 7.5,
                  color:
                      Color(0xFF89958F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trackingLine() {
    return Container(
      margin:
          const EdgeInsets.only(
        left: 11,
      ),

      height: 18,
      width: 2,

      color:
          const Color(0xFFD8E5DE),
    );
  }

  // ============================================================
  // CANCEL ORDER
  // ============================================================

  void _showCancelConfirmation(
    Map<String, dynamic> order,
  ) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),

          title: const Text(
            "Cancel Order?",

            style: TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          content: Text(
            "Are you sure you want to cancel ${order["id"]}?",

            style: const TextStyle(
              fontSize: 10,
              color:
                  Color(0xFF68756F),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },

              child: const Text(
                "No",

                style: TextStyle(
                  color:
                      Color(0xFF68756F),
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {

                Navigator.pop(
                  context,
                );

                setState(() {
                  order["status"] =
                      "Cancelled";

                  order["action"] =
                      "Buy Again";
                });

                ScaffoldMessenger
                    .of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Order cancelled successfully",
                    ),
                    duration:
                        Duration(
                      seconds: 2,
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFD93643,
                ),

                foregroundColor:
                    Colors.white,
              ),

              child: const Text(
                "Cancel Order",
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUY AGAIN
  // ============================================================

  void _buyAgain(
    Map<String, dynamic> order,
  ) {
    ScaffoldMessenger
        .of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          "${order["items"]} added to cart",
        ),

        duration:
            const Duration(
          seconds: 2,
        ),

        action: SnackBarAction(
          label: "VIEW CART",

          onPressed: () {
            _showCartMessage();
          },
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH MESSAGE
  // ============================================================

  void _showSearchMessage() {
    showSearch(
      context: context,
      delegate: OrderSearchDelegate(
        orders: orders,
      ),
    );
  }

  // ============================================================
  // CART MESSAGE
  // ============================================================

  void _showCartMessage() {
    ScaffoldMessenger
        .of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Cart screen will be connected later.",
        ),
        duration:
            Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // SHEET HANDLE
  // ============================================================

  Widget _buildSheetHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,

        decoration:
            BoxDecoration(
          color:
              const Color(0xFFD8DEDB),
          borderRadius:
              BorderRadius.circular(10),
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
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Container(
            width: 65,
            height: 65,

            decoration:
                const BoxDecoration(
              color:
                  Color(0xFFE7F3EC),
              shape:
                  BoxShape.circle,
            ),

            child: const Icon(
              Icons.receipt_long_outlined,
              size: 30,
              color:
                  Color(0xFF087C59),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "No Orders Found",

            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Your orders will appear here.",

            style: TextStyle(
              fontSize: 8,
              color:
                  Color(0xFF7B8782),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      height: 62,

      decoration:
          const BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(
            color:
                Color(0xFFE2E8E5),
            width: 0.8,
          ),
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,

        children: [

          _bottomItem(
            icon:
                Icons.home_outlined,
            label: "Home",
            selected: false,
          ),

          _bottomItem(
            icon:
                Icons.grid_view_rounded,
            label: "Categories",
            selected: false,
          ),

          _bottomItem(
            icon:
                Icons.receipt_long_rounded,
            label: "Orders",
            selected: true,
          ),

          _bottomItem(
            icon:
                Icons.person_outline_rounded,
            label: "Account",
            selected: false,
          ),

          _bottomCart(),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM ITEM
  // ============================================================

  Widget _bottomItem({
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () {
        // Existing Buyer Dashboard
        // navigation can be connected later.
      },

      child: SizedBox(
        width: 60,

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 21,

              color: selected
                  ? const Color(
                      0xFF087C59,
                    )
                  : const Color(
                      0xFF6F7C76,
                    ),
            ),

            const SizedBox(height: 2),

            Text(
              label,

              style: TextStyle(
                fontSize: 7,

                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,

                color: selected
                    ? const Color(
                        0xFF087C59,
                      )
                    : const Color(
                        0xFF6F7C76,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CART BOTTOM ITEM
  // ============================================================

  Widget _bottomCart() {
    return GestureDetector(
      onTap: () {
        _showCartMessage();
      },

      child: SizedBox(
        width: 60,

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Stack(
              clipBehavior:
                  Clip.none,

              children: [

                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 22,
                  color:
                      Color(0xFF6F7C76),
                ),

                Positioned(
                  right: -7,
                  top: -7,

                  child: Container(
                    width: 15,
                    height: 15,

                    decoration:
                        const BoxDecoration(
                      color:
                          Color(0xFFFF4D55),
                      shape:
                          BoxShape.circle,
                    ),

                    child: const Center(
                      child: Text(
                        "3",

                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize: 7,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            const Text(
              "Cart",

              style: TextStyle(
                fontSize: 7,
                color:
                    Color(0xFF6F7C76),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// SEARCH DELEGATE
// =================================================================

class OrderSearchDelegate
    extends SearchDelegate<String> {

  final List<Map<String, dynamic>> orders;

  OrderSearchDelegate({
    required this.orders,
  });

  @override
  List<Widget>? buildActions(
    BuildContext context,
  ) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
    ];
  }

  @override
  Widget? buildLeading(
    BuildContext context,
  ) {
    return IconButton(
      onPressed: () {
        close(
          context,
          "",
        );
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    return _buildResults();
  }

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return _buildResults();
  }

  Widget _buildResults() {
    final results =
        orders.where((order) {

      final String text =
          "${order["id"]} "
          "${order["farmer"]} "
          "${order["status"]}";

      return text
          .toLowerCase()
          .contains(
            query.toLowerCase(),
          );
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          "No orders found",
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,

      itemBuilder: (
        context,
        index,
      ) {
        final order =
            results[index];

        return ListTile(
          leading: const Icon(
            Icons.receipt_long_outlined,
            color:
                Color(0xFF087C59),
          ),

          title: Text(
            "Order ${order["id"]}",
          ),

          subtitle: Text(
            "${order["farmer"]} • ${order["status"]}",
          ),

          trailing: Text(
            order["total"],
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(0xFF087C59),
            ),
          ),
        );
      },
    );
  }
}