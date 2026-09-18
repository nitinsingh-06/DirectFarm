import 'package:flutter/material.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String farm;
  final String location;
  final String description;
  final String rating;
  final String unit;

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.farm,
    required this.location,
    required this.description,
    required this.rating,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(
              image: image,
              name: name,
              price: price,
              unit: unit,
              rating: rating,
              farmName: farm,
              farmLocation: location,
              description: description,
            ),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: const Color(0xFFE1E5E3),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.035),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =====================================================
            // IMAGE SECTION
            // =====================================================

            SizedBox(
              height: 88,
              width: double.infinity,
              child: Stack(
                children: [

                  // PRODUCT IMAGE
                  Positioned.fill(
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: const Color(0xFFEAF2EE),
                          child: const Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 28,
                              color: Color(0xFF9AA49F),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // =================================================
                  // FRESH BADGE
                  // =================================================

                  Positioned(
                    left: 6,
                    bottom: 5,
                    child: Container(
                      height: 18,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF087C59),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Fresh",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // =================================================
                  // HEART
                  // =================================================

                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () {
                        // Favorite functionality later
                      },
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 20,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // INFORMATION SECTION
            // =====================================================

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  7,
                  5,
                  6,
                  5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // =================================================
                    // PRODUCT NAME
                    // =================================================

                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 1),

                    // =================================================
                    // PRICE
                    // =================================================

                    Text(
                      "₹$price/$unit",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF087C59),
                      ),
                    ),

                    const SizedBox(height: 3),

                    // =================================================
                    // FARMER + ADD BUTTON
                    // =================================================

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // FARMER AVATAR
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE8EFEA),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 12,
                            color: Color(0xFF087C59),
                          ),
                        ),

                        const SizedBox(width: 5),

                        // FARMER INFORMATION
                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                farm,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 6.8,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF555555),
                                ),
                              ),

                              const SizedBox(height: 1),

                              Text(
                                location,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 6.5,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 3),

                        // =================================================
                        // PLUS BUTTON
                        // =================================================

                        GestureDetector(
                          onTap: () {
                            // Add to cart functionality later
                          },
                          child: Container(
                            width: 27,
                            height: 27,
                            decoration: const BoxDecoration(
                              color: Color(0xFF159447),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}