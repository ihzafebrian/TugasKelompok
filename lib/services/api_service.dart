import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.215:8000/api';

  // =============================
  // 🔐 AUTH
  // =============================
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
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']); // simpan token
      return data;
    } else {
      print('Login failed: ${response.statusCode}');
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await prefs.remove('token');
    } else {
      print('Logout failed: ${response.statusCode}');
    }
  }

  // =============================
  // 🔧 GENERIC METHOD
  // =============================
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    return await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();
    return await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  // =============================
  // 📦 KATEGORI
  // =============================
  static Future<List<dynamic>> fetchKategori() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/categories');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded;
      } else if (decoded is Map && decoded.containsKey('data')) {
        return decoded['data'];
      } else {
        return [];
      }
    } else {
      throw Exception('Gagal mengambil data kategori');
    }
  }

  static Future<void> tambahKategori(String nama) async {
    final response = await post('categories', {'category_name': nama});

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception('Gagal menambah kategori');
    }
  }

  static Future<void> updateKategori(int id, String nama) async {
    final response = await put('categories/$id', {'category_name': nama});

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Gagal memperbarui kategori');
    }
  }

  static Future<void> hapusKategori(int id) async {
    final response = await delete('categories/$id');
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Gagal menghapus kategori');
    }
  }

  static Future<List<Map<String, dynamic>>> getSuppliers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/suppliers'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load suppliers');
    }
  }

  static Future<Map<String, dynamic>> createSupplier(
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/suppliers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create supplier: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> updateSupplier(
    int id,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/suppliers/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update supplier');
    }
  }

  static Future<void> deleteSupplier(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/suppliers/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete supplier');
    }
  }
}
