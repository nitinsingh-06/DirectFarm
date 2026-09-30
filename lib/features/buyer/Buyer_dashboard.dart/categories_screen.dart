
import 'package:farmdirect/config/api_config.dart';
import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/marketplace/add_to_cart.dart';
import 'package:farmdirect/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // ============================================================
  // STATE
  // ============================================================

  int selectedCategory = 0;

  String? selectedSubCategory;

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> databaseCategories = [];

  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  // ============================================================
  // MAIN CATEGORIES
  // ============================================================

  final List<Map<String, dynamic>> mainCategories = [
    {
      'name': 'All',
      'icon': Icons.grid_view_rounded,
      'color': Color(0xFF087C59),
    },
    {
      'name': 'Vegetables',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF4CAF50),
    },
    {
      'name': 'Fruits',
      'icon': Icons.apple_rounded,
      'color': Color(0xFFE53935),
    },
    {
      'name': 'Grains',
      'icon': Icons.grain_rounded,
      'color': Color(0xFFE7A72B),
    },
    {
      'name': 'Pulses',
      'icon': Icons.spa_rounded,
      'color': Color(0xFF8D6E63),
    },
    {
      'name': 'Dry Products',
      'icon': Icons.inventory_2_rounded,
      'color': Color(0xFF795548),
    },
    {
      'name': 'Other',
      'icon': Icons.category_rounded,
      'color': Color(0xFF7189B0),
    },
  ];

  // ============================================================
  // SUBCATEGORY DEFINITIONS
  //
  // These are used to classify REAL products returned by
  // /products. The product itself still comes from PostgreSQL.
  // ============================================================

  final Map<String, List<String>> subCategories = {
    'Vegetables': [
      'All',
      'Onion',
      'Potato',
      'Tomato',
      'Carrot',
      'Cabbage',
      'Cauliflower',
      'Capsicum',
      'Cucumber',
      'Brinjal',
      'Spinach',
      'Peas',
      'Radish',
      'Beetroot',
      'Lady Finger',
      'Other Vegetables',
    ],

    'Fruits': [
      'All',
      'Apple',
      'Banana',
      'Mango',
      'Orange',
      'Grapes',
      'Papaya',
      'Guava',
      'Pomegranate',
      'Watermelon',
      'Muskmelon',
      'Pineapple',
      'Lemon',
      'Other Fruits',
    ],

    'Grains': [
      'All',
      'Rice',
      'Wheat',
      'Maize',
      'Corn',
      'Bajra',
      'Millet',
      'Ragi',
      'Barley',
      'Oats',
      'Other Grains',
    ],

    'Pulses': [
      'All',
      'Lentils',
      'Dal',
      'Chickpeas',
      'Chana',
      'Rajma',
      'Kidney Beans',
      'Black Gram',
      'Urad',
      'Green Gram',
      'Moong',
      'Toor Dal',
      'Arhar Dal',
      'Peas',
      'Other Pulses',
    ],

    'Dry Products': [
      'All',
      'Almond',
      'Almonds',
      'Cashew',
      'Cashews',
      'Walnut',
      'Walnuts',
      'Raisin',
      'Raisins',
      'Dates',
      'Dry Coconut',
      'Dried Fruits',
      'Seeds',
      'Other Dry Products',
    ],

    'Other': [
      'All',
      'Dairy',
      'Spices',
      'Organic',
      'Beverages',
      'Snacks',
      'Other',
    ],
  };

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      if (!mounted) return;

      setState(() {
        searchText = searchController.text.trim().toLowerCase();
      });
    });

    _loadData();
  }

  // ============================================================
  // LOAD REAL DATA
  // ============================================================

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      // Load categories from PostgreSQL
      final categoryData = await ApiService.getCategories();

      // Load products from PostgreSQL
      final productData = await ApiService.getProducts();

      if (!mounted) return;

      final loadedCategories = categoryData
          .map<Map<String, dynamic>>(
            (item) => {
              'id': item['category_id'],
              'name': item['name']?.toString() ?? '',
              'description':
                  item['description']?.toString() ?? '',
            },
          )
          .where(
            (category) =>
                category['name'].toString().trim().isNotEmpty,
          )
          .toList();

      final loadedProducts = productData
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();

      setState(() {
        databaseCategories = loadedCategories;
        products = loadedProducts;
        isLoading = false;
      });

      debugPrint(
        'CATEGORIES LOADED: ${databaseCategories.length}',
      );

      debugPrint(
        'PRODUCTS LOADED: ${products.length}',
      );
    } catch (e) {
      debugPrint('CATEGORY SCREEN LOAD ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ============================================================
  // CATEGORY ICON
  // ============================================================

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase().trim()) {
      case 'vegetables':
        return Icons.eco_rounded;

      case 'fruits':
        return Icons.apple_rounded;

      case 'grains':
        return Icons.grain_rounded;

      case 'pulses':
        return Icons.spa_rounded;

      case 'dry products':
        return Icons.inventory_2_rounded;

      case 'dairy':
        return Icons.local_drink_rounded;

      case 'organic':
        return Icons.spa_rounded;

      case 'spices':
        return Icons.local_fire_department_rounded;

      case 'beverages':
        return Icons.local_cafe_rounded;

      case 'snacks':
        return Icons.cookie_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  // ============================================================
  // CATEGORY COLOR
  // ============================================================

  Color _getCategoryColor(String name) {
    switch (name.toLowerCase().trim()) {
      case 'vegetables':
        return const Color(0xFF4CAF50);

      case 'fruits':
        return const Color(0xFFE53935);

      case 'grains':
        return const Color(0xFFE7A72B);

      case 'pulses':
        return const Color(0xFF8D6E63);

      case 'dry products':
        return const Color(0xFF795548);

      case 'dairy':
        return const Color(0xFF2196F3);

      case 'organic':
        return const Color(0xFF087C59);

      case 'spices':
        return const Color(0xFFE64A19);

      default:
        return const Color(0xFF7189B0);
    }
  }

  // ============================================================
  // SELECT MAIN CATEGORY
  // ============================================================

  void _selectMainCategory(int index) {
    setState(() {
      selectedCategory = index;
      selectedSubCategory = null;
      searchController.clear();
    });
  }

  // ============================================================
  // SELECT SUBCATEGORY
  // ============================================================

  void _selectSubCategory(String subCategory) {
    setState(() {
      selectedSubCategory = subCategory;
    });
  }

  // ============================================================
  // CURRENT CATEGORY
  // ============================================================

  String get currentCategory {
    return mainCategories[selectedCategory]['name'].toString();
  }

  // ============================================================
  // NORMALIZE TEXT
  // ============================================================

  String _normalize(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll('-', ' ')
        .replaceAll('_', ' ');
  }

  // ============================================================
  // GET PRODUCT CATEGORY NAME
  // ============================================================

  String _getProductCategoryName(
    Map<String, dynamic> product,
  ) {
    final categoryId = product['category_id'];

    // First try matching the category ID from database.
    for (final category in databaseCategories) {
      if (category['id'].toString() == categoryId.toString()) {
        return category['name']?.toString() ?? '';
      }
    }

    // Some backend responses may already contain category.
    return product['category']?.toString() ??
        product['category_name']?.toString() ??
        '';
  }

  // ============================================================
  // CLASSIFY PRODUCT INTO MAIN CATEGORY
  // ============================================================

  String _getMainProductCategory(
    Map<String, dynamic> product,
  ) {
    final name =
        _normalize(product['name']?.toString() ?? '');

    final backendCategory =
        _normalize(_getProductCategoryName(product));

    // ----------------------------------------------------------
    // BACKEND CATEGORY FIRST
    // ----------------------------------------------------------

    if (backendCategory.contains('vegetable')) {
      return 'Vegetables';
    }

    if (backendCategory.contains('fruit')) {
      return 'Fruits';
    }

    if (backendCategory.contains('grain')) {
      return 'Grains';
    }

    if (backendCategory.contains('pulse') ||
        backendCategory.contains('dal') ||
        backendCategory.contains('legume')) {
      return 'Pulses';
    }

    if (backendCategory.contains('dry')) {
      return 'Dry Products';
    }

    // ----------------------------------------------------------
    // PRODUCT NAME FALLBACK
    // ----------------------------------------------------------

    const vegetables = [
      'onion',
      'potato',
      'tomato',
      'carrot',
      'cabbage',
      'cauliflower',
      'capsicum',
      'cucumber',
      'brinjal',
      'eggplant',
      'spinach',
      'palak',
      'peas',
      'radish',
      'beetroot',
      'lady finger',
      'okra',
      'broccoli',
      'garlic',
      'ginger',
      'pumpkin',
      'bottle gourd',
      'bitter gourd',
      'beans',
    ];

    const fruits = [
      'apple',
      'banana',
      'mango',
      'orange',
      'grapes',
      'papaya',
      'guava',
      'pomegranate',
      'watermelon',
      'muskmelon',
      'pineapple',
      'lemon',
      'kiwi',
      'peach',
      'pear',
      'plum',
      'cherry',
      'coconut',
    ];

    const grains = [
      'rice',
      'wheat',
      'maize',
      'corn',
      'bajra',
      'millet',
      'ragi',
      'barley',
      'oats',
      'quinoa',
    ];

    const pulses = [
      'lentil',
      'dal',
      'chickpea',
      'chana',
      'rajma',
      'kidney bean',
      'black gram',
      'urad',
      'green gram',
      'moong',
      'toor',
      'arhar',
      'pigeon pea',
      'soybean',
    ];

    const dryProducts = [
      'almond',
      'cashew',
      'walnut',
      'raisin',
      'date',
      'dry fruit',
      'dried fruit',
      'dry coconut',
      'seed',
      'pistachio',
    ];

    if (vegetables.any(name.contains)) {
      return 'Vegetables';
    }

    if (fruits.any(name.contains)) {
      return 'Fruits';
    }

    if (grains.any(name.contains)) {
      return 'Grains';
    }

    if (pulses.any(name.contains)) {
      return 'Pulses';
    }

    if (dryProducts.any(name.contains)) {
      return 'Dry Products';
    }

    return 'Other';
  }

  // ============================================================
  // FILTER REAL PRODUCTS
  // ============================================================

  List<Map<String, dynamic>> get filteredProducts {
    List<Map<String, dynamic>> result = List.from(products);

    // ----------------------------------------------------------
    // MAIN CATEGORY
    // ----------------------------------------------------------

    if (currentCategory != 'All') {
      result = result.where((product) {
        return _getMainProductCategory(product) ==
            currentCategory;
      }).toList();
    }

    // ----------------------------------------------------------
    // SUBCATEGORY
    // ----------------------------------------------------------

    if (selectedSubCategory != null &&
        selectedSubCategory != 'All') {
      result = result.where((product) {
        return _matchesSubCategory(
          product,
          selectedSubCategory!,
        );
      }).toList();
    }

    // ----------------------------------------------------------
    // SEARCH
    // ----------------------------------------------------------

    if (searchText.isNotEmpty) {
      result = result.where((product) {
        final name =
            product['name']?.toString().toLowerCase() ?? '';

        final description =
            product['description']?.toString().toLowerCase() ??
                '';

        return name.contains(searchText) ||
            description.contains(searchText);
      }).toList();
    }

    return result;
  }

  // ============================================================
  // SUBCATEGORY MATCHING
  // ============================================================

  bool _matchesSubCategory(
    Map<String, dynamic> product,
    String subCategory,
  ) {
    final name =
        _normalize(product['name']?.toString() ?? '');

    switch (_normalize(subCategory)) {
      case 'onion':
        return name.contains('onion');

      case 'potato':
        return name.contains('potato');

      case 'tomato':
        return name.contains('tomato');

      case 'carrot':
        return name.contains('carrot');

      case 'cabbage':
        return name.contains('cabbage');

      case 'cauliflower':
        return name.contains('cauliflower');

      case 'capsicum':
        return name.contains('capsicum') ||
            name.contains('bell pepper');

      case 'cucumber':
        return name.contains('cucumber');

      case 'brinjal':
        return name.contains('brinjal') ||
            name.contains('eggplant');

      case 'spinach':
        return name.contains('spinach') ||
            name.contains('palak');

      case 'peas':
        return name.contains('pea');

      case 'apple':
        return name.contains('apple');

      case 'banana':
        return name.contains('banana');

      case 'mango':
        return name.contains('mango');

      case 'orange':
        return name.contains('orange');

      case 'grapes':
        return name.contains('grape');

      case 'papaya':
        return name.contains('papaya');

      case 'guava':
        return name.contains('guava');

      case 'pomegranate':
        return name.contains('pomegranate');

      case 'watermelon':
        return name.contains('watermelon');

      case 'rice':
        return name.contains('rice');

      case 'wheat':
        return name.contains('wheat');

      case 'maize':
      case 'corn':
        return name.contains('maize') ||
            name.contains('corn');

      case 'bajra':
        return name.contains('bajra');

      case 'millet':
        return name.contains('millet');

      case 'ragi':
        return name.contains('ragi');

      case 'barley':
        return name.contains('barley');

      case 'oats':
        return name.contains('oat');

      case 'lentils':
      case 'dal':
        return name.contains('dal') ||
            name.contains('lentil');

      case 'chickpeas':
      case 'chana':
        return name.contains('chickpea') ||
            name.contains('chana');

      case 'rajma':
      case 'kidney beans':
        return name.contains('rajma') ||
            name.contains('kidney bean');

      case 'black gram':
      case 'urad':
        return name.contains('urad') ||
            name.contains('black gram');

      case 'green gram':
      case 'moong':
        return name.contains('moong') ||
            name.contains('green gram');

      case 'toor dal':
      case 'arhar dal':
        return name.contains('toor') ||
            name.contains('arhar');

      case 'almond':
      case 'almonds':
        return name.contains('almond');

      case 'cashew':
      case 'cashews':
        return name.contains('cashew');

      case 'walnut':
      case 'walnuts':
        return name.contains('walnut');

      case 'raisin':
      case 'raisins':
        return name.contains('raisin');

      case 'dates':
        return name.contains('date');

      case 'dry coconut':
        return name.contains('dry coconut') ||
            name.contains('dried coconut');

      case 'dried fruits':
        return name.contains('dry fruit') ||
            name.contains('dried fruit');

      case 'seeds':
        return name.contains('seed');

      default:
        return true;
    }
  }

  // ============================================================
  // SUBCATEGORY LIST
  // ============================================================

  List<String> get currentSubCategories {
    if (!subCategories.containsKey(currentCategory)) {
      return [];
    }

    return subCategories[currentCategory]!;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSideCategories(),

                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8EEEB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              currentCategory == 'All'
                  ? 'All Categories'
                  : currentCategory,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  _topIcon(
                    icon: Icons.shopping_cart_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      );
                    },
                  ),

                  if (cart.itemCount > 0)
                    Positioned(
                      right: -6,
                      top: -7,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5252),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          cart.itemCount > 99
                              ? '99+'
                              : cart.itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOP ICON
  // ============================================================

  Widget _topIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Center(
          child: Icon(
            icon,
            size: 27,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LEFT SIDEBAR
  // ============================================================

  Widget _buildSideCategories() {
    return Container(
      width: 85,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F3F6),
        border: Border(
          right: BorderSide(
            color: Color(0xFFE0E4E7),
          ),
        ),
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 8),
        itemCount: mainCategories.length,
        itemBuilder: (context, index) {
          final category = mainCategories[index];

          return _buildSideCategoryItem(
            index: index,
            name: category['name'].toString(),
            icon: category['icon'] as IconData,
            color: category['color'] as Color,
          );
        },
      ),
    );
  }

  // ============================================================
  // SIDEBAR ITEM
  // ============================================================

  Widget _buildSideCategoryItem({
    required int index,
    required String name,
    required IconData icon,
    required Color color,
  }) {
    final selected = selectedCategory == index;

    return GestureDetector(
      onTap: () {
        _selectMainCategory(index);
      },
      child: Container(
        height: 92,
        margin: const EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : const Color(0xFFF1F3F6),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Stack(
          children: [
            if (selected)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF087C59),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFE7F6EE)
                          : const Color(0xFFF1F3F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 27,
                      color: selected
                          ? const Color(0xFF087C59)
                          : color,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9.5,
                        height: 1.1,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: selected
                            ? const Color(0xFF087C59)
                            : const Color(0xFF7189B0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MAIN CONTENT
  // ============================================================

  Widget _buildMainContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF087C59),
        ),
      );
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        14,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),

          const SizedBox(height: 15),

          _buildHeroBanner(),

          const SizedBox(height: 20),

          // SUBCATEGORY MENU
          if (currentCategory != 'All') ...[
            _buildSubCategorySelector(),

            const SizedBox(height: 18),
          ],

          _buildProductSection(),

          const SizedBox(height: 20),

          _buildSupportCard(),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 50,
              color: Color(0xFF8A9690),
            ),

            const SizedBox(height: 12),

            const Text(
              'Unable to load products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              errorMessage ?? '',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF087C59),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFE0E7E4),
        ),
      ),
      child: TextField(
        controller: searchController,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF263238),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,

          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 19,
            color: Color(0xFF89958F),
          ),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 42,
          ),

          hintText: currentCategory == 'All'
              ? 'Search products...'
              : 'Search $currentCategory...',

          hintStyle: const TextStyle(
            fontSize: 9.5,
            color: Color(0xFF9AA49F),
          ),

          contentPadding: EdgeInsets.zero,

          suffixIcon: searchText.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: 17,
                    color: Color(0xFF89958F),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHeroBanner() {
    return Container(
      height: 145,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1542838132-92c53300491e?w=900',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.70),
              Colors.black.withOpacity(0.25),
              Colors.transparent,
            ],
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Fresh Choices',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            Text(
              'Healthier Lives',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: 5),

            Text(
              'Shop fresh products\nfrom local farmers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                height: 1.3,
              ),
            ),

            SizedBox(height: 9),

            _ShopButton(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUBCATEGORY SELECTOR
  // ============================================================

  Widget _buildSubCategorySelector() {
    final items = currentSubCategories;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$currentCategory Categories',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const SizedBox(width: 7),
            itemBuilder: (context, index) {
              final item = items[index];

              final selected =
                  selectedSubCategory == item ||
                  (selectedSubCategory == null &&
                      item == 'All');

              return GestureDetector(
                onTap: () {
                  _selectSubCategory(
                    item == 'All' ? 'All' : item,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF087C59)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF087C59)
                          : const Color(0xFFDDE5E1),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? Colors.white
                          : const Color(0xFF52615B),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PRODUCT SECTION
  // ============================================================

  Widget _buildProductSection() {
    final result = filteredProducts;

    String title;

    if (currentCategory == 'All') {
      title = 'All Products';
    } else if (selectedSubCategory != null &&
        selectedSubCategory != 'All') {
      title = selectedSubCategory!;
    } else {
      title = currentCategory;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),

            Text(
              '${result.length} Products',
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Color(0xFF77837E),
              ),
            ),
          ],
        ),

        const SizedBox(height: 11),

        if (result.isEmpty)
          _buildEmptyProducts()
        else
          _buildProductsGrid(result),
      ],
    );
  }

  // ============================================================
  // PRODUCTS GRID
  // ============================================================

  Widget _buildProductsGrid(
    List<Map<String, dynamic>> items,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 9,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final product = items[index];

        return _buildRealProductCard(product);
      },
    );
  }

  // ============================================================
  // REAL PRODUCT CARD
  // ============================================================

  Widget _buildRealProductCard(
    Map<String, dynamic> product,
  ) {
    final name =
        product['name']?.toString() ?? 'Product';

    final price =
        product['price']?.toString() ?? '0';

    final unit =
        product['unit']?.toString() ?? '';

    final quantity =
        product['quantity_available']?.toString() ?? '0';

    final imageUrl =
        product['image_url']?.toString();

    return GestureDetector(
      onTap: () {
        _showProductInfo(product);
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE6EBE8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: _buildProductImage(imageUrl),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF202624),
              ),
            ),

            const SizedBox(height: 3),

            Row(
              children: [
                Text(
                  '₹$price',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF087C59),
                  ),
                ),

                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 3),
                  Text(
                    '/ $unit',
                    style: const TextStyle(
                      fontSize: 8,
                      color: Color(0xFF697671),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 2),

            Text(
              'Available: $quantity $unit',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 8,
                color: Color(0xFF697671),
              ),
            ),

            const SizedBox(height: 6),

            Container(
              height: 28,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF087C59),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                'View Product',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PRODUCT IMAGE
  // ============================================================
Widget _buildProductImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.trim().isEmpty) {
    return _imagePlaceholder();
  }

  String finalUrl = imageUrl.trim();

  // Backend returns:
  // /uploads/products/example.jpg
  //
  // Convert it to:
  // http://192.168.43.18:8000/uploads/products/example.jpg
  if (finalUrl.startsWith('/')) {
    finalUrl = '${ApiConfig.baseUrl}$finalUrl';
  }

  // In case backend ever returns a full URL,
  // don't add baseUrl again.
  else if (!finalUrl.startsWith('http://') &&
      !finalUrl.startsWith('https://')) {
    finalUrl = '${ApiConfig.baseUrl}/$finalUrl';
  }

  debugPrint('CATEGORY IMAGE URL: $finalUrl');

  return Image.network(
    finalUrl,
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.cover,

    loadingBuilder: (
      context,
      child,
      loadingProgress,
    ) {
      if (loadingProgress == null) {
        return child;
      }

      return Container(
        color: const Color(0xFFF1F6F3),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF087C59),
          ),
        ),
      );
    },

    errorBuilder: (
      context,
      error,
      stackTrace,
    ) {
      debugPrint(
        'CATEGORY IMAGE FAILED: $finalUrl',
      );

      debugPrint(
        'IMAGE ERROR: $error',
      );

      return _imagePlaceholder();
    },
  );
}

  // ============================================================
  // IMAGE PLACEHOLDER
  // ============================================================

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFF1F6F3),
      child: const Center(
        child: Icon(
          Icons.agriculture_rounded,
          size: 38,
          color: Color(0xFF8AA099),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY PRODUCTS
  // ============================================================

  Widget _buildEmptyProducts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE4EBE7),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 42,
            color: Color(0xFF9AA69F),
          ),

          const SizedBox(height: 10),

          Text(
            searchText.isNotEmpty
                ? 'No products found'
                : 'No products available',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF45524C),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            searchText.isNotEmpty
                ? 'Try another product name.'
                : 'Farmers have not added products here yet.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF89958F),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT INFO
  // ============================================================

  void _showProductInfo(
    Map<String, dynamic> product,
  ) {
    final name =
        product['name']?.toString() ?? 'Product';

    final price =
        product['price']?.toString() ?? '0';

    final unit =
        product['unit']?.toString() ?? '';

    final description =
        product['description']?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E0DC),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  '₹$price${unit.isNotEmpty ? ' / $unit' : ''}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF087C59),
                  ),
                ),

                if (description.isNotEmpty) ...[
                  const SizedBox(height: 12),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: Color(0xFF66736D),
                    ),
                  ),
                ],

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            '$name selected',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF087C59),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(11),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
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
  }

  // ============================================================
  // SUPPORT CARD
  // ============================================================

  Widget _buildSupportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F6EE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: const BoxDecoration(
              color: Color(0xFFD3F0E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco_rounded,
              color: Color(0xFF087C59),
              size: 24,
            ),
          ),

          const SizedBox(width: 11),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Local Farmers',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Choose fresh. Choose sustainable.\n'
                  'Choose local.',
                  style: TextStyle(
                    fontSize: 8,
                    height: 1.3,
                    color: Color(0xFF63736B),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Color(0xFF087C59),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

// ==================================================================
// SHOP NOW BUTTON
// ==================================================================

class _ShopButton extends StatelessWidget {
  const _ShopButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Shop Now',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: Color(0xFF087C59),
            ),
          ),

          SizedBox(width: 4),

          Icon(
            Icons.arrow_forward_rounded,
            size: 12,
            color: Color(0xFF087C59),
          ),
        ],
      ),
    );
  }
}
