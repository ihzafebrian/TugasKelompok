import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_service.dart';

class ProdukForm extends StatefulWidget {
  final Map<String, dynamic>? produk;

  const ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();

  List kategoriList = [];
  List supplierList = [];

  String? _selectedKategori;
  String? _selectedSupplier;
  File? _selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initForm();
  }

  void _initForm() {
    if (widget.produk != null) {
      final produk = widget.produk!;
      _namaController.text = produk['product_name'] ?? '';
      _hargaController.text = produk['price']?.toString() ?? '';
      _stokController.text = produk['stock']?.toString() ?? '';
      _selectedKategori = produk['category_id']?.toString();
      _selectedSupplier = produk['supplier_id']?.toString();
    }
  }

  Future<void> _loadData() async {
    try {
      final kategori = await ApiService.fetchKategori();
      final supplier = await ApiService.getSuppliers();
      setState(() {
        kategoriList = kategori;
        supplierList = supplier;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submit() async {
    if (_namaController.text.isEmpty ||
        _hargaController.text.isEmpty ||
        _stokController.text.isEmpty ||
        _selectedKategori == null ||
        _selectedSupplier == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }

    setState(() => isLoading = true);

    final data = {
      'product_name': _namaController.text,
      'category_id': _selectedKategori,
      'supplier_id': _selectedSupplier,
      'price': _hargaController.text,
      'stock': _stokController.text,
    };

    try {
      if (widget.produk == null) {
        await ApiService.createProduk(data, _selectedImage);
      } else {
        await ApiService.updateProduk(
          widget.produk!['id'],
          data,
          _selectedImage,
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      print('Gagal menyimpan: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan produk')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produk == null ? 'Tambah Produk' : 'Edit Produk'),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(labelText: 'Nama Produk'),
                    ),
                    TextField(
                      controller: _hargaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Harga'),
                    ),
                    TextField(
                      controller: _stokController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Stok'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedKategori,
                      items:
                          kategoriList
                              .map<DropdownMenuItem<String>>(
                                (item) => DropdownMenuItem<String>(
                                  value: item['id'].toString(),
                                  child: Text(
                                    item['category_name'] ?? 'Tidak diketahui',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => setState(() => _selectedKategori = value),
                      decoration: InputDecoration(labelText: 'Kategori'),
                    ),
                    DropdownButtonFormField<String>(
                      value: _selectedSupplier,
                      items:
                          supplierList
                              .map<DropdownMenuItem<String>>(
                                (item) => DropdownMenuItem<String>(
                                  value: item['id'].toString(),
                                  child: Text(
                                    item['supplier_name'] ?? 'Tidak diketahui',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => setState(() => _selectedSupplier = value),
                      decoration: InputDecoration(labelText: 'Supplier'),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Pilih Gambar'),
                    ),
                    if (_selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Image.file(_selectedImage!, height: 120),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(widget.produk == null ? 'Simpan' : 'Update'),
                    ),
                  ],
                ),
              ),
    );
  }
}
