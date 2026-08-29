import 'dart:io';

import 'package:farmdirect/core/widgets/image_upload_widgets.dart';
import 'package:flutter/material.dart';


class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController =
      TextEditingController(
    text: 'Organic Alphonso Mangoes',
  );

  final TextEditingController priceController =
      TextEditingController(
    text: '350',
  );

  String selectedCategory = 'Fruits / फल';
  String selectedUnit = 'Dozen / दर्जन';

  bool isOrganic = true;

  File? productImage;

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),

      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  7,
                  14,
                  7,
                  15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    _buildLabel(
                      'Product Name',
                    ),

                    const SizedBox(height: 5),

                    _buildTextField(
                      controller: productNameController,
                    ),

                    const SizedBox(height: 11),

                    // Category
                    _buildLabel(
                      'Category',
                    ),

                    const SizedBox(height: 5),

                    _buildDropdown(
                      value: selectedCategory,
                      items: const [
                        'Fruits / फल',
                        'Vegetables / सब्जियां',
                        'Grains / अनाज',
                        'Dairy / डेयरी',
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 11),

                    // Price + Unit
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Price (₹)'),

                              const SizedBox(height: 5),

                              _buildTextField(
                                controller: priceController,
                                keyboardType:
                                    TextInputType.number,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 9),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Per Unit'),

                              const SizedBox(height: 5),

                              _buildDropdown(
                                value: selectedUnit,
                                items: const [
                                  'Dozen / दर्जन',
                                  'Kg / किलो',
                                  'Quintal / क्विंटल',
                                  'Piece / नग',
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedUnit = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Product Photos
                    _buildLabel('Product Photos'),

                    const SizedBox(height: 6),

                    ImageUploadWidget(
                      onImageSelected: (File? image) {
                        setState(() {
                          productImage = image;
                        });

                        debugPrint(
                          'Selected image: ${image?.path}',
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Certified Organic
                    _buildOrganicSwitch(),

                    const SizedBox(height: 13),

                    // Save
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 49,
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE7ECEA),
          ),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: const Text(
        'Add Product',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: Color(0xFF075B47),
        ),
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 8.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF26332F),
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 9.5,
          color: Color(0xFF374151),
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8E5),
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8E5),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFF075B47),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return SizedBox(
      height: 34,
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,

        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 15,
          color: Color(0xFF75817E),
        ),

        style: const TextStyle(
          fontSize: 9.5,
          color: Color(0xFF374151),
        ),

        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8E5),
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(
              color: Color(0xFFE2E8E5),
            ),
          ),
        ),

        items: items.map(
          (String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 9,
                ),
              ),
            );
          },
        ).toList(),

        onChanged: onChanged,
      ),
    );
  }

  // ============================================================
  // ORGANIC SWITCH
  // ============================================================

  Widget _buildOrganicSwitch() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE2E8E5),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Certified Organic',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Color(0xFF303B37),
            ),
          ),

          const Spacer(),

          Switch(
            value: isOrganic,
            onChanged: (value) {
              setState(() {
                isOrganic = value;
              });
            },

            activeColor: Colors.white,
            activeTrackColor: Color(0xFF7BCB00),

            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 35,
      child: ElevatedButton(
        onPressed: _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF075B47),
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: const Text(
          'Save Product',
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SAVE PRODUCT
  // ============================================================

  void _saveProduct() {
    if (productNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter product name',
          ),
        ),
      );

      return;
    }

    if (priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter price',
          ),
        ),
      );

      return;
    }

    debugPrint('Product Name: ${productNameController.text}');
    debugPrint('Price: ${priceController.text}');
    debugPrint('Category: $selectedCategory');
    debugPrint('Unit: $selectedUnit');
    debugPrint('Organic: $isOrganic');
    debugPrint('Image: ${productImage?.path}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Product saved successfully',
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE4E9E7),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            Icons.home_outlined,
            'Home',
            false,
          ),
          _navItem(
            Icons.eco_outlined,
            'Products',
            true,
          ),
          _navItem(
            Icons.receipt_long_outlined,
            'Orders',
            false,
          ),
          _navItem(
            Icons.currency_rupee,
            'Earnings',
            false,
          ),
          _navItem(
            Icons.person_outline,
            'Profile',
            false,
          ),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String title,
    bool selected,
  ) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: selected
              ? const Color(0xFF08745C)
              : const Color(0xFF7B8582),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: TextStyle(
            fontSize: 7,
            fontWeight: selected
                ? FontWeight.w700
                : FontWeight.w500,
            color: selected
                ? const Color(0xFF08745C)
                : const Color(0xFF7B8582),
          ),
        ),
      ],
    );
  }
}