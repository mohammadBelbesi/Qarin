import 'package:flutter/material.dart';
import '../category/category_page.dart';
import 'category_card.dart';

class CategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String languageKey;

  const CategoryGrid({
    required this.categories,
    required this.languageKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(child: Text('No categories available'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        const double spacing = 16;
        const double minCardWidth = 180; // Minimum card width for responsiveness
        final int crossAxisCount =
        (availableWidth / (minCardWidth + spacing)).floor().clamp(1, 4);
        final double cardWidth =
            (availableWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
        final double cardHeight = cardWidth * 1.2; // Adjusted height for smaller screens

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: cardWidth / cardHeight,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final categoryName = category['name']?[languageKey] ?? 'Unknown';
            final categoryId = category['id'] ?? ''; // Retrieve categoryId

            return CategoryCard(
              name: categoryName,
              advertisementSentence:
              category['advertisementSentence']?[languageKey] ?? '',
              picture: category['picture'] ?? '',
              onTap: () {
                // Navigate to CategoryPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      categoryName: categoryName,
                      categoryId: categoryId,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
