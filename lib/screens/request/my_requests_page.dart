import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/requests.dart';
import '../../providers/user_provider.dart';
import 'widgets/request_client_card.dart'; // Import the separated widget

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userDetails?["_id"];

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
        ),
        body: const Center(
          child: Text('User not logged in.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Requests'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: OrdersService.fetchOrdersByUser(userId: userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No requests found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return RequestCard(order: orders[index]);
            },
          );
        },
      ),
    );
  }
}
