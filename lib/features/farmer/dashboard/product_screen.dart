import 'package:flutter/material.dart';
import 'package:farmdirect/features/farmer/dashboard/add_product.dart';
import 'package:farmdirect/features/farmer/dashboard/my_product.dart';

// COLORS
class AppColors {
  static const primary = Color(0xFF075C49);
  static const green = Color(0xFF80D000);
  static const lightGreen = Color(0xFFE9F7EF);
  static const background = Color(0xFFF7F9FA);
  static const border = Color(0xFFE3E7EA);
  static const textDark = Color(0xFF263238);
  static const textGrey = Color(0xFF68747D);
  static const red = Color(0xFFFF5A5F);
  static const yellow = Color(0xFFFFC83D);
}

// PRODUCT SCREEN
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedIndex = 1;

  // Changes whenever a new product is successfully added.
  int _productRefreshKey = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const SimplePage(title: 'Home'),

      MyProductsScreen(
        key: ValueKey(_productRefreshKey),
        products: const [],
        onAddProduct: _openAddProduct,
      ),

      const SimplePage(title: 'Orders'),
      const SimplePage(title: 'Earnings'),
      const SimplePage(title: 'Profile'),
    ];

    return Scaffold(
      body: SafeArea(bottom: false, child: screens[selectedIndex]),
    );
  }

  Future<void> _openAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddProductScreen()),
    );

    // AddProductScreen returns true after successfully
    // creating the product.
    if (result == true && mounted) {
      setState(() {
        _productRefreshKey++;
      });
    }
  }
}

// TEMPORARY SIMPLE PAGE
class SimplePage extends StatelessWidget {
  final String title;

  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
