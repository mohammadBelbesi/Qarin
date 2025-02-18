import 'package:flutter/material.dart';
import '../product/product_page.dart';
import '../../services/products.dart';

class CategoryPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryPage({
    required this.categoryId,
    required this.categoryName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String languageKey = Localizations.localeOf(context).languageCode;
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ProductsService.fetchProductsByCategory(categoryId),
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
                'No products found in this category.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  isLargeScreen ? 4 : 2, // More columns for larger screens
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio:
                  isLargeScreen ? 1 : 0.8, // Balanced aspect ratio
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final name = product['name'] is Map
                  ? product['name'][languageKey] ??
                      product['name']['en'] ??
                      'Unnamed Product'
                  : product['name'] ?? 'Unnamed Product';
              final description = product['description'] is Map
                  ? product['description'][languageKey] ??
                      product['description']['en'] ??
                      'No description available'
                  : product['description'] ?? 'No description available';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(product: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: product['frontImage'] != null &&
                                product['frontImage'].isNotEmpty
                            ? Image.network(
                                product['frontImage'],
                                height: isLargeScreen
                                    ? 140
                                    : 120, // Optimized image height
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: isLargeScreen ? 140 : 120,
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isLargeScreen
                                    ? 16
                                    : 14, // Adjust font size for large screens
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isLargeScreen ? 14 : 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
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
