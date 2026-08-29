import 'package:farmdirect/features/farmer/add_product.dart';
import 'package:flutter/material.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  int selectedCategory = 0;
  int selectedBottomIndex = 1;

  final List<String> categories = [
    "All",
    "Grains",
    "Vegetables",
    "Fruits",
  ];

  final List<Product> products = [
    Product(
      name: "Organic Basmati Rice",
      price: "₹85 / kg",
      category: "Grains",
      stock: "In Stock",
      stockType: StockType.inStock,
      image:
          "https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=500&q=80",
    ),
    Product(
      name: "Red Potatoes",
      price: "₹20 / kg",
      category: "Vegetables",
      stock: "Low Stock",
      stockType: StockType.lowStock,
      image:
          "https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=500&q=80",
    ),
    Product(
      name: "Pure Cow Ghee",
      price: "₹650 / kg",
      category: "Other",
      stock: "Out of Stock",
      stockType: StockType.outOfStock,
      image:
          "https://images.unsplash.com/photo-1628088062854-d1870b4553da?auto=format&fit=crop&w=500&q=80",
    ),
  ];

  List<Product> get filteredProducts {
    if (selectedCategory == 0) {
      return products;
    }

    final selected = categories[selectedCategory];

    return products
        .where((product) => product.category == selected)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAF9),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Products",
          style: TextStyle(
            color: Color(0xFF075E4D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _SearchBar(),
            ),

            const SizedBox(height: 8),

            // Categories
            SizedBox(
              height: 34,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF075E4D)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF075E4D)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF374151),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Product Grid
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int columns = constraints.maxWidth > 700 ? 4 : 2;

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 90),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: filteredProducts.length + 1,
                    itemBuilder: (context, index) {
                      if (index == filteredProducts.length) {
                        return const AddProductCard();
                      }

                      return ProductCard(
                        product: filteredProducts[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add product action
        },
        backgroundColor: const Color(0xFF84D719),
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: Color(0xFF174B18),
          size: 28,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,

      // Bottom Navigation
      bottomNavigationBar: _BottomNavigation(
        selectedIndex: selectedBottomIndex,
        onChanged: (index) {
          setState(() {
            selectedBottomIndex = index;
          });
        },
      ),
    );
  }
}

// ------------------------------------------------------------
// SEARCH BAR
// ------------------------------------------------------------

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: const TextField(
        style: TextStyle(
          fontSize: 11,
          color: Color(0xFF374151),
        ),
        decoration: InputDecoration(
          hintText: "Search crop, grains, etc...",
          hintStyle: TextStyle(
            fontSize: 10,
            color: Color(0xFF9CA3AF),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 18,
            color: Color(0xFF6B7280),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 9,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// PRODUCT MODEL
// ------------------------------------------------------------

enum StockType {
  inStock,
  lowStock,
  outOfStock,
}

class Product {
  final String name;
  final String price;
  final String category;
  final String stock;
  final StockType stockType;
  final String image;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    required this.stockType,
    required this.image,
  });
}

// ------------------------------------------------------------
// PRODUCT CARD
// ------------------------------------------------------------

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  Color get stockBackground {
    switch (product.stockType) {
      case StockType.inStock:
        return const Color(0xFFE5F7EE);

      case StockType.lowStock:
        return const Color(0xFFFFF3D6);

      case StockType.outOfStock:
        return const Color(0xFFFFE6E8);
    }
  }

  Color get stockTextColor {
    switch (product.stockType) {
      case StockType.inStock:
        return const Color(0xFF17804F);

      case StockType.lowStock:
        return const Color(0xFFD18B00);

      case StockType.outOfStock:
        return const Color(0xFFE5484D);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                product.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: const Color(0xFFE5E7EB),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Product Information
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                7,
                6,
                6,
                5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF08734F),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: stockBackground,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          product.stock,
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                            color: stockTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// ADD PRODUCT CARD
// ------------------------------------------------------------

class AddProductCard extends StatelessWidget {
  const AddProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // Navigate to Add Product screen
        Navigator.push(context,MaterialPageRoute(builder: (context)=>AddProductScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFBFCFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFD9DEE2),
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 25,
              color: Color(0xFF6B7280),
            ),
            SizedBox(height: 5),
            Text(
              "Add New Product",  
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// BOTTOM NAVIGATION
// ------------------------------------------------------------

class _BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _BottomNavigation({
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<_NavItem> items = const [
    _NavItem(Icons.home_outlined, "Home"),
    _NavItem(Icons.eco_outlined, "Products"),
    _NavItem(Icons.inventory_2_outlined, "Orders"),
    _NavItem(Icons.currency_rupee, "Earnings"),
    _NavItem(Icons.person_outline, "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
          (index) {
            final selected = selectedIndex == index;

            return Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[index].icon,
                      size: 19,
                      color: selected
                          ? const Color(0xFF08734F)
                          : const Color(0xFF6B7280),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      items[index].label,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? const Color(0xFF08734F)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);
}