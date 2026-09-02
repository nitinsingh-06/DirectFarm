
import 'package:farmdirect/features/farmer/dashboard/product_screen.dart';
import 'package:flutter/material.dart';
class MyProductsScreen extends StatefulWidget {
  final List<Product> products;
  final VoidCallback onAddProduct;

  const MyProductsScreen({
    super.key,
    required this.products,
    required this.onAddProduct,
  });

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}
class _MyProductsScreenState extends State<MyProductsScreen> {
  int selectedCategory = 0;

  final categories = [
    'All',
    'Grains',
    'Vegetables',
    'Fruits',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 25),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 10),
                _buildCategoryChips(),
                const SizedBox(height: 10),
                _buildProductsGrid(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 53,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: const Text(
        'My Products',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 39,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const TextField(
        style: TextStyle(
          fontSize: 11,
        ),
        decoration: InputDecoration(
          hintText: 'Search crop, grains, etc...',
          hintStyle: TextStyle(
            fontSize: 10,
            color: Color(0xFF8B969D),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 17,
            color: Color(0xFF87939B),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 29,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final selected = selectedCategory == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : const Color(0xFFDDE3E7),
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : const Color(0xFF59656C),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid() {
    final defaultProducts = [
     
      
      ProductCardData(
        name: 'Pure Cow Ghee',
        price: '₹650 / kg',
        image: 'assets/images/ghee.png',
        badge: 'Out of Stock',
        badgeColor: AppColors.red,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = <Widget>[];

        for (final product in defaultProducts) {
          cards.add(
            ProductCard(
              data: product,
            ),
          );
        }

        for (final product in widget.products) {
          cards.add(
            ProductCard(
              data: ProductCardData(
                name: product.name,
                price: '₹${product.price} / ${product.unit}',
                fileImage: product.images.isNotEmpty
                    ? product.images.first
                    : null,
                badge: product.organic ? 'Organic' : 'In Stock',
              ),
            ),
          );
        }

        cards.add(
          GestureDetector(
            onTap: widget.onAddProduct,
            child: Container(
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFDDE3E7),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 23,
                    color: Color(0xFF697780),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Add New Product',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF697780),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth > 500 ? 3 : 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (_, index) => cards[index],
        );
      },
    );
  }
}