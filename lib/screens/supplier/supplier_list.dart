import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupplierList extends StatelessWidget {
  const SupplierList({super.key});

  final List<Map<String, dynamic>> dummySupplier = const [
    {
      'nama': 'PT Liquid Vape Indo',
      'telepon': '0812-3456-7890',
      'alamat': 'Jl. Vape No. 12, Jakarta',
    },
    {
      'nama': 'CV Pod Vapor',
      'telepon': '0856-4321-9876',
      'alamat': 'Jl. Steam No. 5, Bandung',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Daftar Supplier', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigasi ke form tambah supplier
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur Tambah Supplier coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dummySupplier.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final supplier = dummySupplier[index];
          return Card(
            color: const Color(0xFF2A2A2A),
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.local_shipping, color: Colors.white),
              ),
              title: Text(
                supplier['nama'],
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${supplier['telepon']}\n${supplier['alamat']}',
                style: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
              isThreeLine: true,
              onTap: () {
                // TODO: ke detail atau edit supplier
              },
            ),
          );
        },
      ),
    );
  }
}
