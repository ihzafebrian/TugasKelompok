import 'package:flutter/material.dart';

class ProdukList extends StatelessWidget {
  const ProdukList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Produk')),
      body: const Center(child: Text('Ini halaman produk')),
    );
  }
}
