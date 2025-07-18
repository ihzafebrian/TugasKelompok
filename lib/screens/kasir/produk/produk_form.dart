import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class ProdukForm extends StatefulWidget {
  final Map<String, dynamic>? produk;

  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  File? _pickedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      nameController.text = widget.produk!['product_name'] ?? '';
      priceController.text = widget.produk!['price'].toString();
      stockController.text = widget.produk!['stock'].toString();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> simpanProduk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token tidak ditemukan. Silakan login ulang.'),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    final isEdit = widget.produk != null;
    final uri =
        isEdit
            ? Uri.parse(
              'http://172.20.10.3:8000/api/products/${widget.produk!['id']}',
            )
            : Uri.parse('http://172.20.10.3:8000/api/products');

    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (isEdit) request.fields['_method'] = 'PUT';

    request.fields['product_name'] = nameController.text;
    request.fields['price'] = priceController.text;
    request.fields['stock'] = stockController.text;
    request.fields['category_id'] = '1'; // Sesuaikan
    request.fields['supplier_id'] = '1'; // Sesuaikan

    if (_pickedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _pickedImage!.path,
          filename: p.basename(_pickedImage!.path),
        ),
      );
    }

    final response = await request.send();
    final resBody = await http.Response.fromStream(response);
    setState(() => isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal simpan produk: ${resBody.body}')),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.produk != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Produk' : 'Tambah Produk'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF1C1C1C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pilih Gambar'),
              ),
              const SizedBox(height: 12),
              if (_pickedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_pickedImage!, height: 150),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : simpanProduk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                ),
                child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
