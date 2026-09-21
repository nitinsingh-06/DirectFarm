import 'package:flutter/material.dart';

import 'package:farmdirect/services/api_services.dart';

class AddAddressScreen
    extends StatefulWidget {
  const AddAddressScreen({
    super.key,
  });

  @override
  State<AddAddressScreen> createState() =>
      _AddAddressScreenState();
}

class _AddAddressScreenState
    extends State<AddAddressScreen> {
  static const primary =
      Color(0xFF087C59);

  static const background =
      Color(0xFFF7FAF9);

  static const textDark =
      Color(0xFF20332E);

  final nameController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final landmarkController =
      TextEditingController();

  final cityController =
      TextEditingController();

  final stateController =
      TextEditingController();

  final pincodeController =
      TextEditingController();

  String selectedLabel = 'Home';

  bool isDefault = false;

  bool saving = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();

    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_validate()) {
      return;
    }

    try {
      setState(() {
        saving = true;
      });

      await ApiService.createAddress(
        fullName:
            nameController.text.trim(),
        phone:
            phoneController.text.trim(),
        addressLine:
            addressController.text.trim(),
        landmark:
            landmarkController.text.trim(),
        city:
            cityController.text.trim(),
        state:
            stateController.text.trim(),
        pincode:
            pincodeController.text.trim(),
        label: selectedLabel,
        isDefault: isDefault,
      );

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      _message(
        'Failed to save address',
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  bool _validate() {
    if (nameController.text
        .trim()
        .isEmpty) {
      _message('Enter full name');
      return false;
    }

    if (phoneController.text
        .trim()
        .isEmpty) {
      _message('Enter phone number');
      return false;
    }

    if (addressController.text
        .trim()
        .isEmpty) {
      _message('Enter address');
      return false;
    }

    if (cityController.text
        .trim()
        .isEmpty) {
      _message('Enter city');
      return false;
    }

    if (stateController.text
        .trim()
        .isEmpty) {
      _message('Enter state');
      return false;
    }

    if (pincodeController.text
        .trim()
        .length !=
        6) {
      _message(
        'Enter valid 6 digit pincode',
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor:
            background,
        elevation: 0,

        leading: IconButton(
          onPressed: () =>
              Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: primary,
          ),
        ),

        title: const Column(
          children: [
            Text(
              'Add New Address',
              style: TextStyle(
                color: primary,
                fontSize: 18,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            Text(
              'Fill in the details to save your address',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 8,
              ),
            ),
          ],
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          10,
          5,
          10,
          20,
        ),
        child: Column(
          children: [
            _labelDropdown(),

            _field(
              'Full Name',
              'Enter full name',
              nameController,
              Icons.person_outline,
            ),

            _field(
              'Phone Number',
              'Enter phone number',
              phoneController,
              Icons.phone_outlined,
              keyboard:
                  TextInputType.phone,
            ),

            _field(
              'Address Line',
              'House / Flat / Street / Area',
              addressController,
              Icons.home_outlined,
              maxLines: 2,
            ),

            _field(
              'Landmark (Optional)',
              'e.g. Near Metro Station',
              landmarkController,
              Icons.location_on_outlined,
            ),

            Row(
              children: [
                Expanded(
                  child: _field(
                    'City',
                    'Enter city',
                    cityController,
                    Icons.location_city_outlined,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: _field(
                    'State',
                    'Enter state',
                    stateController,
                    Icons.map_outlined,
                  ),
                ),
              ],
            ),

            _field(
              'Pincode',
              'Enter pincode',
              pincodeController,
              Icons.markunread_mailbox_outlined,
              keyboard:
                  TextInputType.number,
            ),

            _defaultSwitch(),

            const SizedBox(
              height: 8,
            ),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed:
                    saving
                        ? null
                        : _saveAddress,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      primary,
                  foregroundColor:
                      Colors.white,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                child: saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Address',
                        style:
                            TextStyle(
                          fontSize: 12,
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
  }

  Widget _labelDropdown() {
    return _section(
      'Address Label',
      DropdownButtonHideUnderline(
        child:
            DropdownButton<String>(
          value: selectedLabel,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'Home',
              child: Text('Home'),
            ),
            DropdownMenuItem(
              value: 'Work',
              child: Text('Work'),
            ),
            DropdownMenuItem(
              value: 'Other',
              child: Text('Other'),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedLabel =
                  value;
            });
          },
        ),
      ),
    );
  }

  Widget _field(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboard,
    int maxLines = 1,
  }) {
    return _section(
      label,
      TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        style:
            const TextStyle(
          fontSize: 11,
        ),
        decoration:
            InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            icon,
            size: 17,
            color: Colors.grey,
          ),
          border:
              InputBorder.none,
          contentPadding:
              const EdgeInsets
                  .symmetric(
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _section(
    String title,
    Widget child,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(
            fontSize: 9,
            color: textDark,
            fontWeight:
                FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(
            bottom: 7,
          ),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration:
              BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(
              9,
            ),
            border: Border.all(
              color:
                  const Color(
                0xFFE0E6E3,
              ),
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _defaultSwitch() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration:
                const BoxDecoration(
              color: Color(0xFFFFF1C9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.star,
              color:
                  Colors.orange,
              size: 17,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          const Expanded(
            child: Text(
              'Set as default address',
              style:
                  TextStyle(
                fontSize: 10,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: isDefault,
            activeColor: primary,
            onChanged: (value) {
              setState(() {
                isDefault = value;
              });
            },
          ),
        ],
      ),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}