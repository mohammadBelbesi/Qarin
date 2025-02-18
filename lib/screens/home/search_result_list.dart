import 'package:flutter/material.dart';
import '../product/product_page.dart';

class SearchResultList extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;
  final String languageKey;

  const SearchResultList({
    required this.searchResults,
    required this.languageKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        final name = result['name']?[languageKey] ?? result['name']?['en'] ?? 'Unknown Product';
        final frontImage = result['frontImage'] ?? '';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: frontImage.isNotEmpty
                  ? Image.network(
                frontImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(product: result),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
