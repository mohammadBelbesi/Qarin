import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import 'product_image_widget.dart';
import 'product_details_widget.dart';
import 'product_order_button.dart';

class ProductPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final String languageKey = Localizations.localeOf(context).languageCode;

    // Safely access the product data
    final name = (product['name'] is Map)
        ? (product['name'][languageKey] ??
            product['name']['en'] ??
            'Unknown Product')
        : (product['name'] ?? 'Unknown Product').toString();

    final description = (product['description'] is Map)
        ? (product['description'][languageKey] ??
            product['description']['en'] ??
            'No description available')
        : (product['description'] ?? 'No description available').toString();

    final frontImage = product['frontImage']?.toString() ?? '';
    final backgroundImage = product['backgroundImage']?.toString() ?? '';
    final productId = product['id']?.toString() ?? 'Unknown Product ID';

    // Access the current user from UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    final userId =
        userProvider.userDetails?['_id']?.toString() ?? 'Unknown User ID';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: backgroundImage.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(backgroundImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProductImageWidget(imageUrl: frontImage),
                    const SizedBox(height: 24),
                    ProductDetailsWidget(
                      name: name,
                      description: description,
                      color: product['color']?.toString() ?? 'Not specified',
                      material:
                          product['material']?.toString() ?? 'Not specified',
                      weight: product['weight']?.toString() ?? 'Not specified',
                    ),
                    const SizedBox(height: 24),
                    ProductOrderButton(
                      isLoggedIn: userProvider.isLoggedIn,
                      productName: name,
                      userId: userId,
                      productId: productId,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
