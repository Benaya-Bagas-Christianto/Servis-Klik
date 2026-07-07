import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/chat_page.dart';
import '../chat/inbox_teknisi_page.dart';

import '../auth/login_page.dart';
import 'garansi_page.dart';
import 'riwayat_servis_page.dart';
import 'settings_page.dart';
import 'kelola_garansi_page.dart';

// 👇 Tanda // DIHAPUS agar file Dashboard Teknisi terbaca
import '../mitra/mitra_dashboard.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Silakan log masuk terlebih dahulu.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          String namaUser = "Pengguna";
          String role = "user";

          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            namaUser = userData['nama'] ?? 'Pengguna';
            role = userData['role'] ?? 'user';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  namaUser,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentUser.email ?? "Email tidak ditemukan",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // ==========================================
                // 👤 MENU KHUSUS PELANGGAN (USER)
                // ==========================================
                if (role != 'mitra') ...[
                  _buildMenuOption(
                    Icons.verified_user,
                    "Klaim Garansi Digital",
                    Colors.green,
                    context,
                    targetPage: const GaransiPage(),
                  ),
                  _buildMenuOption(
                    Icons.help_outline,
                    "Pusat Bantuan",
                    Colors.orange,
                    context,
                    // 👇 Mengarah ke ruang obrolan pribadi pelanggan tersebut
                    targetPage: ChatPage(
                      // 👇 Kembali menggunakan email agar riwayat chat lama bisa terbaca lagi
                      customerUid: currentUser.email ?? currentUser.uid,
                      customerName: namaUser,
                    ),
                  ),
                ],

                // ==========================================
                // 🔧 MENU KHUSUS TEKNISI (MITRA)
                // ==========================================
                if (role == 'mitra') ...[
                  _buildMenuOption(
                    Icons.verified_user,
                    "Kelola Klaim Garansi",
                    Colors.green,
                    context,
                    targetPage: const KelolaGaransiPage(),
                  ),

                  // 👇 INI DIA! Menu Chat untuk Teknisi membalas pesan pelanggan
                  _buildMenuOption(
                    Icons.chat_bubble_outline,
                    "Live Chat Pelanggan",
                    Colors.orange,
                    context,
                    // 👇 Mengarah ke halaman daftar nama pelanggan (Inbox)
                    targetPage: const InboxTeknisiPage(),
                  ),

                  const Divider(thickness: 2),
                  const SizedBox(height: 10),
                  _buildMenuOption(
                    Icons.admin_panel_settings,
                    "Laporan Keuangan",
                    Colors.indigo,
                    context,
                    // 👇 Tanda // DIHAPUS agar tombolnya bisa diklik dan masuk ke halaman Dashboard
                    targetPage: const MitraDashboard(),
                  ),
                  const SizedBox(height: 10),
                ],

                // ==========================================
                // 🌍 MENU UMUM (BISA DILIHAT KEDUANYA)
                // ==========================================
                _buildMenuOption(
                  Icons.history,
                  "Riwayat Servis",
                  Colors.blueAccent,
                  context,
                  targetPage: const RiwayatServisPage(),
                ),
                _buildMenuOption(
                  Icons.settings,
                  "Pengaturan",
                  Colors.grey,
                  context,
                  targetPage: const SettingsPage(),
                ),

                const SizedBox(height: 20),

                // TOMBOL KELUAR
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // Navigator dihapus. Saat signOut() dipanggil, AuthWrapper di main.dart 
                      // akan otomatis mendeteksinya dan me-return LoginPage.
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Keluar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuOption(
    IconData icon,
    String title,
    Color iconColor,
    BuildContext context, {
    Widget? targetPage,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          if (targetPage != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetPage),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Halaman sedang dalam pembangunan!'),
              ),
            );
          }
        },
      ),
    );
  }
}
