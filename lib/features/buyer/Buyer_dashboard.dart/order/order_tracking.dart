import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    this.orderId = '#FD-894201',
  });

  @override
  State<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState
    extends State<OrderTrackingScreen> {
  // ----------------------------------------------------------
  // COLORS
  // ----------------------------------------------------------

  static const Color primary = Color(0xFF075C49);
  static const Color green = Color(0xFF80D000);
  static const Color background = Color(0xFFF7F9FA);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF89939A);
  static const Color border = Color(0xFFE1E6E9);

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: _buildBody(),
      ),
    );
  }

  // ----------------------------------------------------------
  // BODY
  // ----------------------------------------------------------

  Widget _buildBody() {
    return Column(
      children: [
        // FIXED HEADER
        _buildHeader(),

        // FIXED ORDER DATE
        _buildOrderDate(),

        // FIXED DELIVERY STATUS
        _buildDeliveryStatus(),

        // SCROLLABLE CONTENT
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 15,
            ),
            child: Column(
              children: [
                _buildFarmerCard(),

                _buildOrderedItems(),

                _buildDeliveryAddress(),

                _buildPaymentSummary(),

                _buildActionButtons(),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      height: 48,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: border,
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 14,
              color: primary,
            ),
          ),

          const SizedBox(width: 8),

          Text(
            'Order ${widget.orderId}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ORDER DATE
  // ----------------------------------------------------------

  Widget _buildOrderDate() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        40,
        0,
        12,
        8,
      ),
      child: const Text(
        'Placed on 24 Oct 2026, 10:30 AM',
        style: TextStyle(
          fontSize: 7.5,
          color: textGrey,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // DELIVERY STATUS
  // ----------------------------------------------------------

  Widget _buildDeliveryStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        10,
        12,
        10,
        10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: border,
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Status',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              _buildStatusStep(
                label: 'Placed',
                active: true,
                completed: true,
              ),

              _buildStatusLine(),

              _buildStatusStep(
                label: 'Confirmed',
                active: true,
                completed: true,
              ),

              _buildStatusLine(),

              _buildStatusStep(
                label: 'Shipped',
                active: true,
                completed: false,
              ),

              _buildStatusLine(),

              _buildStatusStep(
                label: 'Delivery',
                active: false,
                completed: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // STATUS STEP
  // ----------------------------------------------------------

  Widget _buildStatusStep({
    required String label,
    required bool active,
    required bool completed,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? primary
                  : Colors.white,
              border: Border.all(
                color: active
                    ? primary
                    : const Color(0xFFE0E5E7),
                width: 1,
              ),
            ),
            child: active
                ? Icon(
                    completed
                        ? Icons.check
                        : Icons.circle,
                    size: completed ? 9 : 5,
                    color: Colors.white,
                  )
                : null,
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: TextStyle(
              fontSize: 6,
              fontWeight: FontWeight.w600,
              color: active
                  ? primary
                  : textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // STATUS LINE
  // ----------------------------------------------------------

  Widget _buildStatusLine() {
    return Container(
      height: 1.5,
      width: 25,
      margin: const EdgeInsets.only(
        bottom: 13,
      ),
      color: primary,
    );
  }

  // ----------------------------------------------------------
  // FARMER CARD
  // ----------------------------------------------------------

  Widget _buildFarmerCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        7,
        7,
        7,
        0,
      ),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFFE8F3EE),
            ),
            child: const Icon(
              Icons.agriculture,
              size: 18,
              color: primary,
            ),
          ),

          const SizedBox(width: 7),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'GreenLand FPO',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  'Ratnagiri Farms • Certified Green Produce',
                  style: TextStyle(
                    fontSize: 6.5,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          const Row(
            children: [
              Icon(
                Icons.star,
                size: 11,
                color: Color(0xFFFFC107),
              ),

              SizedBox(width: 2),

              Text(
                '4.9',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFFB300),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ORDERED ITEMS
  // ----------------------------------------------------------

  Widget _buildOrderedItems() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        7,
        10,
        7,
        0,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 2,
              bottom: 6,
            ),
            child: Text(
              'Ordered Items',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),
          ),

          _buildProductItem(
            image: 'assets/images/tomato.png',
            name: 'Organic Tomatoes',
            quantity: 'Quantity: 2 kg',
            price: '₹40',
          ),

          const SizedBox(height: 5),

          _buildProductItem(
            image: 'assets/images/mango.png',
            name: 'Alphonso Mangoes',
            quantity: 'Quantity: 1 dozen',
            price: '₹450',
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PRODUCT ITEM
  // ----------------------------------------------------------

  Widget _buildProductItem({
    required String image,
    required String name,
    required String quantity,
    required String price,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: border,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              image,
              height: 38,
              width: 38,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 38,
                  width: 38,
                  color: const Color(0xFFEFF2F1),
                  child: const Icon(
                    Icons.image_outlined,
                    size: 16,
                    color: textGrey,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  quantity,
                  style: const TextStyle(
                    fontSize: 6.5,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          Text(
            price,
            style: const TextStyle(
              fontSize: 7.5,
              fontWeight: FontWeight.w800,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // DELIVERY ADDRESS
  // ----------------------------------------------------------

  Widget _buildDeliveryAddress() {
    return _buildSectionCard(
      marginTop: 10,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Address',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w800,
              color: primary,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Priya Sharma',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'Flat 402, Sector 15, Dwarka, Delhi NCR, 110075',
            style: TextStyle(
              fontSize: 6.5,
              color: textGrey,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PAYMENT SUMMARY
  // ----------------------------------------------------------

  Widget _buildPaymentSummary() {
    return _buildSectionCard(
      marginTop: 7,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w800,
              color: primary,
            ),
          ),

          const SizedBox(height: 6),

          _buildAmountRow(
            'Items Total',
            '₹490',
          ),

          const SizedBox(height: 4),

          _buildAmountRow(
            'Delivery Fee',
            '₹40',
          ),

          const SizedBox(height: 4),

          _buildAmountRow(
            'Promotional Discount',
            '-₹50',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Divider(
              height: 1,
              color: border,
            ),
          ),

          _buildAmountRow(
            'Total Paid',
            '₹480',
            bold: true,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // AMOUNT ROW
  // ----------------------------------------------------------

  Widget _buildAmountRow(
    String title,
    String amount, {
    bool bold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 6.5,
              fontWeight: bold
                  ? FontWeight.w800
                  : FontWeight.w400,
              color: textDark,
            ),
          ),
        ),

        Text(
          amount,
          style: TextStyle(
            fontSize: 7,
            fontWeight: bold
                ? FontWeight.w800
                : FontWeight.w600,
            color: bold
                ? primary
                : textDark,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // SECTION CARD
  // ----------------------------------------------------------

  Widget _buildSectionCard({
    required Widget child,
    required double marginTop,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        7,
        marginTop,
        7,
        0,
      ),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: border,
        ),
      ),
      child: child,
    );
  }

  // ----------------------------------------------------------
  // ACTION BUTTONS
  // ----------------------------------------------------------

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        7,
        10,
        7,
        8,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _contactFarmer,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(
                  0,
                  30,
                ),
                padding: EdgeInsets.zero,
                side: const BorderSide(
                  color: primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Contact Farmer',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: ElevatedButton(
              onPressed: _downloadInvoice,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  0,
                  30,
                ),
                padding: EdgeInsets.zero,
                elevation: 0,
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Download Invoice',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CONTACT FARMER
  // ----------------------------------------------------------

  void _contactFarmer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Contact Farmer feature will be connected to backend.',
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // DOWNLOAD INVOICE
  // ----------------------------------------------------------

  void _downloadInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Invoice download will be connected to backend.',
        ),
      ),
    );
  }
}