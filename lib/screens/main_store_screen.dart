import 'package:flutter/material.dart';
import 'package:karen/screens/request/requests_page.dart';
import 'package:karen/screens/order/store_orders_page.dart';
import 'package:karen/screens/profile/profile_page.dart';

class MainStoreScreen extends StatefulWidget {
  const MainStoreScreen({super.key});

  @override
  _MainStoreScreenState createState() => _MainStoreScreenState();
}

class _MainStoreScreenState extends State<MainStoreScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const RequestsPage(), // Home Page (Requests)
    const OrdersPage(), // Orders Page
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
