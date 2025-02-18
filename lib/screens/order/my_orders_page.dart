import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/order_service.dart'; // Update with actual path
import '../../../providers/user_provider.dart'; // Update with actual path

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userDetails?["_id"];

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Orders")),
        body: const Center(
          child: Text(
            "User not logged in.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: OrderService().getOrdersByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No orders found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              // Extract totalPrice correctly
              final totalPrice = order['totalPrice'] is Map &&
                      order['totalPrice'].containsKey(r'$numberDecimal')
                  ? order['totalPrice'][r'$numberDecimal']
                  : order['totalPrice'].toString();

              // Extract status and get corresponding icon and color
              final String status = order['status'] ?? "Pending";
              final IconData statusIcon;
              final Color statusColor;

              switch (status) {
                case "Processing":
                  statusIcon = Icons.hourglass_bottom;
                  statusColor = Colors.orange;
                  break;
                case "Completed":
                  statusIcon = Icons.check_circle;
                  statusColor = Colors.green;
                  break;
                case "Cancelled":
                  statusIcon = Icons.cancel;
                  statusColor = Colors.red;
                  break;
                default:
                  statusIcon = Icons.pending_actions;
                  statusColor = Colors.blueGrey;
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    "Order ID: ${order['_id']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantity: ${order['quantity']}"),
                      Text("Payment Method: ${order['paymentMethod']}"),
                      Text("Delivery: ${order['deliveryMethod']}"),
                      Text(
                          "Expected Delivery: ${order['expectedDeliveryDate'] ?? 'Not Set'}"),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${totalPrice}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            status,
                            style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
