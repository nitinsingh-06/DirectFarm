import 'package:farmdirect/features/buyer/models/buyer_address.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/core/provider/address_provider.dart';

class CheckoutScreen extends StatefulWidget {
  final int totalAmount;

  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF087C59);

  static const Color lightGreen = Color(0xFFEAF8F0);

  static const Color background = Color(0xFFF5F8F7);

  static const Color darkText = Color(0xFF18332D);

  static const Color greyText = Color(0xFF7D8B87);

  // ============================================================
  // DELIVERY SLOT
  // ============================================================

  int selectedSlot = 0;

  final List<Map<String, String>> deliverySlots = [
    {'day': 'Tomorrow', 'time': '07 AM - 11 AM'},
    {'day': 'Next Day', 'time': '08 AM - 12 PM'},
  ];

  // ============================================================
  // PAYMENT
  // ============================================================

  int selectedPayment = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'title': 'UPI',
      'subtitle': 'GPay / PhonePe / Paytm',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Credit / Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': Icons.credit_card_outlined,
    },
    {
      'title': 'Net Banking',
      'subtitle': 'All major banks supported',
      'icon': Icons.account_balance_outlined,
    },
    {
      'title': 'Cash on Delivery',
      'subtitle': 'Pay when your order is delivered',
      'icon': Icons.payments_outlined,
    },
  ];

  // ============================================================
  // INITIAL LOAD
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddresses();
    });
  }

  // ============================================================
  // GRAND TOTAL
  // ============================================================

  double _grandTotal(CartProvider cart) {
    return cart.totalAmount;
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  void _placeOrder(CartProvider cart, AddressProvider addressProvider) {
    final address = addressProvider.selectedAddress;

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));

      return;
    }

    if (address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );

      return;
    }

    final slot = deliverySlots[selectedSlot];

    final payment = paymentMethods[selectedPayment];

    // COD selected
    if (selectedPayment == 3) {
      _showOrderConfirmation(
        cart: cart,
        address: address,
        slot: slot,
        payment: payment,
      );

      return;
    }

    // Other payment methods
    _showOrderConfirmation(
      cart: cart,
      address: address,
      slot: slot,
      payment: payment,
    );
  }

  // ============================================================
  // CONFIRMATION
  // ============================================================

  void _showOrderConfirmation({
    required CartProvider cart,
    required BuyerAddress address,
    required Map<String, String> slot,
    required Map<String, dynamic> payment,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Confirm Order',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: Text(
            'Delivery\n'
            '${slot['day']} • ${slot['time']}\n\n'
            'Payment\n'
            '${payment['title']}\n\n'
            'Address\n'
            '${address.addressLine}, '
            '${address.city}, '
            '${address.state} - '
            '${address.pincode}\n\n'
            'Total\n'
            '₹${_formatPrice(_grandTotal(cart))}',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed successfully'),
                    backgroundColor: primaryGreen,
                  ),
                );

                // =================================================
                // NEXT BACKEND STEP
                // =================================================
                //
                // Send:
                //
                // address.id
                // selectedSlot
                // payment method
                // cart.items
                // cart.totalAmount
                //
                // to FastAPI /orders
                //
                // Then clear cart.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm Order'),
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
    return Consumer2<CartProvider, AddressProvider>(
      builder: (context, cart, addressProvider, child) {
        final total = _grandTotal(cart);

        return Scaffold(
          backgroundColor: background,

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: darkText,
                size: 20,
              ),
            ),

            title: const Text(
              'Checkout Flow',
              style: TextStyle(
                color: primaryGreen,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),

            centerTitle: true,
          ),

          body: Column(
            children: [
              _buildProgress(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 120),
                  child: Column(
                    children: [
                      _buildAddress(addressProvider),

                      const SizedBox(height: 10),

                      _buildDeliverySlot(),

                      const SizedBox(height: 10),

                      _buildOrderSummary(cart),

                      const SizedBox(height: 10),

                      _buildPayment(),

                      const SizedBox(height: 10),

                      _buildSecureBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          bottomNavigationBar: _buildBottomBar(cart, addressProvider, total),
        );
      },
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget _buildProgress() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(25, 4, 25, 10),
      child: Row(
        children: [
          _step('1', 'Address', true),

          _line(),

          _step('2', 'Delivery', false),

          _line(),

          _step('3', 'Payment', false),

          _line(),

          _checkStep('Confirm'),
        ],
      ),
    );
  }

  Widget _step(String number, String title, bool active) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: BoxDecoration(
              color: active ? primaryGreen : const Color(0xFFE8EEEC),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: active ? Colors.white : greyText,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 9,
              color: active ? primaryGreen : greyText,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkStep(String title) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 31,
            height: 31,
            decoration: const BoxDecoration(
              color: Color(0xFFE8EEEC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 17, color: greyText),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 9, color: greyText)),
        ],
      ),
    );
  }

  Widget _line() {
    return Container(width: 20, height: 2, color: const Color(0xFFDCE3E0));
  }

  // ============================================================
  // ADDRESS
  // ============================================================

  Widget _buildAddress(AddressProvider provider) {
    if (provider.isLoading) {
      return _card(
        child: const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator(color: primaryGreen)),
        ),
      );
    }

    if (provider.error != null) {
      return _card(
        child: Column(
          children: [
            const Icon(
              Icons.location_off_outlined,
              color: Colors.redAccent,
              size: 30,
            ),
            const SizedBox(height: 8),
            const Text(
              'Unable to load addresses',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                provider.loadAddresses();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final address = provider.selectedAddress;

    if (address == null) {
      return _card(
        child: Column(
          children: [
            const Icon(Icons.location_off_outlined, color: greyText, size: 32),

            const SizedBox(height: 8),

            const Text(
              'No delivery address found',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Add an address from your profile.',
              style: TextStyle(fontSize: 10, color: greyText),
            ),
          ],
        ),
      );
    }

    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _sectionIcon(Icons.location_on_outlined),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  _showAddressSelector(provider);
                },
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E8E5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.home_outlined, color: darkText, size: 20),

                const SizedBox(width: 9),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${address.fullName} (${address.label})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                        ),
                      ),

                      const SizedBox(height: 4),
                      Text(
                        '${address.addressLine}, '
                        '${address.landmark.isNotEmpty ? '${address.landmark}, ' : ''}'
                        '${address.city}, '
                        '${address.state} - '
                        '${address.pincode}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: greyText,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, color: greyText, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADDRESS SELECTOR
  // ============================================================

  void _showAddressSelector(AddressProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Select Delivery Address',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 12),

                ...provider.addresses.map((address) {
                  final selected = provider.selectedAddress?.id == address.id;

                  return GestureDetector(
                    onTap: () {
                      provider.selectAddress(address.id);

                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selected ? lightGreen : Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: selected
                              ? primaryGreen
                              : const Color(0xFFE0E6E3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: primaryGreen,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${address.fullName} (${address.label})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: darkText,
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  address.fullName,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: greyText,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected ? primaryGreen : greyText,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DELIVERY SLOT
  // ============================================================

  Widget _buildDeliverySlot() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _sectionIcon(Icons.local_shipping_outlined),

              const SizedBox(width: 10),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Delivery Slot',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: darkText,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Choose when you want your order delivered',
                    style: TextStyle(fontSize: 9, color: greyText),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _slot(0, 'Tomorrow', '07 AM - 11 AM')),

              const SizedBox(width: 8),

              Expanded(child: _slot(1, 'Next Day', '08 AM - 12 PM')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _slot(int index, String day, String time) {
    final selected = selectedSlot == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0FFF6) : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected ? primaryGreen : const Color(0xFFDCE4E1),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 19,
              color: selected ? primaryGreen : darkText,
            ),

            const SizedBox(width: 7),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 8, color: greyText),
                  ),
                ],
              ),
            ),

            Icon(
              selected ? Icons.check_circle : Icons.radio_button_off,
              size: 18,
              color: selected ? primaryGreen : greyText,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ORDER SUMMARY
  // ============================================================

  Widget _buildOrderSummary(CartProvider cart) {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _sectionIcon(Icons.shopping_basket_outlined),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
              ),

              Text(
                '${cart.items.length} items',
                style: const TextStyle(
                  fontSize: 10,
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...cart.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  _productImage(item.image),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          '${item.quantity} ${item.unit} • ₹${_formatPrice(item.price)}',
                          style: const TextStyle(fontSize: 8, color: greyText),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '₹${_formatPrice(item.totalPrice)}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                ],
              ),
            );
          }),

          const Divider(),

          _priceRow('Subtotal', '₹${_formatPrice(cart.totalAmount)}'),

          const SizedBox(height: 5),

          _priceRow('Delivery Fee', 'FREE', color: const Color(0xFF15945E)),

          const SizedBox(height: 5),

          _priceRow('Promo Discount', '₹0', color: greyText),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),

                const Spacer(),

                Text(
                  '₹${_formatPrice(cart.totalAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: primaryGreen,
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
  // PAYMENT
  // ============================================================

  Widget _buildPayment() {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _sectionIcon(Icons.payment_outlined),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Payment Method',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Choose how you want to pay',
                      style: TextStyle(fontSize: 9, color: greyText),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...List.generate(paymentMethods.length, (index) {
            final method = paymentMethods[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: _paymentMethod(
                index: index,
                title: method['title'],
                subtitle: method['subtitle'],
                icon: method['icon'],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _paymentMethod({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = selectedPayment == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0FFF6) : Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected ? primaryGreen : const Color(0xFFDDE4E1),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFE0F7EA)
                    : const Color(0xFFF3F5F4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 19,
                color: selected ? primaryGreen : darkText,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 8, color: greyText),
                  ),
                ],
              ),
            ),

            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: selected ? primaryGreen : greyText,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECURE
  // ============================================================

  Widget _buildSecureBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_outlined, color: primaryGreen, size: 18),
          SizedBox(width: 7),
          Expanded(
            child: Text(
              'Your order and payment details are secure.',
              style: TextStyle(
                fontSize: 9,
                color: primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM BAR
  // ============================================================

  Widget _buildBottomBar(
    CartProvider cart,
    AddressProvider addressProvider,
    double total,
  ) {
    final hasAddress = addressProvider.selectedAddress != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 46,
          child: ElevatedButton(
            onPressed: cart.items.isEmpty || !hasAddress
                ? null
                : () {
                    _placeOrder(cart, addressProvider);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedPayment == 3)
                  const Icon(Icons.local_shipping_outlined, size: 17)
                else
                  const Icon(Icons.lock_outline, size: 16),

                const SizedBox(width: 7),

                const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                ),

                const SizedBox(width: 5),

                Text(
                  '• ₹${_formatPrice(total)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(width: 7),

                const Icon(Icons.arrow_forward, size: 17),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // COMMON CARD
  // ============================================================

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE4EAE7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // SECTION ICON
  // ============================================================

  Widget _sectionIcon(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Color(0xFFE0F7EA),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: primaryGreen, size: 20),
    );
  }

  // ============================================================
  // PRICE ROW
  // ============================================================

  Widget _priceRow(String title, String value, {Color color = darkText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 9, color: greyText)),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================

  Widget _productImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: image.isEmpty
          ? Container(
              width: 42,
              height: 42,
              color: const Color(0xFFF0F4F2),
              child: const Icon(
                Icons.image_outlined,
                color: Colors.grey,
                size: 17,
              ),
            )
          : Image.network(
              image,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 42,
                  height: 42,
                  color: const Color(0xFFF0F4F2),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.grey,
                    size: 17,
                  ),
                );
              },
            ),
    );
  }

  // ============================================================
  // FORMAT PRICE
  // ============================================================

  String _formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}
