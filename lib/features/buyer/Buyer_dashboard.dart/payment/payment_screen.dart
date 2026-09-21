import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final int totalAmount;

  const CheckoutScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryGreen = Color(0xFF087C59);
  static const Color lightGreen = Color(0xFFEAF8F0);
  static const Color limeGreen = Color(0xFF82D20B);
  static const Color background = Color(0xFFF5F8F7);
  static const Color darkText = Color(0xFF18332D);
  static const Color greyText = Color(0xFF7D8B87);

  // ============================================================
  // DELIVERY ADDRESS
  // ============================================================

  final List<Map<String, String>> _addresses = [
    {
      'name': 'Priya Sharma',
      'type': 'Home',
      'address':
          'A-102, Shanti Vihar Apartments, Sector 12, Dwarka, New Delhi - 110075',
    },
    {
      'name': 'Priya Sharma',
      'type': 'Work',
      'address':
          'B-204, Green Park Extension, New Delhi - 110016',
    },
    {
      'name': 'Priya Sharma',
      'type': 'Other',
      'address':
          'C-18, Rajouri Garden, New Delhi - 110027',
    },
  ];

  int selectedAddressIndex = 0;

  // ============================================================
  // DELIVERY SLOT
  // ============================================================

  int selectedSlot = 0;

  final List<Map<String, String>> deliverySlots = [
    {
      'day': 'Tomorrow',
      'time': '07 AM - 11 AM',
    },
    {
      'day': 'Next Day',
      'time': '08 AM - 12 PM',
    },
  ];

  // ============================================================
  // PAYMENT METHOD
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
  ];

  // ============================================================
  // ADDRESS DIALOG
  // ============================================================

  void _showAddressSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  14,
                  18,
                  20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Delivery Address',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: darkText,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ...List.generate(
                      _addresses.length,
                      (index) {
                        final address = _addresses[index];
                        final selected =
                            selectedAddressIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedAddressIndex = index;
                            });

                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: selected
                                  ? lightGreen
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? primaryGreen
                                    : const Color(
                                        0xFFE1E7E5,
                                      ),
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration:
                                      BoxDecoration(
                                    color: selected
                                        ? const Color(
                                            0xFFD5F3E1,
                                          )
                                        : const Color(
                                            0xFFF1F4F3,
                                          ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    address['type'] ==
                                            'Home'
                                        ? Icons.home_outlined
                                        : Icons
                                            .location_on_outlined,
                                    color: primaryGreen,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            address['name']!,
                                            style:
                                                const TextStyle(
                                              fontSize: 14,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              color:
                                                  darkText,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal: 7,
                                              vertical: 3,
                                            ),
                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  Colors.white,
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                5,
                                              ),
                                            ),
                                            child: Text(
                                              address['type']!,
                                              style:
                                                  const TextStyle(
                                                fontSize: 9,
                                                color:
                                                    primaryGreen,
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 5,
                                      ),

                                      Text(
                                        address['address']!,
                                        style:
                                            const TextStyle(
                                          fontSize: 12,
                                          color: greyText,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Icon(
                                  selected
                                      ? Icons
                                          .radio_button_checked
                                      : Icons
                                          .radio_button_off,
                                  color: selected
                                      ? primaryGreen
                                      : Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 5),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showAddAddressDialog();
                        },
                        icon: const Icon(
                          Icons.add,
                          color: primaryGreen,
                        ),
                        label: const Text(
                          'Add New Address',
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: primaryGreen,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ADD NEW ADDRESS
  // ============================================================

  void _showAddAddressDialog() {
    final nameController =
        TextEditingController();
    final addressController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Add New Address',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon:
                      Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Complete Address',
                  prefixIcon:
                      Icon(Icons.location_on_outlined),
                ),
              ),
            ],
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
                if (nameController.text.trim().isEmpty ||
                    addressController.text
                        .trim()
                        .isEmpty) {
                  return;
                }

                setState(() {
                  _addresses.add({
                    'name':
                        nameController.text.trim(),
                    'type': 'Other',
                    'address':
                        addressController.text.trim(),
                  });

                  selectedAddressIndex =
                      _addresses.length - 1;
                });

                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SELECT PAYMENT
  // ============================================================

  void _selectPayment(int index) {
    setState(() {
      selectedPayment = index;
    });
  }

  // ============================================================
  // CART TOTAL
  // ============================================================

  double _getSubtotal(CartProvider cart) {
    return cart.totalAmount;
  }

  // ============================================================
  // DISCOUNT
  // ============================================================

  double _getDiscount(CartProvider cart) {
    // Use the actual cart total.
    // Promo can be connected to your promo provider later.
    return 0;
  }

  // ============================================================
  // GRAND TOTAL
  // ============================================================

  double _getGrandTotal(CartProvider cart) {
    final subtotal = _getSubtotal(cart);
    final discount = _getDiscount(cart);

    return subtotal - discount;
  }

  // ============================================================
  // PLACE ORDER
  // ============================================================

  void _placeOrder(CartProvider cart) {
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
        ),
      );
      return;
    }

    final address =
        _addresses[selectedAddressIndex];

    final slot =
        deliverySlots[selectedSlot];

    final payment =
        paymentMethods[selectedPayment];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Confirm Order',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Delivery: ${slot['day']}, ${slot['time']}\n\n'
            'Payment: ${payment['title']}\n\n'
            'Address: ${address['address']}\n\n'
            'Total: ₹${_formatPrice(_getGrandTotal(cart))}',
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

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Order placed successfully',
                    ),
                    backgroundColor: primaryGreen,
                  ),
                );

                // Later:
                // 1. Create order in PostgreSQL
                // 2. Create order_items
                // 3. Clear cart
                // 4. Open Order Confirmation
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
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final subtotal =
            _getSubtotal(cart);

        final discount =
            _getDiscount(cart);

        final grandTotal =
            _getGrandTotal(cart);

        return Scaffold(
          backgroundColor: background,

          // ====================================================
          // APP BAR
          // ====================================================

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
                size: 21,
              ),
            ),
            title: const Text(
              'Checkout',
              style: TextStyle(
                color: primaryGreen,
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            centerTitle: true,
          ),

          // ====================================================
          // BODY
          // ====================================================

          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Progress
                _buildProgressIndicator(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      10,
                      12,
                      120,
                    ),
                    child: Column(
                      children: [
                        // Address
                        _buildAddressCard(),

                        const SizedBox(height: 12),

                        // Delivery slot
                        _buildDeliverySlot(),

                        const SizedBox(height: 12),

                        // Order summary
                        _buildOrderSummary(
                          cart,
                          subtotal,
                          discount,
                          grandTotal,
                        ),

                        const SizedBox(height: 12),

                        // Payment
                        _buildPaymentSection(),

                        const SizedBox(height: 12),

                        _buildSecureMessage(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ====================================================
          // BOTTOM PLACE ORDER
          // ====================================================

          bottomNavigationBar:
              _buildBottomBar(
            cart,
            grandTotal,
          ),
        );
      },
    );
  }

  // ============================================================
  // PROGRESS INDICATOR
  // ============================================================

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        30,
        5,
        30,
        13,
      ),
      child: Row(
        children: [
          _progressStep(
            number: '1',
            title: 'Delivery',
            active: true,
          ),
          _progressLine(),
          _progressStep(
            number: '2',
            title: 'Payment',
            active: false,
          ),
          _progressLine(),
          _progressStep(
            number: '3',
            title: 'Review',
            active: false,
          ),
          _progressLine(),
          _progressCheck(
            title: 'Confirm',
          ),
        ],
      ),
    );
  }

  Widget _progressStep({
    required String number,
    required String title,
    required bool active,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: active
                  ? primaryGreen
                  : const Color(0xFFE8EEEC),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : const Color(0xFF64736E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active
                  ? FontWeight.bold
                  : FontWeight.w500,
              color: active
                  ? primaryGreen
                  : greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressCheck({
    required String title,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              color: Color(0xFFE8EEEC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 20,
              color: Color(0xFF65746F),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressLine() {
    return Container(
      width: 28,
      height: 3,
      color: const Color(0xFFDCE3E0),
    );
  }

  // ============================================================
  // ADDRESS CARD
  // ============================================================

  Widget _buildAddressCard() {
    final address =
        _addresses[selectedAddressIndex];

    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _sectionIcon(
                Icons.location_on_outlined,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
              ),
              TextButton(
                onPressed: _showAddressSelector,
                child: const Row(
                  children: [
                    Text(
                      'Change',
                      style: TextStyle(
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(
                      Icons.chevron_right,
                      color: primaryGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          GestureDetector(
            onTap: _showAddressSelector,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAF9),
                borderRadius:
                    BorderRadius.circular(13),
                border: Border.all(
                  color: const Color(0xFFE2E9E6),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.home_outlined,
                    color: darkText,
                    size: 21,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${address['name']} (${address['type']})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          address['address']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: greyText,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF65736F),
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
  // DELIVERY SLOT
  // ============================================================

  Widget _buildDeliverySlot() {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _sectionIcon(
                Icons.local_shipping_outlined,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Delivery Slot',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w800,
                        color: darkText,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Choose a convenient time for delivery',
                      style: TextStyle(
                        fontSize: 11,
                        color: greyText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: List.generate(
              deliverySlots.length,
              (index) {
                final slot =
                    deliverySlots[index];

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == 0 ? 7 : 0,
                      left: index == 1 ? 7 : 0,
                    ),
                    child: _slotCard(
                      index: index,
                      day: slot['day']!,
                      time: slot['time']!,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _slotCard({
    required int index,
    required String day,
    required String time,
  }) {
    final selected =
        selectedSlot == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = index;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0FFF6)
              : Colors.white,
          borderRadius:
              BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? primaryGreen
                : const Color(0xFFDDE4E1),
            width: selected ? 1.7 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFE0F7EA)
                    : const Color(0xFFF3F5F4),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_month_outlined,
                color: selected
                    ? primaryGreen
                    : darkText,
                size: 20,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                      color: selected
                          ? primaryGreen
                          : darkText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: selected
                          ? primaryGreen
                          : greyText,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              selected
                  ? Icons.check_circle
                  : Icons.radio_button_off,
              color: selected
                  ? primaryGreen
                  : const Color(0xFFB0BBB7),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ORDER SUMMARY
  // ============================================================

  Widget _buildOrderSummary(
    CartProvider cart,
    double subtotal,
    double discount,
    double grandTotal,
  ) {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _sectionIcon(
                Icons.receipt_long_outlined,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
              ),
              Text(
                '${cart.items.length} items',
                style: const TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.keyboard_arrow_up,
                color: primaryGreen,
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (cart.items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'No products in cart',
                style: TextStyle(
                  color: greyText,
                ),
              ),
            )
          else
            Column(
              children: cart.items.map(
                (item) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: _orderItem(item),
                  );
                },
              ).toList(),
            ),

          const Divider(
            height: 18,
          ),

          _priceRow(
            'Item Total',
            '₹${_formatPrice(subtotal)}',
          ),

          const SizedBox(height: 8),

          _priceRow(
            'Delivery Partner Fee',
            'FREE',
            valueColor:
                const Color(0xFF15945E),
          ),

          const SizedBox(height: 8),

          _priceRow(
            'Discount',
            discount > 0
                ? '- ₹${_formatPrice(discount)}'
                : '₹0',
            valueColor: discount > 0
                ? const Color(0xFF15945E)
                : greyText,
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF8F0),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text(
                  'Grand Total',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  '₹${_formatPrice(grandTotal)}',
                  style: const TextStyle(
                    color: primaryGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderItem(CartItem item) {
    return Row(
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(10),
          child: item.image.isNotEmpty
              ? Image.network(
                  item.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) {
                    return _productFallback();
                  },
                )
              : _productFallback(),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '${item.quantity} ${item.unit} • ${item.farm}',
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: greyText,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                item.location,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: greyText,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        Text(
          '₹${_formatPrice(item.totalPrice)}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAYMENT
  // ============================================================

  Widget _buildPaymentSection() {
    return _card(
      child: Column(
        children: [
          Row(
            children: [
              _sectionIcon(
                Icons.account_balance_wallet_outlined,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: darkText,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          ...List.generate(
            paymentMethods.length,
            (index) {
              final payment =
                  paymentMethods[index];

              return Padding(
                padding:
                    const EdgeInsets.only(
                  bottom: 9,
                ),
                child: _paymentCard(
                  index: index,
                  title:
                      payment['title'],
                  subtitle:
                      payment['subtitle'],
                  icon:
                      payment['icon'],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _paymentCard({
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected =
        selectedPayment == index;

    return GestureDetector(
      onTap: () => _selectPayment(index),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0FFF6)
              : Colors.white,
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? primaryGreen
                : const Color(0xFFDDE4E1),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFE0F7EA)
                    : const Color(0xFFF3F5F4),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected
                    ? primaryGreen
                    : darkText,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.bold,
                      color: darkText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
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
              color: selected
                  ? primaryGreen
                  : const Color(0xFFADB8B4),
              size: 23,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECURE MESSAGE
  // ============================================================

  Widget _buildSecureMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8F0),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: primaryGreen,
            size: 20,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Your payment and order details are secure.',
              style: TextStyle(
                fontSize: 10,
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
    double grandTotal,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        10,
        14,
        12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // TOTAL
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${_formatPrice(grandTotal)}',
                  style: const TextStyle(
                    color: primaryGreen,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'View price details',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 10,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 15),

            // BUTTON
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () {
                          _placeOrder(cart);
                        },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        primaryGreen,
                    disabledBackgroundColor:
                        Colors.grey.shade300,
                    foregroundColor:
                        Colors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ₹${_formatPrice(grandTotal)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 7),
                      const Icon(
                        Icons.arrow_forward,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // COMMON CARD
  // ============================================================

  Widget _card({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE4EAE7),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Color(0xFFE0F7EA),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: primaryGreen,
        size: 22,
      ),
    );
  }

  // ============================================================
  // PRICE ROW
  // ============================================================

  Widget _priceRow(
    String title,
    String value, {
    Color valueColor = darkText,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: greyText,
            fontSize: 11,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCT IMAGE FALLBACK
  // ============================================================

  Widget _productFallback() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F2),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.image_outlined,
        color: Colors.grey,
      ),
    );
  }

  // ============================================================
  // PRICE FORMAT
  // ============================================================

  String _formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }
}