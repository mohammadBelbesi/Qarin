import 'package:flutter/material.dart';
import '../../services/products.dart';

class SearchBar extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onSearchResults; // Updated type to match ProductsService

  const SearchBar({Key? key, required this.onSearchResults}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;

  Future<void> fetchSearchResults(String query, {String lang = 'en'}) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final searchResults = await ProductsService.fetchSearchResults(query, lang: lang);
      widget.onSearchResults(searchResults);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              fetchSearchResults(_searchController.text);
            },
            child: Icon(Icons.search, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search In-Store',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.camera_alt_outlined, color: Colors.grey.shade600),
        ],
      ),
    );
  }
}
