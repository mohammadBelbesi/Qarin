import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  static const String baseUrl = 'http://localhost:3000/orders';

  Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> orderData) async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating order: $e');
    }
  }

   /// Fetch orders by user ID
  Future<List<Map<String, dynamic>>> getOrdersByUserId(String userId) async {
    final url = Uri.parse('$baseUrl/$userId');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>(); // Convert to List of Maps
      } else if (response.statusCode == 404) {
        return []; // Return empty list if no orders found
      } else {
        throw Exception('Failed to fetch orders: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }
  Future<List<Map<String, dynamic>>> getOrdersByStoreId(String storeId) async {
    final url = Uri.parse('$baseUrl/store/$storeId');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>(); // Convert to List of Maps
      } else if (response.statusCode == 404) {
        return []; // Return empty list if no orders found
      } else {
        throw Exception('Failed to fetch store orders: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching store orders: $e');
    }
  }

}
