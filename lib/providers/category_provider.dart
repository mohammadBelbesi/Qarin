import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import the JSON package for encoding/decoding

class CategoryProvider with ChangeNotifier {
  List<Map<String, dynamic>> _categories = []; // Use dynamic for nested structures
  bool _isLoading = true;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    const String url = 'http://localhost:3000/categories';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _categories = data.map((category) {
          return {
            'id': category['_id']?.toString() ?? '', // Extract and include the id
            'name': category['name'], // Keep the nested structure
            'picture': category['picture']?.toString() ?? '',
            'advertisementSentence': category['advertisementSentence'], // Add advertisement sentence
          };
        }).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
