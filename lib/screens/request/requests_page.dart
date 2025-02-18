import 'package:flutter/material.dart';
import '../../services/requests.dart';
import '../offers/create_offer_dialog.dart';

class RequestsPage extends StatefulWidget {
  final String? categoryId;

  const RequestsPage({super.key, this.categoryId});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<RequestsPage> {
  late Future<List<Map<String, dynamic>>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrdersService.fetchOrders(categoryId: widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _ordersFuture,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'No orders found.',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              // Extract the required fields
              final orderId =
                  order['_id'] is Map && order['_id']['\$oid'] is String
                      ? order['_id']['\$oid']
                      : order['_id'].toString();
              final product = order['product'];
              final productName = product != null && product['name'] != null
                  ? product['name']['en'] ?? 'Unnamed Product'
                  : 'Unnamed Product';
              final productPicture =
                  product != null && product['images'] != null
                      ? product['images'].first
                      : 'https://via.placeholder.com/60'; // Placeholder image
              final category = order['category'];
              final categoryName = category != null && category['name'] != null
                  ? category['name']['en'] ?? 'Unnamed Category'
                  : 'Unnamed Category';
              final user = order['user'];
              final userName = user != null
                  ? '${user['firstName']} ${user['lastName']}'
                  : 'Unknown User';
              final description = order['description'] ?? 'No description';
              final quantity = order['quantity'] ?? 1;
              final createdAt = order['createdAt'] is Map &&
                      order['createdAt']['\$date'] != null
                  ? DateTime.parse(order['createdAt']['\$date'])
                  : DateTime.now();

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productPicture,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  title: Text(
                    'Order #$orderId',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Product: $productName',
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(
                          'Category: $categoryName',
                          style: const TextStyle(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('Customer: $userName',
                            style: const TextStyle(fontSize: 14)),
                        Text('User Description: $description',
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        Text('Quantity: $quantity',
                            style: const TextStyle(fontSize: 14)),
                        Text('Date: ${_formatDate(createdAt)}',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreateOfferDialog(orderId: orderId),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
