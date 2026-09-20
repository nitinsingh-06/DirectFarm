import 'dart:io';

class Product {
  final int? productId;
  final String name;
  final String price;
  final String unit;
  final String category;
  final double stock;
  final List<File> images;
  final String? imageUrl;
  final bool organic;

  Product({
    this.productId,
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.stock,
    this.images = const [],
    this.imageUrl,
    required this.organic,
  });
}




class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final double quantityAvailable;
  final String? imageUrl;

  final String? category;
  final String? farmType;
  final String? origin;
  final String? harvestedOn;
  final String? shelfLife;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.quantityAvailable,
    this.imageUrl,
    this.category,
    this.farmType,
    this.origin,
    this.harvestedOn,
    this.shelfLife,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0,
      unit: json['unit'] ?? '',
      quantityAvailable:
          double.tryParse(json['quantity_available'].toString()) ?? 0,
      imageUrl: json['image_url'],

      category: json['category'],
      farmType: json['farm_type'],
      origin: json['origin'],
      harvestedOn: json['harvested_on'],
      shelfLife: json['shelf_life'],
    );
  }
}