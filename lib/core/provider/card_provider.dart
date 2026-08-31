import 'package:flutter/material.dart';

class CartItem {
  final String image;
  final String name;
  final String farm;
  final String unit;
  final int price;

  int quantity;

  CartItem({
    required this.image,
    required this.name,
    required this.farm,
    required this.unit,
    required this.price,
    this.quantity = 1,
  });

  int get total => price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount {
    int count = 0;

    for (final item in _items) {
      count += item.quantity;
    }

    return count;
  }

  int get subtotal {
    int total = 0;

    for (final item in _items) {
      total += item.total;
    }

    return total;
  }

  int get deliveryFee {
    if (_items.isEmpty) {
      return 0;
    }

    return 0; // FREE
  }

  int get promoDiscount {
    if (_items.isEmpty) {
      return 0;
    }

    return 200;
  }

  int get grandTotal {
    return subtotal + deliveryFee - promoDiscount;
  }

  // ============================================================
  // ADD TO CART
  // ============================================================

  void addToCart({
    required String image,
    required String name,
    required String farm,
    required String unit,
    required int price,
    int quantity = 1,
  }) {
    final index = _items.indexWhere(
      (item) => item.name == name,
    );

    if (index != -1) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          image: image,
          name: name,
          farm: farm,
          unit: unit,
          price: price,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  void increaseQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  // ============================================================
  // CLEAR CART
  // ============================================================

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}