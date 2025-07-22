import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:vaporate/models/transaksi_model.dart'; // Tambahkan ini
import 'package:vaporate/models/kategori_model.dart';
import 'package:vaporate/models/produk_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.10.186:8000/api';

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
      await prefs.setString('token', data['token']);
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

  // =============================
  // 📦 SUPPLIER
  // =============================
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

  // =============================
  // 📦 PRODUK
  // =============================
  static Future<List<dynamic>> getProducts() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchProduk() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map && decoded.containsKey('data')) {
        return List<Map<String, dynamic>>.from(decoded['data']);
      } else if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        print('Unexpected response format: $decoded');
        return [];
      }
    } else {
      print('Gagal mengambil data produk: ${response.body}');
      throw Exception('Gagal mengambil data produk');
    }
  }

  static Future<void> createProduk(
    Map<String, dynamic> data,
    File? imageFile,
  ) async {
    final url = Uri.parse('$baseUrl/products');
    final token = await _getToken();

    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['product_name'] = data['product_name'];
    request.fields['category_id'] = data['category_id'].toString();
    request.fields['supplier_id'] = data['supplier_id'].toString();
    request.fields['price'] = data['price'].toString();
    request.fields['stock'] = data['stock'].toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('Status Code: ${response.statusCode}');
    print('Response Body: $responseBody');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menyimpan produk: $responseBody');
    }
  }

  static Future<void> updateProduk(
    int id,
    Map<String, dynamic> data,
    File? imageFile,
  ) async {
    final uri = Uri.parse('$baseUrl/products/$id?_method=PUT');
    final token = await _getToken();

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    request.fields['product_name'] = data['product_name'];
    request.fields['category_id'] = data['category_id'].toString();
    request.fields['supplier_id'] = data['supplier_id'].toString();
    request.fields['price'] = data['price'].toString();
    request.fields['stock'] = data['stock'].toString();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('Status Code: ${response.statusCode}');
    print('Response Body: $responseBody');

    if (response.statusCode != 200) {
      throw Exception('Gagal update produk: $responseBody');
    }
  }

  // 🔁 Ambil semua transaksi (List<Transaksi>)
  static Future<List<Transaksi>> fetchTransaksi() async {
    final url = Uri.parse('$baseUrl/transactions');
    final token = await _getToken();

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> transaksiList = data is List ? data : data['data'];

      return transaksiList.map((json) => Transaksi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat transaksi');
    }
  }

  static Future<Map<String, dynamic>> simpanTransaksi(
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'), // ✅ Pastikan sesuai route backend
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // ✅ Diperlukan
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      return {
        'success': false,
        'message': error['message'] ?? 'Gagal menyimpan transaksi',
      };
    }
  }

  static Future<void> createTransaction(List<TransactionDetail> details) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token tidak ditemukan');

    final url = Uri.parse('$baseUrl/transaksis'); // pastikan rute backend benar

    // Susun body JSON
    final body = jsonEncode({
      'details':
          details
              .map(
                (detail) => {
                  'product_id': detail.productId,
                  'quantity': detail.quantity,
                  'price': detail.price,
                  'subtotal': detail.subtotal,
                },
              )
              .toList(),
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menyimpan transaksi: ${response.body}');
    }
  }

  static Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$baseUrl/products');
    final token = await _getToken();

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = json.decode(response.body); // ✅ fix di sini
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Gagal memuat produk. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error saat fetch produk: $e');
      throw Exception('Gagal memuat produk');
    }
  }
}
