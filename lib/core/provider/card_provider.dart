import 'package:farmdirect/config/api_config.dart';
import 'package:farmdirect/services/api_services.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final int cartItemId;
  final int productId;
  final String name;
  final double price;
  final String unit;
  final String image;
  final String farm;
  final String location;

  int quantity;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.name,
    required this.price,
    required this.unit,
    required this.image,
    required this.farm,
    required this.location,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;
}

class CartProvider extends ChangeNotifier {
  String _buildImageUrl(String imageUrl) {
    if (imageUrl.isEmpty) {
      return '';
    }

    // Already a complete URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }

    // Backend gives:
    // /uploads/products/image.jpg
    if (imageUrl.startsWith('/')) {
      return '${ApiConfig.baseUrl}$imageUrl';
    }

    return '${ApiConfig.baseUrl}/$imageUrl';
  }

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // ============================================================
  // LOAD CART FROM DATABASE
  // ============================================================
  Future<void> loadCart() async {
    try {
      final data = await ApiService.getMyCart();

      debugPrint('========== CART API ==========');
      debugPrint(data.toString());
      debugPrint('==============================');

      _items.clear();

      for (final item in data) {
        final rawImage = item['image_url'];

        debugPrint('PRODUCT: ${item['name']}');
        debugPrint('IMAGE FROM BACKEND: $rawImage');

        _items.add(
          CartItem(
            cartItemId: item['cart_item_id'] as int,
            productId: item['product_id'] as int,
            name: item['name']?.toString() ?? '',
            price: double.tryParse(item['price'].toString()) ?? 0.0,
            unit: item['unit']?.toString() ?? '',
            image: _buildImageUrl(item['image_url']?.toString() ?? ''),
            farm: item['farm']?.toString() ?? '',
            location: item['location']?.toString() ?? '',
            quantity: item['quantity'] as int,
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('LOAD CART ERROR: $e');
      rethrow;
    }
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  Future<void> addToCart({
    required int productId,
    required String name,
    required double price,
    required String unit,
    required String image,
    required String farm,
    required String location,
  }) async {
    try {
      await ApiService.addCartItem(productId: productId, quantity: 1);

      // Fetch latest cart from database
      await loadCart();
    } catch (e) {
      debugPrint('ADD TO CART ERROR: $e');
      rethrow;
    }
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  Future<void> increaseQuantity(int productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);

    if (index == -1) return;

    final item = _items[index];

    try {
      await ApiService.updateCartItem(
        cartItemId: item.cartItemId,
        quantity: item.quantity + 1,
      );

      await loadCart();
    } catch (e) {
      debugPrint('INCREASE CART ERROR: $e');
      rethrow;
    }
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  Future<void> decreaseQuantity(int productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);

    if (index == -1) return;

    final item = _items[index];

    try {
      if (item.quantity > 1) {
        await ApiService.updateCartItem(
          cartItemId: item.cartItemId,
          quantity: item.quantity - 1,
        );
      } else {
        await ApiService.removeCartItem(cartItemId: item.cartItemId);
      }

      await loadCart();
    } catch (e) {
      debugPrint('DECREASE CART ERROR: $e');
      rethrow;
    }
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  Future<void> removeFromCart(int productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);

    if (index == -1) return;

    final item = _items[index];

    try {
      await ApiService.removeCartItem(cartItemId: item.cartItemId);

      await loadCart();
    } catch (e) {
      debugPrint('REMOVE CART ERROR: $e');
      rethrow;
    }
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  Future<void> clearCart() async {
    try {
      await ApiService.clearCart();

      _items.clear();

      notifyListeners();
    } catch (e) {
      debugPrint('CLEAR CART ERROR: $e');
      rethrow;
    }
  }

  // ============================================================
  // CHECK PRODUCT
  // ============================================================

  bool containsProduct(int productId) {
    return _items.any((item) => item.productId == productId);
  }
}
