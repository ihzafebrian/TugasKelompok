import 'package:flutter/material.dart';

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data transaksi
    final List<Map<String, dynamic>> transaksiDummy = [
      {"tanggal": "2025-07-01", "total": 120000},
      {"tanggal": "2025-07-02", "total": 90000},
      {"tanggal": "2025-07-03", "total": 150000},
    ];

    final totalSemua = transaksiDummy.fold<int>(
      0,
      (sum, item) => sum + item['total'] as int,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Penjualan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ringkasan Transaksi:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: transaksiDummy.length,
                itemBuilder: (context, index) {
                  final item = transaksiDummy[index];
                  return ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.deepPurple),
                    title: Text("Tanggal: ${item['tanggal']}"),
                    subtitle: Text("Total: Rp ${item['total']}"),
                  );
                },
              ),
            ),
            Divider(),
            Text(
              "Total Penjualan: Rp $totalSemua",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
