import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int selectedTab = 0;

  final List<String> tabs = [
    'Pending (3)',
    'Confirmed',
    'Shipped',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // =====================================================
          // HEADER
          // =====================================================

          _buildHeader(),

          // =====================================================
          // ORDER STATUS TABS
          // =====================================================

          _buildOrderTabs(),

          // =====================================================
          // ORDERS
          // =====================================================

          Expanded(
            child: _buildOrdersList(),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(11, 13, 11, 9),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8ECEF),
            width: 1,
          ),
        ),
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'My Orders',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF075640),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // ORDER TABS
  // ===========================================================

  Widget _buildOrderTabs() {
    return Container(
      height: 42,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) {
            final bool isSelected = selectedTab == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: 5,
                  top: 7,
                  bottom: 6,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE8F8F1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF168653)
                          : const Color(0xFF7A8491),
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

  // ===========================================================
  // ORDERS LIST
  // ===========================================================

  Widget _buildOrdersList() {
    if (selectedTab == 0) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(
          10,
          8,
          10,
          20,
        ),
        children: [
          _buildOrderCard(
            orderId: '#FD1234',
            buyer: 'Suresh Kumar',
            quantity: '50 kg',
            product: 'Basmati Rice',
            total: '₹4,250',
            time: 'Today, 10:15 AM',
            status: 'Pending Accept',
            statusBackground: const Color(0xFFFFF1C9),
            statusText: const Color(0xFFE59B00),
          ),

          const SizedBox(height: 8),

          _buildOrderCard(
            orderId: '#FD1190',
            buyer: 'Aggarwal Sweet House',
            quantity: '100 kg',
            product: 'Pure Cow Ghee',
            total: '₹65,000',
            time: 'Yesterday',
            status: 'Pending Accept',
            statusBackground: const Color(0xFFFFF1C9),
            statusText: const Color(0xFFE59B00),
          ),
        ],
      );
    }

    if (selectedTab == 1) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(
          10,
          8,
          10,
          20,
        ),
        children: [
          _buildOrderCard(
            orderId: '#FD1178',
            buyer: 'FreshMart Agra',
            quantity: '200 kg',
            product: 'Red Potatoes',
            total: '₹8,400',
            time: 'Yesterday',
            status: 'Confirmed',
            statusBackground: const Color(0xFFE1F4FF),
            statusText: const Color(0xFF2585C7),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        10,
        8,
        10,
        20,
      ),
      children: [
        _buildOrderCard(
          orderId: '#FD1102',
          buyer: 'Organic Hub Delhi',
          quantity: '50 kg',
          product: 'Fresh Tomatoes',
          total: '₹3,000',
          time: '2 days ago',
          status: 'Shipped',
          statusBackground: const Color(0xFFE0ECFF),
          statusText: const Color(0xFF3B82F6),
        ),
      ],
    );
  }

  // ===========================================================
  // ORDER CARD
  // ===========================================================

  Widget _buildOrderCard({
    required String orderId,
    required String buyer,
    required String quantity,
    required String product,
    required String total,
    required String time,
    required String status,
    required Color statusBackground,
    required Color statusText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        10,
        9,
        10,
        10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE1E6EA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------------------------------
          // ORDER ID + STATUS
          // ---------------------------------------------------

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Order $orderId',
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF075640),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: statusText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ---------------------------------------------------
          // DIVIDER
          // ---------------------------------------------------

          Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFFE7EAED),
          ),

          const SizedBox(height: 8),

          // ---------------------------------------------------
          // BUYER
          // ---------------------------------------------------

          Text(
            buyer,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
            ),
          ),

          const SizedBox(height: 2),

          // ---------------------------------------------------
          // PRODUCT
          // ---------------------------------------------------

          Text(
            '$quantity • $product',
            style: const TextStyle(
              fontSize: 8,
              color: Color(0xFF7A8491),
            ),
          ),

          const SizedBox(height: 7),

          // ---------------------------------------------------
          // TOTAL + TIME
          // ---------------------------------------------------

          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(
                        fontSize: 8,
                        color: Color(0xFF7A8491),
                      ),
                    ),
                    TextSpan(
                      text: total,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Text(
                time,
                style: const TextStyle(
                  fontSize: 7.5,
                  color: Color(0xFF7A8491),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}