import 'package:flutter/material.dart';
import 'package:karen/screens/request/my_requests_page.dart'; // Import Requests Page
import 'package:karen/screens/order/my_orders_page.dart'; // Import Orders Page

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Requests and Orders
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: "Requests"),
              Tab(icon: Icon(Icons.shopping_bag), text: "Orders"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MyRequestsPage(), // Tab 1: Requests
            MyOrdersPage(), // Tab 2: Orders
          ],
        ),
      ),
    );
  }
}
