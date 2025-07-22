import 'package:flutter/material.dart';
import 'package:vaporate/models/transaksi_model.dart';

class TransaksiDetailScreen extends StatelessWidget {
  final Transaksi transaksi;

  const TransaksiDetailScreen({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi ${transaksi.transactionCode}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode: ${transaksi.transactionCode}',
                style: const TextStyle(fontSize: 16)),
            Text('Metode Pembayaran: ${transaksi.paymentMethod}'),
            Text('Total: Rp ${transaksi.totalPrice}'),
            Text('Tanggal: ${transaksi.transactionDate}'),
            const SizedBox(height: 16),
            const Text(
              'Detail Produk:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: transaksi.details.length,
                itemBuilder: (context, index) {
                  final detail = transaksi.details[index];
                  return ListTile(
                    leading: Text('${index + 1}'),
                    title: Text('Produk ID: ${detail.productId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Qty: ${detail.quantity}'),
                        Text('Harga: Rp ${detail.price}'),
                        Text('Subtotal: Rp ${detail.subtotal}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
