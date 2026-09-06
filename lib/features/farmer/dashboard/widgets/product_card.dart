
import 'package:flutter/material.dart';
import 'package:farmdirect/features/farmer/dashboard/models/product_model.dart';
import 'package:farmdirect/features/farmer/dashboard/product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final bool outOfStock = product.stock <= 0;

    return Container(
      height: 145,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE1E6E9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(9),
              ),
              child: _buildImage(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(7, 5, 5, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  children: [
                    Text(
                      '₹${product.price} / ${product.unit}',
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),

                    const Spacer(),

                    if (outOfStock)
                      _badge('Out of Stock', AppColors.red)
                    else if (product.organic)
                      _badge('Organic', AppColors.primary)
                    else
                      _badge('In Stock', AppColors.green),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 6.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (product.images.isNotEmpty) {
      return Image.file(
        product.images.first,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Container(
      width: double.infinity,
      color: const Color(0xFFF0F2F1),
      child: const Icon(
        Icons.image_outlined,
        color: Color(0xFF98A29F),
      ),
    );
  }
}