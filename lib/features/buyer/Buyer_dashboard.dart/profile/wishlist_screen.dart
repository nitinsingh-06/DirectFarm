import 'package:flutter/material.dart';

class WishlistProduct {
  final String id;
  final String name;
  final String farmer;
  final String price;
  final String unit;
  final String rating;
  final String image;

  WishlistProduct({
    required this.id,
    required this.name,
    required this.farmer,
    required this.price,
    required this.unit,
    required this.rating,
    required this.image,
  });
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() =>
      _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  static const Color primary = Color(0xFF075B4A);
  static const Color background = Color(0xFFF7F9F8);
  static const Color textDark = Color(0xFF293530);
  static const Color textGrey = Color(0xFF7A8581);
  static const Color red = Color(0xFFFF5C5C);

  // ----------------------------------------------------------
  // WISHLIST DATA
  // ----------------------------------------------------------

  final List<WishlistProduct> _wishlist = [
    WishlistProduct(
      id: '1',
      name: 'Organic Alphonso Mangoes',
      farmer: 'Ratanagiri FPO',
      price: '450',
      unit: 'dozen',
      rating: '4.9',
      image: 'assets/images/mango.png',
    ),

    WishlistProduct(
      id: '2',
      name: 'Organic Tomatoes',
      farmer: 'Ramgarh Farms',
      price: '40',
      unit: 'kg',
      rating: '4.8',
      image: 'assets/images/tomato.png',
    ),

    WishlistProduct(
      id: '3',
      name: 'Premium Basmati Rice',
      farmer: 'Saffron Valley FPO',
      price: '95',
      unit: 'kg',
      rating: '4.8',
      image: 'assets/images/rice.png',
    ),

    WishlistProduct(
      id: '4',
      name: 'Fresh Cauliflower',
      farmer: 'GreenLand FPO',
      price: '35',
      unit: 'piece',
      rating: '4.7',
      image: 'assets/images/cauliflower.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,

        automaticallyImplyLeading: false,

        title: const Text(
          'My Wishlist',
          style: TextStyle(
            color: primary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF6F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_wishlist.length} Items',
                style: const TextStyle(
                  color: primary,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),

      // ------------------------------------------------------
      // BODY
      // ------------------------------------------------------

      body: _wishlist.isEmpty
          ? _buildEmptyWishlist()
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                8,
                4,
                8,
                20,
              ),

              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 9,
                childAspectRatio: 0.78,
              ),

              itemCount: _wishlist.length,

              itemBuilder: (context, index) {
                return _buildProductCard(
                  _wishlist[index],
                );
              },
            ),
    );
  }

  // ==========================================================
  // PRODUCT CARD
  // ==========================================================

  Widget _buildProductCard(
    WishlistProduct product,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE0E5E2),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------
          // IMAGE
          // --------------------------------------------------

          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(9),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,

                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          color:
                              const Color(0xFFF0F2F1),
                          child: const Center(
                            child: Icon(
                              Icons
                                  .image_outlined,
                              color:
                                  Color(0xFF9AA5A1),
                              size: 35,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ------------------------------------------------
                // HEART
                // ------------------------------------------------

                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      _removeFromWishlist(
                        product,
                      );
                    },
                    child: Container(
                      width: 23,
                      height: 23,
                      decoration:
                          const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 14,
                        color: red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------
          // PRODUCT INFORMATION
          // --------------------------------------------------

          Expanded(
            flex: 4,
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                7,
                5,
                7,
                6,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight:
                          FontWeight.w800,
                      color: textDark,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Farmer
                  Text(
                    'By ${product.farmer}',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 7,
                      color: textGrey,
                    ),
                  ),

                  const SizedBox(height: 3),

                  // Price + Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '₹${product.price} / ${product.unit}',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight:
                                FontWeight.w800,
                            color: primary,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.star,
                        size: 9,
                        color:
                            Color(0xFFFFB300),
                      ),

                      const SizedBox(width: 2),

                      Text(
                        product.rating,
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

                  const Spacer(),

                  // ------------------------------------------------
                  // ADD TO CART
                  // ------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 25,
                    child: ElevatedButton(
                      onPressed: () {
                        _addToCart(product);
                      },
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            primary,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        padding:
                            EdgeInsets.zero,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            6,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
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

  // ==========================================================
  // REMOVE FROM WISHLIST
  // ==========================================================

  void _removeFromWishlist(
    WishlistProduct product,
  ) {
    setState(() {
      _wishlist.removeWhere(
        (item) => item.id == product.id,
      );
    });

    _showMessage(
      '${product.name} removed from wishlist',
    );
  }

  // ==========================================================
  // ADD TO CART
  // ==========================================================

  void _addToCart(
    WishlistProduct product,
  ) {
    // --------------------------------------------------------
    // TEMPORARY CART LOGIC
    // --------------------------------------------------------
    //
    // Later this will call your existing CartProvider /
    // CartScreen cart logic.
    //

    _showMessage(
      '${product.name} added to cart',
    );
  }

  // ==========================================================
  // EMPTY WISHLIST
  // ==========================================================

  Widget _buildEmptyWishlist() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color:
                    const Color(0xFFEAF6F2),
                borderRadius:
                    BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 40,
                color: primary,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Your Wishlist is Empty',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: textDark,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Save products you love and find them here later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: textGrey,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor:
                    Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),
                ),
              ),
              child: const Text(
                'Explore Marketplace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
            SnackBarBehavior.floating,
        duration:
            const Duration(seconds: 2),
      ),
    );
  }
}