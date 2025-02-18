import 'package:flutter/material.dart';
import '../../services/products.dart'; // Import the service file

class ProductOrderButton extends StatelessWidget {
  final bool isLoggedIn;
  final String productName;
  final String userId;
  final String productId;

  const ProductOrderButton({
    super.key,
    required this.isLoggedIn,
    required this.productName,
    required this.userId,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isLoggedIn) {
          _showOrderDialog(context, productName, userId, productId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in to place an order.')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 12,
        shadowColor: Colors.orangeAccent.withOpacity(0.5),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      child: const Text('Order Now'),
    );
  }

  void _showOrderDialog(BuildContext context, String productName, String userId, String productId) {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Confirm Order for $productName',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Add a Description (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.production_quantity_limits),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final description = descriptionController.text.trim();
                final quantityText = quantityController.text.trim();

                if (quantityText.isEmpty || int.tryParse(quantityText) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid quantity.')),
                  );
                  return;
                }

                final int quantity = int.parse(quantityText);

                try {
                  bool success = await ProductsService.orderProduct(
                    userId: userId,
                    productId: productId,
                    quantity: quantity,
                    description: description.isNotEmpty ? description : null,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order placed successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to place the order.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Confirm Order'),
            ),
          ],
        );
      },
    );
  }
}
