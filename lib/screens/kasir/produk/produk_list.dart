import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'produk_form.dart';

class ProdukList extends StatefulWidget {
  const ProdukList({super.key});

  @override
  State<ProdukList> createState() => _ProdukListState();
}

class _ProdukListState extends State<ProdukList> {
  late Future<List<dynamic>> produkList;
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    produkList = fetchProduk();
  }

  Future<List<dynamic>> fetchProduk() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('http://192.168.1.215:8000/api/products'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat data produk: ${response.body}');
    }
  }

  Future<void> hapusProduk(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.delete(
      Uri.parse('http://192.168.1.215:8000/api/products/$id'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus')));
      setState(() => produkList = fetchProduk());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: ${res.body}')),
      );
    }
  }

  void konfirmasiHapus(int id) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Produk'),
            content: const Text('Yakin ingin menghapus produk ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (konfirmasi ?? false) {
      await hapusProduk(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        title: Text('Daftar Produk', style: GoogleFonts.poppins()),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final hasil = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProdukForm()),
              );
              if (hasil == true) {
                setState(() => produkList = fetchProduk());
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: produkList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.tealAccent),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat produk\n${snapshot.error}',
                style: GoogleFonts.poppins(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            );
          }

          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(
              child: Text(
                'Belum ada produk.',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final produk = data[index];
              final productName = produk['product_name'] ?? '-';
              final price = double.tryParse(produk['price'].toString()) ?? 0;
              final stock = produk['stock'] ?? 0;
              final image = produk['image'];
              final categoryName =
                  produk['category']?['category_name'] ?? 'Tidak ada';
              final supplierName =
                  produk['supplier']?['supplier_name'] ?? 'Tidak ada';

              return Card(
                color: const Color(0xFF2A2A2A),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading:
                      image != null && image.toString().isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'http://192.168.1.215:8000/storage/$image',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                          : const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                  title: Text(
                    productName,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Kategori: $categoryName\nSupplier: $supplierName\n'
                    'Harga: ${formatCurrency.format(price)} | Stok: $stock',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        final hasil = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProdukForm(produk: produk),
                          ),
                        );
                        if (hasil == true) {
                          setState(() => produkList = fetchProduk());
                        }
                      } else if (value == 'hapus') {
                        konfirmasiHapus(produk['id']);
                      }
                    },
                    itemBuilder:
                        (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                        ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
