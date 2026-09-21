import 'package:farmdirect/core/provider/card_provider.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/cheakout/cheakout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // ============================================================
  // PROMO
  // ============================================================

  int promoDiscount = 0;

  // ============================================================
  // PROMO APPLY
  // ============================================================

  void _applyPromo() {
    final cart = context.read<CartProvider>();

    if (cart.totalAmount < 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Minimum cart value of ₹500 required',
          ),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      promoDiscount = 200;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('MANGO20 applied successfully'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // REMOVE PROMO
  // ============================================================

  void _removePromo() {
    setState(() {
      promoDiscount = 0;
    });
  }

  // ============================================================
  // GRAND TOTAL
  // ============================================================

  double _grandTotal(CartProvider cart) {
    final total = cart.totalAmount - promoDiscount;

    return total < 0 ? 0 : total;
  }

  // ============================================================
  // CLEAR ALL
  // ============================================================

  void _clearCart() {
    final cart = context.read<CartProvider>();

    if (cart.items.isEmpty) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Cart?'),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                cart.clearCart();

                setState(() {
                  promoDiscount = 0;
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cart cleared'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  void _removeItem(int productId, String productName) {
    final cart = context.read<CartProvider>();

    cart.removeFromCart(productId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName removed from cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ============================================================
  // CHECKOUT
  // ============================================================

  void _proceedToCheckout(CartProvider cart) {
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
        ),
      );
      return;
    }

    final total = _grandTotal(cart);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          totalAmount: total.toInt(),
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final grandTotal = _grandTotal(cart);

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8F8),

          // ======================================================
          // APP BAR
          // ======================================================

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              'My Cart (${cart.itemCount} items)',
              style: const TextStyle(
                color: Color(0xFF145C4A),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (cart.items.isNotEmpty)
                TextButton(
                  onPressed: _clearCart,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          // ======================================================
          // BODY
          // ======================================================

          body: cart.items.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 8,
                          bottom: 15,
                        ),
                        child: Column(
                          children: [
                            // Cart products
                            _buildCartItems(cart),

                            const SizedBox(height: 12),

                            // Promo
                            _buildPromoSection(),

                            const SizedBox(height: 12),

                            // Bill
                            _buildBillDetails(
                              cart,
                              grandTotal,
                            ),

                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),

                    // Checkout
                    _buildCheckoutButton(
                      cart,
                      grandTotal,
                    ),
                  ],
                ),
        );
      },
    );
  }

  // ============================================================
  // CART ITEMS
  // ============================================================

  Widget _buildCartItems(CartProvider cart) {
    return Column(
      children: List.generate(
        cart.items.length,
        (index) {
          final item = cart.items[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildCartItem(
              cart: cart,
              item: item,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // SINGLE CART ITEM
  // ============================================================

  Widget _buildCartItem({
    required CartProvider cart,
    required CartItem item,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE9EDED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ======================================================
          // PRODUCT IMAGE
          // ======================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: item.image.isNotEmpty
                ? Image.network(
                    item.image,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return _imageFallback();
                    },
                  )
                : _imageFallback(),
          ),

          const SizedBox(width: 10),

          // ======================================================
          // PRODUCT INFORMATION
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${item.farm} • ${item.unit}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  item.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      '₹${_formatDouble(item.price)}',
                      style: const TextStyle(
                        color: Color(0xFF176B53),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      'per ${item.unit}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(
                  'Total: ₹${_formatDouble(item.totalPrice)}',
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          // ======================================================
          // QUANTITY + DELETE
          // ======================================================

          Column(
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: const Color(0xFFE6E6E6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // MINUS
                    InkWell(
                      onTap: () {
                        cart.decreaseQuantity(
                          item.productId,
                        );
                      },
                      child: const SizedBox(
                        width: 27,
                        child: Center(
                          child: Text(
                            '−',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // QUANTITY
                    Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // PLUS
                    InkWell(
                      onTap: () {
                        cart.increaseQuantity(
                          item.productId,
                        );
                      },
                      child: const SizedBox(
                        width: 27,
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 2),

              // DELETE
              InkWell(
                onTap: () {
                  _removeItem(
                    item.productId,
                    item.name,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(
                    Icons.delete_outline,
                    size: 17,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // IMAGE FALLBACK
  // ============================================================

  Widget _imageFallback() {
    return Container(
      width: 58,
      height: 58,
      color: const Color(0xFFF0F0F0),
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 22,
      ),
    );
  }

  // ============================================================
  // PROMO SECTION
  // ============================================================

  Widget _buildPromoSection() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE5E8E8),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 17,
            color: Color(0xFF176B53),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              promoDiscount > 0
                  ? 'MANGO20 applied'
                  : 'Apply promo code',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555),
              ),
            ),
          ),

          if (promoDiscount > 0)
            TextButton(
              onPressed: _removePromo,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text(
                'Remove',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            TextButton(
              onPressed: _applyPromo,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
              ),
              child: const Text(
                'Apply',
                style: TextStyle(
                  color: Color(0xFF176B53),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // BILL DETAILS
  // ============================================================

  Widget _buildBillDetails(
    CartProvider cart,
    double grandTotal,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        14,
        13,
        14,
        13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE6E9E9),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Details',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF444444),
            ),
          ),

          const SizedBox(height: 12),

          // SUBTOTAL
          _billRow(
            'Basket Subtotal',
            '₹${_formatDouble(cart.totalAmount)}',
          ),

          const SizedBox(height: 9),

          // DELIVERY
          _billRow(
            'Delivery Partner Fee',
            'FREE',
            valueColor: const Color(0xFF31A66B),
          ),

          const SizedBox(height: 9),

          // PROMO
          _billRow(
            'Promo Discount',
            promoDiscount > 0
                ? '-₹${_formatDouble(promoDiscount.toDouble())}'
                : '₹0',
            valueColor: promoDiscount > 0
                ? Colors.redAccent
                : Colors.grey,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 11,
            ),
            child: Divider(
              height: 1,
              color: Color(0xFFE7E7E7),
            ),
          ),

          // GRAND TOTAL
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Grand Total',
                style: TextStyle(
                  color: Color(0xFF176B53),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                '₹${_formatDouble(grandTotal)}',
                style: const TextStyle(
                  color: Color(0xFF176B53),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BILL ROW
  // ============================================================

  Widget _billRow(
    String title,
    String value, {
    Color valueColor =
        const Color(0xFF444444),
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CHECKOUT BUTTON
  // ============================================================

  Widget _buildCheckoutButton(
    CartProvider cart,
    double grandTotal,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        8,
        8,
        8,
        10,
      ),
      color: const Color(0xFFF7F8F8),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              _proceedToCheckout(cart);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF82D20B),
              foregroundColor:
                  const Color(0xFF145C4A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(9),
              ),
            ),
            child: Text(
              'Proceed to Checkout • ₹${_formatDouble(grandTotal)}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY CART
  // ============================================================

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7DD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 42,
              color: Color(0xFF176B53),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Add fresh products from the marketplace',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRICE FORMAT
  // ============================================================

  String _formatDouble(double price) {
    if (price == price.roundToDouble()) {
      return price.toInt().toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
            (match) => '${match.group(1)},',
          );
    }

    return price.toStringAsFixed(2);
  }
}