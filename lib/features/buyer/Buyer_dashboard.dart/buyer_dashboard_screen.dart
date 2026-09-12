import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/home_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/market_place_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/marketplace/add_to_cart.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/order/order_screen.dart';
import 'package:farmdirect/features/buyer/Buyer_dashboard.dart/profile/buyer_profile_screen.dart';
import 'package:flutter/material.dart';

class BuyerDashboard extends StatefulWidget {
  const BuyerDashboard({super.key});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentScreen(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: const Color(0xFF075B4A),
        unselectedItemColor: const Color(0xFF8B949E),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: "Market",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();

      case 1:
        return const MarketplaceScreen();
      

      case 2:
        return const CartScreen();
      

      case 3:
        return const OrderScreen();

      case 4:
        return const BuyerProfileScreen();

      default:
        return const HomeScreen();
    }
  }
}