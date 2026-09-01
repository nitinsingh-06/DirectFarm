import 'package:farmdirect/features/farmer/dashboard/order_details_screen.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF006B4F);
  static const Color backgroundColor = Color(0xFFF7F9F8);
  static const Color textColor = Color(0xFF26332F);
  static const Color secondaryText = Color(0xFF89938F);
  static const Color borderColor = Color(0xFFE2E7E5);

  // ============================================================
  // SELECTED TAB
  // ============================================================

  int selectedTab = 0;

  final List<String> tabs = ["Active (2)", "Completed", "Cancelled"];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // FIXED HEADER
            // ==================================================
            _buildHeader(),

            // ==================================================
            // FIXED FILTER TABS
            // ==================================================
            _buildTabs(),

            // ==================================================
            // SCROLLABLE ORDERS
            // ==================================================
            Expanded(child: _buildOrdersList()),
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
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,

      child: Row(
        children: [
          const Text(
            "My Orders",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: primaryGreen,
            ),
          ),

          const Spacer(),

          // Search / filter button
          Container(
            width: 30,
            height: 30,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: borderColor),
            ),

            child: const Icon(
              Icons.circle_outlined,
              size: 13,
              color: primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs() {
    return Container(
      height: 42,
      color: Colors.white,

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),

      child: Row(
        children: List.generate(tabs.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 7),
            child: _buildTab(title: tabs[index], index: index),
          );
        }),
      ),
    );
  }

  // ============================================================
  // SINGLE TAB
  // ============================================================

  Widget _buildTab({required String title, required int index}) {
    final bool isSelected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),

        padding: const EdgeInsets.symmetric(horizontal: 13),

        decoration: BoxDecoration(
          color: isSelected ? primaryGreen : Colors.white,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: isSelected ? primaryGreen : borderColor),
        ),

        child: Center(
          child: Text(
            title,

            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,

              color: isSelected ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ORDERS LIST
  // ============================================================

  Widget _buildOrdersList() {
    return ListView(
      physics: const BouncingScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(9, 9, 9, 25),

      children: [
        _buildOrderCard(
          orderNumber: "#FD-894201",
          date: "26 Oct 2026",
          status: "Processing",
          statusColor: const Color(0xFFFFB300),
          statusBackground: const Color(0xFFFFF1C7),

          seller: "GreenLand FPO",
          products: "Organic Tomatoes, Alphonso Mangoes",
          itemCount: "3 items total",
          amount: "₹730",

          // Order Details
          buyerName: "Priya Sharma",

          buyerAddress: "Flat 402, Sector 15, Dwarka, Delhi NCR, 110075",

          productName: "Organic Tomatoes",

          quantity: "2 kg",

          price: "40",

          logistics: "40",

          totalAmount: "730",
        ),

        const SizedBox(height: 10),
        _buildOrderCard(
          orderNumber: "#FD-893112",
          date: "22 Oct 2026",
          status: "Shipped",

          statusColor: const Color(0xFF4D8EFF),
          statusBackground: const Color(0xFFE4EEFF),

          seller: "Ratnagiri Farms FPO",

          products: "Fresh Cauliflower, Organic Green Chillies",

          itemCount: "2 items total",

          amount: "₹205",

          // Order Details
          buyerName: "Priya Sharma",

          buyerAddress: "Flat 402, Sector 15, Dwarka, Delhi NCR, 110075",

          productName: "Fresh Cauliflower",

          quantity: "2 kg",

          price: "205",

          logistics: "40",

          totalAmount: "205",
        ),

        const SizedBox(height: 10),

        // Example third order

      ],
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================

  Widget _buildOrderCard({
    required String orderNumber,
    required String date,
    required String status,
    required Color statusColor,
    required Color statusBackground,
    required String seller,
    required String products,
    required String itemCount,
    required String amount,

    // Order details
    required String buyerName,
    required String buyerAddress,
    required String productName,
    required String quantity,
    required String price,
    required String logistics,
    required String totalAmount,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(11, 10, 10, 9),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(11),

        border: Border.all(color: borderColor, width: 0.8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ==================================================
          // ORDER NUMBER + STATUS
          // ==================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Order $orderNumber",

                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      "Placed on $date",

                      style: const TextStyle(fontSize: 8, color: secondaryText),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------
              // STATUS
              // ------------------------------------------
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: statusBackground,

                  borderRadius: BorderRadius.circular(6),
                ),

                child: Text(
                  status,

                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          // ==================================================
          // SELLER
          // ==================================================
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Seller: ",
                  style: TextStyle(
                    fontSize: 8,
                    color: primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                TextSpan(
                  text: seller,
                  style: const TextStyle(
                    fontSize: 8,
                    color: primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 3),

          // ==================================================
          // PRODUCTS
          // ==================================================
          Text(
            products,

            maxLines: 1,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(fontSize: 8, color: textColor),
          ),

          const SizedBox(height: 3),

          // ==================================================
          // ITEM COUNT
          // ==================================================
          Text(
            itemCount,

            style: const TextStyle(fontSize: 8, color: secondaryText),
          ),

          const SizedBox(height: 7),

          // ==================================================
          // DIVIDER
          // ==================================================
          const Divider(height: 1, thickness: 0.7, color: borderColor),

          const SizedBox(height: 7),

          // ==================================================
          // TOTAL + TRACK ORDER
          // ==================================================
          Row(
            children: [
              // ------------------------------------------
              // TOTAL
              // ------------------------------------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Total Amount",

                      style: TextStyle(fontSize: 7, color: secondaryText),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      amount,

                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------
              // TRACK ORDER
              // ------------------------------------------
              SizedBox(
                height: 25,

                child: ElevatedButton(
                  onPressed: () {
                    _trackOrder(orderNumber);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsScreen(
                          orderId: orderNumber,
                          buyerName: buyerName,
                          buyerAddress: buyerAddress,
                          productName: productName,
                          quantity: quantity,
                          price: price,
                          logistics: logistics,
                          totalAmount: totalAmount,
                        ),
                      ),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    padding: const EdgeInsets.symmetric(horizontal: 12),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),

                  child: const Text(
                    "Track Order",

                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
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
  // TRACK ORDER
  // ============================================================

  void _trackOrder(String orderNumber) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Tracking order $orderNumber")));
  }
}
