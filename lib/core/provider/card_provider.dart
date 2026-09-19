import 'package:flutter/foundation.dart';

class CartItem {
  final int productId;
  final String name;
  final double price;
  final String unit;
  final String image;
  final String farm;
  final String location;

  int quantity;

  CartItem({
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
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount {
    return _items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  double get totalAmount {
    return _items.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  void addToCart({
    required int productId,
    required String name,
    required double price,
    required String unit,
    required String image,
    required String farm,
    required String location,
  }) {
    final index = _items.indexWhere(
      (item) => item.productId == productId,
    );

    if (index != -1) {
      // Product already exists
      _items[index].quantity++;
    } else {
      // New product
      _items.add(
        CartItem(
          productId: productId,
          name: name,
          price: price,
          unit: unit,
          image: image,
          farm: farm,
          location: location,
        ),
      );
    }

    notifyListeners();
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  void increaseQuantity(int productId) {
    final index = _items.indexWhere(
      (item) => item.productId == productId,
    );

    if (index == -1) return;

    _items[index].quantity++;

    notifyListeners();
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  void decreaseQuantity(int productId) {
    final index = _items.indexWhere(
      (item) => item.productId == productId,
    );

    if (index == -1) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  // ============================================================
  // REMOVE
  // ============================================================

  void removeFromCart(int productId) {
    _items.removeWhere(
      (item) => item.productId == productId,
    );

    notifyListeners();
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // ============================================================
  // CHECK PRODUCT
  // ============================================================

  bool containsProduct(int productId) {
    return _items.any(
      (item) => item.productId == productId,
    );
  }
}