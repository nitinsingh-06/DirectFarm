import 'package:farmdirect/services/api_services.dart';
import 'package:flutter/material.dart';

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

  List<Map<String, dynamic>> databaseCategories = [];

  bool isLoadingCategories = true;
  String? categoryError;

  final TextEditingController searchController = TextEditingController();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // ============================================================
  // LOAD CATEGORIES FROM DATABASE
  // ============================================================

  Future<void> _loadCategories() async {
    setState(() {
      isLoadingCategories = true;
      categoryError = null;
    });

    try {
      final data = await ApiService.getCategories();

      if (!mounted) return;

      final loadedCategories = data
          .map<Map<String, dynamic>>(
            (item) => {
              "id": item["category_id"],
              "name": item["name"]?.toString() ?? "",
              "description": item["description"]?.toString() ?? "",
            },
          )
          .where(
            (category) =>
                category["name"].toString().trim().isNotEmpty,
          )
          .toList();

      setState(() {
        databaseCategories = loadedCategories;
        isLoadingCategories = false;
        categoryError = null;
        selectedCategory = 0;
      });

      debugPrint(
        "Loaded ${databaseCategories.length} categories from database",
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingCategories = false;
        categoryError = e.toString();
      });

      debugPrint("CATEGORY LOAD ERROR: $e");
    }
  }

  // ============================================================
  // CATEGORY ICON
  // ============================================================

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase().trim()) {
      case "vegetables":
        return Icons.eco_rounded;

      case "fruits":
        return Icons.apple_rounded;

      case "grains":
        return Icons.grain_rounded;

      case "dairy":
        return Icons.local_drink_rounded;

      case "organic":
        return Icons.spa_rounded;

      case "spices":
        return Icons.local_fire_department_rounded;

      case "beverages":
        return Icons.local_cafe_rounded;

      case "snacks":
        return Icons.cookie_rounded;

      case "personal care":
        return Icons.spa_rounded;

      case "household":
        return Icons.home_rounded;

      default:
        return Icons.category_rounded;
    }
  }

  // ============================================================
  // CATEGORY COLOR
  // ============================================================

  Color _getCategoryColor(String name) {
    switch (name.toLowerCase().trim()) {
      case "vegetables":
        return const Color(0xFF4CAF50);

      case "fruits":
        return const Color(0xFFE53935);

      case "grains":
        return const Color(0xFFE7A72B);

      case "dairy":
        return const Color(0xFF2196F3);

      case "organic":
        return const Color(0xFF087C59);

      case "spices":
        return const Color(0xFFE64A19);

      case "beverages":
        return const Color(0xFF00897B);

      case "snacks":
        return const Color(0xFFE6A21A);

      case "personal care":
        return const Color(0xFF8E44AD);

      case "household":
        return const Color(0xFF607D8B);

      default:
        return const Color(0xFF7189B0);
    }
  }

  // ============================================================
  // SIDEBAR CATEGORY DATA
  // ============================================================

  List<Map<String, dynamic>> get sidebarCategories {
    return [
      {
        "id": 0,
        "name": "All",
        "icon": Icons.grid_view_rounded,
        "color": const Color(0xFF087C59),
      },
      ...databaseCategories.map(
        (category) {
          final String name =
              category["name"]?.toString() ?? "";

          return {
            "id": category["id"],
            "name": name,
            "icon": _getCategoryIcon(name),
            "color": _getCategoryColor(name),
          };
        },
      ),
    ];
  }


  // ============================================================
// POPULAR CATEGORIES
// ============================================================

final List<Map<String, String>> popularCategories = [
  {
    "name": "Vegetables",
    "products": "124 Products",
    "image":
        "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500",
  },
  {
    "name": "Fruits",
    "products": "98 Products",
    "image":
        "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500",
  },
  {
    "name": "Grains",
    "products": "56 Products",
    "image":
        "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500",
  },
  {
    "name": "Dairy",
    "products": "42 Products",
    "image":
        "https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=500",
  },
  {
    "name": "Organic",
    "products": "36 Products",
    "image":
        "https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=500",
  },
  {
    "name": "Spices",
    "products": "28 Products",
    "image":
        "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=500",
  },
  {
    "name": "Beverages",
    "products": "45 Products",
    "image":
        "https://images.unsplash.com/photo-1544145945-f90425340c7e?w=500",
  },
  {
    "name": "Snacks",
    "products": "39 Products",
    "image":
        "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=500",
  },
  {
    "name": "Personal Care",
    "products": "22 Products",
    "image":
        "https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500",
  },
  {
    "name": "Household",
    "products": "18 Products",
    "image":
        "https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=500",
  },
];

// ============================================================
// VEGETABLE PRODUCTS
// ============================================================

final List<Map<String, String>> vegetableProducts = [
  {
    "name": "Leafy Greens",
    "products": "24 Products",
    "image":
        "https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500",
  },
  {
    "name": "Tomato",
    "products": "18 Products",
    "image":
        "https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=500",
  },
  {
    "name": "Onion",
    "products": "16 Products",
    "image":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYyPLMBO6msqHAsNVxjS4PCnEsF4fjkI1mQKNRWV38Jd7vLh7iwZQkFjDW&s=10",
  },
  {
    "name": "Potato",
    "products": "14 Products",
    "image":
        "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=500",
  },
  {
    "name": "Carrot",
    "products": "12 Products",
    "image":
        "https://images.unsplash.com/photo-1445282768818-728615cc910a?w=500",
  },
  {
    "name": "Capsicum",
    "products": "10 Products",
    "image":
        "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=500",
  },
  {
    "name": "Cucumber",
    "products": "8 Products",
    "image":
        "https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=500",
  },
  {
    "name": "Brinjal",
    "products": "8 Products",
    "image":
        "https://images.unsplash.com/photo-1650978676850-6a5a3f2a1e9f?w=500",
  },
];

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
          ),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              "All Categories",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),

          // SEARCH
          _topIcon(
            icon: Icons.search_rounded,
            onTap: () {},
          ),

          const SizedBox(width: 12),

          // CAMERA
          _topIcon(
            icon: Icons.camera_alt_outlined,
            onTap: () {},
          ),

          const SizedBox(width: 12),

          // CART
          Stack(
            clipBehavior: Clip.none,
            children: [
              _topIcon(
                icon: Icons.shopping_cart_rounded,
                onTap: () {
                  // Cart navigation later
                },
              ),

              Positioned(
                right: -6,
                top: -7,
                child: Container(
                  width: 23,
                  height: 23,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5252),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "7",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
  // LEFT CATEGORY SIDEBAR
  // ============================================================

  Widget _buildSideCategories() {
    // ----------------------------------------------------------
    // LOADING
    // ----------------------------------------------------------

    if (isLoadingCategories) {
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
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF2F5BEA),
            ),
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // ERROR
    // ----------------------------------------------------------

    if (categoryError != null) {
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
        child: Center(
          child: IconButton(
            onPressed: _loadCategories,
            icon: const Icon(
              Icons.refresh_rounded,
              color: Color(0xFF2F5BEA),
            ),
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // EMPTY
    // ----------------------------------------------------------

    if (databaseCategories.isEmpty) {
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
        child: const Center(
          child: Icon(
            Icons.category_outlined,
            color: Color(0xFF7189B0),
            size: 28,
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // CATEGORY LIST
    // ----------------------------------------------------------

    final categories = sidebarCategories;

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
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return _buildSideCategoryItem(
            index: index,
            name: category["name"].toString(),
            icon: category["icon"] as IconData,
            color: category["color"] as Color,
          );
        },
      ),
    );
  }

  // ============================================================
  // SIDE CATEGORY ITEM
  // ============================================================

  Widget _buildSideCategoryItem({
    required int index,
    required String name,
    required IconData icon,
    required Color color,
  }) {
    final bool selected = selectedCategory == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = index;
        });
      },
      child: Container(
        height: 95,
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
                    color: const Color(0xFF2F5BEA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFEAF0FF)
                          : const Color(0xFFF1F3F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 29,
                      color: selected
                          ? const Color(0xFF2F5BEA)
                          : color,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.1,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: selected
                            ? const Color(0xFF2F5BEA)
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

          const SizedBox(height: 22),

          if (selectedCategory == 0) ...[
            _buildSectionTitle(
              "Popular Categories",
            ),

            const SizedBox(height: 10),

            _buildCategoryGrid(),
          ] else if (
              selectedCategory == 1 &&
              databaseCategories.isNotEmpty
          ) ...[
            _buildSectionTitle(
              "Fresh Vegetables",
            ),

            const SizedBox(height: 5),

            const Text(
              "Fresh vegetables from local farmers",
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFF77837E),
              ),
            ),

            const SizedBox(height: 12),

            _buildVegetableGrid(),
          ] else ...[
            _buildSectionTitle(
              _getSelectedCategoryName(),
            ),

            const SizedBox(height: 10),

            _buildCategoryGrid(),
          ],

          const SizedBox(height: 20),

          _buildSupportCard(),
        ],
      ),
    );
  }

  // ============================================================
  // SELECTED CATEGORY NAME
  // ============================================================

  String _getSelectedCategoryName() {
    final categories = sidebarCategories;

    if (selectedCategory >= 0 &&
        selectedCategory < categories.length) {
      return categories[selectedCategory]["name"]
          .toString();
    }

    return "Categories";
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
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 19,
            color: Color(0xFF89958F),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 40,
            minHeight: 42,
          ),
          hintText: "Search categories...",
          hintStyle: TextStyle(
            fontSize: 9.5,
            color: Color(0xFF9AA49F),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  // ============================================================
  // HERO BANNER
  // ============================================================

  Widget _buildHeroBanner() {
    return Container(
      height: 145,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        image: const DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1542838132-92c53300491e?w=900",
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
              "Fresh Choices",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            Text(
              "Healthier Lives",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: 5),

            Text(
              "Shop fresh products\nfrom local farmers",
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
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
    );
  }

  // ============================================================
  // CATEGORY GRID
  // ============================================================

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: popularCategories.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 9,
        mainAxisSpacing: 10,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final item = popularCategories[index];

        return _buildCategoryCard(
          name: item["name"]!,
          products: item["products"]!,
          image: item["image"]!,
        );
      },
    );
  }

  // ============================================================
  // VEGETABLE GRID
  // ============================================================

  Widget _buildVegetableGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vegetableProducts.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 9,
        mainAxisSpacing: 10,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final item = vegetableProducts[index];

        return _buildCategoryCard(
          name: item["name"]!,
          products: item["products"]!,
          image: item["image"]!,
        );
      },
    );
  }

  // ============================================================
  // CATEGORY CARD
  // ============================================================

  Widget _buildCategoryCard({
    required String name,
    required String products,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        // Product/category navigation will be connected later.
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
                child: Image.network(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF1F6F3),
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 35,
                          color: Color(0xFF8AA099),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 7),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 3,
              ),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF202624),
                ),
              ),
            ),

            const SizedBox(height: 2),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 3,
              ),
              child: Text(
                products,
                style: const TextStyle(
                  fontSize: 8,
                  color: Color(0xFF697671),
                ),
              ),
            ),

            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUPPORT FARMERS CARD
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
                  "Support Local Farmers",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "Choose fresh. Choose sustainable.\n"
                  "Choose local.",
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
            "Shop Now",
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