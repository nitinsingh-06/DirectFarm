import 'package:flutter/material.dart';

class SavedAddress {
  final String id;

  String label;
  String name;
  String address;
  String city;
  String state;
  String pincode;
  String phone;
  String landmark;
  bool isDefault;

  SavedAddress({
    required this.id,
    required this.label,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.phone,
    this.landmark = '',
    this.isDefault = false,
  });
}

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() =>
      _SavedAddressesScreenState();
}

class _SavedAddressesScreenState
    extends State<SavedAddressesScreen> {
  static const Color primary = Color(0xFF075B4A);
  static const Color background = Color(0xFFF7F9F8);
  static const Color lightGreen = Color(0xFFEAF6F2);
  static const Color textDark = Color(0xFF293530);
  static const Color textGrey = Color(0xFF7A8581);
  static const Color borderColor = Color(0xFFE1E6E3);
  static const Color red = Color(0xFFFF6B6B);

  // ----------------------------------------------------------
  // DEMO ADDRESSES
  // ----------------------------------------------------------

  final List<SavedAddress> _addresses = [
    SavedAddress(
      id: '1',
      label: 'HOME',
      name: 'A-45, Pocket 2, Sector 12',
      address: 'A-45, Pocket 2, Sector 12',
      city: 'Dehradun',
      state: 'Uttarakhand',
      pincode: '2481001',
      phone: '9876543210',
      landmark: 'Near Durga Mandir',
      isDefault: true,
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------

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
          'Saved Addresses',
          style: TextStyle(
            color: primary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // ------------------------------------------------------
      // BODY
      // ------------------------------------------------------

      body: Column(
        children: [
          Expanded(
            child: _addresses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      4,
                      10,
                      20,
                    ),
                    itemCount: _addresses.length,
                    itemBuilder: (context, index) {
                      return _buildAddressCard(
                        _addresses[index],
                      );
                    },
                  ),
          ),

          // --------------------------------------------------
          // ADD BUTTON
          // --------------------------------------------------

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                10,
                4,
                10,
                12,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 47,
                child: ElevatedButton(
                  onPressed: () {
                    _openAddressForm();
                  },
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
                    '+ Add New Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ADDRESS CARD
  // ==========================================================

  Widget _buildAddressCard(SavedAddress address) {
    final bool selected = address.isDefault;

    return GestureDetector(
      onTap: () {
        _setDefault(address);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        padding: const EdgeInsets.fromLTRB(
          10,
          9,
          9,
          9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(11),

          border: Border.all(
            color: selected
                ? primary
                : borderColor,
            width: selected ? 1.4 : 1,
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // LABEL + DEFAULT
            // ------------------------------------------------

            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? lightGreen
                        : const Color(0xFFF1F3F2),
                    borderRadius:
                        BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        address.label
                                    .toLowerCase() ==
                                'work'
                            ? Icons.business
                            : Icons.home,
                        size: 8,
                        color: primary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        address.label,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight:
                              FontWeight.w900,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                if (selected)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'DEFAULT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            // ------------------------------------------------
            // ADDRESS
            // ------------------------------------------------

            Text(
              address.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),

            const SizedBox(height: 4),

            // ------------------------------------------------
            // CITY / STATE / PINCODE / LANDMARK
            // ------------------------------------------------

            Text(
              '${address.city}, ${address.state} - '
              '${address.pincode}'
              '${address.landmark.isNotEmpty ? ' • ${address.landmark}' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9.5,
                color: textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            // ------------------------------------------------
            // PHONE + EDIT + DELETE
            // ------------------------------------------------

            Row(
              children: [
                const Icon(
                  Icons.phone,
                  size: 9,
                  color: textGrey,
                ),

                const SizedBox(width: 4),

                Text(
                  '+91 ${address.phone}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                // EDIT
                GestureDetector(
                  onTap: () {
                    _openAddressForm(
                      address: address,
                    );
                  },
                  child: Container(
                    width: 27,
                    height: 25,
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius:
                          BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: primary,
                    ),
                  ),
                ),

                const SizedBox(width: 7),

                // DELETE
                GestureDetector(
                  onTap: () {
                    _deleteAddress(address);
                  },
                  child: Container(
                    width: 27,
                    height: 25,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFFFE7E7),
                      borderRadius:
                          BorderRadius.circular(6),
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
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SET DEFAULT
  // ==========================================================

  void _setDefault(SavedAddress selected) {
    setState(() {
      for (final address in _addresses) {
        address.isDefault =
            address.id == selected.id;
      }
    });

    _showMessage(
      '${selected.label} address selected',
    );
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  void _deleteAddress(SavedAddress address) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Address',
          ),

          content: Text(
            'Are you sure you want to delete '
            '${address.label.toLowerCase()} address?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
              ),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  _addresses.remove(address);

                  // If deleted address was default,
                  // make first remaining address default.
                  if (address.isDefault &&
                      _addresses.isNotEmpty) {
                    _addresses.first.isDefault =
                        true;
                  }
                });

                Navigator.pop(dialogContext);

                _showMessage(
                  'Address deleted',
                );
              },
              child: const Text(
                'Delete',
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
  // ADD / EDIT FORM
  // ==========================================================

  void _openAddressForm({
    SavedAddress? address,
  }) {
    final bool isEditing = address != null;

    final labelController =
        TextEditingController(
      text: address?.label ?? '',
    );

    final nameController =
        TextEditingController(
      text: address?.name ?? '',
    );

    final addressController =
        TextEditingController(
      text: address?.address ?? '',
    );

    final cityController =
        TextEditingController(
      text: address?.city ?? '',
    );

    final stateController =
        TextEditingController(
      text: address?.state ?? '',
    );

    final pincodeController =
        TextEditingController(
      text: address?.pincode ?? '',
    );

    final phoneController =
        TextEditingController(
      text: address?.phone ?? '',
    );

    final landmarkController =
        TextEditingController(
      text: address?.landmark ?? '',
    );

    bool makeDefault =
        address?.isDefault ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),

      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (
            context,
            setSheetState,
          ) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 18,
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
                    // ----------------------------------------
                    // TITLE
                    // ----------------------------------------

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEditing
                                ? 'Edit Address'
                                : 'Add New Address',
                            style:
                                const TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.w800,
                              color: textDark,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(
                              sheetContext,
                            );
                          },
                          icon: const Icon(
                            Icons.close,
                            color: textGrey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ----------------------------------------
                    // LABEL
                    // ----------------------------------------

                    _field(
                      controller:
                          labelController,
                      label: 'Address Label',
                      hint: 'Home / Work / Other',
                    ),

                    // ----------------------------------------
                    // FULL NAME
                    // ----------------------------------------

                    _field(
                      controller:
                          nameController,
                      label: 'Full Name',
                      hint:
                          'Enter full name',
                    ),

                    // ----------------------------------------
                    // ADDRESS
                    // ----------------------------------------

                    _field(
                      controller:
                          addressController,
                      label: 'Address',
                      hint:
                          'House / Flat / Street',
                      maxLines: 2,
                    ),

                    // ----------------------------------------
                    // CITY
                    // ----------------------------------------

                    _field(
                      controller:
                          cityController,
                      label: 'City',
                      hint: 'Enter city',
                    ),

                    // ----------------------------------------
                    // STATE
                    // ----------------------------------------

                    _field(
                      controller:
                          stateController,
                      label: 'State',
                      hint: 'Enter state',
                    ),

                    // ----------------------------------------
                    // PINCODE
                    // ----------------------------------------

                    _field(
                      controller:
                          pincodeController,
                      label: 'Pincode',
                      hint: 'Enter pincode',
                      keyboardType:
                          TextInputType.number,
                    ),

                    // ----------------------------------------
                    // LANDMARK
                    // ----------------------------------------

                    _field(
                      controller:
                          landmarkController,
                      label: 'Landmark',
                      hint:
                          'Near school, hospital etc.',
                    ),

                    // ----------------------------------------
                    // PHONE
                    // ----------------------------------------

                    _field(
                      controller:
                          phoneController,
                      label: 'Phone Number',
                      hint:
                          'Enter phone number',
                      keyboardType:
                          TextInputType.phone,
                    ),

                    const SizedBox(height: 5),

                    // ----------------------------------------
                    // DEFAULT CHECKBOX
                    // ----------------------------------------

                    InkWell(
                      onTap: () {
                        setSheetState(() {
                          makeDefault =
                              !makeDefault;
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: makeDefault,
                            onChanged: (value) {
                              setSheetState(() {
                                makeDefault =
                                    value ??
                                        false;
                              });
                            },
                            activeColor:
                                primary,
                          ),

                          const Text(
                            'Set as default address',
                            style:
                                TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w600,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ----------------------------------------
                    // SAVE
                    // ----------------------------------------

                    SizedBox(
                      width:
                          double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          _saveAddress(
                            address: address,
                            label:
                                labelController
                                    .text
                                    .trim(),
                            name:
                                nameController
                                    .text
                                    .trim(),
                            addressText:
                                addressController
                                    .text
                                    .trim(),
                            city:
                                cityController
                                    .text
                                    .trim(),
                            state:
                                stateController
                                    .text
                                    .trim(),
                            pincode:
                                pincodeController
                                    .text
                                    .trim(),
                            phone:
                                phoneController
                                    .text
                                    .trim(),
                            landmark:
                                landmarkController
                                    .text
                                    .trim(),
                            makeDefault:
                                makeDefault,
                            sheetContext:
                                sheetContext,
                          );
                        },

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              primary,
                          foregroundColor:
                              Colors.white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              25,
                            ),
                          ),
                        ),

                        child: Text(
                          isEditing
                              ? 'Update Address'
                              : 'Save Address',
                          style:
                              const TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w800,
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

  // ==========================================================
  // SAVE ADDRESS
  // ==========================================================

  void _saveAddress({
    required SavedAddress? address,
    required String label,
    required String name,
    required String addressText,
    required String city,
    required String state,
    required String pincode,
    required String phone,
    required String landmark,
    required bool makeDefault,
    required BuildContext sheetContext,
  }) {
    if (label.isEmpty ||
        name.isEmpty ||
        addressText.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        pincode.isEmpty ||
        phone.isEmpty) {
      _showMessage(
        'Please fill all required fields',
      );
      return;
    }

    setState(() {
      if (address == null) {
        // ----------------------------------------------
        // ADD
        // ----------------------------------------------

        if (makeDefault) {
          for (final item in _addresses) {
            item.isDefault = false;
          }
        }

        _addresses.add(
          SavedAddress(
            id: DateTime.now()
                .millisecondsSinceEpoch
                .toString(),
            label: label.toUpperCase(),
            name: name,
            address: addressText,
            city: city,
            state: state,
            pincode: pincode,
            phone: phone,
            landmark: landmark,
            isDefault: makeDefault ||
                _addresses.isEmpty,
          ),
        );
      } else {
        // ----------------------------------------------
        // EDIT
        // ----------------------------------------------

        if (makeDefault) {
          for (final item in _addresses) {
            item.isDefault = false;
          }
        }

        address.label =
            label.toUpperCase();
        address.name = name;
        address.address = addressText;
        address.city = city;
        address.state = state;
        address.pincode = pincode;
        address.phone = phone;
        address.landmark = landmark;
        address.isDefault =
            makeDefault;
      }
    });

    Navigator.pop(sheetContext);

    _showMessage(
      address == null
          ? 'Address added successfully'
          : 'Address updated successfully',
    );
  }

  // ==========================================================
  // FORM FIELD
  // ==========================================================

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,

          filled: true,
          fillColor: Colors.white,

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 13,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: borderColor,
            ),
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(11),
            borderSide: const BorderSide(
              color: borderColor,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(11),
            borderSide:
                const BorderSide(
              color: primary,
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_off_outlined,
            size: 60,
            color: Color(0xFF9AA5A1),
          ),

          const SizedBox(height: 12),

          const Text(
            'No Saved Addresses',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Add an address for faster checkout.',
            style: TextStyle(
              fontSize: 14,
              color: textGrey,
            ),
          ),
        ],
      ),
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