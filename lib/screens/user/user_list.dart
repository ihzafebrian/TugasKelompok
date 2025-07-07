import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  final List<Map<String, String>> dummyUsers = const [
    {
      'nama': 'Iza Febrian',
      'email': 'admin@vapestore.com',
      'role': 'Admin',
    },
    {
      'nama': 'Dina Saputra',
      'email': 'kasir1@vapestore.com',
      'role': 'Kasir',
    },
    {
      'nama': 'Eka Dewi',
      'email': 'kasir2@vapestore.com',
      'role': 'Kasir',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Daftar User',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.tealAccent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur tambah user coming soon')),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: dummyUsers.length,
        itemBuilder: (context, index) {
          final user = dummyUsers[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.tealAccent.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.tealAccent,
                child: Icon(Icons.person, color: Colors.black),
              ),
              title: Text(
                user['nama']!,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['email']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    user['role']!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {
                // TODO: navigasi ke detail user
              },
            ),
          );
        },
      ),
    );
  }
}
