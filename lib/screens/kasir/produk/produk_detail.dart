import 'package:flutter/material.dart';

class ProdukDetail extends StatelessWidget {
  final Map<String, dynamic> produk;
  const ProdukDetail({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(produk['gambar'], height: 150),
            const SizedBox(height: 16),
            Text(produk['nama'], style: const TextStyle(fontSize: 24)),
            Text('Harga: Rp ${produk['harga']}'),
            Text('Stok: ${produk['stok']} pcs'),
          ],
        ),
      ),
    );
  }
}
