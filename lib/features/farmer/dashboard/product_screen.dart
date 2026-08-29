import 'dart:io';

import 'package:farmdirect/features/farmer/dashboard/my_product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


// ============================================================
// COLORS
// ============================================================

class AppColors {
  static const primary = Color(0xFF075C49);
  static const green = Color(0xFF80D000);
  static const lightGreen = Color(0xFFE9F7EF);
  static const background = Color(0xFFF7F9FA);
  static const border = Color(0xFFE3E7EA);
  static const textDark = Color(0xFF263238);
  static const textGrey = Color(0xFF68747D);
  static const red = Color(0xFFFF5A5F);
  static const yellow = Color(0xFFFFC83D);
}

// ============================================================
// PRODUCT MODEL
// ============================================================

class Product {
  final String name;
  final String price;
  final String unit;
  final String category;
  final List<File> images;
  final bool organic;

  Product({
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.images,
    required this.organic,
  });
}

// ============================================================
// PRODUCT SCREEN
// ============================================================

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedIndex = 1;

  final List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    final screens = [
      const SimplePage(title: 'Home'),
      MyProductsScreen(
        products: products,
        onAddProduct: _openAddProduct,
      ),
      const SimplePage(title: 'Orders'),
      const SimplePage(title: 'Earnings'),
      const SimplePage(title: 'Profile'),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: screens[selectedIndex],
      ),
    );
  }

  void _openAddProduct() async {
    final Product? product = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddProductScreen(),
      ),
    );

    if (product != null) {
      setState(() {
        products.add(product);
      });
    }
  }

  Widget _buildBottomNavigation() {
    final items = [
      (Icons.home_outlined, Icons.home, 'Home'),
      (Icons.eco_outlined, Icons.eco, 'Products'),
      (Icons.inventory_2_outlined, Icons.inventory_2, 'Orders'),
      (Icons.currency_rupee, Icons.currency_rupee, 'Earnings'),
      (Icons.person_outline, Icons.person, 'Profile'),
    ];

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) {
            final selected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 62,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      selected ? items[index].$2 : items[index].$1,
                      size: 19,
                      color: selected
                          ? AppColors.primary
                          : const Color(0xFF7B8790),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[index].$3,
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected
                            ? AppColors.primary
                            : const Color(0xFF7B8790),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// MY PRODUCTS SCREEN
// ============================================================




// ============================================================
// PRODUCT CARD
// ============================================================

class ProductCardData {
  final String name;
  final String price;
  final String? image;
  final File? fileImage;
  final String badge;
  final Color? badgeColor;

  ProductCardData({
    required this.name,
    required this.price,
    this.image,
    this.fileImage,
    required this.badge,
    this.badgeColor,
  });
}

class ProductCard extends StatelessWidget {
  final ProductCardData data;

  const ProductCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 145,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE1E6E9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(9),
              ),
              child: _buildImage(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 5, 5, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      data.price,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    if (data.badge.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: (data.badgeColor ?? AppColors.lightGreen)
                              .withOpacity(0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          data.badge,
                          style: TextStyle(
                            fontSize: 6.5,
                            fontWeight: FontWeight.w700,
                            color: data.badgeColor ?? AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (data.fileImage != null) {
      return Image.file(
        data.fileImage!,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (data.image != null) {
      return Image.asset(
        data.image!,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _placeholder();
        },
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF0F2F1),
      child: const Icon(
        Icons.image_outlined,
        color: Color(0xFF98A29F),
      ),
    );
  }
}

// ============================================================
// ADD PRODUCT SCREEN
// ============================================================

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final productNameController = TextEditingController();
  final priceController = TextEditingController();

  String selectedCategory = 'Fruits / फल';
  String selectedUnit = 'Dozen / दर्जन';

  bool certifiedOrganic = true;

  final List<File> selectedImages = [];

  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
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
                    _buildLabel('Product Name'),
                    const SizedBox(height: 5),
                    _buildTextField(
                      controller: productNameController,
                      hint: 'Organic Alphonso Mangoes',
                    ),

                    const SizedBox(height: 12),

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

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Price (₹)'),
                              const SizedBox(height: 5),
                              _buildTextField(
                                controller: priceController,
                                hint: '350',
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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

                    _buildLabel('Product Photos'),
                    const SizedBox(height: 5),
                    _buildPhotoSection(),

                    const SizedBox(height: 12),

                    _buildOrganicSwitch(),

                    const SizedBox(height: 13),

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

  Widget _buildHeader() {
    return Container(
      height: 53,
      width: double.infinity,
      alignment: Alignment.centerLeft,
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
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 17,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 10.5,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 10,
            color: Color(0xFF7B858B),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            size: 18,
            color: Color(0xFF78858D),
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

  Widget _buildPhotoSection() {
    return SizedBox(
      height: 76,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: 76,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFDDE3E7),
                  style: BorderStyle.solid,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 21,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Upload',
                    style: TextStyle(
                      fontSize: 8,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),

          ...selectedImages.map(
            (file) => Padding(
              padding: const EdgeInsets.only(left: 7),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 3,
                    top: 3,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImages.remove(file);
                        });
                      },
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganicSwitch() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Certified Organic',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                certifiedOrganic = !certifiedOrganic;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 18,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: certifiedOrganic
                    ? AppColors.green
                    : const Color(0xFFB9C0C4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: certifiedOrganic
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Save Product',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await picker.pickMultiImage(
      imageQuality: 80,
    );

    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(
          images.map((image) => File(image.path)),
        );
      });
    }
  }

  void _saveProduct() {
    if (productNameController.text.trim().isEmpty) {
      _showMessage('Please enter product name');
      return;
    }

    if (priceController.text.trim().isEmpty) {
      _showMessage('Please enter product price');
      return;
    }

    final product = Product(
      name: productNameController.text.trim(),
      price: priceController.text.trim(),
      unit: _getShortUnit(selectedUnit),
      category: selectedCategory,
      images: selectedImages,
      organic: certifiedOrganic,
    );

    Navigator.pop(context, product);
  }

  String _getShortUnit(String unit) {
    if (unit.startsWith('Dozen')) return 'dozen';
    if (unit.startsWith('Kg')) return 'kg';
    if (unit.startsWith('Piece')) return 'piece';
    if (unit.startsWith('Liter')) return 'liter';

    return unit;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// OTHER PAGES
// ============================================================

class SimplePage extends StatelessWidget {
  final String title;

  const SimplePage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }
}