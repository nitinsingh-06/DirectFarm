import 'dart:io';

import 'package:farmdirect/features/farmer/dashboard/models/product_model.dart';
import 'package:farmdirect/features/farmer/dashboard/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  String selectedCategory = 'Fruits / फल';
  String selectedUnit = 'Dozen / दर्जन';

  bool certifiedOrganic = true;

  final List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  12,
                  14,
                  25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PRODUCT NAME
                    _buildLabel('Product Name'),

                    const SizedBox(height: 5),

                    _buildTextField(
                      controller: productNameController,
                      hint: 'Organic Alphonso Mangoes',
                    ),

                    const SizedBox(height: 12),

                    // CATEGORY
                    _buildLabel('Category'),

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

                    const SizedBox(height: 12),

                    // PRICE + PER UNIT
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                hint: '350',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

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
                                  'Piece / नग',
                                  'Liter / लीटर',
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

                    // TOTAL STOCK - SEPARATE FULL WIDTH ROW
                    _buildLabel('Total Stock in kg'),

                    const SizedBox(height: 5),

                    _buildTextField(
                      controller: stockController,
                      hint: '100',
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // PRODUCT PHOTOS
                    _buildLabel('Product Photos'),

                    const SizedBox(height: 5),

                    _buildPhotoSection(),

                    const SizedBox(height: 12),

                    // ORGANIC
                    _buildOrganicSwitch(),

                    const SizedBox(height: 13),

                    // SAVE
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      height: 53,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 20,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            'Add Product',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // LABEL
  // ----------------------------------------------------------

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  // ----------------------------------------------------------
  // TEXT FIELD
  // ----------------------------------------------------------

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 39,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 10,
            color: Color(0xFF8B969D),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // DROPDOWN
  // ----------------------------------------------------------

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 17,
            color: Color(0xFF68747D),
          ),
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textDark,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // PHOTO SECTION
  // ----------------------------------------------------------

  Widget _buildPhotoSection() {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
                SizedBox(height: 4),
                Text(
                  'Add Photo',
                  style: TextStyle(
                    fontSize: 7.5,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 7),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        selectedImages[index],
                        height: 72,
                        width: 72,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      right: 2,
                      top: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImages.removeAt(index);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // PICK IMAGES
  // ----------------------------------------------------------

  Future<void> _pickImages() async {
    final images = await picker.pickMultiImage();

    if (images.isEmpty) return;

    setState(() {
      selectedImages.addAll(
        images.map((image) => File(image.path)),
      );
    });
  }

  // ----------------------------------------------------------
  // ORGANIC SWITCH
  // ----------------------------------------------------------

  Widget _buildOrganicSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certified Organic',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'This product is organically certified',
                  style: TextStyle(
                    fontSize: 7.5,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: certifiedOrganic,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                certifiedOrganic = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SAVE BUTTON
  // ----------------------------------------------------------

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Save Product',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SAVE PRODUCT
  // ----------------------------------------------------------

  void _saveProduct() {
    final name = productNameController.text.trim();
    final priceText = priceController.text.trim();
    final stockText = stockController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter product name');
      return;
    }

    if (priceText.isEmpty) {
      _showMessage('Please enter price');
      return;
    }

    final price = double.tryParse(priceText);

    if (price == null || price <= 0) {
      _showMessage('Please enter a valid price');
      return;
    }

    if (stockText.isEmpty) {
      _showMessage('Please enter total stock');
      return;
    }

    final stock = double.tryParse(stockText);

    if (stock == null || stock <= 0) {
      _showMessage('Please enter a valid stock quantity');
      return;
    }

    final product = Product(
      name: name,
      price: price.toString(),
      unit: _getShortUnit(selectedUnit),
      category: _getShortCategory(selectedCategory),
      stock: stock,
      images: selectedImages,
      organic: certifiedOrganic,
    );

    Navigator.pop(context, product);
  }

  // ----------------------------------------------------------
  // UNIT
  // ----------------------------------------------------------

  String _getShortUnit(String unit) {
    switch (unit) {
      case 'Dozen / दर्जन':
        return 'dozen';

      case 'Kg / किलो':
        return 'kg';

      case 'Piece / नग':
        return 'piece';

      case 'Liter / लीटर':
        return 'liter';

      default:
        return unit;
    }
  }

  // ----------------------------------------------------------
  // CATEGORY
  // ----------------------------------------------------------

  String _getShortCategory(String category) {
    switch (category) {
      case 'Fruits / फल':
        return 'Fruits';

      case 'Vegetables / सब्जियां':
        return 'Vegetables';

      case 'Grains / अनाज':
        return 'Grains';

      case 'Dairy / डेयरी':
        return 'Dairy';

      default:
        return category;
    }
  }

  // ----------------------------------------------------------
  // MESSAGE
  // ----------------------------------------------------------

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}