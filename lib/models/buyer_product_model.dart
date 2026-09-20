import 'package:farmdirect/config/api_config.dart';

class BuyerProduct {
  final int productId;
  final int farmerId;
  final int categoryId;

  final String name;
  final String description;
  final double price;
  final String unit;
  final double quantityAvailable;

  final String? imageUrl;
  final bool isAvailable;

  // ============================================================
  // PRODUCT SPECIFICATIONS
  // ============================================================

  final String? category;
  final String? farmType;
  final String? origin;
  final String? harvestedOn;
  final String? shelfLife;

  BuyerProduct({
    required this.productId,
    required this.farmerId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.quantityAvailable,
    this.imageUrl,
    required this.isAvailable,

    // Specifications
    this.category,
    this.farmType,
    this.origin,
    this.harvestedOn,
    this.shelfLife,
  });

  factory BuyerProduct.fromJson(
    Map<String, dynamic> json,
  ) {
    return BuyerProduct(
      productId: json['product_id'] ?? 0,

      farmerId: json['farmer_id'] ?? 0,

      categoryId: json['category_id'] ?? 0,

      name: json['name']?.toString() ?? '',

      description:
          json['description']?.toString() ?? '',

      price: double.tryParse(
            json['price']?.toString() ?? '0',
          ) ??
          0.0,

      unit: json['unit']?.toString() ?? '',

      quantityAvailable: double.tryParse(
            json['quantity_available']?.toString() ?? '0',
          ) ??
          0.0,

      imageUrl: json['image_url']?.toString(),

      isAvailable: json['is_available'] ?? true,

      // ========================================================
      // SPECIFICATIONS FROM API
      // ========================================================

      category: json['category']?.toString(),

      farmType: json['farm_type']?.toString(),

      origin: json['origin']?.toString(),

      harvestedOn:
          json['harvested_on']?.toString(),

      shelfLife:
          json['shelf_life']?.toString(),
    );
  }

  // ============================================================
  // FULL PRODUCT IMAGE URL
  // ============================================================

  String get fullImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return '';
    }

    if (imageUrl!.startsWith('http://') ||
        imageUrl!.startsWith('https://')) {
      return imageUrl!;
    }

    return '${ApiConfig.baseUrl}$imageUrl';
  }
}