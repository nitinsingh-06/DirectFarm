// ============================================================
// HOME SCREEN
// ============================================================

import 'package:farmdirect/core/provider/farmer_profile_provider.dart';
import 'package:farmdirect/core/widgets/farmer/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onAddProduct;

  const HomeScreen({super.key, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(13, 14, 13, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatistics(),

                  const SizedBox(height: 14),

                  _buildActionButtons(),

                  const SizedBox(height: 16),

                  _buildRecentOrders(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
// ============================================================
// HEADER
// ============================================================

Widget _buildHeader() {
  return Consumer<ProfileProvider>(
    builder: (context, profile, child) {
      return Container(
        width: double.infinity,
        height: 62,
        color: const Color(0xFF075640),
        padding: const EdgeInsets.symmetric(horizontal: 13),

        child: Row(
          children: [

            // ==================================================
            // NAME
            // ==================================================

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Namaste, ${profile.name}! 🌾',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  const Text(
                    'Farm ID: #88432',
                    style: TextStyle(
                      color: Color(0xFF9ACB51),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // PROFILE IMAGE
            // ==================================================

            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(2),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFB5D56A),
                  width: 2,
                ),
              ),

              child: const ProfileImage(
                size: 36,
              ),
            ),
          ],
        ),
      );
    },
  );
}

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.85,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _statCard(
          icon: Icons.eco_outlined,
          title: 'Total Products',
          value: '24',
          valueColor: const Color(0xFF075640),
        ),

        _statCard(
          icon: Icons.shopping_bag_outlined,
          title: 'Active Orders',
          value: '8',
          valueColor: const Color(0xFF3B82F6),
        ),

        _statCard(
          icon: Icons.currency_rupee,
          title: 'Month Earnings',
          value: '₹45,200',
          valueColor: const Color(0xFF0BA579),
        ),

        _statCard(
          icon: Icons.star_border,
          title: 'Rating',
          value: '4.8★',
          valueColor: const Color(0xFF374151),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E7EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF0B765B)),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget _buildActionButtons() {
    return Row(
      children: [
        // --------------------------------------------------------
        // ADD PRODUCT
        // --------------------------------------------------------
        Expanded(
          child: SizedBox(
            height: 29,
            child: ElevatedButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Icons.add_circle_outline, size: 14),
              label: const Text(
                'Add Product',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075640),
                foregroundColor: const Color(0xFFB8D94F),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // --------------------------------------------------------
        // VIEW ORDERS
        // --------------------------------------------------------
        Expanded(
          child: SizedBox(
            height: 29,
            child: OutlinedButton.icon(
              onPressed: () {
                // Handle View Orders from parent
              },
              icon: const Icon(Icons.inventory_2_outlined, size: 13),
              label: const Text(
                'View Orders',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF164F42),
                side: const BorderSide(color: Color(0xFF377C6D), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RECENT ORDERS
  // ============================================================

  Widget _buildRecentOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Orders',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF075640),
          ),
        ),

        const SizedBox(height: 8),

        _orderCard(
          buyer: 'Suresh Kumar (Bulk Buyer)',
          details: '200 kg • Basmati Rice',
          status: 'New',
          statusColor: const Color(0xFFDCF7E9),
          statusTextColor: const Color(0xFF168653),
        ),

        const SizedBox(height: 7),

        _orderCard(
          buyer: 'FreshMart Agra',
          details: '500 kg • Red Potatoes',
          status: 'Shipped',
          statusColor: const Color(0xFFDCEAFF),
          statusTextColor: const Color(0xFF3B82F6),
        ),

        const SizedBox(height: 7),

        _orderCard(
          buyer: 'Organic Hub Delhi',
          details: '50 kg • Fresh Tomatoes',
          status: 'Pending',
          statusColor: const Color(0xFFFFEBC0),
          statusTextColor: const Color(0xFFE59B00),
        ),
      ],
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================

  Widget _orderCard({
    required String buyer,
    required String details,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFE3E7EA)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buyer,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  details,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF7A8491)),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
