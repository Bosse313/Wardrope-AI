import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<dynamic>> getWardrobe() async {
    final response = await http.get(Uri.parse('$baseUrl/wardrobe/items'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to load wardrobe');
  }

  static Future<List<dynamic>> generateOutfits() async {
    final response = await http.get(
      Uri.parse('$baseUrl/outfits/generate?occasion=daily&season=all&style=casual'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to generate outfits');
  }

  static Future<void> createItem(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wardrobe/items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create item');
    }
  }

  static Future<void> updateStatus(int itemId, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/wardrobe/items/$itemId/status?status=$status'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }
}
