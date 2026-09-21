import 'package:farmdirect/services/api_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:farmdirect/features/farmer/dashboard/widgets/product_card.dart';
import 'package:farmdirect/features/buyer/models/product_model.dart';
import 'package:farmdirect/features/farmer/dashboard/product_screen.dart';

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

  final categories = ['All', 'Grains', 'Vegetables', 'Fruits', 'Dairy'];

  final TextEditingController searchController = TextEditingController();

  String searchText = '';

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

  Future<void> _addProductAndRefresh() async {
    await widget.onAddProduct();

    if (!mounted) return;

    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 25),
            child: Column(
              children: [
                _buildSearchBar(),

                const SizedBox(height: 10),

                _buildCategoryChips(),

                const SizedBox(height: 10),

                _buildProductsGrid(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  //  LOAD PRODUCT--------------------->
  // --------------------------------------------------------

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
        return;
      }

      final productsData = await ApiService.getMyProducts(idToken: idToken);

      final loadedProducts = productsData.map<Product>((data) {
        return Product(
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
    }
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      height: 53,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: const Text(
        'My Products',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SEARCH
  // ----------------------------------------------------------

  Widget _buildSearchBar() {
    return Container(
      height: 39,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: searchController,
        style: const TextStyle(fontSize: 11),
        decoration: const InputDecoration(
          hintText: 'Search crop, grains, etc...',
          hintStyle: TextStyle(fontSize: 10, color: Color(0xFF8B969D)),
          prefixIcon: Icon(Icons.search, size: 17, color: Color(0xFF87939B)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CATEGORY CHIPS
  // ----------------------------------------------------------

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 29,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final selected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFFDDE3E7),
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : const Color(0xFF59656C),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // PRODUCTS GRID
  // ----------------------------------------------------------

  Widget _buildProductsGrid() {
    final allProducts = [...backendProducts];

    final filteredProducts = allProducts.where((product) {
      // SEARCH FILTER
      final matchesSearch =
          searchText.isEmpty ||
          product.name.toLowerCase().contains(searchText) ||
          product.category.toLowerCase().contains(searchText);

      // CATEGORY FILTER
      final selectedCategoryName = categories[selectedCategory];

      final matchesCategory =
          selectedCategory == 0 ||
          product.category.toLowerCase() == selectedCategoryName.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = <Widget>[];

        for (final product in filteredProducts) {
          cards.add(ProductCard(product: product));
        }

        // ADD NEW PRODUCT CARD
        cards.add(
          GestureDetector(
            onTap: _addProductAndRefresh,
            child: Container(
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDDE3E7)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 23, color: Color(0xFF697780)),
                  SizedBox(height: 7),
                  Text(
                    'Add New Product',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF697780),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // NO PRODUCTS MESSAGE
        if (filteredProducts.isEmpty) {
          return Column(
            children: [
              const SizedBox(height: 25),

              const Icon(
                Icons.inventory_2_outlined,
                size: 40,
                color: Color(0xFF9AA5AA),
              ),

              const SizedBox(height: 8),

              const Text(
                'No products found',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: 15),

              GestureDetector(
                onTap: _addProductAndRefresh,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Add New Product',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 500 ? 3 : 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (_, index) => cards[index],
        );
      },
    );
  }

  // --------------------------------------------------
  // GET CATEGORYNAME
  // --------------------------------------------------
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

  // ---------------------------------------
  //
  // ---------------------------------------
}
