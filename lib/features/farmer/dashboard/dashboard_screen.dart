
import 'package:farmdirect/features/farmer/dashboard/FARMER%20ORDER/farmer_order_management_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/farmer_earning_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/farmer_home_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/farmer_profile_screen.dart';
import 'package:farmdirect/features/farmer/dashboard/product_screen.dart';
import 'package:flutter/material.dart';


class FarmerDashboard extends StatefulWidget {
  const FarmerDashboard({super.key});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _currentIndex = 0;

  // ============================================================
  // CHANGE TAB
  // ============================================================

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // ============================================================
  // SCREENS
  // ============================================================

  List<Widget> get _screens {
    return [
      HomeScreen(
        onAddProduct: () {
          _changeTab(1);
        },
      ),

      const ProductScreen(),

      const FarmerOrderManagementScreen(),

      const EarningsScreen(),

    ProfileScreen(
  onBottomNavTap: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

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

        onTap: _changeTab,

        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,

        selectedItemColor: const Color(0xFF075640),

        unselectedItemColor: const Color(0xFF8A939D),

        selectedFontSize: 10,

        unselectedFontSize: 9,

        elevation: 0,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.eco_outlined),
            activeIcon: Icon(Icons.eco),
            label: 'Products',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Orders',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee),
            label: 'Earnings',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
