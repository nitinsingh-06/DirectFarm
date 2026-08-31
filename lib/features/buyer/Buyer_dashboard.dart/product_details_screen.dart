import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String image;
  final String name;
  final String price;
  final String unit;
  final String rating;
  final String farmName;
  final String farmLocation;
  final String description;

  const ProductDetailsScreen({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.unit,
    required this.rating,
    required this.farmName,
    required this.farmLocation,
    required this.description,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {

  int quantity = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ====================================================
              // HEADER
              // ====================================================

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),

                child: Row(
                  children: [

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },

                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 17,
                        color: Color(0xFF455A64),
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      "Product Details",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF075B4A),
                      ),
                    ),

                    const Spacer(),

                    const Icon(
                      Icons.share_outlined,
                      size: 18,
                      color: Color(0xFF455A64),
                    ),
                  ],
                ),
              ),

              // ====================================================
              // PRODUCT IMAGE
              // ====================================================

              Stack(
                children: [

                  SizedBox(
                    width: double.infinity,
                    height: 138,

                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.cover,

                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFE8ECEA),
                          child: const Icon(
                            Icons.image_outlined,
                            size: 45,
                            color: Color(0xFF9AA3A8),
                          ),
                        );
                      },
                    ),
                  ),

                  // Organic badge

                  Positioned(
                    top: 10,
                    left: 10,

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFF80D000),
                        borderRadius:
                            BorderRadius.circular(4),
                      ),

                      child: const Text(
                        "100% Organic",
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF164000),
                        ),
                      ),
                    ),
                  ),

                  // Image dots

                  Positioned(
                    bottom: 7,
                    left: 0,
                    right: 0,

                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        _dot(true),
                        _dot(false),
                        _dot(false),
                        _dot(false),
                      ],
                    ),
                  ),
                ],
              ),

              // ====================================================
              // PRODUCT INFORMATION
              // ====================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  11,
                  11,
                  11,
                  0,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF075B4A),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Price + freshness

                    Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Price / Unit",
                                style: TextStyle(
                                  fontSize: 7,
                                  color:
                                      Color(0xFF8B949E),
                                ),
                              ),

                              const SizedBox(height: 2),

                              Row(
                                children: [

                                  Text(
                                    widget.price,
                                    style:
                                        const TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.w800,
                                      color:
                                          Color(0xFF263238),
                                    ),
                                  ),

                                  const SizedBox(width: 3),

                                  Text(
                                    "/ ${widget.unit}",
                                    style:
                                        const TextStyle(
                                      fontSize: 8,
                                      color:
                                          Color(0xFF7B8794),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Freshness Guarantee",
                                style: TextStyle(
                                  fontSize: 7,
                                  color:
                                      Color(0xFF8B949E),
                                ),
                              ),

                              const SizedBox(height: 3),

                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),

                                decoration: BoxDecoration(
                                  color: const Color(
                                      0xFFE6F7EF),
                                  borderRadius:
                                      BorderRadius.circular(
                                          4),
                                ),

                                child: const Text(
                                  "Harvested Today",
                                  style: TextStyle(
                                    fontSize: 7,
                                    fontWeight:
                                        FontWeight.w700,
                                    color:
                                        Color(0xFF087C59),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Divider(
                      height: 1,
                      color: Color(0xFFE5E9EB),
                    ),

                    const SizedBox(height: 9),

                    // =================================================
                    // FARM CARD
                    // =================================================

                    Container(
                      padding: const EdgeInsets.all(7),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(
                              0xFFE5E9EB),
                        ),
                      ),

                      child: Row(
                        children: [

                          Container(
                            width: 29,
                            height: 29,

                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE5F1EA),
                            ),

                            child: const Icon(
                              Icons.agriculture,
                              size: 17,
                              color: Color(0xFF087C59),
                            ),
                          ),

                          const SizedBox(width: 7),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Text(
                                  widget.farmName,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight:
                                        FontWeight.w800,
                                    color:
                                        Color(0xFF263238),
                                  ),
                                ),

                                const SizedBox(height: 2),

                                Text(
                                  widget.farmLocation,
                                  style: const TextStyle(
                                    fontSize: 7,
                                    color:
                                        Color(0xFF8B949E),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [

                              const Icon(
                                Icons.star,
                                size: 10,
                                color: Color(0xFFFFB300),
                              ),

                              const SizedBox(width: 2),

                              Text(
                                widget.rating,
                                style:
                                    const TextStyle(
                                  fontSize: 7,
                                  fontWeight:
                                      FontWeight.w700,
                                  color:
                                      Color(0xFFFFA000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 11),

                    // =================================================
                    // DESCRIPTION
                    // =================================================

                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF263238),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 8,
                        height: 1.4,
                        color: Color(0xFF7B8794),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ============================================================
      // BOTTOM CART BAR
      // ============================================================

      bottomNavigationBar: SafeArea(
        top: false,

        child: Container(
          height: 54,

          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),

          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFE5E9EB),
              ),
            ),
          ),

          child: Row(
            children: [

              // ==================================================
              // QUANTITY
              // ==================================================

              Container(
                height: 31,

                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7F7),
                  borderRadius:
                      BorderRadius.circular(7),
                ),

                child: Row(
                  children: [

                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() {
                            quantity--;
                          });
                        }
                      },

                      padding: EdgeInsets.zero,

                      constraints:
                          const BoxConstraints(
                        minWidth: 27,
                      ),

                      icon: const Icon(
                        Icons.remove,
                        size: 13,
                      ),
                    ),

                    Text(
                      "$quantity",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        setState(() {
                          quantity++;
                        });
                      },

                      padding: EdgeInsets.zero,

                      constraints:
                          const BoxConstraints(
                        minWidth: 27,
                      ),

                      icon: const Icon(
                        Icons.add,
                        size: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // ==================================================
              // ADD TO CART
              // ==================================================

              Expanded(
                child: SizedBox(
                  height: 31,

                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            "$quantity ${widget.unit} added to cart",
                          ),
                          duration:
                              const Duration(seconds: 1),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF075B4A),

                      foregroundColor: Colors.white,

                      elevation: 0,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(7),
                      ),
                    ),

                    child: Text(
                      "Add $quantity ${widget.unit} to Cart",
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
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

  // =============================================================
  // IMAGE DOT
  // =============================================================

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 2,
      ),

      width: active ? 5 : 4,
      height: active ? 5 : 4,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: active
            ? const Color(0xFF80D000)
            : Colors.white,
      ),
    );
  }
}