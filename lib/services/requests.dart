import 'dart:convert';
import 'package:http/http.dart' as http;

class OrdersService {
  static const String baseUrl = 'http://localhost:3000/requests';

  // Function to fetch orders (requests) by category ID
  static Future<List<Map<String, dynamic>>> fetchOrders(
      {String? categoryId}) async {
    try {
      // Build the URL with the optional categoryId query parameter
      final url =
          categoryId != null ? '$baseUrl?categoryId=$categoryId' : baseUrl;

      // Perform the GET request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse and return the JSON response
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        // Handle errors
        throw Exception(
            'Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      throw Exception('Failed to load orders: $error');
    }
  }
  // Function to fetch orders by user ID
  static Future<List<Map<String, dynamic>>> fetchOrdersByUser(
      {required String userId}) async {
    try {
      // Build the URL with the userId query parameter
      final url = '$baseUrl/user?userId=$userId';

      // Perform the GET request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse and return the JSON response
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        // Handle errors
        throw Exception(
            'Failed to load user orders. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      throw Exception('Failed to load user orders: $error');
    }
  }
  
}
