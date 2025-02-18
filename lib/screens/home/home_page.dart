import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_bar.dart' as custom;
import '../../widgets/navbar.dart';
import '../../providers/category_provider.dart';
import 'search_result_list.dart';
import 'category_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;
    final isLoading = categoryProvider.isLoading;
    final String languageKey = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: const Navbar(title: 'Prices'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            custom.SearchBar(
              onSearchResults: (results) {
                setState(() {
                  searchResults = results;
                  isSearching = true;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isSearching
                  ? SearchResultList(
                searchResults: searchResults,
                languageKey: languageKey,
              )
                  : isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CategoryGrid(
                categories: categories,
                languageKey: languageKey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
