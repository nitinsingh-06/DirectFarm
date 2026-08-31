import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/payment/payment_screen.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final int totalAmount;

  const CheckoutScreen({
    super.key,
    this.totalAmount = 805,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // ============================================================
  // SELECTED DELIVERY SLOT
  // ============================================================

  int selectedSlot = 0;

  // ============================================================
  // SELECTED PAYMENT METHOD
  // ============================================================

  int selectedPayment = 0;

  // ============================================================
  // DELIVERY SLOTS
  // ============================================================

  final List<Map<String, String>> deliverySlots = [
    {
      'title': 'Tomorrow',
      'time': '07 AM - 11 AM',
    },
    {
      'title': 'Next Day',
      'time': '08 AM - 12 PM',
    },
  ];

  // ============================================================
  // PLACE ORDER
  // ============================================================

void _placeOrder() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentScreen(
        totalAmount: widget.totalAmount,
      ),
    ),
  );
}
  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: const Text(
          'Checkout Flow',
          style: TextStyle(
            color: Color(0xFF145C4A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF333333),
            size: 21,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          // Green progress indicator
          _buildProgressBar(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                11,
                12,
                11,
                20,
              ),
              child: Column(
                children: [
                  // Delivery Address
                  _buildDeliveryAddress(),

                  const SizedBox(height: 12),

                  // Delivery Slot
                  _buildDeliverySlot(),

                  const SizedBox(height: 12),

                  // Order Summary
                  _buildOrderSummary(),

                  const SizedBox(height: 12),

                  // Payment Method
                  _buildPaymentMethod(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Place Order
          _buildPlaceOrderButton(),
        ],
      ),
    );
  }

  // ============================================================
  // PROGRESS BAR
  // ============================================================

  Widget _buildProgressBar() {
    return Container(
      height: 3,
      width: double.infinity,
      color: const Color(0xFFE5E8E8),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.67,
        child: Container(
          color: const Color(0xFF82D20B),
        ),
      ),
    );
  }

  // ============================================================
  // DELIVERY ADDRESS
  // ============================================================

  Widget _buildDeliveryAddress() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),

              TextButton(
                onPressed: () {
                  // Later open address selection screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Change address'),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: Color(0xFF20A56F),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            'Priya Sharma (Home)',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF444444),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'A-102, Shanti Vihar Apartments, Sector 12, Dwarka, New Delhi - 110075',
            style: TextStyle(
              fontSize: 9,
              height: 1.4,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY SLOT
  // ============================================================

  Widget _buildDeliverySlot() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Delivery Slot',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: List.generate(
              deliverySlots.length,
              (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == 0 ? 5 : 0,
                      left: index == 1 ? 5 : 0,
                    ),
                    child: _deliverySlotCard(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY SLOT CARD
  // ============================================================

  Widget _deliverySlotCard(int index) {
    final bool selected = selectedSlot == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedSlot = index;
        });
      },
      borderRadius: BorderRadius.circular(9),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFEFFFF5)
              : Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: selected
                ? const Color(0xFF20B77A)
                : const Color(0xFFE4E7E7),
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              deliverySlots[index]['title']!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: selected
                    ? const Color(0xFF145C4A)
                    : const Color(0xFF444444),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              deliverySlots[index]['time']!,
              style: TextStyle(
                fontSize: 8,
                color: selected
                    ? const Color(0xFF20A56F)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ORDER SUMMARY
  // ============================================================

  Widget _buildOrderSummary() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 10),

          _summaryRow(
            '2 Dozen Alphonso Mango',
            '₹900',
          ),

          const SizedBox(height: 7),

          _summaryRow(
            '3 Fresh Cauliflower',
            '₹105',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY ROW
  // ============================================================

  Widget _summaryRow(
    String product,
    String price,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          product,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.grey,
          ),
        ),

        Text(
          price,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAYMENT METHOD
  // ============================================================

  Widget _buildPaymentMethod() {
    return _sectionContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 10),

          InkWell(
            onTap: () {
              setState(() {
                selectedPayment = 0;
              });
            },
            borderRadius: BorderRadius.circular(9),
            child: Container(
              height: 29,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: const Color(0xFFE4E7E7),
                ),
              ),
              child: Row(
                children: [
                  // UPI icon
                  Container(
                    width: 13,
                    height: 13,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 13,
                      color: Color(0xFF20A56F),
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Expanded(
                    child: Text(
                      'UPI (GPay / PhonePe)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF444444),
                      ),
                    ),
                  ),

                  // Radio
                  Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF145C4A),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF145C4A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PLACE ORDER BUTTON
  // ============================================================

  Widget _buildPlaceOrderButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        11,
        8,
        11,
        10,
      ),
      color: const Color(0xFFF7F8F8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF82D20B),
              foregroundColor: const Color(0xFF145C4A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: Text(
              'Place Order • ₹${widget.totalAmount}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COMMON SECTION CONTAINER
  // ============================================================

  Widget _sectionContainer({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFE5E8E8),
        ),
      ),
      child: child,
    );
  }
}