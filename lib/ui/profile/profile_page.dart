import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/chat_page.dart';
import '../chat/inbox_teknisi_page.dart';

import 'garansi_page.dart';
import 'riwayat_servis_page.dart';
import 'settings_page.dart';
import 'kelola_garansi_page.dart';

// 👇 Tanda // DIHAPUS agar file Dashboard Teknisi terbaca
import '../mitra/mitra_dashboard.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Dell1996PageFrame(
        child: Scaffold(
          backgroundColor: Dell1996Colors.canvas,
          body: const Center(
            child: Text("SILAKAN LOG MASUK TERLEBIH DAHULU."),
          ),
        ),
      );
    }

    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Dell1996Colors.primary),
                );
              }

              String namaUser = "Pengguna";
              String role = "user";

              if (snapshot.hasData && snapshot.data!.exists) {
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                namaUser = userData['nama'] ?? 'Pengguna';
                role = userData['role'] ?? 'user';
              }

              return Column(
                children: [
                  Dell1996TopBanner(
                    title: 'PROFIL ${role == 'mitra' ? 'MITRA' : 'PENGGUNA'}',
                    subtitle: currentUser.email ?? 'Tidak diketahui',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(Dell1996Spacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- User Info Box ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(Dell1996Spacing.lg),
                            decoration: BoxDecoration(
                              color: role == 'mitra' ? Dell1996Colors.yellowSticker : Dell1996Colors.tintSky,
                              border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Dell1996Colors.canvas,
                                    border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                                  ),
                                  child: const Icon(Icons.person, size: 40, color: Dell1996Colors.frameInk),
                                ),
                                const SizedBox(width: Dell1996Spacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        namaUser.toUpperCase(),
                                        style: Dell1996Typography.heading2,
                                      ),
                                      const SizedBox(height: Dell1996Spacing.xs),
                                      Text(
                                        "Akses: ${role.toUpperCase()}",
                                        style: Dell1996Typography.uiLabel,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dell1996Spacing.section),

                          // ==========================================
                          // 👤 MENU KHUSUS PELANGGAN (USER)
                          // ==========================================
                          if (role != 'mitra') ...[
                            const Dell1996SectionEyebrow(
                              title: 'MENU PELANGGAN',
                              backgroundColor: Dell1996Colors.tintPeach,
                            ),
                            const SizedBox(height: Dell1996Spacing.md),
                            _buildMenuOption(
                              "KLAIM GARANSI DIGITAL",
                              context,
                              targetPage: const GaransiPage(),
                            ),
                            _buildMenuOption(
                              "PUSAT BANTUAN",
                              context,
                              targetPage: ChatPage(
                                customerUid: currentUser.email ?? currentUser.uid,
                                customerName: namaUser,
                              ),
                            ),
                            const SizedBox(height: Dell1996Spacing.xl),
                          ],

                          // ==========================================
                          // 🔧 MENU KHUSUS TEKNISI (MITRA)
                          // ==========================================
                          if (role == 'mitra') ...[
                            const Dell1996SectionEyebrow(
                              title: 'MENU TEKNISI',
                              backgroundColor: Dell1996Colors.tintLime,
                            ),
                            const SizedBox(height: Dell1996Spacing.md),
                            _buildMenuOption(
                              "KELOLA KLAIM GARANSI",
                              context,
                              targetPage: const KelolaGaransiPage(),
                            ),
                            _buildMenuOption(
                              "LIVE CHAT PELANGGAN",
                              context,
                              targetPage: const InboxTeknisiPage(),
                            ),
                            _buildMenuOption(
                              "LAPORAN KEUANGAN",
                              context,
                              targetPage: const MitraDashboard(),
                            ),
                            const SizedBox(height: Dell1996Spacing.xl),
                          ],

                          // ==========================================
                          // 🌍 MENU UMUM (BISA DILIHAT KEDUANYA)
                          // ==========================================
                          const Dell1996SectionEyebrow(
                            title: 'PENGATURAN UMUM',
                            backgroundColor: Dell1996Colors.tintSteel,
                          ),
                          const SizedBox(height: Dell1996Spacing.md),
                          _buildMenuOption(
                            "RIWAYAT SERVIS",
                            context,
                            targetPage: const RiwayatServisPage(),
                          ),
                          _buildMenuOption(
                            "PENGATURAN",
                            context,
                            targetPage: const SettingsPage(),
                          ),
                          const SizedBox(height: Dell1996Spacing.section),

                          // TOMBOL KELUAR
                          Dell1996CtaBlockRed(
                            text: 'KELUAR (LOGOUT)',
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    String title,
    BuildContext context, {
    Widget? targetPage,
  }) {
    return InkWell(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'FUNGSI BELUM TERSEDIA!',
                style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas),
              ),
              backgroundColor: Dell1996Colors.primary,
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: Dell1996Spacing.md),
        padding: const EdgeInsets.all(Dell1996Spacing.lg),
        decoration: BoxDecoration(
          color: Dell1996Colors.canvas,
          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Dell1996Colors.frameInk),
          ],
        ),
      ),
    );
  }
}
