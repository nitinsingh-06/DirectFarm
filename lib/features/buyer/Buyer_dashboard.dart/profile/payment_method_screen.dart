import 'package:flutter/material.dart';

class PaymentMethod {
  final String id;
  final String type;

  String? upiId;

  String? cardHolder;
  String? last4;
  String? expiry;
  String? bankName;
  String? cardType;

  bool isDefault;

  PaymentMethod.upi({
    required this.id,
    required this.upiId,
    this.isDefault = false,
  }) : type = 'upi';

  PaymentMethod.card({
    required this.id,
    required this.cardHolder,
    required this.last4,
    required this.expiry,
    required this.bankName,
    required this.cardType,
    this.isDefault = false,
  }) : type = 'card';
}

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState
    extends State<PaymentMethodsScreen> {
  static const Color primary = Color(0xFF075B4A);
  static const Color background = Color(0xFFF7F9F8);
  static const Color lightGreen = Color(0xFFEAF6F2);
  static const Color lime = Color(0xFFB8D93B);
  static const Color textDark = Color(0xFF293530);
  static const Color textGrey = Color(0xFF7A8581);
  static const Color borderColor = Color(0xFFE1E6E3);
  static const Color red = Color(0xFFE74C4C);

  // ----------------------------------------------------------
  // UPI
  // ----------------------------------------------------------

  final List<PaymentMethod> _upiMethods = [
    PaymentMethod.upi(
      id: 'upi_1',
      upiId: 'priyasharma@okaxis',
      isDefault: true,
    ),
    PaymentMethod.upi(
      id: 'upi_2',
      upiId: '9876543210@ybl',
    ),
  ];

  // ----------------------------------------------------------
  // CARDS
  // ----------------------------------------------------------

  final List<PaymentMethod> _cardMethods = [
    PaymentMethod.card(
      id: 'card_1',
      cardHolder: 'PRIYA SHARMA',
      last4: '4321',
      expiry: '12/28',
      bankName: 'HDFC Bank Gold',
      cardType: 'VISA',
      isDefault: true,
    ),
    PaymentMethod.card(
      id: 'card_2',
      cardHolder: 'PRIYA SHARMA',
      last4: '8765',
      expiry: '08/29',
      bankName: 'ICICI Bank Coral',
      cardType: 'VISA',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: primary,
            size: 21,
          ),
        ),

        title: const Text(
          'Payment Methods',
          style: TextStyle(
            color: primary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                8,
                3,
                8,
                15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // UPI
                  _sectionTitle('SAVED UPI IDs'),

                  const SizedBox(height: 7),

                  _buildUpiSection(),

                  const SizedBox(height: 16),

                  // CARDS
                  _sectionTitle('SAVED CARDS'),

                  const SizedBox(height: 7),

                  _buildCardsSection(),
                ],
              ),
            ),
          ),

          _buildAddPaymentButton(),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 1),
      child: Text(
        text,
        style: const TextStyle(
          color: primary,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ==========================================================
  // UPI SECTION
  // ==========================================================

  Widget _buildUpiSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < _upiMethods.length; i++) ...[
            _buildUpiCard(_upiMethods[i]),

            if (i < _upiMethods.length - 1)
              const Divider(
                height: 1,
                color: borderColor,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildUpiCard(PaymentMethod method) {
    return SizedBox(
      height: 42,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
        ),
        child: Row(
          children: [
            Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: method.isDefault
                    ? lightGreen
                    : const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(
                Icons.close,
                size: 14,
                color: method.isDefault
                    ? primary
                    : const Color(0xFF87918D),
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    method.upiId ?? '',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    method.isDefault
                        ? 'Primary UPI • Google Pay'
                        : 'PhonePe',
                    style: const TextStyle(
                      fontSize: 7,
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                _deletePaymentMethod(method);
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  size: 14,
                  color: red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CARD SECTION
  // ==========================================================

  Widget _buildCardsSection() {
    return Column(
      children: [
        for (final card in _cardMethods)
          _buildCard(card),
      ],
    );
  }

  // ==========================================================
  // CARD
  // ==========================================================

  Widget _buildCard(PaymentMethod card) {
    final bool selected = card.isDefault;

    return GestureDetector(
      onTap: () {
        _selectCard(card);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        width: double.infinity,
        height: 94,

        margin: const EdgeInsets.only(
          bottom: 9,
        ),

        padding: const EdgeInsets.fromLTRB(
          11,
          9,
          11,
          8,
        ),

        decoration: BoxDecoration(
          color: selected
              ? primary
              : Colors.white,

          borderRadius: BorderRadius.circular(11),

          border: Border.all(
            color: selected
                ? primary
                : borderColor,
          ),

          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // BANK + SELECT ICON
            // ------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: Text(
                    card.bankName ?? 'Bank Card',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: selected
                          ? lime
                          : primary,
                    ),
                  ),
                ),

                // Selection indicator
                Container(
                  width: 20,
                  height: 15,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected
                          ? Colors.white
                          : const Color(0xFF5E6865),
                      width: 1.3,
                    ),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check,
                          size: 11,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.credit_card,
                          size: 11,
                          color: Color(0xFF5E6865),
                        ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ------------------------------------------------
            // CARD NUMBER
            // ------------------------------------------------

            Text(
              '••••  ••••  ••••  ${card.last4}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: selected
                    ? Colors.white
                    : textDark,
              ),
            ),

            const SizedBox(height: 3),

            // ------------------------------------------------
            // HOLDER + EXPIRY + DEFAULT
            // ------------------------------------------------

            Row(
              children: [
                Expanded(
                  child: Text(
                    card.cardHolder ?? '',
                    style: TextStyle(
                      fontSize: 6.5,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white70
                          : textGrey,
                    ),
                  ),
                ),

                Text(
                  'Expires: ${card.expiry}',
                  style: TextStyle(
                    fontSize: 6.5,
                    color: selected
                        ? Colors.white70
                        : textGrey,
                  ),
                ),

                const SizedBox(width: 10),

                if (selected)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: lime,
                      borderRadius:
                          BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'DEFAULT',
                      style: TextStyle(
                        fontSize: 5.5,
                        fontWeight: FontWeight.w900,
                        color: primary,
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      _selectCard(card);
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 6.5,
                        color: red,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SELECT CARD
  // ==========================================================

  void _selectCard(PaymentMethod selectedCard) {
    setState(() {
      for (final card in _cardMethods) {
        card.isDefault = false;
      }

      selectedCard.isDefault = true;
    });
  }

  // ==========================================================
  // ADD PAYMENT BUTTON
  // ==========================================================

  Widget _buildAddPaymentButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          8,
          4,
          8,
          12,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton(
            onPressed: _showAddPaymentMethod,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              '+ Add Payment Method',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ADD PAYMENT METHOD
  // ==========================================================

  void _showAddPaymentMethod() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D6D3),
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Add Payment Method',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textDark,
                  ),
                ),

                const SizedBox(height: 20),

                _paymentOption(
                  icon: Icons
                      .account_balance_wallet_outlined,
                  title: 'UPI',
                  subtitle:
                      'Google Pay, PhonePe, Paytm etc.',
                  onTap: () {
                    Navigator.pop(context);
                    _showAddUpi();
                  },
                ),

                const SizedBox(height: 12),

                _paymentOption(
                  icon: Icons.credit_card_outlined,
                  title: 'Debit / Credit Card',
                  subtitle:
                      'Add HDFC or ICICI card',
                  onTap: () {
                    Navigator.pop(context);
                    _showAddCard();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _paymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              color: textGrey,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ADD UPI
  // ==========================================================

  void _showAddUpi() {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                    25,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Add UPI ID',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: controller,
                keyboardType:
                    TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'UPI ID',
                  hintText: 'example@upi',
                  prefixIcon: const Icon(
                    Icons
                        .account_balance_wallet_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              _saveButton(
                text: 'Save UPI ID',
                onPressed: () {
                  final upi =
                      controller.text.trim();

                  if (upi.isEmpty ||
                      !upi.contains('@')) {
                    _showMessage(
                      'Enter a valid UPI ID',
                    );
                    return;
                  }

                  setState(() {
                    _upiMethods.add(
                      PaymentMethod.upi(
                        id: DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        upiId: upi,
                      ),
                    );
                  });

                  Navigator.pop(context);

                  _showMessage(
                    'UPI ID added successfully',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // ADD CARD
  // ==========================================================

  void _showAddCard() {
    final cardNumberController =
        TextEditingController();

    final nameController =
        TextEditingController();

    final expiryController =
        TextEditingController();

    String selectedBank = 'HDFC';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom:
                    MediaQuery.of(context)
                            .viewInsets
                            .bottom +
                        20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Debit / Credit Card',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Select Bank',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textDark,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // HDFC / ICICI SELECTOR
                    Row(
                      children: [
                        Expanded(
                          child: _bankSelector(
                            title: 'HDFC Bank',
                            selected:
                                selectedBank == 'HDFC',
                            onTap: () {
                              setSheetState(() {
                                selectedBank =
                                    'HDFC';
                              });
                            },
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: _bankSelector(
                            title: 'ICICI Bank',
                            selected:
                                selectedBank == 'ICICI',
                            onTap: () {
                              setSheetState(() {
                                selectedBank =
                                    'ICICI';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller:
                          cardNumberController,
                      keyboardType:
                          TextInputType.number,
                      maxLength: 16,
                      decoration:
                          InputDecoration(
                        labelText: 'Card Number',
                        hintText:
                            '1234 5678 9012 3456',
                        prefixIcon: const Icon(
                          Icons
                              .credit_card_outlined,
                        ),
                        counterText: '',
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: nameController,
                      textCapitalization:
                          TextCapitalization
                              .characters,
                      decoration:
                          InputDecoration(
                        labelText:
                            'Card Holder Name',
                        hintText:
                            'PRIYA SHARMA',
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller:
                          expiryController,
                      keyboardType:
                          TextInputType.number,
                      maxLength: 5,
                      decoration:
                          InputDecoration(
                        labelText: 'Expiry',
                        hintText: 'MM/YY',
                        counterText: '',
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _saveButton(
                      text: 'Save Card',
                      onPressed: () {
                        final number =
                            cardNumberController
                                .text
                                .replaceAll(
                                  ' ',
                                  '',
                                );

                        final name =
                            nameController
                                .text
                                .trim();

                        final expiry =
                            expiryController
                                .text
                                .trim();

                        if (number.length != 16) {
                          _showMessage(
                            'Enter a valid 16-digit card number',
                          );
                          return;
                        }

                        if (name.isEmpty) {
                          _showMessage(
                            'Enter card holder name',
                          );
                          return;
                        }

                        if (expiry.length != 5 ||
                            !expiry.contains('/')) {
                          _showMessage(
                            'Enter expiry as MM/YY',
                          );
                          return;
                        }

                        setState(() {
                          _cardMethods.add(
                            PaymentMethod.card(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              cardHolder:
                                  name.toUpperCase(),
                              last4:
                                  number.substring(
                                number.length - 4,
                              ),
                              expiry: expiry,
                              bankName:
                                  selectedBank ==
                                          'HDFC'
                                      ? 'HDFC Bank Gold'
                                      : 'ICICI Bank Coral',
                              cardType: 'VISA',
                              isDefault: false,
                            ),
                          );
                        });

                        Navigator.pop(context);

                        _showMessage(
                          '$selectedBank card added successfully',
                        );
                      },
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

  // ==========================================================
  // BANK SELECTOR
  // ==========================================================

  Widget _bankSelector({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 150),
        height: 52,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primary
              : Colors.white,
          borderRadius:
              BorderRadius.circular(11),
          border: Border.all(
            color: selected
                ? primary
                : borderColor,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.account_balance,
              size: 18,
              color: selected
                  ? Colors.white
                  : primary,
            ),

            const SizedBox(width: 7),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      FontWeight.w800,
                  color: selected
                      ? Colors.white
                      : textDark,
                ),
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_circle,
                size: 17,
                color: lime,
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SAVE BUTTON
  // ==========================================================

  Widget _saveButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  void _deletePaymentMethod(
    PaymentMethod method,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Remove Payment Method',
          ),
          content: Text(
            method.type == 'upi'
                ? 'Remove ${method.upiId}?'
                : 'Remove card ending ${method.last4}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  if (method.type == 'upi') {
                    _upiMethods.remove(method);
                  } else {
                    _cardMethods.remove(method);
                  }
                });

                Navigator.pop(dialogContext);

                _showMessage(
                  'Payment method removed',
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
      ),
    );
  }
}