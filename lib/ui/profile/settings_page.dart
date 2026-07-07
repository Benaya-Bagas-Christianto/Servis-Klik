import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String _namaUser = "Memuat data...";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // --- MENGAMBIL NAMA DARI FIREBASE ---
  Future<void> _fetchUserData() async {
    if (currentUser != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          _namaUser = doc.data()?['nama'] ?? 'Pengguna';
        });
      }
    }
  }

  // =================================================================
  // 🔥 FITUR 1: GANTI NAMA (UPDATE CRUD FIREBASE)
  // =================================================================
  void _showEditProfileDialog() {
    TextEditingController namaController = TextEditingController(text: _namaUser);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Ganti Nama", style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: namaController,
            decoration: InputDecoration(
              labelText: "Nama Lengkap Baru",
              prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async {
                String namaBaru = namaController.text.trim();
                if (namaBaru.isEmpty) return;

                // Update ke Firebase Firestore
                await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
                  'nama': namaBaru,
                });

                setState(() {
                  _namaUser = namaBaru; // Update tampilan di layar langsung
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nama berhasil diperbarui!"), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // =================================================================
  // 🔥 FITUR 2: GANTI PASSWORD (FIREBASE AUTH)
  // =================================================================
  void _resetPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Ganti Password", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Kirimkan tautan untuk mengganti password ke email:\n${currentUser?.email}?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: currentUser!.email!);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tautan ganti password telah dikirim ke email Anda!"), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  debugPrint("Error: $e");
                }
              },
              child: const Text("Ya, Kirim Email", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- SECTION: AKUN SAAT INI ---
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text("Akun Saat Ini", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: const CircleAvatar(radius: 25, backgroundColor: Colors.blueAccent, child: Icon(Icons.person, color: Colors.white, size: 30)),
              title: Text(_namaUser, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(currentUser?.email ?? "Email tidak ditemukan", style: const TextStyle(fontSize: 13)),
              // Ikon pensil (edit) dihilangkan sesuai permintaan
            ),
          ),
          const SizedBox(height: 20),

          // --- SECTION: UMUM ---
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text("Umum", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                // 👇 Notifikasi & Bahasa dihapus, diganti menjadi menu Ganti Nama dan Ganti Password
                _buildListTile(Icons.badge_outlined, "Ganti Nama", onTap: _showEditProfileDialog),
                const Divider(height: 1, indent: 50),
                _buildListTile(Icons.lock_outline, "Ganti Password", onTap: _resetPassword),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // --- SECTION: INFORMASI ---
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text("Informasi", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildListTile(Icons.privacy_tip_outlined, "Kebijakan Privasi"),
                const Divider(height: 1, indent: 50),
                _buildListTile(Icons.info_outline, "Tentang Aplikasi", subtitle: "Versi 1.0.0"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk merapikan desain tombol
  Widget _buildListTile(IconData icon, String title, {String? subtitle, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
