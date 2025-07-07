import 'package:flutter/material.dart';
import 'produk/produk_list.dart';
import 'transaksi/transaksi_screen.dart';
import 'laporan_screen.dart';
import 'login_screen.dart'; // Untuk logout kembali ke login

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo, admin!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    icon: Icons.inventory,
                    label: 'Produk',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ProdukList()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.point_of_sale,
                    label: 'Transaksi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TransaksiScreen()),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    icon: Icons.bar_chart,
                    label: 'Laporan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LaporanScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.deepPurple),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
