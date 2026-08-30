import 'package:flutter/material.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedTab = 0;

  // ============================================================
  // ORDER DATA
  // ============================================================

  final List<Map<String, String>> pendingOrders = [
    {
      'orderId': 'FD1234',
      'buyer': 'Suresh Kumar',
      'quantity': '50 kg',
      'product': 'Basmati Rice',
      'amount': '₹4,250',
      'date': 'Today, 10:15 AM',
      'status': 'Pending Accept',
      'address': 'Sector 15, Rohini, New Delhi, 110085',
      'price': '₹4,250',
      'logistics': '₹150',
      'total': '₹4,400',
    },
    {
      'orderId': 'FD1190',
      'buyer': 'Aggarwal Sweet House',
      'quantity': '100 kg',
      'product': 'Cow Ghee',
      'amount': '₹65,000',
      'date': 'Yesterday',
      'status': 'Pending Accept',
      'address': 'New Delhi, India',
      'price': '₹65,000',
      'logistics': '₹0',
      'total': '₹65,000',
    },
  ];

  final List<Map<String, String>> confirmedOrders = [
    {
      'orderId': 'FD1180',
      'buyer': 'Sharma Foods',
      'quantity': '75 kg',
      'product': 'Organic Wheat',
      'amount': '₹3,750',
      'date': 'Yesterday',
      'status': 'Confirmed',
      'address': 'Gurugram, Haryana, India',
      'price': '₹3,750',
      'logistics': '₹150',
      'total': '₹3,900',
    },
  ];

  final List<Map<String, String>> shippedOrders = [
    {
      'orderId': 'FD1145',
      'buyer': 'Fresh Mart',
      'quantity': '40 kg',
      'product': 'Organic Rice',
      'amount': '₹3,400',
      'date': '25 Aug, 2026',
      'status': 'Shipped',
      'address': 'New Delhi, India',
      'price': '₹3,400',
      'logistics': '₹150',
      'total': '₹3,550',
    },
  ];

  // ============================================================
  // GET CURRENT ORDERS
  // ============================================================

  List<Map<String, String>> get currentOrders {
    switch (selectedTab) {
      case 1:
        return confirmedOrders;

      case 2:
        return shippedOrders;

      default:
        return pendingOrders;
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
          _buildHeader(),

          _buildTabs(),

          Expanded(
            child: currentOrders.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      5,
                      14,
                      5,
                      20,
                    ),
                    itemCount: currentOrders.length,
                    itemBuilder: (context, index) {
                      final order = currentOrders[index];

                      return _buildOrderCard(order);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        0,
        10,
        0,
        12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8ECEF),
          ),
        ),
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'My Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF075B47),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs() {
    final tabs = [
      'Pending (${pendingOrders.length})',
      'Confirmed',
      'Shipped',
    ];

    return Container(
      height: 42,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: List.generate(
          tabs.length,
          (index) {
            final isSelected = selectedTab == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = index;
                  });
                },
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE5F7F1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF075B47)
                            : const Color(0xFF737B82),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================

  Widget _buildOrderCard(
    Map<String, String> order,
  ) {
    return GestureDetector(
      onTap: () {
        _openOrderDetails(order);
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: const Color(0xFFE4E8EB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====================================================
            // ORDER ID + STATUS
            // ====================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order['orderId']}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF075B47),
                  ),
                ),

                _buildStatusBadge(
                  order['status'] ?? '',
                ),
              ],
            ),

            const SizedBox(height: 11),

            // ====================================================
            // BUYER
            // ====================================================

            Text(
              order['buyer'] ?? '',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF303840),
              ),
            ),

            const SizedBox(height: 4),

            // ====================================================
            // PRODUCT
            // ====================================================

            Text(
              '${order['quantity']} • ${order['product']}',
              style: const TextStyle(
                fontSize: 9.5,
                color: Color(0xFF7D858D),
              ),
            ),

            const SizedBox(height: 8),

            // ====================================================
            // BOTTOM ROW
            // ====================================================

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total: ',
                      style: TextStyle(
                        fontSize: 9,
                        color: Color(0xFF8A939B),
                      ),
                    ),
                    Text(
                      order['amount'] ?? '',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF39434B),
                      ),
                    ),
                  ],
                ),

                Text(
                  order['date'] ?? '',
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: Color(0xFF8A939B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

   switch (status) {
    case 'Accepted':
      backgroundColor = const Color(0xFFE3F6EE);
      textColor = const Color(0xFF08795D);
      break;

    case 'Rejected':
      backgroundColor = const Color(0xFFFFE1E1);
      textColor = const Color(0xFFE55353);
      break;

    case 'Confirmed':
      backgroundColor = const Color(0xFFE3F6EE);
      textColor = const Color(0xFF08795D);
      break;

    case 'Shipped':
      backgroundColor = const Color(0xFFE7F0FF);
      textColor = const Color(0xFF3569B8);
      break;

    case 'Pending Accept':
    default:
      backgroundColor = const Color(0xFFFFF0C2);
      textColor = const Color(0xFFC48A00);
      break;
  }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  // ============================================================
  // OPEN ORDER DETAILS
  // ============================================================
Future<void> _openOrderDetails(
  Map<String, String> order,
) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return OrderDetailsScreen(
          orderId: order['orderId'] ?? '',
          buyerName: order['buyer'] ?? '',
          buyerAddress: order['address'] ?? '',
          productName: order['product'] ?? '',
          quantity: order['quantity'] ?? '',
          price: order['price'] ?? '',
          logistics: order['logistics'] ?? '',
          totalAmount: order['total'] ?? '',
        );
      },
    ),
  );

  // ============================================================
  // ACCEPTED
  // ============================================================

  if (result == 'accepted') {
    setState(() {
      order['status'] = 'Accepted';
    });
  }

  // ============================================================
  // REJECTED
  // ============================================================

  if (result == 'rejected') {
    setState(() {
      order['status'] = 'Rejected';

    });
  }
}

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    String message;

    switch (selectedTab) {
      case 1:
        message = 'No confirmed orders';
        break;

      case 2:
        message = 'No shipped orders';
        break;

      default:
        message = 'No pending orders';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEAF5F1),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 28,
              color: Color(0xFF075B47),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5560),
            ),
          ),
        ],
      ),
    );
  }
}