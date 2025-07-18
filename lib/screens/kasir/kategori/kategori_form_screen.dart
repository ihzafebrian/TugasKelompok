import 'package:flutter/material.dart';
import 'package:vaporate/services/api_service.dart';

class KategoriFormScreen extends StatefulWidget {
  final Map<String, dynamic>? kategori;

  const KategoriFormScreen({super.key, this.kategori});

  @override
  State<KategoriFormScreen> createState() => _KategoriFormScreenState();
}

class _KategoriFormScreenState extends State<KategoriFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.kategori?['category_name'] ?? '',
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.kategori == null) {
        // Tambah kategori baru
        await ApiService.tambahKategori(_namaController.text);
      } else {
        // Edit kategori
        await ApiService.updateKategori(
          widget.kategori!['id'],
          _namaController.text,
        );
      }

      Navigator.pop(context, true); // Kembali dengan hasil sukses
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.kategori != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Kategori' : 'Tambah Kategori')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kategori',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kategori tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _simpanData,
                  icon: Icon(isEdit ? Icons.save : Icons.add),
                  label: Text(
                    _isLoading
                        ? 'Menyimpan...'
                        : (isEdit ? 'Simpan Perubahan' : 'Tambah'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
