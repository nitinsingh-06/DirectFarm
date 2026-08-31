import 'package:farmdirect/features/Buyer_dashboard.dart/product_details_screen.dart';
import 'package:flutter/material.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 14, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // HEADER
              // ==================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Marketplace",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF075B4A),
                    ),
                  ),

                  Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE6EAEC),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ==================================================
              // SEARCH + SORT
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 31,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: const Color(0xFFE2E6E8),
                        ),
                      ),
                      child: const TextField(
                        style: TextStyle(
                          fontSize: 8.5,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 14,
                            color: Color(0xFF8B949E),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 29,
                          ),
                          hintText: "Search crop, grain...",
                          hintStyle: TextStyle(
                            fontSize: 8.5,
                            color: Color(0xFF9AA3A8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 7,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  Container(
                    height: 31,
                    width: 67,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: const Color(0xFFE2E6E8),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Popularity",
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF455A64),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ==================================================
              // PRODUCT GRID
              // ==================================================

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: products.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  crossAxisSpacing: 8,

                  mainAxisSpacing: 9,

                  childAspectRatio: 0.76,
                ),

                itemBuilder: (context, index) {
                  final product = products[index];

                  return ProductCard(
                    image: product["image"]!,
                    name: product["name"]!,
                    price: product["price"]!,
                    rating: product["rating"]!,
                  );
                },
              ),

              const SizedBox(height: 18),

              // ==================================================
              // LOAD MORE
              // ==================================================

              Center(
                child: OutlinedButton(
                  onPressed: () {},

                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(112, 29),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    side: const BorderSide(
                      color: Color(0xFF087C59),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  child: const Text(
                    "Load More Products",
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF075B4A),
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
}

// =================================================================
// PRODUCT CARD
// =================================================================

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String rating;

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          image: image,
          name: name,
          price: price.replaceAll(
            RegExp(r'[^0-9]'),
            '',
          ),
          unit: price.contains("/")
              ? price.split("/").last.trim()
              : "unit",
          rating: rating,
          farmName: "Ratnagiri Farms (FPO)",
          farmLocation:
              "Ratnagiri, Maharashtra • 340 km away",
          description:
              "Grown without synthetic pesticides. "
              "Naturally ripened and farm-fresh produce. "
              "Sweet, rich aroma with perfect saffron-colored "
              "pulp. Straight from coastal orchards.",
        ),
      ),
    );
  },
    
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFE3E7EA),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ======================================================
          // PRODUCT IMAGE
          // ======================================================

          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),

              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,

                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 35,
                      color: Color(0xFFB8C0C4),
                    ),
                  );
                },
              ),
            ),
          ),

          // ======================================================
          // PRODUCT DETAILS
          // ======================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              7,
              5,
              7,
              6,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // PRODUCT NAME

                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF263238),
                  ),
                ),

                const SizedBox(height: 3),

                // PRICE + RATING

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF087C59),
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 9,
                          color: Color(0xFFFFB300),
                        ),

                        const SizedBox(width: 2),

                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 7,
                            color: Color(0xFFFFA000),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // ADD TO CART BUTTON

                SizedBox(
                  width: double.infinity,
                  height: 21,

                  child: ElevatedButton(
                    onPressed: () {
                      // Add product to cart here
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF075B4A),

                      foregroundColor: Colors.white,

                      elevation: 0,

                      padding: EdgeInsets.zero,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5),
                      ),
                    ),

                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        fontSize: 7.5,
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
    )
    );
  }
}

// =================================================================
// PRODUCT DATA
// =================================================================

final List<Map<String, String>> products = [
  {
    "image": "assets/images/mangoes.png",
    "name": "Organic Alphonso Mango",
    "price": "₹450 / dozen",
    "rating": "4.9",
  },

  {
    "image": "assets/images/cauliflower.png",
    "name": "Fresh Cauliflower",
    "price": "₹35 / piece",
    "rating": "4.7",
  },

  {
    "image": "assets/images/rice.png",
    "name": "Premium Basmati Rice",
    "price": "₹95 / kg",
    "rating": "4.8",
  },

  {
    "image": "assets/images/green_chillies.png",
    "name": "Organic Green Chillies",
    "price": "₹15 / 250g",
    "rating": "4.6",
  },
];