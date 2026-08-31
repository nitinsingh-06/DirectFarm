import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/cheakout/cheakout_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  // ============================================================
  // CART PRODUCTS
  // Later these can come from Provider / Backend
  // ============================================================

  final List<Map<String, dynamic>> _cartItems = [
    {
      'name': 'Organic Alphonso Mango',
      'farmer': 'Ratnagiri Farms',
      'unit': 'Dozen',
      'price': 790,
      'oldPrice': 1000,
      'quantity': 2,
      'image':
          'https://images.unsplash.com/photo-1553279768-865429fa0078?w=300',
    },
    {
      'name': 'Fresh Cauliflower',
      'farmer': 'Ramgarh Farms',
      'unit': 'Piece',
      'price': 105,
      'oldPrice': null,
      'quantity': 3,
      'image':
          'https://images.unsplash.com/photo-1568584711075-3d021a7c3ca3?w=300',
    },
  ];

  // Promo discount
  int promoDiscount = 200;

  // ============================================================
  // CALCULATE SUBTOTAL
  // ============================================================

  int get basketSubtotal {
    int total = 0;

    for (final item in _cartItems) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }

    return total;
  }

  // ============================================================
  // GRAND TOTAL
  // ============================================================

  int get grandTotal {
    return basketSubtotal - promoDiscount;
  }

  // ============================================================
  // INCREASE QUANTITY
  // ============================================================

  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  // ============================================================
  // DECREASE QUANTITY
  // ============================================================

  void _decreaseQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      } else {
        _removeItem(index);
      }
    });
  }

  // ============================================================
  // REMOVE ITEM
  // ============================================================

  void _removeItem(int index) {
    final removedItem = _cartItems[index]['name'];

    setState(() {
      _cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$removedItem removed from cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // CLEAR ALL
  // ============================================================

  void _clearCart() {
    if (_cartItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Cart?'),
          content: const Text(
            'Are you sure you want to remove all items from your cart?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cartItems.clear();
                });

                Navigator.pop(context);
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
  // REMOVE PROMO
  // ============================================================

  void _removePromo() {
    setState(() {
      promoDiscount = 0;
    });
  }

  // ============================================================
  // CHECKOUT
  // ============================================================
void _proceedToCheckout() {
  if (_cartItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your cart is empty'),
      ),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CheckoutScreen(
        totalAmount: grandTotal,
      ),
    ),
  );
}
  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Cart (${_cartItems.length} items)',
              style: const TextStyle(
                color: Color(0xFF145C4A),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 2),

          
          ],
        ),

        actions: [
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

      // ========================================================
      // BODY
      // ========================================================

      body: _cartItems.isEmpty
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
                        // Product list
                        _buildCartItems(),

                        const SizedBox(height: 12),

                        // Promo
                        _buildPromoSection(),

                        const SizedBox(height: 12),

                        // Bill details
                        _buildBillDetails(),

                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),

                // Checkout button
                _buildCheckoutButton(),
              ],
            ),
    );
  }

  // ============================================================
  // CART ITEMS
  // ============================================================

  Widget _buildCartItems() {
    return Column(
      children: List.generate(
        _cartItems.length,
        (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildCartItem(
              item: _cartItems[index],
              index: index,
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
    required Map<String, dynamic> item,
    required int index,
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
            child: Image.network(
              item['image'],
              width: 58,
              height: 58,
              fit: BoxFit.cover,

              // If internet image fails
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 58,
                  height: 58,
                  color: const Color(0xFFF0F0F0),
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                );
              },
            ),
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
                  item['name'],
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
                  '${item['farmer']} • ${item['unit']}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      '₹${item['price']}',
                      style: const TextStyle(
                        color: Color(0xFF176B53),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),

                    if (item['oldPrice'] != null) ...[
                      const SizedBox(width: 5),
                      Text(
                        '₹${item['oldPrice']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 9,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // ======================================================
          // QUANTITY CONTROLLER
          // ======================================================

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
                // Minus
                InkWell(
                  onTap: () => _decreaseQuantity(index),
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

                // Quantity
                Text(
                  '${item['quantity']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Plus
                InkWell(
                  onTap: () => _increaseQuantity(index),
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
        ],
      ),
    );
  }

  // ============================================================
  // PROMO SECTION
  // ============================================================

  Widget _buildPromoSection() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
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
            ),
        ],
      ),
    );
  }

  // ============================================================
  // BILL DETAILS
  // ============================================================

  Widget _buildBillDetails() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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

          // Basket subtotal
          _billRow(
            'Basket Subtotal',
            '₹${_formatPrice(basketSubtotal)}',
          ),

          const SizedBox(height: 9),

          // Delivery
          _billRow(
            'Delivery Partner Fee',
            'FREE',
            valueColor: const Color(0xFF31A66B),
          ),

          const SizedBox(height: 9),

          // Promo
          _billRow(
            'Promo Discount',
            promoDiscount > 0
                ? '-₹${_formatPrice(promoDiscount)}'
                : '₹0',
            valueColor: promoDiscount > 0
                ? Colors.redAccent
                : Colors.grey,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 11),
            child: Divider(
              height: 1,
              color: Color(0xFFE7E7E7),
            ),
          ),

          // Grand total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                '₹${_formatPrice(grandTotal)}',
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
    Color valueColor = const Color(0xFF444444),
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildCheckoutButton() {
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
            onPressed: _proceedToCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF82D20B),
              foregroundColor: const Color(0xFF145C4A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: Text(
              'Proceed to Checkout • ₹${_formatPrice(grandTotal)}',
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF7DD),
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

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match.group(1)},',
        );
  }
}