import 'dart:io';

class Product {
  final String name;
  final String price;
  final String unit;
  final String category;
  final double stock;
  final List<File> images;
  final bool organic;

  Product({
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.stock,
    required this.images,
    required this.organic,
  });
}