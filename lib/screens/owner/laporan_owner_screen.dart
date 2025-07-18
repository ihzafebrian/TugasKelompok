import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LaporanOwnerScreen extends StatelessWidget {
  const LaporanOwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Laporan Pemilik',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Text('Halaman Laporan Pemilik',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
