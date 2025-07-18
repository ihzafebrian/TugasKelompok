import 'package:flutter/material.dart';
import 'package:vaporate/services/api_service.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  late Future<List<Map<String, dynamic>>> _futureSuppliers;

  @override
  void initState() {
    super.initState();
    _futureSuppliers = ApiService.getSuppliers();
  }

  Future<void> _refresh() async {
    setState(() {
      _futureSuppliers = ApiService.getSuppliers();
    });
  }

  void _deleteSupplier(int id) async {
    try {
      await ApiService.deleteSupplier(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supplier berhasil dihapus')),
      );
      _refresh();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus supplier: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Supplier'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureSuppliers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final suppliers = snapshot.data ?? [];

          if (suppliers.isEmpty) {
            return const Center(child: Text('Belum ada data supplier'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: suppliers.length,
              itemBuilder: (context, index) {
                final supplier = suppliers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(supplier['supplier_name'] ?? '-'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Telepon: ${supplier['phone'] ?? '-'}'),
                        Text('Alamat: ${supplier['address'] ?? '-'}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(supplier['id']),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/supplier_form');
          if (result == true) {
            _refresh();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Tambah Supplier',
      ),
    );
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text(
              'Apakah anda yakin ingin menghapus supplier ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _deleteSupplier(id);
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
