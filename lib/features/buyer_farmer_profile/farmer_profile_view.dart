
import 'dart:convert';

import 'package:farmdirect/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// IMPORTANT:
// Change this import to your actual ApiConfig file.

class FarmerProfileScreenview extends StatefulWidget {
  final int farmerId;

  const FarmerProfileScreenview({
    super.key,
    required this.farmerId,
  });

  @override
  State<FarmerProfileScreenview> createState() =>
      _FarmerProfileScreenviewState();
}

// ============================================================
// MODELS
// ============================================================

class FarmerProfile {
  final int farmerId;
  final String name;
  final String farmName;
  final String location;
  final String profileImageUrl;
  final String farmImageUrl;

  final String farmType;
  final String farmSize;
  final List<String> crops;
  final String memberSince;
  final String description;

  final double rating;
  final int reviewCount;
  final int orderCount;

  FarmerProfile({
    required this.farmerId,
    required this.name,
    required this.farmName,
    required this.location,
    required this.profileImageUrl,
    required this.farmImageUrl,
    required this.farmType,
    required this.farmSize,
    required this.crops,
    required this.memberSince,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.orderCount,
  });

  factory FarmerProfile.fromJson(Map<String, dynamic> json) {
    return FarmerProfile(
      farmerId: _toInt(
        json['farmer_id'] ??
            json['id'] ??
            json['user_id'],
      ),
      name: _toString(
        json['name'] ??
            json['farmer_name'] ??
            json['user']?['name'],
        'Farmer',
      ),
      farmName: _toString(
        json['farm_name'],
        'FarmDirect Farmer',
      ),
      location: _toString(
        json['farm_location'] ??
            json['location'] ??
            json['address'],
        'Location not available',
      ),
      profileImageUrl: _buildImageUrl(
        json['profile_image_url'] ??
            json['profile_image'],
      ),
      farmImageUrl: _buildImageUrl(
        json['farm_image_url'] ??
            json['cover_image_url'],
      ),
      farmType: _toString(
        json['farm_type'],
        'Not specified',
      ),
      farmSize: _toString(
        json['farm_size'],
        'Not specified',
      ),
      crops: _toStringList(
        json['crops'],
      ),
      memberSince: _formatMemberSince(
        json['created_at'] ??
            json['member_since'],
      ),
      description: _toString(
        json['description'],
        'No farm description available.',
      ),
      rating: _toDouble(
        json['rating'] ??
            json['average_rating'] ??
            0,
      ),
      reviewCount: _toInt(
        json['review_count'] ??
            json['reviews_count'] ??
            0,
      ),
      orderCount: _toInt(
        json['order_count'] ??
            json['orders_count'] ??
            0,
      ),
    );
  }
}

class FarmerProduct {
  final int productId;
  final String name;
  final String description;
  final double price;
  final String unit;
  final double quantityAvailable;
  final String imageUrl;
  final bool isAvailable;

  FarmerProduct({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.quantityAvailable,
    required this.imageUrl,
    required this.isAvailable,
  });

  factory FarmerProduct.fromJson(Map<String, dynamic> json) {
    return FarmerProduct(
      productId: _toInt(
        json['product_id'] ??
            json['id'],
      ),
      name: _toString(
        json['name'],
        'Product',
      ),
      description: _toString(
        json['description'],
        '',
      ),
      price: _toDouble(
        json['price'],
      ),
      unit: _toString(
        json['unit'],
        'kg',
      ),
      quantityAvailable: _toDouble(
        json['quantity_available'] ??
            json['quantity'],
      ),
      imageUrl: _buildImageUrl(
        json['image_url'] ??
            json['image'],
      ),
      isAvailable: json['is_available'] != false,
    );
  }
}

class FarmerReview {
  final int reviewId;
  final String buyerName;
  final String review;
  final double rating;
  final String buyerImage;

  FarmerReview({
    required this.reviewId,
    required this.buyerName,
    required this.review,
    required this.rating,
    required this.buyerImage,
  });

  factory FarmerReview.fromJson(Map<String, dynamic> json) {
    return FarmerReview(
      reviewId: _toInt(
        json['review_id'] ??
            json['id'],
      ),
      buyerName: _toString(
        json['buyer_name'] ??
            json['user_name'] ??
            json['name'],
        'Buyer',
      ),
      review: _toString(
        json['comment'] ??
            json['review'] ??
            json['message'],
        '',
      ),
      rating: _toDouble(
        json['rating'] ?? 0,
      ),
      buyerImage: _buildImageUrl(
        json['buyer_image'] ??
            json['profile_image_url'],
      ),
    );
  }
}

// ============================================================
// HELPER FUNCTIONS
// ============================================================

String _toString(dynamic value, String fallback) {
  if (value == null) return fallback;

  final result = value.toString().trim();

  if (result.isEmpty || result == 'null') {
    return fallback;
  }

  return result;
}

int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;

  if (value is double) return value;

  if (value is int) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}

List<String> _toStringList(dynamic value) {
  if (value == null) return [];

  if (value is List) {
    return value
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  if (value is String) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  return [];
}

String _formatMemberSince(dynamic value) {
  if (value == null) {
    return 'Not available';
  }

  try {
    final date = DateTime.parse(value.toString());

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.year}';
  } catch (_) {
    return value.toString();
  }
}

String _buildImageUrl(dynamic image) {
  if (image == null) return '';

  final path = image.toString().trim();

  if (path.isEmpty || path == 'null') {
    return '';
  }

  if (path.startsWith('http://') ||
      path.startsWith('https://')) {
    return path;
  }

  final baseUrl = ApiConfig.baseUrl;

  if (path.startsWith('/')) {
    return '$baseUrl$path';
  }

  return '$baseUrl/$path';
}

// ============================================================
// SCREEN
// ============================================================

class _FarmerProfileScreenviewState
    extends State<FarmerProfileScreenview> {

  static const Color primaryGreen = Color(0xFF087F5B);
  static const Color lightGreen = Color(0xFFEAF7EF);
  static const Color textColor = Color(0xFF17212B);

  int selectedTab = 0;

  FarmerProfile? farmer;

  List<FarmerProduct> products = [];
  List<FarmerReview> reviews = [];

  bool isLoading = true;
  bool isProductsLoading = false;
  bool isReviewsLoading = false;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFarmerData();
  }

  // ==========================================================
  // LOAD FARMER
  // ==========================================================

  Future<void> _loadFarmerData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final profile = await _fetchFarmerProfile();

      if (!mounted) return;

      setState(() {
        farmer = profile;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // ==========================================================
  // FETCH PROFILE
  // ==========================================================

  Future<FarmerProfile> _fetchFarmerProfile() async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/farmer-profile/${widget.farmerId}',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    debugPrint(
      'Farmer Profile Status: ${response.statusCode}',
    );

    debugPrint(
      'Farmer Profile Response: ${response.body}',
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load farmer profile '
        '(${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body);

    // Some APIs return:
    // { "data": {...} }
    // while others return {...}
    final profileJson =
        data is Map<String, dynamic> &&
                data['data'] is Map
            ? Map<String, dynamic>.from(data['data'])
            : Map<String, dynamic>.from(data);

    return FarmerProfile.fromJson(profileJson);
  }

  // ==========================================================
  // FETCH PRODUCTS
  // ==========================================================

  Future<void> _fetchProducts() async {
    if (isProductsLoading) return;

    setState(() {
      isProductsLoading = true;
    });

    try {
      final url = Uri.parse(
        '${ApiConfig.baseUrl}/products?farmer_id=${widget.farmerId}',
      );

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      debugPrint(
        'Farmer Products Status: ${response.statusCode}',
      );

      debugPrint(
        'Farmer Products Response: ${response.body}',
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load products '
          '(${response.statusCode})',
        );
      }

      final decoded = jsonDecode(response.body);

      List<dynamic> list;

      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map &&
          decoded['data'] is List) {
        list = decoded['data'];
      } else if (decoded is Map &&
          decoded['items'] is List) {
        list = decoded['items'];
      } else {
        list = [];
      }

      final loadedProducts = list
          .whereType<Map>()
          .map(
            (item) => FarmerProduct.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        products = loadedProducts;
        isProductsLoading = false;
      });
    } catch (e) {
      debugPrint(
        'Products Error: $e',
      );

      if (!mounted) return;

      setState(() {
        isProductsLoading = false;
      });

      _showError(
        'Unable to load products',
      );
    }
  }

  // ==========================================================
  // FETCH REVIEWS
  // ==========================================================

  Future<void> _fetchReviews() async {
    if (isReviewsLoading) return;

    setState(() {
      isReviewsLoading = true;
    });

    try {
      /*
       * IMPORTANT:
       *
       * Make sure your FastAPI route matches this endpoint.
       *
       * Example:
       * GET /reviews/farmer/{farmer_id}
       */

      final url = Uri.parse(
        '${ApiConfig.baseUrl}/reviews/farmer/${widget.farmerId}',
      );

      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );

      debugPrint(
        'Reviews Status: ${response.statusCode}',
      );

      debugPrint(
        'Reviews Response: ${response.body}',
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load reviews '
          '(${response.statusCode})',
        );
      }

      final decoded = jsonDecode(response.body);

      List<dynamic> list;

      if (decoded is List) {
        list = decoded;
      } else if (decoded is Map &&
          decoded['data'] is List) {
        list = decoded['data'];
      } else if (decoded is Map &&
          decoded['items'] is List) {
        list = decoded['items'];
      } else {
        list = [];
      }

      final loadedReviews = list
          .whereType<Map>()
          .map(
            (item) => FarmerReview.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        reviews = loadedReviews;
        isReviewsLoading = false;
      });
    } catch (e) {
      debugPrint(
        'Reviews Error: $e',
      );

      if (!mounted) return;

      setState(() {
        isReviewsLoading = false;
      });

      _showError(
        'Unable to load reviews',
      );
    }
  }

  // ==========================================================
  // TAB CHANGE
  // ==========================================================

  void _changeTab(int index) {
    setState(() {
      selectedTab = index;
    });

    if (index == 1 && products.isEmpty) {
      _fetchProducts();
    }

    if (index == 2 && reviews.isEmpty) {
      _fetchReviews();
    }
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : errorMessage != null
                ? _buildErrorScreen()
                : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _loadFarmerData,
                          child: SingleChildScrollView(
                            physics:
                                const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                _buildHeader(),

                                Transform.translate(
                                  offset:
                                      const Offset(0, -28),
                                  child:
                                      _buildProfileContent(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      _buildBottomButtons(),
                    ],
                  ),
      ),
    );
  }

  // ==========================================================
  // ERROR SCREEN
  // ==========================================================

  Widget _buildErrorScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 55,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 15),

            const Text(
              'Unable to load farmer profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              errorMessage ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: _loadFarmerData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    final image = farmer?.farmImageUrl ?? '';

    return SizedBox(
      height: 185,
      child: Stack(
        children: [
          Positioned.fill(
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            _farmImageFallback(),
                  )
                : _farmImageFallback(),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.transparent,
                    Colors.black.withOpacity(0.08),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 14,
            top: 12,
            child: _circleButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () =>
                  Navigator.pop(context),
            ),
          ),

          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Farmer Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            right: 14,
            top: 12,
            child: _circleButton(
              icon: Icons.more_vert,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _farmImageFallback() {
    return Container(
      color: lightGreen,
      child: const Center(
        child: Icon(
          Icons.agriculture,
          size: 55,
          color: primaryGreen,
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            size: 17,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PROFILE CONTENT
  // ==========================================================

  Widget _buildProfileContent() {
    final data = farmer!;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      padding:
          const EdgeInsets.fromLTRB(14, 0, 14, 15),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Text(
                  data.name,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),

              const SizedBox(width: 5),

              const Icon(
                Icons.eco,
                size: 18,
                color: primaryGreen,
              ),
            ],
          ),

          const SizedBox(height: 2),

          Text(
            data.farmName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),

          const SizedBox(height: 2),

          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 12,
                color: Colors.grey.shade700,
              ),

              const SizedBox(width: 2),

              Expanded(
                child: Text(
                  data.location,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          _buildStats(),

          const SizedBox(height: 8),

          _buildQuote(),

          const SizedBox(height: 9),

          _buildTabs(),

          const SizedBox(height: 10),

          if (selectedTab == 0)
            _buildAboutTab()
          else if (selectedTab == 1)
            _buildProductsTab()
          else
            _buildReviewsTab(),
        ],
      ),
    );
  }

  // ==========================================================
  // PROFILE IMAGE
  // ==========================================================

  Widget _buildProfileHeader() {
    final image = farmer?.profileImageUrl ?? '';

    return SizedBox(
      height: 55,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 2,
            top: -30,
            child: Container(
              width: 68,
              height: 68,
              padding:
                  const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.12),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                                _farmerProfileFallback(),
                      )
                    : _farmerProfileFallback(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _farmerProfileFallback() {
    return Container(
      color: lightGreen,
      alignment: Alignment.center,
      child: const Icon(
        Icons.person,
        size: 32,
        color: primaryGreen,
      ),
    );
  }

  // ==========================================================
  // STATS
  // ==========================================================

  Widget _buildStats() {
    final data = farmer!;

    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 16,
        ),

        const SizedBox(width: 3),

        Text(
          data.rating > 0
              ? data.rating.toStringAsFixed(1)
              : 'No rating',
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
          ),
        ),

        if (data.reviewCount > 0)
          Text(
            ' (${data.reviewCount} reviews)',
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade600,
            ),
          ),

        Container(
          height: 17,
          width: 1,
          margin:
              const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          color: Colors.grey.shade300,
        ),

        Icon(
          Icons.people,
          size: 14,
          color: Colors.grey.shade700,
        ),

        const SizedBox(width: 4),

        Text(
          '${data.orderCount}+ orders',
          style: TextStyle(
            fontSize: 9.5,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // QUOTE
  // ==========================================================

  Widget _buildQuote() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius:
            BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.eco,
            size: 17,
            color: primaryGreen,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              farmer!.description,
              style: TextStyle(
                fontSize: 8.5,
                height: 1.35,
                color:
                    Colors.grey.shade700,
                fontStyle:
                    FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TABS
  // ==========================================================

  Widget _buildTabs() {
    const tabs = [
      'About',
      'Products',
      'Reviews',
    ];

    return Row(
      children: List.generate(
        tabs.length,
        (index) {
          final selected =
              selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () =>
                  _changeTab(index),
              child: Container(
                padding:
                    const EdgeInsets.only(
                  bottom: 7,
                ),
                decoration:
                    BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected
                          ? primaryGreen
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: selected
                          ? primaryGreen
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // ABOUT
  // ==========================================================

  Widget _buildAboutTab() {
    final data = farmer!;

    final crops = data.crops.isEmpty
        ? 'Not specified'
        : data.crops.join(', ');

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _infoCard(
                Icons.agriculture,
                'Farm Type',
                data.farmType,
              ),
            ),

            const SizedBox(width: 7),

            Expanded(
              child: _infoCard(
                Icons.spa,
                'Farm Size',
                data.farmSize,
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        Row(
          children: [
            Expanded(
              child: _infoCard(
                Icons.eco,
                'Crops Grown',
                crops,
              ),
            ),

            const SizedBox(width: 7),

            Expanded(
              child: _infoCard(
                Icons.calendar_month,
                'Member Since',
                data.memberSince,
              ),
            ),
          ],
        ),

        const SizedBox(height: 11),

        const Text(
          'About Farm',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          data.description,
          style: TextStyle(
            fontSize: 8.5,
            height: 1.4,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      height: 50,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius:
            BorderRadius.circular(9),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius:
                  BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              size: 14,
              color: primaryGreen,
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 7,
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 7.5,
                    fontWeight:
                        FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRODUCTS
  // ==========================================================

  Widget _buildProductsTab() {
    if (isProductsLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: primaryGreen,
              size: 30,
            ),

            SizedBox(height: 8),

            Text(
              'No products available',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Farm Products',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        ...products.map(
          (product) =>
              _productCard(product),
        ),
      ],
    );
  }

  Widget _productCard(
    FarmerProduct product,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius:
            BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(8),
            child: SizedBox(
              width: 58,
              height: 58,
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              _productFallback(),
                    )
                  : _productFallback(),
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w800,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 3),

                if (product.description
                    .isNotEmpty)
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 7.5,
                      color:
                          Colors.grey.shade600,
                    ),
                  ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style:
                          const TextStyle(
                        fontSize: 9,
                        fontWeight:
                            FontWeight.w800,
                        color: primaryGreen,
                      ),
                    ),

                    const SizedBox(width: 4),

                    Text(
                      '/ ${product.unit}',
                      style: TextStyle(
                        fontSize: 7.5,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Icon(
            product.isAvailable
                ? Icons.check_circle
                : Icons.cancel,
            size: 16,
            color: product.isAvailable
                ? primaryGreen
                : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _productFallback() {
    return Container(
      color: lightGreen,
      alignment: Alignment.center,
      child: const Icon(
        Icons.eco,
        color: primaryGreen,
      ),
    );
  }

  // ==========================================================
  // REVIEWS
  // ==========================================================

  Widget _buildReviewsTab() {
    if (isReviewsLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              color: primaryGreen,
              size: 30,
            ),

            SizedBox(height: 8),

            Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        ...reviews.map(
          (review) =>
              Padding(
            padding:
                const EdgeInsets.only(
              bottom: 6,
            ),
            child:
                _reviewCard(review),
          ),
        ),
      ],
    );
  }

  Widget _reviewCard(
    FarmerReview review,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius:
            BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < review.rating.round()
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: 13,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            review.review,
            style:
                const TextStyle(
              fontSize: 8.5,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            review.buyerName,
            style: TextStyle(
              fontSize: 7.5,
              color:
                  Colors.grey.shade600,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BOTTOM BUTTONS
  // ==========================================================

  Widget _buildBottomButtons() {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        14,
        8,
        14,
        10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset:
                const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO:
                // Navigate to your chat screen
                // with farmerId.
              },
              icon: const Icon(
                Icons.chat_bubble_outline,
                size: 16,
              ),
              label: const Text(
                'Chat',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    primaryGreen,
                side:
                    const BorderSide(
                  color: primaryGreen,
                ),
                minimumSize:
                    const Size(0, 38),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _changeTab(1);
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 16,
              ),
              label: const Text(
                'View Products',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryGreen,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                minimumSize:
                    const Size(0, 38),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
