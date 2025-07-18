import 'package:flutter/material.dart';
import 'package:vaporate/screens/kasir/kategori/kategori_form_screen.dart';
import 'package:vaporate/services/api_service.dart';

class KategoriScreen extends StatefulWidget {
  const KategoriScreen({super.key});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  List<dynamic> kategoriList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    try {
      final data = await ApiService.fetchKategori();
      setState(() {
        kategoriList = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error saat ambil data kategori: $e');
    }
  }

  void hapusKategori(int id) async {
    await ApiService.hapusKategori(id);
    fetchKategori();
  }

  void bukaFormTambah() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => KategoriFormScreen()),
    );

    if (result != null && result == true) fetchKategori();
  }

  void bukaFormEdit(Map kategori) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                KategoriFormScreen(kategori: kategori as Map<String, dynamic>),
      ),
    );

    if (result != null && result == true) fetchKategori();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kategori'),
        actions: [
          IconButton(onPressed: fetchKategori, icon: const Icon(Icons.refresh)),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: kategoriList.length,
                itemBuilder: (context, index) {
                  final kategori = kategoriList[index];
                  return ListTile(
                    title: Text(kategori['category_name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => bukaFormEdit(kategori),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => hapusKategori(kategori['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: bukaFormTambah,
        child: const Icon(Icons.add),
      ),
    );
  }
}
