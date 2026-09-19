import 'package:farmdirect/core/provider/buyer_product_provider.dart';
import 'package:farmdirect/features/buyer/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmdirect/core/provider/buyer_profile_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<String> selectedCategories = {"All"};

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<BuyerProductProvider>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(13, 10, 13, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // HEADER
            // =========================================================
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FARM DIRECT LOGO
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Farm",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF087C59),
                              ),
                            ),
                            TextSpan(
                              text: "Direct",
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF075B4A),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Text(
                        "From Farms to Your Home",
                        style: TextStyle(
                          fontSize: 7.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7B8782),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // LOCATION
                      Row(
                        children: const [
                          Icon(
                            Icons.location_on_rounded,
                            size: 13,
                            color: Color(0xFF087C59),
                          ),

                          SizedBox(width: 3),

                          Text(
                            "Dehradun, Uttarakhand",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF455A64),
                            ),
                          ),

                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: Color(0xFF60716B),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // =====================================================
                // NOTIFICATION
                // =====================================================
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8E5)),
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    size: 17,
                    color: Color(0xFF263238),
                  ),
                ),

                const SizedBox(width: 8),

                // =====================================================
                // PROFILE IMAGE
                // =====================================================
                Consumer<BuyerProfileProvider>(
                  builder: (context, profile, child) {
                    final name = profile.name.trim();

                    final firstLetter = name.isNotEmpty
                        ? name[0].toUpperCase()
                        : "U";

                    final imageUrl = profile.fullProfileImageUrl;

                    return Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF80D000),
                          width: 1.8,
                        ),
                      ),
                      child: ClipOval(
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _profileFallback(firstLetter);
                                },
                              )
                            : _profileFallback(firstLetter),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =========================================================
            // SEARCH BAR + FILTER
            // =========================================================
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 39,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE0E7E4)),
                    ),

                    child: const TextField(
                      textAlignVertical: TextAlignVertical.center,

                      style: TextStyle(fontSize: 10, color: Color(0xFF263238)),

                      decoration: InputDecoration(
                        border: InputBorder.none,

                        isDense: true,

                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: Color(0xFF89958F),
                        ),

                        prefixIconConstraints: BoxConstraints(
                          minWidth: 38,
                          minHeight: 39,
                        ),

                        hintText: "Search for fresh products...",

                        hintStyle: TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF9AA49F),
                        ),

                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 7),

                // FILTER BUTTON
                Container(
                  width: 39,
                  height: 39,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0E7E4)),
                  ),

                  child: Material(
                    color: Colors.transparent,

                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),

                      onTap: () {
                        // Filter action later
                      },

                      child: const Center(
                        child: Icon(
                          Icons.tune_rounded,
                          size: 18,
                          color: Color(0xFF075B4A),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 13),

            // =========================================================
            // CATEGORIES
            // =========================================================
            SizedBox(
              height: 74,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),

                itemCount: categories.length,

                itemBuilder: (context, index) {
                  final category = categories[index];

                  return _categoryCircle(
                    title: category["name"] as String,
                    icon: category["icon"] as IconData,
                    color: category["color"] as Color,
                  );
                },
              ),
            ),

            const SizedBox(height: 4),

            // =========================================================
            // FARMER BANNER
            // =========================================================
            _buildFarmerBanner(),

            const SizedBox(height: 15),

            // =========================================================
            // FRESH PRODUCTS HEADER
            // =========================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text(
                  "Fresh Products",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                GestureDetector(
                  onTap: () {

                  },

                  child: const Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF087C59),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Consumer<BuyerProductProvider>(
              builder: (context, provider, child) {
                // ==========================================================
                // LOADING
                // ==========================================================

                if (provider.isLoading) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF087C59),
                      ),
                    ),
                  );
                }

                // ==========================================================
                // ERROR
                // ==========================================================

                if (provider.error != null) {
                  return SizedBox(
                    height: 180,
                    child: Center(
                      child: Text(
                        provider.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, color: Colors.red),
                      ),
                    ),
                  );
                }

                // ==========================================================
                // EMPTY
                // ==========================================================

                if (provider.products.isEmpty) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: Text(
                        'No products available',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7B8782),
                        ),
                      ),
                    ),
                  );
                }

                // ==========================================================
                // PRODUCTS FROM POSTGRESQL
                // ==========================================================

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: provider.products.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 9,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.92,
                  ),

                  itemBuilder: (context, index) {
                    final product = provider.products[index];

                   return ProductCard(
  productId: product.productId,
  image: product.fullImageUrl,
  name: product.name,
  price: product.price.toStringAsFixed(2),
  farm: 'Farmer ${product.farmerId}',
  location: 'Local Farm',
  description: product.description,
  rating: '4.8',
  unit: product.unit,
);
                  },
                );
              },
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // PROFILE FALLBACK
  // ================================================================

  Widget _profileFallback(String letter) {
    return Container(
      color: const Color(0xFFE8F5E9),

      alignment: Alignment.center,

      child: Text(
        letter,

        style: const TextStyle(
          color: Color(0xFF075B4A),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ================================================================
  // CATEGORY CIRCLE
  // ================================================================

  Widget _categoryCircle({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final bool isSelected = selectedCategories.contains(title);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (title == "All") {
            selectedCategories = {"All"};
          } else {
            selectedCategories.remove("All");

            if (selectedCategories.contains(title)) {
              selectedCategories.remove(title);
            } else {
              selectedCategories.add(title);
            }

            if (selectedCategories.isEmpty) {
              selectedCategories.add("All");
            }
          }
        });
      },

      child: Container(
        width: 59,

        margin: const EdgeInsets.only(right: 9),

        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              width: 47,
              height: 47,

              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.12)
                    : const Color(0xFFF3F5F4),

                shape: BoxShape.circle,

                border: Border.all(
                  color: isSelected ? color : Colors.transparent,

                  width: 1.5,
                ),
              ),

              child: Icon(icon, size: 22, color: color),
            ),

            const SizedBox(height: 5),

            Text(
              title,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 7.5,

                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,

                color: isSelected
                    ? const Color(0xFF075B4A)
                    : const Color(0xFF6D7974),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // FARMER BANNER
  // ================================================================

  Widget _buildFarmerBanner() {
    return Container(
      height: 101,
      width: double.infinity,

      clipBehavior: Clip.antiAlias,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),

        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,

          colors: [Color(0xFF075B4A), Color(0xFF15835D)],
        ),
      ),

      child: Stack(
        children: [
          // ----------------------------------------------------------
          // RIGHT IMAGE
          // ----------------------------------------------------------
          Positioned(
            right: -5,
            top: 0,
            bottom: 0,
            width: 145,

            child: Image.asset(
              "assets/images/farm1.png",

              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2B785E), Color(0xFF83A86C)],
                    ),
                  ),
                );
              },
            ),
          ),

          // ----------------------------------------------------------
          // DARK OVERLAY
          // ----------------------------------------------------------
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 220,

            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF075B4A),
                    const Color(0xFF075B4A).withOpacity(0.88),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ----------------------------------------------------------
          // TEXT
          // ----------------------------------------------------------
          const Positioned(
            left: 13,
            top: 13,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Fresh from Farmers",

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                Text(
                  "Direct to You",

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Support local farmers.\n"
                  "Get fresh. Eat healthy.",

                  style: TextStyle(
                    fontSize: 8,
                    height: 1.3,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // ----------------------------------------------------------
          // ARROW
          // ----------------------------------------------------------
          Positioned(
            left: 145,
            top: 37,

            child: Container(
              width: 28,
              height: 28,

              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: Color(0xFF087C59),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// PRODUCT DATA
// ==================================================================

final List<Map<String, String>> products = [
  {
    "image": "assets/images/tomatoes.png",

    "name": "Tomato",

    "price": "40",

    "unit": "kg",

    "rating": "4.8",

    "farm": "Ramesh Singh",

    "location": "Dehradun, Uttarakhand",

    "description": "Fresh farm-grown tomatoes directly from local farmers.",
  },

  {
    "image": "assets/images/potato.png",

    "name": "Potato",

    "price": "25",

    "unit": "kg",

    "rating": "4.7",

    "farm": "Suresh Negi",

    "location": "Rishikesh, Uttarakhand",

    "description": "Fresh quality potatoes sourced directly from the farm.",
  },

  {
    "image": "assets/images/onion.png",

    "name": "Onion",

    "price": "30",

    "unit": "kg",

    "rating": "4.7",

    "farm": "Local Farmers",

    "location": "Dehradun, Uttarakhand",

    "description": "Fresh onions directly sourced from local farmers.",
  },

  {
    "image": "assets/images/spinach.png",

    "name": "Spinach",

    "price": "20",

    "unit": "bunch",

    "rating": "4.8",

    "farm": "Green Farm",

    "location": "Dehradun, Uttarakhand",

    "description": "Fresh and naturally grown spinach from local farms.",
  },
];

// ==================================================================
// CATEGORIES
// ==================================================================

final List<Map<String, dynamic>> categories = [
  {"name": "All", "icon": Icons.grid_view_rounded, "color": Color(0xFF087C59)},

  {"name": "Vegetables", "icon": Icons.eco_rounded, "color": Color(0xFF63B33F)},

  {"name": "Fruits", "icon": Icons.apple, "color": Color(0xFFE53935)},

  {"name": "Grains", "icon": Icons.grain_rounded, "color": Color(0xFFE7A72B)},

  {
    "name": "Dairy",
    "icon": Icons.local_drink_rounded,
    "color": Color(0xFF42A5F5),
  },

  {
    "name": "Other",
    "icon": Icons.more_horiz_rounded,
    "color": Color(0xFF607D8B),
  },
];
