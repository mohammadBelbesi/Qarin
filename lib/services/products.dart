import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsService {
  static const String _baseUrl = 'http://localhost:3000/products';
  static const String _searchUrl = '$_baseUrl/search';
  static const String _orderUrl = 'http://localhost:3000/requests/';

  // Fetch search results
  static Future<List<Map<String, dynamic>>> fetchSearchResults(String query, {String lang = 'en'}) async {
    if (query.isEmpty) {
      throw Exception('Query cannot be empty');
    }

    try {
      final response = await http.get(Uri.parse('$_searchUrl?query=$query&lang=$lang'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) {
          // Safely handle `_id` field
          final id = item['_id'];
          final String parsedId = (id is Map && id.containsKey('\$oid'))
              ? id['\$oid']
              : id.toString();

          return {
            'id': parsedId, // Use the parsed ID
            'productId': item['productId'] ?? '',
            'name': item['name'] ?? '',
            'description': item['description']?[lang]?.toString() ?? '',
            'frontImage': (item['images'] != null && item['images'].isNotEmpty)
                ? item['images'][0].toString()
                : '',
            'backgroundImage': (item['images'] != null && item['images'].length > 1)
                ? item['images'][1].toString()
                : '',
            'color': item['attributes']?['color'] ?? '',
            'material': item['attributes']?['material'] ?? '',
            'weight': item['attributes']?['weight'] ?? '',
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch search results');
      }
    } catch (e) {
      throw Exception('Error fetching search results: $e');
    }
  }

  // Fetch products by category ID
  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      throw Exception('Category ID cannot be empty');
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/category/$categoryId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((item) {
          // Safely handle `_id` field
          final id = item['_id'];
          final String parsedId = (id is Map && id.containsKey('\$oid'))
              ? id['\$oid']
              : id.toString();

          return {
            'id': parsedId, // Use the parsed ID
            'productId': item['productId'] ?? '',
            'name': item['name'] ?? '',
            'description': item['description'] ?? '',
            'frontImage': (item['images'] != null && item['images'].isNotEmpty)
                ? item['images'][0].toString()
                : '',
            'backgroundImage': (item['images'] != null && item['images'].length > 1)
                ? item['images'][1].toString()
                : '',
            'color': item['attributes']?['color'] ?? '',
            'material': item['attributes']?['material'] ?? '',
            'weight': item['attributes']?['weight'] ?? '',
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch products by category');
      }
    } catch (e) {
      throw Exception('Error fetching products by category: $e');
    }
  }

  // Order a product
  static Future<bool> orderProduct({
    required String userId,
    required String productId,
    required int quantity,
    String? description,
  }) async {
    if (userId.isEmpty) {
      throw Exception('User ID cannot be empty');
    }
    if (productId.isEmpty) {
      throw Exception('Product ID cannot be empty');
    }
    if (quantity <= 0) {
      throw Exception('Quantity must be greater than zero');
    }

    try {
      final response = await http.post(
        Uri.parse(_orderUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
          'description': description ?? '',
        }),
      );

      if (response.statusCode == 201) {
        // Successfully placed the order
        return true;
      } else {
        // Handle other response statuses
        return false;
      }
    } catch (e) {
      print('Error placing order: $e');
      return false; // Return false on any error
    }
  }
}
