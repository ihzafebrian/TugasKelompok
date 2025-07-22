import 'package:flutter/material.dart';
import 'package:vaporate/screens/kasir/transaksi/transaksi_form.dart';
import 'package:vaporate/screens/kasir/transaksi/transaksi_list.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      body: const TransaksiListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigasi ke form transaksi
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransaksiForm()),
          );
          if (result == true) {
            setState(
              () {},
            ); // refresh list jika transaksi baru berhasil ditambahkan
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
