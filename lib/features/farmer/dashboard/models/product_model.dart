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