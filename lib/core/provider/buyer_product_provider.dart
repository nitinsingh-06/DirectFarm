import 'package:farmdirect/features/farmer/dashboard/models/buyer_product_model.dart';
import 'package:flutter/foundation.dart';

import 'package:farmdirect/services/api_services.dart';

class BuyerProductProvider extends ChangeNotifier {
  // ============================================================
  // VARIABLES
  // ============================================================

  List<BuyerProduct> _products = [];

  bool _isLoading = false;

  String? _error;

  // ============================================================
  // GETTERS
  // ============================================================

  List<BuyerProduct> get products => _products;

  bool get isLoading => _isLoading;

  String? get error => _error;

  // ============================================================
  // LOAD PRODUCTS
  // ============================================================

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _error = null;

      notifyListeners();

      debugPrint('======================================');
      debugPrint('LOADING BUYER PRODUCTS');
      debugPrint('======================================');

      final data = await ApiService.getProducts();

      _products = data
          .map(
            (item) => BuyerProduct.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .where((product) => product.isAvailable)
          .toList();

      debugPrint(
        'TOTAL PRODUCTS: ${_products.length}',
      );
    } catch (e) {
      debugPrint(
        'BUYER PRODUCTS ERROR: $e',
      );

      _error = e.toString();
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // ============================================================
  // REFRESH PRODUCTS
  // ============================================================

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // ============================================================
  // CATEGORY FILTER
  // ============================================================

  List<BuyerProduct> productsByCategory(
    int categoryId,
  ) {
    return _products
        .where(
          (product) =>
              product.categoryId == categoryId,
        )
        .toList();
  }
}