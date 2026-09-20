import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/features/buyer_farmer_profile/farmer_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String image;
  final int productId;
  final int farmerId; 

  final String name;
  final String price;
  final String unit;
  final String rating;
  final String farmName;
  final String farmLocation;
  final String description;

  final String category;
  final String farmType;
  final String harvestedOn;
  final String shelfLife;

  const ProductDetailsScreen({
    super.key,
    required this.image,
    required this.productId,
    required this.farmerId, 

    required this.name,
    required this.price,
    required this.unit,
    required this.rating,
    required this.farmName,
    required this.farmLocation,
    required this.description,

    required this.category,
    required this.farmType,
    required this.harvestedOn,
    required this.shelfLife,
  });


  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ============================================================
      // BODY
      // ============================================================
      body: SafeArea(
        child: Column(
          children: [
            // ------------------------------------------------------
            // SCROLLABLE CONTENT
            // ------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // =================================================
                    // TOP BAR
                    // =================================================
                    _buildTopBar(),

                    // =================================================
                    // PRODUCT IMAGE
                    // =================================================
                    _buildProductImage(),

                    // =================================================
                    // IMAGE THUMBNAILS
                    // =================================================
                    _buildThumbnails(),

                    // =================================================
                    // PRODUCT BASIC INFORMATION
                    // =================================================
                    _buildProductInformation(),

                    // =================================================
                    // PRODUCT TAGS
                    // =================================================
                    _buildProductTags(),

                    // =================================================
                    // STOCK / UNIT / DELIVERY
                    // =================================================
                    _buildProductStats(),

                    // =================================================
                    // FARMER INFORMATION
                    // =================================================
                    _buildFarmerCard(),

                    // =================================================
                    // SUPPORT LOCAL FARMERS
                    // =================================================
                    _buildSupportCard(),

                    // =================================================
                    // ABOUT PRODUCT
                    // =================================================
                    _buildAboutProduct(),

                    // =================================================
                    // PRODUCT BENEFITS
                    // =================================================
                    _buildBenefits(),

                    // =================================================
                    // SPECIFICATIONS
                    // =================================================
                    _buildSpecifications(),

                    // =================================================
                    // NUTRITION
                    // =================================================

                    // _buildNutrition(),

                    // =================================================
                    // REVIEWS
                    // =================================================
                    _buildReviews(),

                    // =================================================
                    // RECOMMENDED PRODUCTS
                    // =================================================
                    _buildRecommendedProducts(),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),

            // ========================================================
            // FIXED BOTTOM CART BAR
            // ========================================================
            _buildBottomCartBar(),
          ],
        ),
      ),
    );
  }

  // =================================================================
  // TOP BAR
  // =================================================================

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      child: Row(
        children: [
          // BACK BUTTON
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF263238),
            ),
          ),

          const SizedBox(width: 12),

          // TITLE
          const Expanded(
            child: Text(
              "Product Details",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF263238),
              ),
            ),
          ),

          // FAVORITE
          GestureDetector(
            onTap: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },

            child: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,

              size: 20,

              color: isFavorite
                  ? const Color(0xFFE53935)
                  : const Color(0xFF455A64),
            ),
          ),

          const SizedBox(width: 13),

          // SHARE
          const Icon(
            Icons.ios_share_rounded,
            size: 19,
            color: Color(0xFF455A64),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // PRODUCT IMAGE
  // =================================================================

  Widget _buildProductImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),

        child: SizedBox(
          height: 190,
          width: double.infinity,

          child: Stack(
            children: [
              // IMAGE
              Positioned.fill(
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFEAF2ED),

                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 50,
                          color: Color(0xFF8FA39A),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // FRESH LABEL
              Positioned(
                left: 10,
                top: 10,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFF087C59),
                    borderRadius: BorderRadius.circular(6),
                  ),

                  child: const Text(
                    "Fresh Produce",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // IMAGE COUNT
              Positioned(
                right: 9,
                bottom: 9,

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Text(
                    "1/5",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =================================================================
  // THUMBNAILS
  // =================================================================

  Widget _buildThumbnails() {
    return SizedBox(
      height: 58,

      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),

        scrollDirection: Axis.horizontal,

        children: [
          _thumbnail(widget.image, true),
          _thumbnail(widget.image, false),
          _thumbnail(widget.image, false),
          _thumbnail(widget.image, false),
        ],
      ),
    );
  }

  Widget _thumbnail(String image, bool selected) {
    return Container(
      width: 57,
      height: 43,

      margin: const EdgeInsets.only(right: 7),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),

        border: Border.all(
          color: selected ? const Color(0xFF087C59) : const Color(0xFFE0E6E3),

          width: selected ? 2 : 1,
        ),
      ),

      clipBehavior: Clip.antiAlias,

      child: Image.asset(
        image,
        fit: BoxFit.cover,

        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_outlined, color: Color(0xFF9BA6A1));
        },
      ),
    );
  }

  // =================================================================
  // PRODUCT INFORMATION
  // =================================================================

  Widget _buildProductInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 8),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            widget.name,

            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 3),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "₹${widget.price}/${widget.unit}",

                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF087C59),
                ),
              ),

              // RATING
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 17,
                    color: Color(0xFFFFB300),
                  ),

                  const SizedBox(width: 3),

                  Text(
                    widget.rating,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF455A64),
                    ),
                  ),

                  const SizedBox(width: 3),

                  const Text(
                    "(24 reviews)",
                    style: TextStyle(fontSize: 8, color: Color(0xFF7B8782)),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            widget.description,

            style: const TextStyle(
              fontSize: 10,
              height: 1.45,
              color: Color(0xFF65736D),
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // PRODUCT TAGS
  // =================================================================

  Widget _buildProductTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),

      child: Row(
        children: [
          _tag(Icons.eco_outlined, "Organic"),

          const SizedBox(width: 6),

          _tag(Icons.science_outlined, "No Pesticides"),

          const SizedBox(width: 6),

          _tag(Icons.spa_outlined, "Naturally Grown"),
        ],
      ),
    );
  }

  Widget _tag(IconData icon, String title) {
    return Expanded(
      child: Container(
        height: 31,

        decoration: BoxDecoration(
          color: const Color(0xFFF0F8F3),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 13, color: const Color(0xFF087C59)),

            const SizedBox(width: 4),

            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 7.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF455A64),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =================================================================
  // PRODUCT STATS
  // =================================================================

  Widget _buildProductStats() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 10),

      padding: const EdgeInsets.symmetric(vertical: 13),

      decoration: BoxDecoration(
        color: const Color(0xFFF3F9F5),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          _stat(Icons.inventory_2_outlined, "In Stock", "120 kg"),

          _verticalDivider(),

          _stat(Icons.scale_outlined, "Unit", "per kg"),

          _verticalDivider(),

          _stat(Icons.local_shipping_outlined, "Delivery", "2-3 days"),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF087C59)),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(fontSize: 7.5, color: Color(0xFF68766F)),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF075B4A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: 45, color: const Color(0xFFDCE7E1));
  }

  // =================================================================
  // FARMER CARD
  // =================================================================

  Widget _buildFarmerCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 8),

      child: Row(
        children: [
          // FARMER IMAGE
          Container(
            width: 43,
            height: 43,

            decoration: const BoxDecoration(
              color: Color(0xFFE8F3EC),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFF087C59),
              size: 25,
            ),
          ),

          const SizedBox(width: 9),

          // FARMER INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  widget.farmName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  "Local Farmer",
                  style: TextStyle(fontSize: 8, color: Color(0xFF7B8782)),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 10,
                      color: Color(0xFF087C59),
                    ),

                    const SizedBox(width: 2),

                    Expanded(
                      child: Text(
                        widget.farmLocation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 7.5,
                          color: Color(0xFF697770),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // VIEW PROFILE
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FarmerProfileScreenview(farmerId: widget.farmerId),
                ),
              );
            },

            style: OutlinedButton.styleFrom(
              minimumSize: const Size(70, 29),

              padding: const EdgeInsets.symmetric(horizontal: 8),

              side: const BorderSide(color: Color(0xFF8BD7B1)),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            child: const Text(
              "View Profile",
              style: TextStyle(
                fontSize: 7,
                fontWeight: FontWeight.w700,
                color: Color(0xFF087C59),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // SUPPORT FARMERS
  // =================================================================

  Widget _buildSupportCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 3, 14, 10),

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: const Color(0xFFF1F9F4),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [
          const Icon(Icons.eco_rounded, size: 28, color: Color(0xFF087C59)),

          const SizedBox(width: 9),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Supporting Local Farmers",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF075B4A),
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  "Your purchase helps local farmers "
                  "and promotes sustainable agriculture.",
                  style: TextStyle(
                    fontSize: 7,
                    height: 1.3,
                    color: Color(0xFF697770),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF087C59),
            size: 19,
          ),
        ],
      ),
    );
  }

  // =================================================================
  // ABOUT PRODUCT
  // =================================================================

  Widget _buildAboutProduct() {
    return _section(
      title: "About this Product",

      child: Text(
        widget.description,

        style: const TextStyle(
          fontSize: 9,
          height: 1.5,
          color: Color(0xFF65736D),
        ),
      ),
    );
  }

  // =================================================================
  // BENEFITS
  // =================================================================

  Widget _buildBenefits() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 3, 14, 12),

      padding: const EdgeInsets.symmetric(vertical: 12),

      decoration: BoxDecoration(
        color: const Color(0xFFF6FAF7),
        borderRadius: BorderRadius.circular(10),
      ),

      child: const Row(
        children: [
          Expanded(
            child: _Benefit(
              icon: Icons.favorite_border_rounded,
              title: "Rich in",
              subtitle: "Vitamins",
            ),
          ),

          Expanded(
            child: _Benefit(
              icon: Icons.eco_outlined,
              title: "Good for",
              subtitle: "Health",
            ),
          ),

          Expanded(
            child: _Benefit(
              icon: Icons.spa_outlined,
              title: "100%",
              subtitle: "Natural",
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // SPECIFICATIONS
  // =================================================================
  Widget _buildSpecifications() {
    return _section(
      title: "Specifications",
      child: Column(
        children: [
          _specification(Icons.category_outlined, "Category", widget.category),
          _specification(
            Icons.home_work_outlined,
            "Farm Type",
            widget.farmType,
          ),
          _specification(
            Icons.location_on_outlined,
            "Origin",
            widget.farmLocation,
          ),
          _specification(
            Icons.calendar_today_outlined,
            "Harvested On",
            widget.harvestedOn,
          ),
          _specification(
            Icons.access_time_rounded,
            "Shelf Life",
            widget.shelfLife,
          ),
        ],
      ),
    );
  }

  Widget _specification(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),

      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF087C59)),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 8.5, color: Color(0xFF65736D)),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF455A64),
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // NUTRITION
  // =================================================================

  // Widget _buildNutrition() {
  //   return _section(
  //     title: "Nutritional Information (per 100g)",

  //     child: Column(
  //       children: [

  //         _nutritionRow(
  //           Icons.local_fire_department_rounded,
  //           "Calories",
  //           "18 kcal",
  //         ),

  //         _nutritionRow(
  //           Icons.grain_rounded,
  //           "Carbohydrates",
  //           "3.9 g",
  //         ),

  //         _nutritionRow(
  //           Icons.fitness_center_rounded,
  //           "Protein",
  //           "0.9 g",
  //         ),

  //         _nutritionRow(
  //           Icons.water_drop_rounded,
  //           "Fat",
  //           "0.2 g",
  //         ),

  //         _nutritionRow(
  //           Icons.local_drink_rounded,
  //           "Vitamin C",
  //           "13.7 mg",
  //         ),

  //         _nutritionRow(
  //           Icons.eco_rounded,
  //           "Potassium",
  //           "237 mg",
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _nutritionRow(
  //   IconData icon,
  //   String name,
  //   String value,
  // ) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(
  //       vertical: 6,
  //     ),

  //     child: Row(
  //       children: [

  //         Icon(
  //           icon,
  //           size: 14,
  //           color: const Color(0xFF087C59),
  //         ),

  //         const SizedBox(width: 8),

  //         Expanded(
  //           child: Text(
  //             name,
  //             style: const TextStyle(
  //               fontSize: 8.5,
  //               color: Color(0xFF65736D),
  //             ),
  //           ),
  //         ),

  //         Text(
  //           value,
  //           style: const TextStyle(
  //             fontSize: 8.5,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF455A64),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // =================================================================
  // REVIEWS
  // =================================================================

  Widget _buildReviews() {
    return _section(
      title: "Reviews (24)",

      trailing: "View All",

      child: Column(
        children: [
          // RATING SUMMARY
          Row(
            children: [
              SizedBox(
                width: 90,

                child: Column(
                  children: [
                    const Text(
                      "4.8",
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF263238),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Color(0xFFFFB300),
                        ),
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      "24 reviews",
                      style: TextStyle(fontSize: 7, color: Color(0xFF7B8782)),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  children: [
                    _ratingBar(5, 18),
                    _ratingBar(4, 4),
                    _ratingBar(3, 2),
                    _ratingBar(2, 0),
                    _ratingBar(1, 0),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _review(
            "Priya Sharma",
            "Very fresh and good quality tomatoes. Highly recommended!",
            "Sep 12, 2026",
            5,
          ),

          _review(
            "Amit Verma",
            "Tastes amazing and much fresher than market tomatoes.",
            "Sep 8, 2026",
            5,
          ),

          _review(
            "Neha Joshi",
            "Good quality and timely delivery.",
            "Sep 5, 2026",
            4,
          ),
        ],
      ),
    );
  }

  Widget _ratingBar(int stars, int count) {
    return Row(
      children: [
        Text("$stars", style: const TextStyle(fontSize: 7)),

        const Icon(Icons.star_rounded, size: 9, color: Color(0xFFFFB300)),

        const SizedBox(width: 4),

        Expanded(
          child: LinearProgressIndicator(
            value: count / 24,

            minHeight: 5,

            borderRadius: BorderRadius.circular(5),

            backgroundColor: const Color(0xFFE8EEEB),

            valueColor: const AlwaysStoppedAnimation(Color(0xFF087C59)),
          ),
        ),

        const SizedBox(width: 5),

        SizedBox(
          width: 12,

          child: Text("$count", style: const TextStyle(fontSize: 7)),
        ),
      ],
    );
  }

  Widget _review(String name, String comment, String date, int stars) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),

      padding: const EdgeInsets.all(9),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),

        border: Border.all(color: const Color(0xFFE5EBE8)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,

                decoration: const BoxDecoration(
                  color: Color(0xFFE8F3EC),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.person,
                  size: 17,
                  color: Color(0xFF087C59),
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_rounded,
                          size: 9,
                          color: index < stars
                              ? const Color(0xFFFFB300)
                              : const Color(0xFFD6DEDA),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                date,
                style: const TextStyle(fontSize: 6.5, color: Color(0xFF89958F)),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            comment,
            style: const TextStyle(
              fontSize: 7.5,
              height: 1.35,
              color: Color(0xFF65736D),
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // RECOMMENDED PRODUCTS
  // =================================================================

  Widget _buildRecommendedProducts() {
    return _section(
      title: "You May Also Like",

      trailing: "See All",

      child: SizedBox(
        height: 145,

        child: ListView(
          scrollDirection: Axis.horizontal,

          children: const [
            _RecommendedCard(
              image: "assets/images/cauliflower.png",
              name: "Potato",
              price: "₹25/kg",
            ),

            _RecommendedCard(
              image: "assets/images/onion.png",
              name: "Onion",
              price: "₹30/kg",
            ),

            _RecommendedCard(
              image: "assets/images/spinach.png",
              name: "Spinach",
              price: "₹20/bunch",
            ),
          ],
        ),
      ),
    );
  }

  // =================================================================
  // SECTION HELPER
  // =================================================================

  Widget _section({
    required String title,
    required Widget child,
    String? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 5, 14, 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF263238),
                ),
              ),

              if (trailing != null)
                Text(
                  trailing,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF087C59),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 7),

          child,
        ],
      ),
    );
  }

  // =================================================================
  // BOTTOM CART BAR
  // =================================================================

  Widget _buildBottomCartBar() {
    return Container(
      height: 65,

      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),

      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),

      child: Row(
        children: [
          // QUANTITY
          Container(
            height: 42,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),

              border: Border.all(color: const Color(0xFFDCE5E0)),
            ),

            child: Row(
              children: [
                _quantityButton(Icons.remove_rounded, () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                  }
                }),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),

                  child: Text(
                    "$quantity kg",
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                _quantityButton(Icons.add_rounded, () {
                  setState(() {
                    quantity++;
                  });
                }),
              ],
            ),
          ),

          const SizedBox(width: 9),

          // ADD TO CART
          Expanded(
            child: SizedBox(
              height: 42,

              child: ElevatedButton.icon(
                onPressed: () {
                  final cart = context.read<CartProvider>();
                  final productPrice =
                      double.tryParse(
                        widget.price
                            .replaceAll('₹', '')
                            .replaceAll(',', '')
                            .trim(),
                      ) ??
                      0.0;

                  for (int i = 0; i < quantity; i++) {
                    cart.addToCart(
                      productId: widget.productId,
                      name: widget.name,
                      price: productPrice,
                      unit: widget.unit,
                      image: widget.image,
                      farm: widget.farmName,
                      location: widget.farmLocation,
                    );
                  }
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('${widget.name} added to cart'),
                        backgroundColor: const Color(0xFF087C59),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                },

                icon: const Icon(Icons.shopping_cart_outlined, size: 17),

                label: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087C59),

                  foregroundColor: Colors.white,

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =================================================================
  // QUANTITY BUTTON
  // =================================================================

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,

      child: SizedBox(
        width: 30,
        height: 40,

        child: Center(
          child: Icon(icon, size: 16, color: const Color(0xFF087C59)),
        ),
      ),
    );
  }
}

// ====================================================================
// BENEFIT WIDGET
// ====================================================================

class _Benefit extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Benefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF087C59)),

        const SizedBox(height: 4),

        Text(
          title,
          style: const TextStyle(fontSize: 7.5, color: Color(0xFF65736D)),
        ),

        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 7.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF455A64),
          ),
        ),
      ],
    );
  }
}

// ====================================================================
// RECOMMENDED PRODUCT CARD
// ====================================================================

class _RecommendedCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;

  const _RecommendedCard({
    required this.image,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,

      margin: const EdgeInsets.only(right: 9),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(10),

        border: Border.all(color: const Color(0xFFE2E8E5)),
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            height: 75,
            width: double.infinity,

            child: Image.asset(
              image,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_outlined,
                  color: Color(0xFF9BA6A1),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(6),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF087C59),
                  ),
                ),

                const SizedBox(height: 3),

                const Row(
                  children: [
                    Icon(Icons.star_rounded, size: 9, color: Color(0xFFFFB300)),

                    SizedBox(width: 2),

                    Text("4.8", style: TextStyle(fontSize: 6.5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
