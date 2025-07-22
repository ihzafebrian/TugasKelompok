import 'package:flutter/material.dart';
import 'package:vaporate/models/produk_model.dart';
import 'package:vaporate/models/transaksi_model.dart';
import 'package:vaporate/services/api_service.dart';

class TransaksiForm extends StatefulWidget {
  const TransaksiForm({Key? key}) : super(key: key);

  @override
  _TransaksiFormState createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<TransaksiForm> {
  List<Product> _products = [];
  Product? _selectedProduct;
  int _quantity = 1;
  List<TransactionDetail> _detailList = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ApiService.fetchProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  void _addToTransaction() {
    if (_selectedProduct == null) return;

    final double price = _selectedProduct!.price ?? 0.0;
    final subtotal = (price * _quantity).toInt();

    final detail = TransactionDetail(
      id: 0,
      transactionId: 0,
      productId: _selectedProduct!.id,
      quantity: _quantity,
      price: price.toString(),
      subtotal: subtotal.toString(),
      createdAt: '',
      updatedAt: '',
    );

    setState(() {
      _transactionDetails.add(detail);
    });
  }
  List<TransactionDetail> get _transactionDetails => _detailList;
  int _calculateTotal() {
    return _detailList.fold(
      0,
      (sum, item) => sum + (int.tryParse(item.subtotal) ?? 0),
    );
  }

  Future<void> _submitTransaction() async {
    try {
      await ApiService.createTransaction(_detailList);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaksi berhasil disimpan')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal simpan transaksi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<Product>(
              value: _selectedProduct,
              items:
                  _products.map((product) {
                    return DropdownMenuItem(
                      value: product,
                      child: Text(product.productName),
                    );
                  }).toList(),
              hint: const Text('Pilih Produk'),
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                });
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
              initialValue: _quantity.toString(),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                setState(() {
                  _quantity = parsed != null && parsed > 0 ? parsed : 1;
                });
              },
            ),
            ElevatedButton(
              onPressed: _addToTransaction,
              child: const Text('Tambah'),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _detailList.length,
                itemBuilder: (context, index) {
                  final item = _detailList[index];
                  final product = _products.firstWhere(
                    (p) => p.id == item.productId,
                    orElse:
                        () => Product(
                          id: 0,
                          productName: 'Tidak Ditemukan',
                          price: 0,
                          categoryId: 0,
                          stock: 0,
                        ),
                  );
                  return ListTile(
                    title: Text(product.productName),
                    subtitle: Text(
                      'Jumlah: ${item.quantity} | Subtotal: Rp${item.subtotal}',
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text('Total: Rp ${_calculateTotal()}'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitTransaction,
              child: const Text('Simpan Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
