import 'package:farmdirect/features/farmer/dashboard/FARMER%20ORDER/farmer_order_management_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/farmer_earning_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/farmer_home_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/farmer_profile_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/farmer_ratings_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/product_screen.dart';
import 'package:flutter/material.dart';

class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  // ============================================================
  // CURRENT BOTTOM NAVIGATION TAB
  // ============================================================

  int _currentIndex = 0;

  // ============================================================
  // CHANGE TAB
  // ============================================================

  void _changeTab(int index) {
    if (!mounted) return;

    setState(() {
      _currentIndex = index;
    });
  }

  // ============================================================
  // BUILD SCREENS
  // ============================================================

  List<Widget> get _screens {
    return [
      // ==========================================================
      // 0. HOME
      // ==========================================================

      HomeScreen(
        onAddProduct: () {
          _changeTab(1);
        },

        // Total Products
        onManageProducts: () {
          _changeTab(1);
        },

        // Active Orders
        onViewOrders: () {
          _changeTab(2);
        },

        // Month Earnings
        onViewEarnings: () {
          _changeTab(3);
        },

        // Rating
        //
        // Rating is part of the Profile area in the current
        // 5-tab dashboard structure.
        onViewRatings: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RatingsScreen()));
        },

        // Profile
        onProfile: () {
          _changeTab(4);
        },

        // Recent Order
        //
        // For now this keeps the main bottom navigation visible
        // and opens the Orders tab.
        //
        // We can later pass order.orderItemId into the order
        // management screen to automatically open that exact
        // order.
        onViewOrder: (order) {
          _changeTab(2);
        },
      ),

      // ==========================================================
      // 1. PRODUCTS
      // ==========================================================

      const ProductScreen(),

      // ==========================================================
      // 2. ORDERS
      // ==========================================================

      const FarmerOrderManagementScreen(),

      // ==========================================================
      // 3. EARNINGS
      // ==========================================================

      const EarningsScreen(),

      // ==========================================================
      // 4. PROFILE
      // ==========================================================

      ProfileScreen(
        onBottomNavTap: (index) {
          _changeTab(index);
        },
      ),
    ];
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),

      // ==========================================================
      // BODY
      // ==========================================================

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // ==========================================================
      // BOTTOM NAVIGATION
      // ==========================================================

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE3E7EA),
            width: 1,
          ),
        ),
      ),

      child: BottomNavigationBar(
        currentIndex: _currentIndex,

        // IMPORTANT:
        // Never Navigator.push() here.
        // Just change the IndexedStack index.
        onTap: _changeTab,

        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,

        selectedItemColor: const Color(0xFF075640),

        unselectedItemColor: const Color(0xFF8A939D),

        selectedFontSize: 10,

        unselectedFontSize: 9,

        elevation: 0,

        items: const [
          // ======================================================
          // HOME
          // ======================================================

          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),

          // ======================================================
          // PRODUCTS
          // ======================================================

          BottomNavigationBarItem(
            icon: Icon(
              Icons.eco_outlined,
            ),
            activeIcon: Icon(
              Icons.eco,
            ),
            label: 'Products',
          ),

          // ======================================================
          // ORDERS
          // ======================================================

          BottomNavigationBarItem(
            icon: Icon(
              Icons.inventory_2_outlined,
            ),
            activeIcon: Icon(
              Icons.inventory_2,
            ),
            label: 'Orders',
          ),

          // ======================================================
          // EARNINGS
          // ======================================================

          BottomNavigationBarItem(
            icon: Icon(
              Icons.currency_rupee,
            ),
            activeIcon: Icon(
              Icons.currency_rupee,
            ),
            label: 'Earnings',
          ),

          // ======================================================
          // PROFILE
          // ======================================================

          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            activeIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}