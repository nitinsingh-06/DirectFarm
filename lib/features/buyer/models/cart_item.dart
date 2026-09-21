class CartItem {
  final int productId;
  final int farmerId;
  final String name;
  final String farmer;
  final String unit;
  final double price;
  final double? oldPrice;
  final String image;
  final int quantity;

  CartItem({
    required this.productId,
    required this.farmerId,
    required this.name,
    required this.farmer,
    required this.unit,
    required this.price,
    this.oldPrice,
    required this.image,
    this.quantity = 1,
  });

  CartItem copyWith({
    int? quantity,
  }) {
    return CartItem(
      productId: productId,
      farmerId: farmerId,
      name: name,
      farmer: farmer,
      unit: unit,
      price: price,
      oldPrice: oldPrice,
      image: image,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => price * quantity;
}