import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/dell_1996_theme.dart';
import '../../widget/dell_1996_components.dart';
import 'booking/booking_page.dart';
import '../mitra/daftar_tugas_page.dart';

/// HomePage dengan Dell 1996 Design Language
class HomePageDell1996 extends StatefulWidget {
  const HomePageDell1996({super.key});

  @override
  State<HomePageDell1996> createState() => _HomePageDell1996State();
}

class _HomePageDell1996State extends State<HomePageDell1996> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Silakan login terlebih dahulu.")),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String role = userData['role'] ?? 'user';
          String namaUser = userData['nama'] ?? 'Pengguna';

          if (role == 'mitra') {
            return _buildMitraHome(namaUser);
          } else {
            return _buildCustomerHome(namaUser);
          }
        }

        return _buildCustomerHome("Pelanggan");
      },
    );
  }

  // =========================================================================
  // TAMPILAN BERANDA KHUSUS TEKNISI (MITRA) - DELL 1996 STYLE
  // =========================================================================
  Widget _buildMitraHome(String nama) {
    return Scaffold(
      backgroundColor: Dell1996Colors.canvas,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner
            Dell1996TopBanner(
              title: 'SELAMAT DATANG, $nama! 👋',
              subtitle: 'Siap menyelesaikan servis laptop hari ini?',
            ),

            const SizedBox(height: Dell1996Spacing.lg),

            // Section Eyebrow
            const Dell1996SectionEyebrow(
              title: 'RINGKASAN TUGAS ANDA',
              backgroundColor: Dell1996Colors.tintSalmon,
            ),

            const SizedBox(height: Dell1996Spacing.lg),

            // Statistik Tugas dengan Ribbon Cards
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dell1996Spacing.lg,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('pesanan').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  int tugasBaru = 0;
                  int diproses = 0;
                  int selesai = 0;

                  for (var doc in snapshot.data!.docs) {
                    var data = doc.data() as Map<String, dynamic>;
                    String status = data['status'] ?? '';

                    if (status == 'Menunggu Teknisi') {
                      tugasBaru++;
                    } else if (status == 'Selesai') {
                      selesai++;
                    } else {
                      diproses++;
                    }
                  }

                  return Column(
                    children: [
                      // Tugas Baru
                      Dell1996RibbonCard(
                        title: 'TUGAS BARU',
                        description:
                            '$tugasBaru pesanan baru menunggu untuk diproses. Klik untuk melihat detail.',
                        tintColor: Dell1996Colors.tintSalmon,
                        leadingWidget: Container(
                          padding: const EdgeInsets.all(
                            Dell1996Spacing.sm,
                          ),
                          decoration: const BoxDecoration(
                            color: Dell1996Colors.primary,
                          ),
                          child: Text(
                            tugasBaru.toString(),
                            style: Dell1996Typography.display.copyWith(
                              color: Dell1996Colors.canvas,
                              fontSize: 48,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DaftarTugasPage(),
                            ),
                          );
                        },
                      ),

                      // Diproses
                      Dell1996RibbonCard(
                        title: 'DIPROSES',
                        description:
                            '$diproses pesanan sedang dalam proses perbaikan. From Dell\'s award-winning service teams.',
                        tintColor: Dell1996Colors.tintSky,
                        leadingWidget: Container(
                          padding: const EdgeInsets.all(
                            Dell1996Spacing.sm,
                          ),
                          decoration: const BoxDecoration(
                            color: Dell1996Colors.frameInk,
                          ),
                          child: Text(
                            diproses.toString(),
                            style: Dell1996Typography.display.copyWith(
                              color: Dell1996Colors.canvas,
                              fontSize: 48,
                            ),
                          ),
                        ),
                      ),

                      // Selesai
                      Dell1996RibbonCard(
                        title: 'SELESAI',
                        description:
                            '$selesai pesanan telah berhasil diselesaikan. Reliable service untuk pelanggan Anda.',
                        tintColor: Dell1996Colors.tintLime,
                        leadingWidget: Container(
                          padding: const EdgeInsets.all(
                            Dell1996Spacing.sm,
                          ),
                          decoration: const BoxDecoration(
                            color: Dell1996Colors.yellowSticker,
                            border: Border.fromBorderSide(
                              BorderSide(color: Dell1996Colors.frameInk),
                            ),
                          ),
                          child: Text(
                            selesai.toString(),
                            style: Dell1996Typography.display.copyWith(
                              color: Dell1996Colors.ink,
                              fontSize: 48,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: Dell1996Spacing.section),

            // Section untuk Tugas Aktif
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dell1996Spacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TUGAS PERBAIKAN AKTIF',
                        style: Dell1996Typography.heading3,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DaftarTugasPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Lihat Semua',
                          style: Dell1996Typography.link,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dell1996Spacing.md),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('pesanan')
                        .where('status', isNotEqualTo: 'Selesai')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(Dell1996Spacing.lg),
                          decoration: BoxDecoration(
                            color: Dell1996Colors.tintLime,
                            border: Border.all(
                              color: Dell1996Colors.frameInk,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Mantap! Tidak ada tunggakan servis hari ini.',
                            style: Dell1996Typography.body,
                          ),
                        );
                      }

                      var activeOrders = snapshot.data!.docs;

                      return Column(
                        children: activeOrders.map((doc) {
                          var order = doc.data() as Map<String, dynamic>;
                          return Dell1996RibbonCard(
                            title: order['perangkat'] ?? 'LAPTOP',
                            description:
                                'Keluhan: ${order['keluhan'] ?? 'Tidak ada keluhan'}\nStatus: ${order['status'] ?? 'Proses'}',
                            tintColor: _getStatusColor(order['status'] ?? ''),
                            leadingWidget: const Icon(
                              Icons.computer,
                              size: 32,
                              color: Dell1996Colors.ink,
                            ),
                            onTap: () {
                              _showUpdateStatusDialog(
                                context,
                                doc.id,
                                order['status'] ?? '',
                                order['metode_penyerahan'] ?? 'Dijemput',
                                order['metode_pengambilan'] ?? 'Diantar',
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dell1996Spacing.section),

            // Footer
            const Dell1996FooterBand(
              text:
                  'Copyright © 2026 ServisKlik Mitra Dashboard. All rights reserved.',
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu Teknisi':
        return Dell1996Colors.tintSalmon;
      case 'Proses Perbaikan':
        return Dell1996Colors.tintSky;
      case 'Menunggu Pembayaran':
        return Dell1996Colors.tintPeach;
      case 'Sudah Dibayar':
        return Dell1996Colors.tintLime;
      default:
        return Dell1996Colors.tintSteel;
    }
  }

  // =========================================================================
  // TAMPILAN BERANDA UNTUK USER / CUSTOMER - DELL 1996 STYLE
  // =========================================================================
  Widget _buildCustomerHome(String nama) {
    return Scaffold(
      backgroundColor: Dell1996Colors.canvas,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner
            Dell1996TopBanner(
              title: 'HALO, $nama! 👋',
              subtitle: 'Laptopmu kenapa hari ini?',
            ),

            const SizedBox(height: Dell1996Spacing.lg),

            // Section Eyebrow
            const Dell1996SectionEyebrow(
              title: 'PILIH KELUHAN PERANGKAT',
              backgroundColor: Dell1996Colors.tintOlive,
            ),

            const SizedBox(height: Dell1996Spacing.lg),

            // Menu Grid dengan Ribbon Cards
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dell1996Spacing.lg,
              ),
              child: Column(
                children: [
                  // Row 1
                  Row(
                    children: [
                      Expanded(
                        child: _buildMenuRibbonCard(
                          'LAYAR BLANK',
                          Icons.monitor,
                          Dell1996Colors.tintSage,
                        ),
                      ),
                      const SizedBox(width: Dell1996Spacing.sm),
                      Expanded(
                        child: _buildMenuRibbonCard(
                          'BATERAI DROP',
                          Icons.battery_alert,
                          Dell1996Colors.tintSalmon,
                        ),
                      ),
                    ],
                  ),

                  // Row 2
                  Row(
                    children: [
                      Expanded(
                        child: _buildMenuRibbonCard(
                          'MATI TOTAL',
                          Icons.power_off,
                          Dell1996Colors.tintSteel,
                        ),
                      ),
                      const SizedBox(width: Dell1996Spacing.sm),
                      Expanded(
                        child: _buildMenuRibbonCard(
                          'KEYBOARD',
                          Icons.keyboard,
                          Dell1996Colors.tintPeach,
                        ),
                      ),
                    ],
                  ),

                  // Row 3
                  Row(
                    children: [
                      Expanded(
                        child: _buildMenuRibbonCard(
                          'KENA AIR',
                          Icons.water_drop,
                          Dell1996Colors.tintSky,
                        ),
                      ),
                      const SizedBox(width: Dell1996Spacing.sm),
                      Expanded(
                        child: _buildMenuRibbonCard(
                          'KENA VIRUS',
                          Icons.bug_report,
                          Dell1996Colors.tintLime,
                        ),
                      ),
                    ],
                  ),

                  // Row 4
                  Row(
                    children: [
                      Expanded(
                        child: _buildMenuRibbonCard(
                          'AUDIO RUSAK',
                          Icons.volume_off,
                          Dell1996Colors.tintPeriwinkle,
                        ),
                      ),
                      const SizedBox(width: Dell1996Spacing.sm),
                      Expanded(
                        child: _buildMenuRibbonCard(
                          'UPGRADE',
                          Icons.memory,
                          Dell1996Colors.tintOlive,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dell1996Spacing.section),

            // CTA Promo
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dell1996Spacing.lg,
              ),
              child: Dell1996CtaBlockRed(
                text:
                    'PROMO SERVIS BULAN INI! Diskon 20% untuk jasa pembersihan kipas dan ganti pasta thermal. At ServisKlik.com, we\'ll help you find the right service, configure it, price it, and order it online. Klaim sekarang!',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Promo tersedia! Hubungi customer service'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: Dell1996Spacing.section),

            // Artikel Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dell1996Spacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ARTIKEL & TIPS PILIHAN',
                    style: Dell1996Typography.heading3,
                  ),
                  const SizedBox(height: Dell1996Spacing.md),
                  Dell1996RibbonCard(
                    title: 'AWAS OVERHEAT!',
                    description:
                        'Jangan Taruh Laptop di Atas Kasur. Membahas risiko sirkulasi udara laptop tersumbat kasur. From Dell\'s award-winning service and support teams.',
                    tintColor: Dell1996Colors.tintSalmon,
                    leadingWidget: const Dell1996YellowSticker(
                      text: 'NEW!',
                      rotated: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dell1996Spacing.section),

            // Footer
            const Dell1996FooterBand(
              text:
                  'Copyright © 2026 ServisKlik. All rights reserved.\nThis site is best viewed with browser versions 3.0 and higher.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRibbonCard(String title, IconData icon, Color tintColor) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingPage(gejalaLayanan: title),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dell1996Spacing.sm),
        decoration: BoxDecoration(
          border: Border.all(color: Dell1996Colors.frameInk, width: 1),
        ),
        child: Column(
          children: [
            // Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: Dell1996Spacing.s,
                vertical: Dell1996Spacing.xs,
              ),
              decoration: const BoxDecoration(
                color: Dell1996Colors.canvas,
                border: Border(
                  bottom: BorderSide(color: Dell1996Colors.frameInk, width: 1),
                ),
              ),
              child: Text(
                title,
                style: Dell1996Typography.uiLabel,
                textAlign: TextAlign.center,
              ),
            ),
            // Body
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dell1996Spacing.md),
              color: tintColor,
              child: Icon(icon, size: 32, color: Dell1996Colors.ink),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // FUNGSI UNTUK MENGUBAH STATUS OLEH TEKNISI
  // =========================================================================
  void _showUpdateStatusDialog(
    BuildContext context,
    String docId,
    String currentStatus,
    String metodePenyerahan,
    String metodePengambilan,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) {
        String? targetStatus;
        String buttonText = "";
        IconData buttonIcon = Icons.check_circle;

        if (currentStatus == "Menunggu Teknisi") {
          targetStatus = "Proses Perbaikan";
          buttonText = "Mulai Proses Perbaikan";
          buttonIcon = Icons.build;
        } else if (currentStatus == "Proses Perbaikan") {
          targetStatus = "Menunggu Pembayaran";
          buttonText = "Selesai & Input Tagihan";
          buttonIcon = Icons.payments;
        } else if (currentStatus == "Menunggu Pembayaran") {
          targetStatus = null;
          buttonText = "Menunggu Pelanggan Membayar";
          buttonIcon = Icons.hourglass_empty;
        } else if (currentStatus == "Sudah Dibayar") {
          if (metodePengambilan == 'Diantar' ||
              metodePengambilan == 'Dijemput') {
            targetStatus = "Siap Diantar";
            buttonText = "Tandai Siap Diantar";
          } else {
            targetStatus = "Siap Diambil";
            buttonText = "Tandai Siap Diambil";
          }
          buttonIcon = Icons.local_shipping;
        } else if (currentStatus == "Siap Diantar" ||
            currentStatus == "Siap Diambil") {
          targetStatus = "Selesai";
          buttonText = "Selesaikan Pesanan";
          buttonIcon = Icons.done_all;
        } else if (currentStatus == "Selesai") {
          targetStatus = null;
          buttonText = "Pesanan Telah Selesai";
          buttonIcon = Icons.verified;
        } else if (currentStatus == "Dibatalkan") {
          targetStatus = "DELETE";
          buttonText = "Hapus Data Ini";
          buttonIcon = Icons.delete;
        } else {
          targetStatus = null;
          buttonText = "Status Tidak Diketahui";
          buttonIcon = Icons.error;
        }

        return Container(
          decoration: BoxDecoration(
            color: Dell1996Colors.canvas,
            border: Border.all(color: Dell1996Colors.frameInk, width: 2),
          ),
          padding: const EdgeInsets.all(Dell1996Spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UPDATE FASE PERBAIKAN',
                style: Dell1996Typography.heading2,
              ),
              const SizedBox(height: Dell1996Spacing.sm),
              Text(
                'Status Saat Ini: $currentStatus\nPenyerahan: $metodePenyerahan\nPengembalian: $metodePengambilan',
                style: Dell1996Typography.body,
              ),
              const SizedBox(height: Dell1996Spacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(buttonIcon),
                  label: Text(buttonText),
                  onPressed: targetStatus == null
                      ? null
                      : () async {
                          if (targetStatus == "Menunggu Pembayaran") {
                            Navigator.pop(context);
                            _tampilkanPopUpTagihan(context, docId);
                          } else if (targetStatus == "DELETE") {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('pesanan')
                                  .doc(docId)
                                  .delete();

                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Pesanan yang dibatalkan berhasil dihapus",
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint("Error hapus: $e");
                            }
                          } else {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('pesanan')
                                  .doc(docId)
                                  .update({'status': targetStatus});

                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Status berhasil diubah ke: $targetStatus",
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint("Error update: $e");
                            }
                          }
                        },
                ),
              ),
              const SizedBox(height: Dell1996Spacing.sm),
            ],
          ),
        );
      },
    );
  }

  void _tampilkanPopUpTagihan(BuildContext context, String docId) {
    final TextEditingController hargaController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: Dell1996Colors.canvas,
          title: Text(
            'INPUT BIAYA SERVIS',
            style: Dell1996Typography.heading2,
          ),
          content: TextField(
            controller: hargaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Total Biaya Perbaikan (Rp)",
              prefixText: "Rp ",
              hintText: "Contoh: 350000",
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('BATAL'),
            ),
            ElevatedButton(
              onPressed: () async {
                String hargaText =
                    hargaController.text.trim().replaceAll('.', '');
                if (hargaText.isEmpty) return;

                int biaya = int.parse(hargaText);

                await FirebaseFirestore.instance
                    .collection('pesanan')
                    .doc(docId)
                    .update({
                  'status': 'Menunggu Pembayaran',
                  'biaya_servis': biaya,
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Tagihan biaya berhasil dikirim ke pelanggan!",
                      ),
                    ),
                  );
                }
              },
              child: const Text('KIRIM TAGIHAN'),
            ),
          ],
        );
      },
    );
  }
}
