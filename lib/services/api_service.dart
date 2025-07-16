import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://172.20.10.3:8000/api';

  // POST: Login
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  // GET: Endpoint protected with token
  static Future<http.Response> get(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  // POST: Endpoint protected
  static Future<http.Response> post(
    String endpoint,
    Map<String, String> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: data,
    );
  }

  // PUT: Endpoint protected
  static Future<http.Response> put(
    String endpoint,
    Map<String, String> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: data,
    );
  }

  // DELETE: Endpoint protected
  static Future<http.Response> delete(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }
}
