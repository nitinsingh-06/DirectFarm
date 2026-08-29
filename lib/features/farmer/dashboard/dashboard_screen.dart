import 'package:farmdirect/features/farmer/add_product.dart';
import 'package:farmdirect/utils/colors.dart';
import 'package:flutter/material.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int selectedIndex = 0;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsGrid(),

                    const SizedBox(height: 10),

                    _buildActionButtons(),

                    const SizedBox(height: 14),

                    _buildRecentOrders(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(14),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Namaste, Ramesh! 🌾',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Farm ID: #86432',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.75),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/farmer_profile_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // STATISTICS
  // ------------------------------------------------------------

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 2.35,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _statCard(
          icon: Icons.eco_outlined,
          iconColor: const Color(0xFF267D68),
          title: 'Total Products',
          value: '24',
        ),

        _statCard(
          icon: Icons.shopping_bag_outlined,
          iconColor: Colors.blue,
          title: 'Active Orders',
          value: '8',
        ),

        _statCard(
          icon: Icons.currency_rupee,
          iconColor: const Color(0xFF269B7D),
          title: 'Month Earnings',
          value: '₹45,200',
        ),

        _statCard(
          icon: Icons.star_border,
          iconColor: Colors.orange,
          title: 'Rating',
          value: '4.8★',
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE6EAE8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 16,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF737A77),
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: TextStyle(
                    color: primaryGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ACTION BUTTONS
  // ------------------------------------------------------------

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Add Product
              Navigator.push(context,MaterialPageRoute(builder: (context)=>AddProductScreen()));
            },
            icon: const Icon(
              Icons.add_circle_outline,
              size: 15,
            ),
            label: const Text(
              'Add Product',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(0, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // View Orders
            },
            icon: Icon(
              Icons.inventory_2_outlined,
              size: 15,
              color: primaryGreen,
            ),
            label: Text(
              'View Orders',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: primaryGreen,
              ),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 34),
              side: BorderSide(
                color: primaryGreen,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // RECENT ORDERS
  // ------------------------------------------------------------

  Widget _buildRecentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Orders',
          style: TextStyle(
            color: primaryGreen,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        _orderCard(
          buyer: 'Suresh Kumar (Bulk Buyer)',
          quantity: '200 kg • Basmati Rice',
          status: 'New',
          statusColor: const Color(0xFF20966E),
          statusBackground: const Color(0xFFE6F7EF),
        ),

        const SizedBox(height: 7),

        _orderCard(
          buyer: 'FreshMart Agra',
          quantity: '500 kg • Red Potatoes',
          status: 'Shipped',
          statusColor: const Color(0xFF367FEA),
          statusBackground: const Color(0xFFE6F0FF),
        ),

        const SizedBox(height: 7),

        _orderCard(
          buyer: 'Organic Hub Delhi',
          quantity: '50 kg • Fresh Tomatoes',
          status: 'Pending',
          statusColor: const Color(0xFFDB9B00),
          statusBackground: const Color(0xFFFFF2D1),
        ),
      ],
    );
  }

  Widget _orderCard({
    required String buyer,
    required String quantity,
    required String status,
    required Color statusColor,
    required Color statusBackground,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE6EAE8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buyer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF303633),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  quantity,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Color(0xFF858B88),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ------------------------------------------------------------

  Widget _buildBottomNavigation() {
    final items = [
      (Icons.home_outlined, 'Home'),
      (Icons.eco_outlined, 'Products'),
      (Icons.inventory_2_outlined, 'Orders'),
      (Icons.currency_rupee, 'Earnings'),
      (Icons.person_outline, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: List.generate(
              items.length,
              (index) {
                final selected = selectedIndex == index;

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[index].$1,
                          size: 18,
                          color: selected
                              ? primaryGreen
                              : Colors.grey.shade600,
                        ),

                        const SizedBox(height: 3),

                        Text(
                          items[index].$2,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: selected
                                ? primaryGreen
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}