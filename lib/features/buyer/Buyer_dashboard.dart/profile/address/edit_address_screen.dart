import 'package:farmdirect/features/buyer/models/address_model.dart';
import 'package:flutter/material.dart';

import 'package:farmdirect/services/api_services.dart';

class EditAddressScreen
    extends StatefulWidget {
  final AddressModel address;

  const EditAddressScreen({
    super.key,
    required this.address,
  });

  @override
  State<EditAddressScreen> createState() =>
      _EditAddressScreenState();
}

class _EditAddressScreenState
    extends State<EditAddressScreen> {
  static const primary =
      Color(0xFF087C59);

  static const background =
      Color(0xFFF7FAF9);

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

  late String selectedLabel;

  late bool isDefault;

  bool saving = false;
  bool deleting = false;

  @override
  void initState() {
    super.initState();

    final address =
        widget.address;

    nameController.text =
        address.fullName;

    phoneController.text =
        address.phone;

    addressController.text =
        address.addressLine;

    landmarkController.text =
        address.landmark;

    cityController.text =
        address.city;

    stateController.text =
        address.state;

    pincodeController.text =
        address.pincode;

    selectedLabel =
        address.label;

    isDefault =
        address.isDefault;
  }

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

  // ============================================================
  // UPDATE
  // ============================================================

  Future<void> _updateAddress() async {
    if (!_validate()) {
      return;
    }

    try {
      setState(() {
        saving = true;
      });

      await ApiService.updateAddress(
        addressId:
            widget.address.addressId,
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
        'Failed to update address',
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> _deleteAddress() async {
    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Address?',
          ),
          content: const Text(
            'This address will be permanently deleted from your account.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                false,
              ),
              child:
                  const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(
                context,
                true,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {
      setState(() {
        deleting = true;
      });

      await ApiService.deleteAddress(
        addressId:
            widget.address.addressId,
      );

      if (!mounted) return;

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      _message(
        'Failed to delete address',
      );
    } finally {
      if (mounted) {
        setState(() {
          deleting = false;
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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          background,

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
              'Edit Address',
              style: TextStyle(
                color: primary,
                fontSize: 18,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            Text(
              'Update your address details',
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
              nameController,
              Icons.person_outline,
            ),

            _field(
              'Phone Number',
              phoneController,
              Icons.phone_outlined,
              keyboard:
                  TextInputType.phone,
            ),

            _field(
              'Address Line',
              addressController,
              Icons.home_outlined,
              maxLines: 2,
            ),

            _field(
              'Landmark (Optional)',
              landmarkController,
              Icons.location_on_outlined,
            ),

            Row(
              children: [
                Expanded(
                  child: _field(
                    'City',
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
                    stateController,
                    Icons.map_outlined,
                  ),
                ),
              ],
            ),

            _field(
              'Pincode',
              pincodeController,
              Icons.markunread_mailbox_outlined,
              keyboard:
                  TextInputType.number,
            ),

            _defaultSwitch(),

            const SizedBox(
              height: 8,
            ),

            // UPDATE
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed:
                    saving || deleting
                        ? null
                        : _updateAddress,
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
                        width: 19,
                        height: 19,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    : const Text(
                        'Update Address',
                        style:
                            TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // DELETE
            SizedBox(
              width: double.infinity,
              height: 42,
              child:
                  OutlinedButton.icon(
                onPressed:
                    saving || deleting
                        ? null
                        : _deleteAddress,
                icon: deleting
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.red,
                        ),
                      )
                    : const Icon(
                        Icons
                            .delete_outline,
                        size: 16,
                      ),
                label:
                    const Text(
                  'Delete Address',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
                style:
                    OutlinedButton
                        .styleFrom(
                  foregroundColor:
                      Colors.red,
                  side:
                      const BorderSide(
                    color: Colors.red,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
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