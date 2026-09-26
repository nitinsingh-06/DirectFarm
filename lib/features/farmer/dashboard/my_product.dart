import 'package:farmdirect/config/api_config.dart';
import 'package:farmdirect/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmdirect/features/buyer/models/product_model.dart';

class MyProductsScreen extends StatefulWidget {
  final List<Product> products;
  final Future<void> Function() onAddProduct;

  const MyProductsScreen({
    super.key,
    required this.products,
    required this.onAddProduct,
  });

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  bool isLoadingProducts = false;

  List<Product> backendProducts = [];

  int selectedCategory = 0;

  final List<String> categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Grains',
    'Dairy',
    'Others',
  ];

  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  // Keeps track of availability switches locally.
  final Map<String, bool> availabilityMap = {};

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {
        searchText = searchController.text.toLowerCase().trim();
      });
    });

    _loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // ADD PRODUCT
  // ============================================================

  Future<void> _addProductAndRefresh() async {
    await widget.onAddProduct();

    if (!mounted) return;

    await _loadProducts();
  }

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

  Future<void> _loadProducts() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return;
    }

    try {
      setState(() {
        isLoadingProducts = true;
      });

      final idToken = await firebaseUser.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        if (mounted) {
          setState(() {
            isLoadingProducts = false;
          });
        }
        return;
      }

      final productsData = await ApiService.getMyProducts(idToken: idToken);

      final loadedProducts = productsData.map<Product>((data) {
        return Product(
          productId: int.tryParse(data['product_id']?.toString() ?? ''),
          name: data['name']?.toString() ?? '',
          price: data['price']?.toString() ?? '0',
          unit: data['unit']?.toString() ?? '',
          category: _getCategoryName(data['category_id']),
          stock:
              double.tryParse(data['quantity_available']?.toString() ?? '0') ??
              0,
          imageUrl: data['image_url']?.toString(),
          organic: false,
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        backendProducts = loadedProducts;
        isLoadingProducts = false;
      });
    } catch (e) {
      debugPrint('LOAD PRODUCTS ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoadingProducts = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to load products',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF006B54),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          


          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Manage Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Add, edit or remove your farm products',
                  style: TextStyle(
                    color: Color(0xFFD5F2E9),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: _addProductAndRefresh,
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add_circle, size: 15, color: Color(0xFF006B54)),
                  SizedBox(width: 5),
                  Text(
                    'Add Product',
                    style: TextStyle(
                      color: Color(0xFF006B54),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
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

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E5E7)),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(fontSize: 11, color: Color(0xFF1D2B32)),
              decoration: const InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(fontSize: 10, color: Color(0xFF8A969D)),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 17,
                  color: Color(0xFF7C8A91),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),

        const SizedBox(width: 7),

        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE0E5E7)),
          ),
          child: const Row(
            children: [
              Icon(Icons.tune_rounded, size: 15, color: Color(0xFF006B54)),
              SizedBox(width: 4),
              Text(
                'Filter',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF006B54),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CATEGORY CHIPS
  // ============================================================

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 31,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final selected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF006B54) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? const Color(0xFF006B54)
                      : const Color(0xFFDDE3E7),
                ),
              ),
              child: Row(
                children: [
                  if (index != 0) ...[
                    Text(
                      _categoryIcon(categories[index]),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    categories[index],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : const Color(0xFF526067),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _categoryIcon(String category) {
    switch (category) {
      case 'Vegetables':
        return '🌿';
      case 'Fruits':
        return '🍎';
      case 'Grains':
        return '🌾';
      case 'Dairy':
        return '🥛';
      default:
        return '•••';
    }
  }

  // ============================================================
  // PRODUCT LIST
  // ============================================================

  Widget _buildProductsList() {
    final allProducts = [...backendProducts];

    final filteredProducts = allProducts.where((product) {
      final matchesSearch =
          searchText.isEmpty ||
          product.name.toLowerCase().contains(searchText) ||
          product.category.toLowerCase().contains(searchText);

      final selectedCategoryName = categories[selectedCategory];

      final matchesCategory =
          selectedCategory == 0 ||
          product.category.toLowerCase() == selectedCategoryName.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

    if (isLoadingProducts) {
      return const Padding(
        padding: EdgeInsets.only(top: 80),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF006B54)),
        ),
      );
    }

    if (filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        ...filteredProducts.map(
          (product) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildProductCard(product),
          ),
        ),

        const SizedBox(height: 5),

        _buildAddProductCard(),
      ],
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _buildProductCard(Product product) {
    final productKey = product.name;

    final isAvailable = availabilityMap[productKey] ?? product.stock > 0;

    return Container(
      height: 124,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E7E9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------
          // IMAGE
          // ----------------------------------------------------
          _buildProductImage(product),

          const SizedBox(width: 9),

          // ----------------------------------------------------
          // PRODUCT INFORMATION
          // ----------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF17262D),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        _showProductMenu(product);
                      },
                      child: const Icon(
                        Icons.more_vert_rounded,
                        size: 18,
                        color: Color(0xFF006B54),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3),

                // Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F6EC),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 7.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF087A48),
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                // Price
                Row(
                  children: [
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF006B54),
                      ),
                    ),
                    Text(
                      '/${product.unit}',
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color(0xFF697780),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                // Stock
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 10,
                      color: Color(0xFF748189),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'Available: ${_formatStock(product.stock)} ${product.unit}',
                      style: const TextStyle(
                        fontSize: 7.5,
                        color: Color(0xFF68757C),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                // Location
                const Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 10,
                      color: Color(0xFF748189),
                    ),
                    SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        'Paurikhal, Tehri Garhwal',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 7.5,
                          color: Color(0xFF68757C),
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // ------------------------------------------------
                // ACTION BUTTONS
                // ------------------------------------------------
                Row(
                  children: [
                    // Availability
                    Container(
                      height: 23,
                      padding: const EdgeInsets.only(left: 6, right: 3),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? const Color(0xFFE6F7ED)
                            : const Color(0xFFF1F2F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isAvailable ? 'Available' : 'Unavailable',
                            style: TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                              color: isAvailable
                                  ? const Color(0xFF087A48)
                                  : const Color(0xFF6D777D),
                            ),
                          ),
                          const SizedBox(width: 3),
                          SizedBox(
                            width: 27,
                            height: 17,
                            child: Switch(
                              value: isAvailable,
                              onChanged: (value) {
                                setState(() {
                                  availabilityMap[productKey] = value;
                                });
                              },
                              activeColor: Colors.white,
                              activeTrackColor: const Color(0xFF006B54),
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: const Color(0xFFB9C1C5),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Edit
                    _smallActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: const Color(0xFF006B54),
                      background: Colors.white,
                      borderColor: const Color(0xFF79B9A8),
                      onTap: () {
                        _editProduct(product);
                      },
                    ),

                    const SizedBox(width: 5),

                    // Delete
                    _smallActionButton(
                      icon: Icons.delete_outline_rounded,
                      label: 'Delete',
                      color: const Color(0xFFE53935),
                      background: const Color(0xFFFFEEEE),
                      borderColor: const Color(0xFFFFD0D0),
                      onTap: () {
                        _confirmDelete(product);
                      },
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

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================
  Widget _buildProductImage(Product product) {
    String? imageUrl = product.imageUrl?.trim();

    debugPrint('======================================');
    debugPrint('PRODUCT NAME: ${product.name}');
    debugPrint('IMAGE FROM API: $imageUrl');

    if (imageUrl == null || imageUrl.isEmpty) {
      debugPrint('NO IMAGE URL');
      return _imagePlaceholder();
    }

    // Convert relative backend path to complete URL
    if (imageUrl.startsWith('/')) {
      imageUrl = '${ApiConfig.baseUrl}$imageUrl';
    }

    debugPrint('FINAL IMAGE URL: $imageUrl');
    debugPrint('======================================');

    return Container(
      width: 82,
      height: 109,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F2),
        borderRadius: BorderRadius.circular(9),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            debugPrint('IMAGE LOADED: $imageUrl');
            return child;
          }

          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF006B54),
              ),
            ),
          );
        },

        errorBuilder: (context, error, stackTrace) {
          debugPrint('IMAGE LOAD FAILED: $imageUrl');
          debugPrint('IMAGE ERROR: $error');

          return _imagePlaceholder();
        },
      ),
    );
  }

  Widget _imagePlaceholder() {
    return const Center(
      child: Icon(Icons.image_outlined, size: 25, color: Color(0xFF9BA5A9)),
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  Widget _smallActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color background,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 23,
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 7.5,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ADD PRODUCT CARD
  // ============================================================

  Widget _buildAddProductCard() {
    return GestureDetector(
      onTap: _addProductAndRefresh,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8F5),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFB9DCCF)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              color: Color(0xFF006B54),
              size: 20,
            ),
            SizedBox(width: 7),
            Text(
              'Add New Product',
              style: TextStyle(
                color: Color(0xFF006B54),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 20),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6F1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              size: 32,
              color: Color(0xFF006B54),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF26343A),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Add your first product to start selling.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Color(0xFF7A858B)),
          ),

          const SizedBox(height: 18),

          GestureDetector(
            onTap: _addProductAndRefresh,
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF006B54),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text(
                    'Add Product',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
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

  // ============================================================
  // THREE DOT MENU
  // ============================================================

  void _showProductMenu(Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DDDF),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  _buildMenuProductImage(product),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '₹${product.price}/${product.unit}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF006B54),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              _menuItem(
                icon: Icons.edit_outlined,
                title: 'Edit Product',
                subtitle: 'Update product details',
                onTap: () {
                  Navigator.pop(context);
                  _editProduct(product);
                },
              ),

              _menuItem(
                icon: Icons.visibility_outlined,
                title: 'View Product',
                subtitle: 'See product information',
                onTap: () {
                  Navigator.pop(context);
                  _viewProduct(product);
                },
              ),

              _menuItem(
                icon: Icons.inventory_2_outlined,
                title: 'Manage Stock',
                subtitle: 'Update available quantity',
                onTap: () {
                  Navigator.pop(context);
                  _manageStock(product);
                },
              ),

              _menuItem(
                icon: Icons.copy_outlined,
                title: 'Duplicate Product',
                subtitle: 'Create a copy of this product',
                onTap: () {
                  Navigator.pop(context);
                  _duplicateProduct(product);
                },
              ),

              _menuItem(
                icon: Icons.delete_outline_rounded,
                title: 'Delete Product',
                subtitle: 'Remove from your store',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(product);
                },
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDE3E7)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF5E6A70),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuProductImage(Product product) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F2),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: product.imageUrl != null && product.imageUrl!.isNotEmpty
          ? Image.network(product.imageUrl!, fit: BoxFit.cover)
          : const Icon(Icons.image_outlined, color: Color(0xFF8B969D)),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = const Color(0xFF203039),
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color == Colors.red
              ? const Color(0xFFFFEEEE)
              : const Color(0xFFEAF6F1),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(
          icon,
          color: color == Colors.red ? Colors.red : const Color(0xFF006B54),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 9, color: Color(0xFF7A858B)),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: color),
    );
  }

  // ============================================================
  // EDIT
  // ============================================================

  void _editProduct(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${product.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO:
    // Navigate to your EditProductScreen here.
  }

  // ============================================================
  // VIEW PRODUCT
  // ============================================================

  void _viewProduct(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('View ${product.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO:
    // Navigate to FarmerProductDetailsScreen.
  }

  // ============================================================
  // MANAGE STOCK
  // ============================================================

  void _manageStock(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(
          text: product.stock.toString(),
        );

        return AlertDialog(
          title: const Text(
            'Manage Stock',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Available Quantity',
              suffixText: product.unit,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Stock update will be connected to backend.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006B54),
              ),
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DUPLICATE
  // ============================================================

  void _duplicateProduct(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Duplicate ${product.name}'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO:
    // Add duplicate product API call.
  }

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product?'),
          content: Text('Are you sure you want to delete "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteProduct(product);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DELETE
  // ============================================================
  Future<void> _deleteProduct(Product product) async {
    if (product.productId == null) {
      debugPrint('DELETE FAILED: productId is null');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Product?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text('Are you sure you want to delete "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception('User is not logged in');
      }

      final idToken = await firebaseUser.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Invalid Firebase token');
      }

      await ApiService.deleteProduct(
        productId: product.productId!,
        idToken: idToken,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );

      await _loadProducts();
    } catch (e) {
      debugPrint('DELETE PRODUCT ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // ============================================================
  // HELPERS
  // ============================================================

  String _formatStock(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  String _getCategoryName(dynamic categoryId) {
    switch (int.tryParse(categoryId.toString())) {
      case 1:
        return 'Vegetables';

      case 2:
        return 'Fruits';

      case 3:
        return 'Grains';

      case 5:
        return 'Dairy';

      default:
        return 'Other';
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7FAF9),
      child: Column(
        children: [
          _buildHeader(),

          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF006B54),
              onRefresh: _loadProducts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 9, 12, 25),
                child: Column(
                  children: [
                    _buildSearchBar(),

                    const SizedBox(height: 9),

                    _buildCategoryChips(),

                    const SizedBox(height: 9),

                    _buildProductsList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
