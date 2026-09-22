import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/core/provider/address_provider.dart';

class ConfirmOrderScreen extends StatelessWidget {
  final String deliveryDate;
  final String deliverySlot;
  final String deliveryInstructions;

  final String paymentMethod;

  final double deliveryCharge;
  final double platformFee;

  const ConfirmOrderScreen({
    super.key,
    required this.deliveryDate,
    required this.deliverySlot,
    required this.deliveryInstructions,
    required this.paymentMethod,
    required this.deliveryCharge,
    required this.platformFee,
  });

  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF087C59);
  static const Color lightGreen = Color(0xFFE9F8F2);
  static const Color textDark = Color(0xFF263238);
  static const Color textGrey = Color(0xFF71807A);
  static const Color borderColor = Color(0xFFE1E9E5);

  // ============================================================
  // PRICE FORMAT
  // ============================================================

  String _formatPrice(double value) {
    return value.toStringAsFixed(0);
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  void _placeOrder(
    BuildContext context,
    CartProvider cart,
    AddressProvider addressProvider,
  ) {
    final address = addressProvider.selectedAddress;

    if (address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }

    final itemsTotal = cart.totalAmount;

    final total = itemsTotal + deliveryCharge + platformFee;

    debugPrint('================================');
    debugPrint('PLACE ORDER');
    debugPrint('================================');

    debugPrint('Payment: $paymentMethod');
    debugPrint('Delivery date: $deliveryDate');
    debugPrint('Delivery slot: $deliverySlot');
    debugPrint('Instructions: $deliveryInstructions');

    debugPrint('Items total: $itemsTotal');
    debugPrint('Delivery charge: $deliveryCharge');
    debugPrint('Platform fee: $platformFee');
    debugPrint('Total: $total');

    // ==========================================================
    // NEXT STEP:
    // Send this information to FastAPI.
    // ==========================================================

    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(...),
      ),
    );
    */
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final addressProvider = context.watch<AddressProvider>();

    // final address = addressProvider.selectedAddress;

    final itemsTotal = cart.totalAmount;

    final total = itemsTotal + deliveryCharge + platformFee;

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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: textDark,
          ),
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
              padding: const EdgeInsets.fromLTRB(18, 5, 18, 12),
              child: _buildCheckoutStepper(),
            ),

            // ==================================================
            // CONTENT
            // ==================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 90),
                child: Column(
                  children: [
                    _buildReviewHeader(),

                    const SizedBox(height: 8),

                    // ADDRESS
                    _buildAddressCard(context, addressProvider),

                    const SizedBox(height: 8),

                    _buildDeliveryCard(context),

                    const SizedBox(height: 8),

                    _buildPaymentCard(context),

                    const SizedBox(height: 8),

                    // ORDER SUMMARY
                    _buildOrderSummary(cart, itemsTotal, total),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM PLACE ORDER BUTTON
      // ========================================================
      bottomNavigationBar: _buildBottomBar(
        context,
        cart,
        addressProvider,
        total,
      ),
    );
  }

  // ============================================================
  // STEPPER
  // ============================================================

  Widget _buildCheckoutStepper() {
    return Row(
      children: [
        _buildStep(
          title: 'Address',
          number: null,
          icon: Icons.check_rounded,
          active: true,
        ),

        _buildLine(true),

        _buildStep(
          title: 'Payment',
          number: null,
          icon: Icons.check_rounded,
          active: true,
        ),

        _buildLine(true),

        _buildStep(title: 'Confirm', number: '4', icon: null, active: true),
      ],
    );
  }

  Widget _buildStep({
    required String title,
    required String? number,
    required IconData? icon,
    required bool active,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryGreen,
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 14, color: Colors.white)
                  : Text(
                      number ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(bool active) {
    return Container(
      width: 18,
      height: 1.5,
      margin: const EdgeInsets.only(bottom: 18),
      color: active ? primaryGreen : const Color(0xFFDDE5E1),
    );
  }

  // ============================================================
  // REVIEW HEADER
  // ============================================================

  Widget _buildReviewHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              size: 38,
              color: primaryGreen,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Review Your Order',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            'Please check all details before placing your order',
            style: TextStyle(fontSize: 7.5, color: textGrey),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADDRESS CARD
  // ============================================================
Widget _buildAddressCard(
  BuildContext context,
  AddressProvider addressProvider,
) {
    final address = addressProvider.selectedAddress;

    if (address == null) {
      return _buildEmptyCard(
        icon: Icons.location_on_outlined,
        title: 'Delivery Address',
        message: 'No address selected',
      );
    }

    return _buildCard(
      icon: Icons.location_on_outlined,
      title: 'Delivery Address',
      changeText: 'Change',
      onChange: () {
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            address.fullName,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            address.addressLine,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 7, color: textGrey),
          ),

          const SizedBox(height: 2),

          Text(
            '${address.city}, ${address.state} - ${address.pincode}',
            style: const TextStyle(fontSize: 7, color: textGrey),
          ),

          const SizedBox(height: 2),

          Text(
            '+91 ${address.phone}',
            style: const TextStyle(fontSize: 7, color: textGrey),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY CARD
  // ============================================================
Widget _buildDeliveryCard(BuildContext context) {
    return _buildCard(
      icon: Icons.local_shipping_outlined,
      title: 'Delivery Slot',
      changeText: 'Change',
      onChange: () {
        Navigator.pop(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deliveryDate,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: textDark,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            deliverySlot,
            style: const TextStyle(fontSize: 7, color: textGrey),
          ),

          if (deliveryInstructions.isNotEmpty) ...[
            const SizedBox(height: 4),

            Text(
              'Note: $deliveryInstructions',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 6.5, color: textGrey),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT CARD
  // ============================================================

  Widget _buildPaymentCard(BuildContext context) {
    return _buildCard(
      icon: Icons.credit_card_outlined,
      title: 'Payment Method',
      changeText: 'Change',
      onChange: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 18,
            color: primaryGreen,
          ),

          const SizedBox(width: 7),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paymentMethod,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                _paymentSubtitle(paymentMethod),
                style: const TextStyle(fontSize: 6.5, color: textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _paymentSubtitle(String method) {
    switch (method.toLowerCase()) {
      case 'upi':
        return 'Pay using UPI';
      case 'credit / debit card':
        return 'Pay using your card';
      case 'cash on delivery':
        return 'Pay when you receive your order';
      case 'net banking':
        return 'Pay using your bank account';
      default:
        return 'Selected payment method';
    }
  }

  // ============================================================
  // ORDER SUMMARY
  // ============================================================

  Widget _buildOrderSummary(
    CartProvider cart,
    double itemsTotal,
    double total,
  ) {
    return _buildCard(
      icon: Icons.shopping_bag_outlined,
      title: 'Order Summary',
      changeText: '${cart.items.length} items',
      onChange: null,
      child: Column(
        children: [
          // PRODUCT IMAGES
          SizedBox(
            height: 55,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6F4),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: item.image.isNotEmpty
                      ? Image.network(
                          item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.image_outlined,
                              color: Colors.grey,
                            );
                          },
                        )
                      : const Icon(Icons.image_outlined, color: Colors.grey),
                );
              },
            ),
          ),

          const SizedBox(height: 9),

          _buildSummaryRow('Items Total', itemsTotal),

          const SizedBox(height: 5),

          _buildSummaryRow('Delivery Charge', deliveryCharge),

          const SizedBox(height: 5),

          _buildSummaryRow('Platform Fee', platformFee),

          const SizedBox(height: 7),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  '₹${_formatPrice(total)}',
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
  // GENERIC CARD
  // ============================================================

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String changeText,
    required Widget child,
    VoidCallback? onChange,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: lightGreen,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, size: 15, color: primaryGreen),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                ),
              ),

              if (onChange != null)
                GestureDetector(
                  onTap: onChange,
                  child: Text(
                    changeText,
                    style: const TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                      color: primaryGreen,
                    ),
                  ),
                )
              else
                Text(
                  changeText,
                  style: const TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: primaryGreen,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 7),

          Padding(padding: const EdgeInsets.only(left: 34), child: child),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY CARD
  // ============================================================

  Widget _buildEmptyCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return _buildCard(
      icon: icon,
      title: title,
      changeText: 'Change',
      child: Text(
        message,
        style: const TextStyle(fontSize: 7.5, color: textGrey),
      ),
    );
  }

  // ============================================================
  // SUMMARY ROW
  // ============================================================

  Widget _buildSummaryRow(String title, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 7.5, color: textGrey)),
        Text(
          '₹${_formatPrice(amount)}',
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

  Widget _buildBottomBar(
    BuildContext context,
    CartProvider cart,
    AddressProvider addressProvider,
    double total,
  ) {
    final hasAddress = addressProvider.selectedAddress != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 43,
          child: ElevatedButton(
            onPressed: cart.items.isEmpty || !hasAddress
                ? null
                : () {
                    _placeOrder(context, cart, addressProvider);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, size: 16),

                const SizedBox(width: 7),

                const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                ),

                const SizedBox(width: 5),

                Text(
                  '• ₹${_formatPrice(total)}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
