import 'dart:convert';
import 'package:http/http.dart' as http;

class OffersService {
  static const String baseUrl = 'http://localhost:3000/offers';

  // Function to create a new offer
  static Future<Map<String, dynamic>> createOffer(
      Map<String, dynamic> offerData) async {
    try {
      // Perform the POST request
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(offerData),
      );

      if (response.statusCode == 201) {
        // Parse and return the JSON response
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Handle errors
        throw Exception(
            'Failed to create offer. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle exceptions
      throw Exception('Failed to create offer: $error');
    }
  }
}
