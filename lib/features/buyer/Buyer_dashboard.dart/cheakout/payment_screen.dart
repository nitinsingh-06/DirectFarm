import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/cheakout/confirm_order.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final double itemsTotal;

  final String deliveryDate;
  final String deliverySlot;
  final String deliveryInstructions;

  final double deliveryCharge;
  final double platformFee;

  const PaymentScreen({
    super.key,
    required this.itemsTotal,
    required this.deliveryDate,
    required this.deliverySlot,
    required this.deliveryInstructions,
    required this.deliveryCharge,
    required this.platformFee,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF087C59);
  static const Color lightGreen = Color(0xFFE9F8F2);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF71807A);
  static const Color borderColor = Color(0xFFE1E9E5);

  // ============================================================
  // SELECTED PAYMENT METHOD
  // ============================================================

  int selectedPayment = 0;

  // ============================================================
  // PAYMENT METHODS
  // ============================================================

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'title': 'UPI',
      'subtitle': 'Pay quickly and securely using UPI',
      'icon': Icons.account_balance_wallet_outlined,
      'recommended': true,
    },
    {
      'title': 'Credit / Debit Card',
      'subtitle': 'Pay using your credit or debit card',
      'icon': Icons.credit_card_outlined,
      'recommended': false,
    },
    {
      'title': 'Cash on Delivery',
      'subtitle': 'Pay when you receive your order',
      'icon': Icons.payments_outlined,
      'recommended': false,
    },
    {
      'title': 'Net Banking',
      'subtitle': 'Pay using your bank account',
      'icon': Icons.account_balance_outlined,
      'recommended': false,
    },
  ];

  // ============================================================
  // TOTAL
  // ============================================================

  double get totalAmount {
    return widget.itemsTotal +
        widget.deliveryCharge +
        widget.platformFee;
  }

  // ============================================================
  // SELECTED PAYMENT METHOD
  // ============================================================

  String get selectedPaymentMethod {
    return paymentMethods[selectedPayment]['title'] as String;
  }

  // ============================================================
  // CONTINUE TO CONFIRM
  // ============================================================

  void _continueToConfirm() {
    final paymentMethod = selectedPaymentMethod;

    debugPrint('==============================');
    debugPrint('PAYMENT');
    debugPrint('==============================');

    debugPrint('Payment method: $paymentMethod');
    debugPrint('Delivery date: ${widget.deliveryDate}');
    debugPrint('Delivery slot: ${widget.deliverySlot}');
    debugPrint(
      'Instructions: ${widget.deliveryInstructions}',
    );
    debugPrint(
      'Items total: ₹${widget.itemsTotal.toStringAsFixed(2)}',
    );
    debugPrint(
      'Delivery charge: ₹${widget.deliveryCharge.toStringAsFixed(2)}',
    );
    debugPrint(
      'Platform fee: ₹${widget.platformFee.toStringAsFixed(2)}',
    );
    debugPrint(
      'Total: ₹${totalAmount.toStringAsFixed(2)}',
    );

    // ==========================================================
    // UPI WILL BE IMPLEMENTED LATER
    // ==========================================================

    if (selectedPayment == 0) {
      // For now we allow the user to continue.
      // Actual UPI gateway integration will be added later.
    }

    // ==========================================================
    // GO TO CONFIRM ORDER
    // ==========================================================

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmOrderScreen(
          deliveryDate: widget.deliveryDate,
          deliverySlot: widget.deliverySlot,
          deliveryInstructions: widget.deliveryInstructions,

          // THIS COMES FROM THE PAYMENT SCREEN
          paymentMethod: paymentMethod,

          deliveryCharge: widget.deliveryCharge,
          platformFee: widget.platformFee,
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
      backgroundColor: const Color(0xFFF5F8F6),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: textDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Checkout Flow',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // CHECKOUT STEPPER
            // ==================================================

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(
                18,
                5,
                18,
                12,
              ),
              child: _buildCheckoutStepper(),
            ),

            // ==================================================
            // CONTENT
            // ==================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  8,
                  8,
                  90,
                ),
                child: Column(
                  children: [
                    _buildPaymentMethodCard(),

                    const SizedBox(height: 8),

                    _buildSecurityCard(),

                    const SizedBox(height: 8),

                    _buildPaymentSummary(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM BUTTON
      // ========================================================

      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ============================================================
  // CHECKOUT STEPPER
  // ============================================================

  Widget _buildCheckoutStepper() {
    return Row(
      children: [
        _buildStep(
          icon: Icons.check_rounded,
          number: null,
          title: 'Address',
          active: true,
        ),

        _buildLine(true),

        _buildStep(
          icon: Icons.check_rounded,
          number: null,
          title: 'Delivery',
          active: true,
        ),

        _buildLine(true),

        _buildStep(
          icon: null,
          number: '3',
          title: 'Payment',
          active: true,
        ),

        _buildLine(false),

        _buildStep(
          icon: null,
          number: '4',
          title: 'Confirm',
          active: false,
        ),
      ],
    );
  }

  // ============================================================
  // STEP
  // ============================================================

  Widget _buildStep({
    String? number,
    IconData? icon,
    required String title,
    required bool active,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? primaryGreen
                  : const Color(0xFFE9EFEC),
            ),
            child: Center(
              child: icon != null
                  ? Icon(
                      icon,
                      size: 14,
                      color: Colors.white,
                    )
                  : Text(
                      number ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: active
                            ? Colors.white
                            : const Color(0xFF8D9A95),
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: TextStyle(
              fontSize: 8,
              fontWeight:
                  active ? FontWeight.w700 : FontWeight.w500,
              color: active
                  ? primaryGreen
                  : const Color(0xFF89958F),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STEP LINE
  // ============================================================

  Widget _buildLine(bool active) {
    return Container(
      width: 18,
      height: 1.5,
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      color: active
          ? primaryGreen
          : const Color(0xFFDDE5E1),
    );
  }

  // ============================================================
  // PAYMENT METHOD CARD
  // ============================================================

  Widget _buildPaymentMethodCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // HEADER
          // ====================================================

          Row(
            children: [
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.credit_card_outlined,
                  size: 17,
                  color: primaryGreen,
                ),
              ),

              const SizedBox(width: 8),

              const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textDark,
                    ),
                  ),

                  SizedBox(height: 2),

                  Text(
                    'Choose a convenient payment option',
                    style: TextStyle(
                      fontSize: 7.5,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 9),

          // ====================================================
          // PAYMENT OPTIONS
          // ====================================================

          ...List.generate(
            paymentMethods.length,
            (index) {
              return _buildPaymentOption(index);
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT OPTION
  // ============================================================

  Widget _buildPaymentOption(int index) {
    final method = paymentMethods[index];

    final selected = selectedPayment == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),

        width: double.infinity,

        margin: const EdgeInsets.only(
          bottom: 6,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0FBF7)
              : Colors.white,

          borderRadius: BorderRadius.circular(8),

          border: Border.all(
            color: selected
                ? const Color(0xFF50B58F)
                : borderColor,
            width: selected ? 1.3 : 1,
          ),
        ),

        child: Row(
          children: [
            // ==================================================
            // RADIO
            // ==================================================

            Container(
              width: 19,
              height: 19,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color: selected
                      ? primaryGreen
                      : const Color(0xFFB8C3BE),
                  width: selected ? 1.5 : 1,
                ),
              ),

              child: selected
                  ? const Center(
                      child: Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: primaryGreen,
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 9),

            // ==================================================
            // ICON
            // ==================================================

            Container(
              width: 30,
              height: 30,

              decoration: BoxDecoration(
                color: selected
                    ? lightGreen
                    : const Color(0xFFF4F7F5),

                borderRadius:
                    BorderRadius.circular(7),
              ),

              child: Icon(
                method['icon'] as IconData,
                size: 17,
                color: selected
                    ? primaryGreen
                    : const Color(0xFF65736D),
              ),
            ),

            const SizedBox(width: 8),

            // ==================================================
            // TEXT
            // ==================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method['title'] as String,
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: textDark,
                        ),
                      ),

                      if (method['recommended'] == true)
                        Container(
                          margin: const EdgeInsets.only(
                            left: 5,
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: lightGreen,
                            borderRadius:
                                BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 5.5,
                              fontWeight: FontWeight.w700,
                              color: primaryGreen,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    method['subtitle'] as String,
                    style: const TextStyle(
                      fontSize: 6.5,
                      color: textGrey,
                    ),
                  ),

                  // ==========================================
                  // UPI PLACEHOLDER
                  // ==========================================

                  if (index == 0)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          _buildUpiBrand('G'),
                          _buildUpiBrand('PhonePe'),
                          _buildUpiBrand('Paytm'),
                        ],
                      ),
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
  // UPI BRAND
  // ============================================================

  Widget _buildUpiBrand(String name) {
    return Container(
      margin: const EdgeInsets.only(
        right: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F6),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 5.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF53615C),
        ),
      ),
    );
  }

  // ============================================================
  // SECURITY CARD
  // ============================================================

  Widget _buildSecurityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE9FAF2),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFD4F2E5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: 16,
              color: primaryGreen,
            ),
          ),

          const SizedBox(width: 8),

          const Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '100% Secure Payments',
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),

              SizedBox(height: 2),

              Text(
                'Your payment information is safe with us',
                style: TextStyle(
                  fontSize: 6.5,
                  color: textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT SUMMARY
  // ============================================================

  Widget _buildPaymentSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  size: 16,
                  color: primaryGreen,
                ),
              ),

              const SizedBox(width: 7),

              const Text(
                'Payment Summary',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          _buildSummaryRow(
            'Items Total',
            widget.itemsTotal,
          ),

          const SizedBox(height: 5),

          _buildSummaryRow(
            'Delivery Charge',
            widget.deliveryCharge,
          ),

          const SizedBox(height: 5),

          _buildSummaryRow(
            'Platform Fee',
            widget.platformFee,
          ),

          const SizedBox(height: 7),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE9FAF2),
              borderRadius:
                  BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),

                Text(
                  '₹${totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY ROW
  // ============================================================

  Widget _buildSummaryRow(
    String title,
    double amount,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 7.5,
            color: textGrey,
          ),
        ),

        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM BAR
  // ============================================================

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        12,
        8,
        12,
        10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 46,
          child: ElevatedButton(
            onPressed: _continueToConfirm,

            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Text(
                  'Continue to Confirm',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(width: 7),

                const Icon(
                  Icons.arrow_forward,
                  size: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}