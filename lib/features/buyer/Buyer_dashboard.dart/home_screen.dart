import 'package:farmdirect/core/provider/buyer_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<String> selectedCategories = {"All"};
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(13, 12, 13, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // HEADER
            // =====================================================
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<BuyerProfileProvider>(
                        builder: (context, profile, child) {
                          return Text(
                            profile.name.isNotEmpty
                                ? "Welcome, ${profile.name}! 🛒"
                                : "Welcome! 🛒",
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF075B4A),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 3),
                    ],
                  ),
                ),

                // Profile image
                // Profile image
                // Profile image
                Consumer<BuyerProfileProvider>(
                  builder: (context, profile, child) {
                    final name = profile.name.trim();

                    final firstLetter = name.isNotEmpty
                        ? name[0].toUpperCase()
                        : 'U';

                    final imageUrl = profile.fullProfileImageUrl;

                    return Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF80D000),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                width: 36,
                                height: 36,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFE8F5E9),
                                    alignment: Alignment.center,
                                    child: Text(
                                      firstLetter,
                                      style: const TextStyle(
                                        color: Color(0xFF075B4A),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: const Color(0xFFE8F5E9),
                                alignment: Alignment.center,
                                child: Text(
                                  firstLetter,
                                  style: const TextStyle(
                                    color: Color(0xFF075B4A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =====================================================
            // SEARCH BAR
            // =====================================================
            Container(
              height: 39,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E6E8)),
              ),
              child: const TextField(
                style: TextStyle(fontSize: 11),
                decoration: InputDecoration(
                  border: InputBorder.none,

                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: Color(0xFF8A949B),
                  ),

                  hintText: "Search fresh vegetables, mangoes, grains...",

                  hintStyle: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF9AA3A8),
                  ),

                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            const SizedBox(height: 9),

            // =====================================================
            // CATEGORIES
            // =====================================================
            SizedBox(
              height: 32,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _category("All"),

                  _category("Vegetables"),

                  _category("Fruits"),

                  _category("Grains"),

                  _category("Organic"),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // =====================================================
            // SEASONAL OFFER
            // =====================================================
            _buildOfferBanner(),

            const SizedBox(height: 4),

            // =====================================================
            // FEATURED FARMS HEADER
            // =====================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Featured Farms",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4DAE91),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // =====================================================
            // FEATURED FARMS
            // =====================================================
            SizedBox(
              height: 124,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _FarmCard(
                    image: "assets/images/farm1.png",
                    name: "GreenLand FPO",
                    rating: "4.9",
                    orders: "120+ orders",
                  ),

                  SizedBox(width: 10),

                  _FarmCard(
                    image: "assets/images/farm2.png",
                    name: "Saffron Valley",
                    rating: "4.8",
                    orders: "85 orders",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 13),

            // =====================================================
            // FRESH ARRIVALS HEADER
            // =====================================================
            const Text(
              "Fresh Arrivals",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF263238),
              ),
            ),

            const SizedBox(height: 7),

            // =====================================================
            // FRESH ARRIVALS
            // =====================================================
            Row(
              children: const [
                Expanded(
                  child: InkWell(
                    child: _ProductCard(
                      image: "assets/images/tomatoes.png",
                      name: "Organic Tomatoes",
                      price: "₹40 / kg",
                      farm: "By Ramgarh Farms",
                    ),
                  ),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: _ProductCard(
                    image: "assets/images/mangoes.png",
                    name: "Alphonso Mangoes",
                    price: "₹450 / dozen",
                    farm: "By Ratnagiri FPO",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // CATEGORY
  // =============================================================
  Widget _category(String title) {
    final bool isSelected = selectedCategories.contains(title);

    return GestureDetector(
      onTap: () {
        setState(() {
          // =====================================================
          // ALL
          // =====================================================

          if (title == "All") {
            // Selecting All removes every other selection
            selectedCategories = {"All"};
          }
          // =====================================================
          // OTHER CATEGORIES
          // =====================================================
          else {
            // Remove All when selecting an individual category
            selectedCategories.remove("All");

            // Toggle the selected category
            if (selectedCategories.contains(title)) {
              selectedCategories.remove(title);
            } else {
              selectedCategories.add(title);
            }

            // If nothing is selected, automatically select All
            if (selectedCategories.isEmpty) {
              selectedCategories.add("All");
            }
          }
        });
      },

      child: Container(
        margin: const EdgeInsets.only(right: 7),

        padding: const EdgeInsets.symmetric(horizontal: 14),

        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF075B4A) : Colors.white,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: isSelected
                ? const Color(0xFF075B4A)
                : const Color(0xFFE1E5E8),
          ),
        ),

        alignment: Alignment.center,

        child: Text(
          title,

          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,

            color: isSelected ? Colors.white : const Color(0xFF455A64),
          ),
        ),
      ),
    );
  }
  // =============================================================
  // OFFER BANNER
  // =============================================================

  Widget _buildOfferBanner() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        image: const DecorationImage(
          image: AssetImage("assets/images/mango_offer.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Colors.black.withOpacity(0.25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF80D000),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const Text(
                "SEASONAL OFFER",
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF164000),
                ),
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Get 20% Off on Fresh Mangoes!",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 2),

            const Text(
              "Directly from Ratnagiri Farms • Use Code: MANGO20",
              style: TextStyle(fontSize: 8.5, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// FARM CARD
// =================================================================

class _FarmCard extends StatelessWidget {
  final String image;
  final String name;
  final String rating;
  final String orders;

  const _FarmCard({
    required this.image,
    required this.name,
    required this.rating,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E7EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 57,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 3),

          Row(
            children: [
              const Icon(Icons.star, size: 11, color: Color(0xFFFFB300)),

              const SizedBox(width: 3),

              Text(
                "$rating (${orders})",
                style: const TextStyle(fontSize: 7.5, color: Color(0xFF7B8794)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =================================================================
// PRODUCT CARD
// =================================================================

class _ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String farm;

  const _ProductCard({
    required this.image,
    required this.name,
    required this.price,
    required this.farm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 165,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E7EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 91,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 7, 7, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF087C59),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  farm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 7.5,
                    color: Color(0xFF8A949B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
