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
    final productKey = product.productId?.toString() ?? product.name;

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
                                 _changeAvailability(product, value);
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
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.70,
          minChildSize: 0.45,
          maxChildSize: 0.92,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                children: [
                  // ==================================================
                  // DRAG HANDLE
                  // ==================================================
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8DDDF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // ==================================================
                  // SCROLLABLE CONTENT
                  // ==================================================
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 25),
                      children: [
                        // =================================================
                        // PRODUCT HEADER
                        // =================================================
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildMenuProductImage(product),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF203039),
                                    ),
                                  ),

                                  const SizedBox(height: 4),

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

                        const SizedBox(height: 18),

                        // =================================================
                        // EDIT PRODUCT
                        // =================================================
                        _menuItem(
                          icon: Icons.edit_outlined,
                          title: 'Edit Product',
                          subtitle: 'Update product details',
                          onTap: () {
                            Navigator.pop(context);
                            _editProduct(product);
                          },
                        ),

                        // =================================================
                        // VIEW PRODUCT
                        // =================================================
                        _menuItem(
                          icon: Icons.visibility_outlined,
                          title: 'View Product',
                          subtitle: 'See product information',
                          onTap: () {
                            Navigator.pop(context);
                            _viewProduct(product);
                          },
                        ),

                        // =================================================
                        // MANAGE STOCK
                        // =================================================
                        _menuItem(
                          icon: Icons.inventory_2_outlined,
                          title: 'Manage Stock',
                          subtitle: 'Update available quantity',
                          onTap: () {
                            Navigator.pop(context);
                            _manageStock(product);
                          },
                        ),

                        // =================================================
                        // DUPLICATE
                        // =================================================
                        _menuItem(
                          icon: Icons.copy_outlined,
                          title: 'Duplicate Product',
                          subtitle: 'Create a copy of this product',
                          onTap: () {
                            Navigator.pop(context);
                            _duplicateProduct(product);
                          },
                        ),

                        // =================================================
                        // DELETE
                        // =================================================
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

                        const SizedBox(height: 10),

                        // =================================================
                        // CANCEL
                        // =================================================
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuProductImage(Product product) {
    String? imageUrl = product.imageUrl?.trim();

    // ------------------------------------------------------------
    // NO IMAGE
    // ------------------------------------------------------------

    if (imageUrl == null || imageUrl.isEmpty) {
      return _menuImagePlaceholder();
    }

    // ------------------------------------------------------------
    // CONVERT RELATIVE URL TO FULL URL
    // ------------------------------------------------------------

    if (imageUrl.startsWith('/')) {
      imageUrl = '${ApiConfig.baseUrl}$imageUrl';
    }

    debugPrint('MENU PRODUCT IMAGE: $imageUrl');

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDDE5E2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,

        // =========================================================
        // LOADING
        // =========================================================
        loadingBuilder:
            (
              BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) {
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

        // =========================================================
        // ERROR
        // =========================================================
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
              debugPrint('MENU IMAGE LOAD FAILED: $imageUrl');

              debugPrint('MENU IMAGE ERROR: $error');

              return _menuImagePlaceholder();
            },
      ),
    );
  }

  Widget _menuImagePlaceholder() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 27, color: Color(0xFF8B969D)),
      ),
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
  // EDIT PRODUCT
  // ============================================================

  Future<void> _editProduct(Product product) async {
    if (product.productId == null) {
      _showError('Product ID is missing');
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

      final data = await ApiService.getProduct(
        productId: product.productId!,
        idToken: idToken,
      );

      if (!mounted) return;

      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _EditProductDialog(
          product: product,
          data: data,
          idToken: idToken,
        ),
      );

      if (result == true && mounted) {
        await _loadProducts();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('EDIT PRODUCT ERROR: $e');
      _showError('Failed to open product: $e');
    }
  }

  // ============================================================
  // VIEW PRODUCT
  // ============================================================

  Future<void> _viewProduct(Product product) async {
    if (product.productId == null) {
      _showError('Product ID is missing');
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

      final data = await ApiService.getProduct(
        productId: product.productId!,
        idToken: idToken,
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (_) => _ProductDetailsDialog(
          product: product,
          data: data,
        ),
      );
    } catch (e) {
      debugPrint('VIEW PRODUCT ERROR: $e');
      _showError('Failed to load product: $e');
    }
  }

  // ============================================================
  // MANAGE STOCK
  // ============================================================

  Future<void> _manageStock(Product product) async {
    if (product.productId == null) {
      _showError('Product ID is missing');
      return;
    }

    final controller = TextEditingController(
      text: _formatStock(product.stock),
    );

    final quantity = await showDialog<double>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Manage Stock',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006B54),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final value = double.tryParse(
                  controller.text.trim(),
                );

                if (value == null || value < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter a valid quantity'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext, value);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (quantity == null || !mounted) {
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

      await ApiService.updateProductStock(
        productId: product.productId!,
        idToken: idToken,
        quantityAvailable: quantity,
      );

      if (!mounted) return;

      await _loadProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stock updated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('UPDATE STOCK ERROR: $e');
      _showError('Failed to update stock: $e');
    }
  }

  // ============================================================
  // DUPLICATE PRODUCT
  // ============================================================

  Future<void> _duplicateProduct(Product product) async {
    if (product.productId == null) {
      _showError('Product ID is missing');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Duplicate Product?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            'Create a new copy of "${product.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006B54),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Duplicate'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
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

      await ApiService.duplicateProduct(
        productId: product.productId!,
        idToken: idToken,
      );

      if (!mounted) return;

      await _loadProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product duplicated successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('DUPLICATE PRODUCT ERROR: $e');
      _showError('Failed to duplicate product: $e');
    }
  }

  // ============================================================
  // DELETE PRODUCT
  // ============================================================

  Future<void> _deleteProduct(Product product) async {
    if (product.productId == null) {
      _showError('Product ID is missing');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Product?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            'Are you sure you want to permanently delete '
            '"${product.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
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

      setState(() {
        backendProducts.removeWhere(
          (item) => item.productId == product.productId,
        );
        availabilityMap.remove(product.productId.toString());
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      await _loadProducts();
    } catch (e) {
      debugPrint('DELETE PRODUCT ERROR: $e');
      _showError('Failed to delete product: $e');
    }
  }

  void _confirmDelete(Product product) {
    _deleteProduct(product);
  }

  // ============================================================
  // AVAILABILITY
  // ============================================================

  Future<void> _changeAvailability(
    Product product,
    bool value,
  ) async {
    if (product.productId == null) {
      return;
    }

    final key = product.productId.toString();
    final previousValue =
        availabilityMap[key] ?? product.stock > 0;

    setState(() {
      availabilityMap[key] = value;
    });

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception('User is not logged in');
      }

      final idToken = await firebaseUser.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Invalid Firebase token');
      }

      await ApiService.updateProductAvailability(
        productId: product.productId!,
        idToken: idToken,
        isAvailable: value,
      );
    } catch (e) {
      debugPrint('UPDATE AVAILABILITY ERROR: $e');

      if (mounted) {
        setState(() {
          availabilityMap[key] = previousValue;
        });
      }

      _showError('Failed to update availability: $e');
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
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

// ============================================================================
// EDIT PRODUCT DIALOG
// ============================================================================

class _EditProductDialog extends StatefulWidget {
  final Product product;
  final Map<String, dynamic> data;
  final String idToken;

  const _EditProductDialog({
    required this.product,
    required this.data,
    required this.idToken,
  });

  @override
  State<_EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<_EditProductDialog> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController unitController;
  late final TextEditingController quantityController;

  late int selectedCategoryId;

  bool isSaving = false;

  final List<Map<String, dynamic>> categoryOptions = const [
    {'id': 1, 'name': 'Vegetables'},
    {'id': 2, 'name': 'Fruits'},
    {'id': 3, 'name': 'Grains'},
    {'id': 5, 'name': 'Dairy'},
  ];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.data['name']?.toString() ?? widget.product.name,
    );

    descriptionController = TextEditingController(
      text: widget.data['description']?.toString() ?? '',
    );

    priceController = TextEditingController(
      text: widget.data['price']?.toString() ?? widget.product.price,
    );

    unitController = TextEditingController(
      text: widget.data['unit']?.toString() ?? widget.product.unit,
    );

    quantityController = TextEditingController(
      text: widget.data['quantity_available']?.toString() ??
          widget.product.stock.toString(),
    );

    selectedCategoryId =
        int.tryParse(
          widget.data['category_id']?.toString() ?? '',
        ) ??
        _categoryIdFromName(widget.product.category);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    unitController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  int _categoryIdFromName(String category) {
    switch (category.toLowerCase()) {
      case 'vegetables':
        return 1;
      case 'fruits':
        return 2;
      case 'grains':
        return 3;
      case 'dairy':
        return 5;
      default:
        return 1;
    }
  }

  Future<void> _save() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    final price = double.tryParse(priceController.text.trim());
    final quantity =
        double.tryParse(quantityController.text.trim());
    final unit = unitController.text.trim();

    if (name.isEmpty) {
      _showError('Product name is required');
      return;
    }

    if (price == null || price < 0) {
      _showError('Enter a valid price');
      return;
    }

    if (quantity == null || quantity < 0) {
      _showError('Enter a valid stock quantity');
      return;
    }

    if (unit.isEmpty) {
      _showError('Unit is required');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await ApiService.updateProduct(
        productId: widget.product.productId!,
        idToken: widget.idToken,
        name: name,
        description: description.isEmpty ? null : description,
        categoryId: selectedCategoryId,
        price: price,
        unit: unit,
        quantityAvailable: quantity,
        imageUrl: widget.data['image_url']?.toString(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint('SAVE EDIT PRODUCT ERROR: $e');

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      _showError('Failed to update product: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _decoration(
    String label, {
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFF006B54),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.edit_outlined,
            color: Color(0xFF006B54),
          ),
          SizedBox(width: 8),
          Text(
            'Edit Product',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 430,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                enabled: !isSaving,
                decoration: _decoration('Product Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                enabled: !isSaving,
                minLines: 3,
                maxLines: 5,
                decoration: _decoration(
                  'Description',
                  hint: 'Describe your product',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: categoryOptions.any(
                  (item) => item['id'] == selectedCategoryId,
                )
                    ? selectedCategoryId
                    : null,
                decoration: _decoration('Category'),
                items: categoryOptions.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'] as int,
                    child: Text(category['name'] as String),
                  );
                }).toList(),
                onChanged: isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategoryId = value;
                          });
                        }
                      },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      enabled: !isSaving,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: _decoration('Price'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: unitController,
                      enabled: !isSaving,
                      decoration: _decoration('Unit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: quantityController,
                enabled: !isSaving,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _decoration(
                  'Available Quantity',
                  hint: 'Current stock',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving
              ? null
              : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isSaving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006B54),
            foregroundColor: Colors.white,
          ),
          child: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Save Changes'),
        ),
      ],
    );
  }
}

// ============================================================================
// VIEW PRODUCT DIALOG
// ============================================================================

class _ProductDetailsDialog extends StatelessWidget {
  final Product product;
  final Map<String, dynamic> data;

  const _ProductDetailsDialog({
    required this.product,
    required this.data,
  });

  String _value(String key, String fallback) {
    final value = data[key]?.toString().trim();

    if (value == null || value.isEmpty || value == 'null') {
      return fallback;
    }

    return value;
  }

  String _stock() {
    final value = double.tryParse(
      data['quantity_available']?.toString() ?? '',
    );

    if (value == null) {
      return product.stock.toString();
    }

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  String _price() {
    final raw = data['price']?.toString();

    if (raw == null || raw.isEmpty) {
      return product.price;
    }

    final value = double.tryParse(raw);

    if (value == null) {
      return raw;
    }

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    String? imageUrl = data['image_url']?.toString();

    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl.startsWith('/')) {
      imageUrl = '${ApiConfig.baseUrl}$imageUrl';
    }

    return AlertDialog(
      title: const Text(
        'Product Details',
        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return _imagePlaceholder();
                    },
                  ),
                )
              else
                _imagePlaceholder(),
              const SizedBox(height: 15),
              Text(
                _value('name', product.name),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF203039),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '₹${_price()}/${_value('unit', product.unit)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF006B54),
                ),
              ),
              const SizedBox(height: 15),
              _infoRow(
                'Category',
                _value('category_name', product.category),
              ),
              _infoRow(
                'Available Stock',
                '${_stock()} ${_value('unit', product.unit)}',
              ),
              _infoRow(
                'Product ID',
                _value(
                  'product_id',
                  product.productId?.toString() ?? '-',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF203039),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _value(
                  'description',
                  'No description available.',
                ),
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF68757C),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF006B54),
            foregroundColor: Colors.white,
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7A858B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF203039),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 45,
          color: Color(0xFF8B969D),
        ),
      ),
    );
  }
}
