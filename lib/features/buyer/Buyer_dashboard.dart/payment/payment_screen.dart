import 'package:farmdirect/Authentification/screens/Register_screen/successful_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/order/order_success.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final int totalAmount;

  const PaymentScreen({
    super.key,
    this.totalAmount = 805,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // ============================================================
  // SELECTED PAYMENT
  // 0 = UPI
  // 1 = Card
  // 2 = COD
  // ============================================================

  int selectedPayment = 0;

  // ============================================================
  // UPI ID
  // ============================================================

  final TextEditingController upiController =
      TextEditingController(text: 'priyasharma@okaxis');

  bool upiVerified = false;

  @override
  void dispose() {
    upiController.dispose();
    super.dispose();
  }

  // ============================================================
  // VERIFY UPI
  // ============================================================

  void _verifyUPI() {
    if (upiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your UPI ID'),
        ),
      );
      return;
    }

    setState(() {
      upiVerified = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('UPI ID verified successfully'),
      ),
    );
  }

  // ============================================================
  // PAY SECURELY
  // ============================================================

  void _paySecurely() {
    if (selectedPayment == 0 && !upiVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify your UPI ID first'),
        ),
      );
      return;
    }

    if (selectedPayment == 0) {
      _showPaymentSuccess();
    } else if (selectedPayment == 1) {
      _showCardMessage();
    } else {
      _showCODConfirmation();
    }
  }

  // ============================================================
  // PAYMENT SUCCESS
  // ============================================================

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Payment Successful',
            style: TextStyle(
              color: Color(0xFF145C4A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '₹${widget.totalAmount} has been paid successfully.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                // Navigate to Order Success / Orders screen
                SuccessScreen();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF82D20B),
                foregroundColor: const Color(0xFF145C4A),
              ),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // CARD MESSAGE
  // ============================================================

  void _showCardMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Card payment screen will open here.',
        ),
      ),
    );
  }

  // ============================================================
  // COD CONFIRMATION
  // ============================================================

  void _showCODConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm COD',
            style: TextStyle(
              color: Color(0xFF145C4A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Pay ₹${widget.totalAmount} when your order is delivered?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderSuccessScreen()));

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Order placed with Cash on Delivery',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF82D20B),
                foregroundColor: const Color(0xFF145C4A),
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
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

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF333333),
            size: 21,
          ),
        ),

        title: const Text(
          'Choose Payment',
          style: TextStyle(
            color: Color(0xFF145C4A),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                7,
                10,
                7,
                20,
              ),
              child: Column(
                children: [
                  // UPI
                  _buildUPIPayment(),

                  const SizedBox(height: 9),

                  // Card
                  _buildPaymentOption(
                    index: 1,
                    title: 'Credit / Debit Card',
                    icon: Icons.credit_card_outlined,
                  ),

                  const SizedBox(height: 9),

                  // COD
                  _buildPaymentOption(
                    index: 2,
                    title: 'Cash on Delivery (COD)',
                    icon: Icons.payments_outlined,
                  ),

                  const SizedBox(height: 15),

                  // Security information
                  _buildSecurityInfo(),
                ],
              ),
            ),
          ),

          // Pay button
          _buildPayButton(),
        ],
      ),
    );
  }

  // ============================================================
  // UPI PAYMENT
  // ============================================================

  Widget _buildUPIPayment() {
    final bool selected = selectedPayment == 0;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = 0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.fromLTRB(
          10,
          10,
          10,
          9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected
                ? const Color(0xFF176B53)
                : const Color(0xFFE2E6E6),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 15,
                  color: Color(0xFF176B53),
                ),

                const SizedBox(width: 8),

                const Expanded(
                  child: Text(
                    'UPI Payment',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),

                _radioButton(selected),
              ],
            ),

            const SizedBox(height: 7),

            // UPI input
            Container(
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8F8),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: const Color(0xFFE7EAEA),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: upiController,
                      enabled: selected,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF555555),
                      ),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 9,
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter UPI ID',
                        hintStyle: TextStyle(
                          fontSize: 9,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: selected ? _verifyUPI : null,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      upiVerified ? 'Verified' : 'Verify',
                      style: TextStyle(
                        color: upiVerified
                            ? const Color(0xFF20A56F)
                            : const Color(0xFF20A56F),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
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
  // CARD / COD OPTION
  // ============================================================

  Widget _buildPaymentOption({
    required int index,
    required String title,
    required IconData icon,
  }) {
    final bool selected = selectedPayment == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFF176B53)
                : const Color(0xFFE3E7E7),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: Colors.grey,
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444444),
                ),
              ),
            ),

            _radioButton(selected),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RADIO BUTTON
  // ============================================================

  Widget _radioButton(bool selected) {
    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? const Color(0xFF145C4A)
              : const Color(0xFFD9DDDD),
          width: selected ? 2 : 1,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF145C4A),
                ),
              ),
            )
          : null,
    );
  }

  // ============================================================
  // SECURITY INFO
  // ============================================================

  Widget _buildSecurityInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.verified_user_outlined,
          size: 10,
          color: Color(0xFF20A56F),
        ),

        const SizedBox(width: 4),

        const Text(
          'Secure 256-bit SSL',
          style: TextStyle(
            fontSize: 7,
            color: Colors.grey,
          ),
        ),

        const SizedBox(width: 15),

        const Icon(
          Icons.verified_user_outlined,
          size: 10,
          color: Color(0xFF20A56F),
        ),

        const SizedBox(width: 4),

        const Text(
          '100% Refund Guarantee',
          style: TextStyle(
            fontSize: 7,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAY BUTTON
  // ============================================================

  Widget _buildPayButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        7,
        7,
        7,
        10,
      ),
      color: const Color(0xFFF7F8F8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: _paySecurely,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF82D20B),
              foregroundColor: const Color(0xFF145C4A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Pay Securely • ₹${widget.totalAmount}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}