import 'package:flutter/material.dart';
import 'package:vaporate/models/transaksi_model.dart';
import 'package:vaporate/services/api_service.dart';
import 'package:vaporate/screens/kasir/transaksi/transaksi_detail_screen.dart';
import 'package:vaporate/screens/kasir/transaksi/transaksi_form.dart';

class TransaksiListScreen extends StatefulWidget {
  const TransaksiListScreen({Key? key}) : super(key: key);

  @override
  State<TransaksiListScreen> createState() => _TransaksiListScreenState();
}

class _TransaksiListScreenState extends State<TransaksiListScreen> {
  late Future<List<Transaksi>> _transaksiListFuture;

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  void _loadTransaksi() {
    _transaksiListFuture = ApiService.fetchTransaksi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TransaksiForm()),
              );
              if (result == true) {
                setState(() {
                  _loadTransaksi();
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Transaksi>>(
        future: _transaksiListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada transaksi'));
          }

          final transaksiList = snapshot.data!;

          return ListView.builder(
            itemCount: transaksiList.length,
            itemBuilder: (context, index) {
              final transaksi = transaksiList[index];
              return ListTile(
                title: Text(transaksi.transactionCode),
                subtitle: Text('Total: Rp ${transaksi.totalPrice}'),
                trailing: Text(transaksi.paymentMethod),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              TransaksiDetailScreen(transaksi: transaksi),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
