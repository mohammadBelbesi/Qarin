import 'package:flutter/material.dart';
import 'make_order_form.dart';

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const RequestCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productName = order['product']['name']['en'] ?? 'Unnamed Product';
    final productPicture = (order['product']['images'] as List).isNotEmpty
        ? order['product']['images'][0]
        : 'https://via.placeholder.com/60';
    final categoryName = order['category']['name']['en'] ?? 'Unnamed Category';
    final quantity = order['quantity'] ?? 1;
    final description = order['description'] ?? 'No description available';
    final offers = order['offers'] ?? [];
    final int offerCount = offers.length;

    return Stack(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('Category: $categoryName\nQuantity: $quantity'),
              children: offers.isNotEmpty
                  ? offers.map<Widget>((offer) {
                      final wholesalePrice = offer['wholeSalePrice'];
                      final retailPrice =
                          offer['retailPrice']['\$numberDecimal'] ?? 'N/A';
                      final comment = offer['comment'] ?? 'No comments';

                      return ListTile(
                        title: Text(
                          'Wholesale Price: $wholesalePrice',
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          'Retail Price: $retailPrice\nComment: $comment',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  MakeOrderForm(order: order, offer: offer),
                            );
                          },
                          child: const Text('Make Order',
                              style: TextStyle(color: Colors.white)),
                        ),
                      );
                    }).toList()
                  : [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'No offers available for this request.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
            ),
          ),
        ),
        Positioned(
          top: 15,
          right: 25,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: offerCount > 0
                  ? Colors.green.shade600
                  : Colors.orange.shade600,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  offerCount > 0 ? Icons.local_offer : Icons.hourglass_empty,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  offerCount > 0 ? '$offerCount Offers' : 'Pending',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
