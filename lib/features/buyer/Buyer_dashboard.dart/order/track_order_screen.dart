import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final String buyerName;
  final String buyerAddress;
  final String productName;
  final String quantity;
  final String price;
  final String logistics;
  final String totalAmount;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.buyerName,
    required this.buyerAddress,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.logistics,
    required this.totalAmount
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen =
      Color(0xFF006B4F);

  static const Color darkGreen =
      Color(0xFF075B49);

  static const Color backgroundColor =
      Color(0xFFF7F9F8);

  static const Color textColor =
      Color(0xFF26332F);

  static const Color secondaryText =
      Color(0xFF7E8985);

  static const Color borderColor =
      Color(0xFFE1E7E4);

  static const Color discountGreen =
      Color(0xFF2E9D6F);

  static const Color lightGreen =
      Color(0xFFEAF7F2);

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

            _buildHeader(context),

            // ==================================================
            // SCROLLABLE CONTENT
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(
                  7,
                  8,
                  7,
                  15,
                ),

                child: Column(
                  children: [
                    // ------------------------------------------
                    // DELIVERY STATUS
                    // ------------------------------------------

                    _buildDeliveryStatus(),

                    const SizedBox(height: 8),

                    // ------------------------------------------
                    // FARMER / FPO
                    // ------------------------------------------

                    _buildFarmerCard(),

                    const SizedBox(height: 9),

                    // ------------------------------------------
                    // ORDERED ITEMS
                    // ------------------------------------------

                    _buildOrderedItems(),

                    const SizedBox(height: 9),

                    // ------------------------------------------
                    // DELIVERY ADDRESS
                    // ------------------------------------------

                    _buildDeliveryAddress(),

                    const SizedBox(height: 9),

                    // ------------------------------------------
                    // PAYMENT SUMMARY
                    // ------------------------------------------

                    _buildPaymentSummary(),

                    const SizedBox(height: 10),

                    // ------------------------------------------
                    // ACTION BUTTONS
                    // ------------------------------------------

                    _buildActionButtons(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ==================================================
            // BOTTOM NAVIGATION
            // ==================================================

            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 49,

      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),

      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 0.7,
          ),
        ),
      ),

      child: Row(
        children: [
          // ==================================================
          // BACK BUTTON
          // ==================================================

          Container(
            width: 28,
            height: 28,

            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius:
                  BorderRadius.circular(8),
            ),

            child: IconButton(
              padding: EdgeInsets.zero,

              onPressed: () {
                Navigator.pop(context);
              },

              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 11,
                color: primaryGreen,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ==================================================
          // ORDER INFORMATION
          // ==================================================

          Column(
            mainAxisAlignment:
                MainAxisAlignment.center,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: const [
              Text(
                "Order #FD-894201",

                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w800,
                  color: darkGreen,
                ),
              ),

              SizedBox(height: 2),

              Text(
                "Placed on 24 Oct 2026, 10:30 AM",

                style: TextStyle(
                  fontSize: 7,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY STATUS
  // ============================================================

  Widget _buildDeliveryStatus() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "Delivery Status",

            style: TextStyle(
              fontSize: 9,
              fontWeight:
                  FontWeight.w800,
              color: textColor,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              _buildStatusStep(
                title: "Placed",
                completed: true,
              ),

              _buildStatusLine(
                completed: true,
              ),

              _buildStatusStep(
                title: "Confirmed",
                completed: true,
              ),

              _buildStatusLine(
                completed: true,
              ),

              _buildStatusStep(
                title: "Shipped",
                completed: true,
              ),

              _buildStatusLine(
                completed: false,
              ),

              _buildStatusStep(
                title: "Delivery",
                completed: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS STEP
  // ============================================================

  Widget _buildStatusStep({
    required String title,
    required bool completed,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 16,
            height: 16,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: completed
                  ? primaryGreen
                  : Colors.white,

              border: Border.all(
                color: completed
                    ? primaryGreen
                    : const Color(0xFFDDE3E0),
                width: 1,
              ),
            ),

            child: completed
                ? const Icon(
                    Icons.check,
                    size: 10,
                    color: Colors.white,
                  )
                : null,
          ),

          const SizedBox(height: 3),

          Text(
            title,

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 6.5,
              fontWeight: completed
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: completed
                  ? primaryGreen
                  : secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS LINE
  // ============================================================

  Widget _buildStatusLine({
    required bool completed,
  }) {
    return Expanded(
      child: Container(
        height: 2,

        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        color: completed
            ? primaryGreen
            : const Color(0xFFE0E5E2),
      ),
    );
  }

  // ============================================================
  // FARMER CARD
  // ============================================================

  Widget _buildFarmerCard() {
    return _buildCard(
      child: Row(
        children: [
          // ==================================================
          // FARM IMAGE
          // ==================================================

          Container(
            width: 39,
            height: 39,

            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(7),

              color: lightGreen,
            ),

            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(7),

              child: Image.asset(
                "assets/images/farm.jpg",

                fit: BoxFit.cover,

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.agriculture,
                    color: primaryGreen,
                    size: 20,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 8),

          // ==================================================
          // FARMER INFORMATION
          // ==================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  "GreenLand FPO",

                  style: TextStyle(
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w800,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  "Ratnagiri Farms • Certified Green Producer",

                  style: TextStyle(
                    fontSize: 6.5,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // RATING
          // ==================================================

          Row(
            children: const [
              Icon(
                Icons.star,
                size: 10,
                color: Color(0xFFFFB300),
              ),

              SizedBox(width: 2),

              Text(
                "4.9",
                style: TextStyle(
                  fontSize: 7,
                  fontWeight:
                      FontWeight.w700,
                  color: Color(0xFFFF9F00),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ORDERED ITEMS
  // ============================================================

  Widget _buildOrderedItems() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        const Padding(
          padding: EdgeInsets.only(
            left: 5,
            bottom: 6,
          ),

          child: Text(
            "Ordered Items",

            style: TextStyle(
              fontSize: 8,
              fontWeight:
                  FontWeight.w800,
              color: textColor,
            ),
          ),
        ),

        // ----------------------------------------------
        // TOMATOES
        // ----------------------------------------------

        _buildProductItem(
          image:
              "assets/images/tomatoes.jpg",
          name: "Organic Tomatoes",
          quantity: "Quantity: 2 kg",
          price: "₹40",
        ),

        const SizedBox(height: 7),

        // ----------------------------------------------
        // MANGOES
        // ----------------------------------------------

        _buildProductItem(
          image:
              "assets/images/mango.jpg",
          name: "Alphonso Mangoes",
          quantity: "Quantity: 1 dozen",
          price: "₹450",
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCT ITEM
  // ============================================================

  Widget _buildProductItem({
    required String image,
    required String name,
    required String quantity,
    required String price,
  }) {
    return Container(
      height: 45,

      padding: const EdgeInsets.all(5),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(9),

        border: Border.all(
          color: borderColor,
          width: 0.8,
        ),
      ),

      child: Row(
        children: [
          // ----------------------------------------------
          // PRODUCT IMAGE
          // ----------------------------------------------

          ClipRRect(
            borderRadius:
                BorderRadius.circular(6),

            child: Image.asset(
              image,

              width: 34,
              height: 34,

              fit: BoxFit.cover,

              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  width: 34,
                  height: 34,

                  color: lightGreen,

                  child: const Icon(
                    Icons.image_outlined,
                    size: 17,
                    color: primaryGreen,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 8),

          // ----------------------------------------------
          // PRODUCT NAME
          // ----------------------------------------------

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  name,

                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight:
                        FontWeight.w700,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  quantity,

                  style: const TextStyle(
                    fontSize: 6.5,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------
          // PRICE
          // ----------------------------------------------

          Text(
            price,

            style: const TextStyle(
              fontSize: 8,
              fontWeight:
                  FontWeight.w800,
              color: primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY ADDRESS
  // ============================================================

  Widget _buildDeliveryAddress() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "Delivery Address",

            style: TextStyle(
              fontSize: 8,
              fontWeight:
                  FontWeight.w800,
              color: primaryGreen,
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            "Priya Sharma",

            style: TextStyle(
              fontSize: 8,
              fontWeight:
                  FontWeight.w700,
              color: textColor,
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            "Flat 402, Sector 15, Dwarka, Delhi NCR, 110075",

            style: TextStyle(
              fontSize: 6.5,
              color: secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT SUMMARY
  // ============================================================

  Widget _buildPaymentSummary() {
    return _buildCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ----------------------------------------------
          // TITLE
          // ----------------------------------------------

          const Text(
            "Payment Summary",

            style: TextStyle(
              fontSize: 8,
              fontWeight:
                  FontWeight.w800,
              color: primaryGreen,
            ),
          ),

          const SizedBox(height: 7),

          // ----------------------------------------------
          // ITEMS TOTAL
          // ----------------------------------------------

          _buildPaymentRow(
            title: "Items Total",
            amount: "₹490",
          ),

          const SizedBox(height: 5),

          // ----------------------------------------------
          // DELIVERY FEE
          // ----------------------------------------------

          _buildPaymentRow(
            title: "Delivery Fee",
            amount: "₹40",
          ),

          const SizedBox(height: 5),

          // ----------------------------------------------
          // PROMOTIONAL DISCOUNT
          // ----------------------------------------------

          _buildPaymentRow(
            title: "Promotional Discount",
            amount: "-₹50",
            amountColor: discountGreen,
          ),

          const SizedBox(height: 8),

          const Divider(
            height: 1,
            thickness: 0.7,
            color: borderColor,
          ),

          const SizedBox(height: 7),

          // ----------------------------------------------
          // TOTAL PAID
          // ----------------------------------------------

          Row(
            children: [
              const Expanded(
                child: Text(
                  "Total Paid",

                  style: TextStyle(
                    fontSize: 9,
                    fontWeight:
                        FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),

              const Text(
                "₹480",

                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w800,
                  color: primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT ROW
  // ============================================================

  Widget _buildPaymentRow({
    required String title,
    required String amount,
    Color amountColor =
        secondaryText,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,

            style: const TextStyle(
              fontSize: 7,
              color: secondaryText,
            ),
          ),
        ),

        Text(
          amount,

          style: TextStyle(
            fontSize: 7,
            color: amountColor,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget _buildActionButtons() {
    return Row(
      children: [
        // ----------------------------------------------
        // CONTACT FARMER
        // ----------------------------------------------

        Expanded(
          child: SizedBox(
            height: 30,

            child: OutlinedButton(
              onPressed: () {
                _contactFarmer();
              },

              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    primaryGreen,

                side:
                    const BorderSide(
                  color: primaryGreen,
                  width: 1,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),

              child: const Text(
                "Contact Farmer",

                style: TextStyle(
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 7),

        // ----------------------------------------------
        // DOWNLOAD INVOICE
        // ----------------------------------------------

        Expanded(
          child: SizedBox(
            height: 30,

            child: ElevatedButton(
              onPressed: () {
                _downloadInvoice();
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryGreen,

                foregroundColor:
                    Colors.white,

                elevation: 0,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),
              ),

              child: const Text(
                "Download Invoice",

                style: TextStyle(
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      height: 51,

      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 0.7,
          ),
        ),
      ),

      child: Row(
        children: [
          _buildBottomItem(
            icon: Icons.home_outlined,
            title: "Home",
          ),

          _buildBottomItem(
            icon: Icons.search,
            title: "Market",
          ),

          _buildBottomItem(
            icon: Icons.shopping_cart_outlined,
            title: "Cart",
          ),

          _buildBottomItem(
            icon: Icons.receipt_long_outlined,
            title: "Orders",
            selected: true,
          ),

          _buildBottomItem(
            icon: Icons.person_outline,
            title: "Profile",
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM NAV ITEM
  // ============================================================

  Widget _buildBottomItem({
    required IconData icon,
    required String title,
    bool selected = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Icon(
            icon,
            size: 16,

            color: selected
                ? primaryGreen
                : secondaryText,
          ),

          const SizedBox(height: 2),

          Text(
            title,

            style: TextStyle(
              fontSize: 6.5,
              fontWeight: selected
                  ? FontWeight.w700
                  : FontWeight.w500,

              color: selected
                  ? primaryGreen
                  : secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON CARD
  // ============================================================

  Widget _buildCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(9),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(10),

        border: Border.all(
          color: borderColor,
          width: 0.8,
        ),
      ),

      child: child,
    );
  }

  // ============================================================
  // CONTACT FARMER
  // ============================================================

  void _contactFarmer() {
    // TODO:
    // Connect to phone call / chat.

    // Example:
    // launchUrl(Uri.parse("tel:+91XXXXXXXXXX"));

    debugPrint(
      "Contact Farmer",
    );
  }

  // ============================================================
  // DOWNLOAD INVOICE
  // ============================================================

  void _downloadInvoice() {
    // TODO:
    // Generate/download actual invoice.

    debugPrint(
      "Download Invoice",
    );
  }
}