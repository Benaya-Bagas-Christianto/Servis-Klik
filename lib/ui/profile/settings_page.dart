import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String _namaUser = "MEMUAT DATA...";

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
          _namaUser = (doc.data()?['nama'] ?? 'Pengguna').toString().toUpperCase();
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
          backgroundColor: Dell1996Colors.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text("GANTI NAMA", style: Dell1996Typography.heading2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("NAMA LENGKAP BARU:", style: Dell1996Typography.uiLabel),
              const SizedBox(height: Dell1996Spacing.xs),
              Dell1996TextInput(controller: namaController),
            ],
          ),
          actions: [
            Dell1996ButtonPrimary(
              text: "BATAL",
              onPressed: () => Navigator.pop(context),
            ),
            Dell1996ButtonPrimary(
              text: "SIMPAN",
              onPressed: () async {
                String namaBaru = namaController.text.trim();
                if (namaBaru.isEmpty) return;

                // Update ke Firebase Firestore
                await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
                  'nama': namaBaru,
                });

                setState(() {
                  _namaUser = namaBaru.toUpperCase(); // Update tampilan di layar langsung
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("NAMA BERHASIL DIPERBARUI!", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
                      backgroundColor: Dell1996Colors.primary,
                    ),
                  );
                }
              },
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
          backgroundColor: Dell1996Colors.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text("GANTI PASSWORD", style: Dell1996Typography.heading2),
          content: Text(
            "Kirimkan tautan untuk mengganti password ke email:\n${currentUser?.email?.toUpperCase()}?",
            style: Dell1996Typography.body,
          ),
          actions: [
            Dell1996ButtonPrimary(
              text: "BATAL",
              onPressed: () => Navigator.pop(context),
            ),
            Dell1996ButtonPrimary(
              text: "YA, KIRIM EMAIL",
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: currentUser!.email!);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("TAUTAN TELAH DIKIRIM KE EMAIL ANDA!", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
                        backgroundColor: Dell1996Colors.primary,
                      ),
                    );
                  }
                } catch (e) {
                  debugPrint("Error: $e");
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              const Dell1996TopBanner(
                title: 'PENGATURAN UMUM',
                subtitle: 'Konfigurasi Sistem',
                showBackButton: true,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Dell1996Spacing.lg),
                  children: [
                    // --- SECTION: AKUN SAAT INI ---
                    const Dell1996SectionEyebrow(
                      title: 'AKUN SAAT INI',
                      backgroundColor: Dell1996Colors.tintSky,
                    ),
                    const SizedBox(height: Dell1996Spacing.sm),
                    Container(
                      padding: const EdgeInsets.all(Dell1996Spacing.md),
                      decoration: BoxDecoration(
                        color: Dell1996Colors.canvas,
                        border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Dell1996Colors.canvas,
                              border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                            ),
                            child: const Icon(Icons.person, size: 30, color: Dell1996Colors.frameInk),
                          ),
                          const SizedBox(width: Dell1996Spacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_namaUser, style: Dell1996Typography.heading3),
                                const SizedBox(height: Dell1996Spacing.xs),
                                Text((currentUser?.email ?? "EMAIL TIDAK DITEMUKAN").toUpperCase(), style: Dell1996Typography.uiLabel),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Dell1996Spacing.section),

                    // --- SECTION: UMUM ---
                    const Dell1996SectionEyebrow(
                      title: 'UMUM',
                      backgroundColor: Dell1996Colors.tintPeach,
                    ),
                    const SizedBox(height: Dell1996Spacing.sm),
                    _buildListTile(Icons.badge_outlined, "GANTI NAMA", onTap: _showEditProfileDialog),
                    _buildListTile(Icons.lock_outline, "GANTI PASSWORD", onTap: _resetPassword),
                    const SizedBox(height: Dell1996Spacing.section),

                    // --- SECTION: INFORMASI ---
                    const Dell1996SectionEyebrow(
                      title: 'INFORMASI',
                      backgroundColor: Dell1996Colors.tintLime,
                    ),
                    const SizedBox(height: Dell1996Spacing.sm),
                    _buildListTile(Icons.privacy_tip_outlined, "KEBIJAKAN PRIVASI"),
                    _buildListTile(Icons.info_outline, "TENTANG APLIKASI", subtitle: "VERSI 1.0.0"),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(Dell1996Spacing.md),
                color: Dell1996Colors.canvas,
                child: Dell1996ButtonPrimary(
                  text: 'KEMBALI',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {String? subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: Dell1996Spacing.xs),
        padding: const EdgeInsets.all(Dell1996Spacing.md),
        decoration: BoxDecoration(
          color: Dell1996Colors.canvas,
          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: Dell1996Colors.frameInk),
            const SizedBox(width: Dell1996Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold)),
                  if (subtitle != null) ...[
                    const SizedBox(height: Dell1996Spacing.xs),
                    Text(subtitle, style: Dell1996Typography.uiLabel),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Dell1996Colors.frameInk),
          ],
        ),
      ),
    );
  }
}
