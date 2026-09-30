import 'dart:io';

import 'package:farmdirect/features/farmer/dashboard/product_screen.dart';
import 'package:farmdirect/l10n/app_localizations.dart';
import 'package:farmdirect/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // Keep these values language-independent.
  String selectedCategory = 'fruits';
  String selectedUnit = 'dozen';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PRODUCT NAME
                    _buildLabel(l10n.productName),

                    const SizedBox(height: 5),

                    _buildTextField(
                      controller: productNameController,
                      hint: l10n.productNameHint,
                    ),

                    const SizedBox(height: 12),

                    // CATEGORY
                    _buildLabel(l10n.category),

                    const SizedBox(height: 5),

                    _buildDropdown(
                      value: selectedCategory,
                      items: const ['fruits', 'vegetables', 'grains', 'dairy'],
                      itemLabel: _categoryLabel,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(l10n.priceRupees),

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(l10n.perUnit),

                              const SizedBox(height: 5),

                              _buildDropdown(
                                value: selectedUnit,
                                items: const ['dozen', 'kg', 'piece', 'liter'],
                                itemLabel: _unitLabel,
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

                    // TOTAL STOCK
                    _buildLabel(l10n.totalStockKg),

                    const SizedBox(height: 5),

                    _buildTextField(
                      controller: stockController,
                      hint: '100',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // PRODUCT PHOTOS
                    _buildLabel(l10n.productPhotos),

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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 53,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
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

          Text(
            l10n.addProduct,
            style: const TextStyle(
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
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 11, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 10, color: Color(0xFF8B969D)),
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
    required String Function(String, AppLocalizations) itemLabel,
    required ValueChanged<String?> onChanged,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
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
          style: const TextStyle(fontSize: 10, color: AppColors.textDark),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                itemLabel(item, l10n),
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
  // CATEGORY LABEL
  // ----------------------------------------------------------

  static String _categoryLabel(String category, AppLocalizations l10n) {
    switch (category) {
      case 'fruits':
        return l10n.fruits;

      case 'vegetables':
        return l10n.vegetables;

      case 'grains':
        return l10n.grains;

      case 'dairy':
        return l10n.dairy;

      default:
        return category;
    }
  }

  // ----------------------------------------------------------
  // UNIT LABEL
  // ----------------------------------------------------------

  static String _unitLabel(String unit, AppLocalizations l10n) {
    switch (unit) {
      case 'dozen':
        return l10n.dozen;

      case 'kg':
        return l10n.kilogram;

      case 'piece':
        return l10n.piece;

      case 'liter':
        return l10n.liter;

      default:
        return unit;
    }
  }

  // ----------------------------------------------------------
  // PHOTO SECTION
  // ----------------------------------------------------------
  Widget _buildPhotoSection() {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        GestureDetector(
          onTap: _showImageSourceDialog,
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_a_photo_outlined,
                  size: 22,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.addPhoto,
                  style: const TextStyle(
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
              separatorBuilder: (_, __) => const SizedBox(width: 7),
              itemBuilder: (context, index) {
                final imageFile = selectedImages[index];

                return Stack(
                  key: ValueKey(imageFile.path),
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        imageFile,
                        height: 72,
                        width: 72,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 72,
                            width: 72,
                            color: const Color(0xFFF2F4F3),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.broken_image_outlined,
                              size: 22,
                              color: AppColors.textGrey,
                            ),
                          );
                        },
                      ),
                    ),

                    Positioned(
                      right: 2,
                      top: 2,
                      child: GestureDetector(
                        onTap: () => _removeImage(imageFile.path),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(1),
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

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Add Product Photo',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Choose how you want to add the product photo',
                  style: TextStyle(fontSize: 11, color: AppColors.textGrey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _imageSourceButton(
                        icon: Icons.camera_alt_rounded,
                        title: 'Take Photo',
                        onTap: () {
                          Navigator.pop(context);
                          _takePhoto();
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _imageSourceButton(
                        icon: Icons.photo_library_rounded,
                        title: 'Gallery',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImages();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // IMAGE SOURCE BUTTONS
  // ----------------------------------------------------------
  Widget _imageSourceButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAF8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppColors.primary),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1600,
        maxHeight: 1600,
      );

      if (image == null || !mounted) return;

      final file = File(image.path);

      final alreadySelected = selectedImages.any(
        (selected) => selected.path == file.path,
      );

      if (alreadySelected) {
        _showMessage(l10n.imagesAlreadySelected);
        return;
      }

      setState(() {
        selectedImages.add(file);
      });

      debugPrint('CAMERA IMAGE ADDED: ${file.path}');
    } catch (e) {
      debugPrint('CAMERA ERROR: $e');

      if (!mounted) return;

      _showMessage('Unable to open camera: $e');
    }
  }

  // ----------------------------------------------------------
  // PICK IMAGES
  // ----------------------------------------------------------

  Future<void> _pickImages() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final images = await picker.pickMultiImage();

      if (images.isEmpty || !mounted) return;

      final newFiles = <File>[];

      for (final image in images) {
        final file = File(image.path);

        final alreadySelected = selectedImages.any(
          (selected) => selected.path == file.path,
        );

        if (!alreadySelected) {
          newFiles.add(file);
        }
      }

      if (newFiles.isEmpty) {
        _showMessage(l10n.imagesAlreadySelected);
        return;
      }

      setState(() {
        selectedImages.addAll(newFiles);
      });
    } catch (e) {
      debugPrint('IMAGE PICK ERROR: $e');

      if (!mounted) return;

      _showMessage(l10n.unableToSelectImages);
    }
  }

  void _removeImage(String imagePath) {
    if (!mounted) return;

    setState(() {
      selectedImages.removeWhere((image) => image.path == imagePath);
    });

    debugPrint('IMAGE REMOVED: $imagePath');
  }

  // ----------------------------------------------------------
  // ORGANIC SWITCH
  // ----------------------------------------------------------

  Widget _buildOrganicSwitch() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.certifiedOrganic,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  l10n.organicDescription,
                  style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          l10n.saveProduct,
          style: const TextStyle(
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

  Future<void> _saveProduct() async {
    final l10n = AppLocalizations.of(context)!;

    final name = productNameController.text.trim();
    final priceText = priceController.text.trim();
    final stockText = stockController.text.trim();

    // --------------------------------------------------------
    // VALIDATION
    // --------------------------------------------------------

    if (name.isEmpty) {
      _showMessage(l10n.pleaseEnterProductName);
      return;
    }

    if (priceText.isEmpty) {
      _showMessage(l10n.pleaseEnterPrice);
      return;
    }

    final price = double.tryParse(priceText);

    if (price == null || price <= 0) {
      _showMessage(l10n.pleaseEnterValidPrice);
      return;
    }

    if (stockText.isEmpty) {
      _showMessage(l10n.pleaseEnterTotalStock);
      return;
    }

    final stock = double.tryParse(stockText);

    if (stock == null || stock <= 0) {
      _showMessage(l10n.pleaseEnterValidStock);
      return;
    }

    // --------------------------------------------------------
    // FIREBASE USER
    // --------------------------------------------------------

    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      _showMessage(l10n.pleaseLoginAgain);
      return;
    }

    try {
      // ------------------------------------------------------
      // FIREBASE TOKEN
      // ------------------------------------------------------

      final idToken = await firebaseUser.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        _showMessage(l10n.unableToGetFirebaseToken);
        return;
      }

      // ------------------------------------------------------
      // CATEGORY
      // ------------------------------------------------------

      final categoryId = _getCategoryId(selectedCategory);

      // ------------------------------------------------------
      // UPLOAD PRIMARY IMAGE
      // ------------------------------------------------------

      String? imageUrl;

      if (selectedImages.isNotEmpty) {
        _showMessage(l10n.uploadingProductImage);

        imageUrl = await ApiService.uploadProductImage(
          imagePath: selectedImages.first.path,
        );

        debugPrint('PRODUCT IMAGE URL: $imageUrl');
      }

      // ------------------------------------------------------
      // CREATE PRODUCT
      // ------------------------------------------------------

      final response = await ApiService.createProduct(
        idToken: idToken,
        name: name,
        description: null,
        categoryId: categoryId,
        price: price,
        unit: _getShortUnit(selectedUnit),
        quantityAvailable: stock,
        imageUrl: imageUrl,
      );

      debugPrint('PRODUCT CREATED: $response');

      // ------------------------------------------------------
      // SUCCESS
      // ------------------------------------------------------

      if (!mounted) return;

      _showMessage(l10n.productSavedSuccessfully);

      if (mounted) {
        setState(() {
          selectedImages.clear();
        });
      }

      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('CREATE PRODUCT ERROR: $e');

      if (!mounted) return;

      // Keep backend/API error as returned by the server.
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // ----------------------------------------------------------
  // UNIT
  // ----------------------------------------------------------

  String _getShortUnit(String unit) {
    switch (unit) {
      case 'dozen':
        return 'dozen';

      case 'kg':
        return 'kg';

      case 'piece':
        return 'piece';

      case 'liter':
        return 'liter';

      default:
        return unit;
    }
  }

  // ----------------------------------------------------------
  // CATEGORY ID
  // ----------------------------------------------------------

  int _getCategoryId(String category) {
    switch (category) {
      case 'vegetables':
        return 1;

      case 'fruits':
        return 2;

      case 'grains':
        return 3;

      case 'dairy':
        return 5;

      default:
        return 7;
    }
  }

  // ----------------------------------------------------------
  // MESSAGE
  // ----------------------------------------------------------

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
