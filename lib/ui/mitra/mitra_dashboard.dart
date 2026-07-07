import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class MitraDashboard extends StatelessWidget {
  const MitraDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              const Dell1996TopBanner(
                title: 'LAPORAN KEUANGAN',
                subtitle: 'Ringkasan Omzet Teknisi',
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pesanan')
                      .orderBy('waktu_pesan', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("Belum ada data pesanan."));
                    }

                    var pesananList = snapshot.data!.docs.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return data['total_bayar_akhir'] != null || data['biaya_servis'] != null;
                    }).toList();

                    if (pesananList.isEmpty) {
                      return const Center(child: Text("Belum ada data pesanan dengan tagihan."));
                    }

                    int totalPendapatan = 0;
                    int totalPesananSelesai = 0;

                    for (var doc in pesananList) {
                      var data = doc.data() as Map<String, dynamic>;
                      if (data['status'] == 'Selesai') {
                        totalPesananSelesai++;
                        totalPendapatan += (data['total_bayar_akhir'] ?? data['biaya_servis'] ?? 0) as int;
                      }
                    }

                    final formatRupiah = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- 1. KARTU REKAP PENDAPATAN (HEADER) ---
                        Container(
                          margin: const EdgeInsets.all(Dell1996Spacing.lg),
                          padding: const EdgeInsets.all(Dell1996Spacing.lg),
                          decoration: BoxDecoration(
                            color: Dell1996Colors.yellowSticker,
                            border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("TOTAL OMZET (SELESAI)", style: Dell1996Typography.uiLabel),
                              const SizedBox(height: Dell1996Spacing.xs),
                              Text(
                                formatRupiah.format(totalPendapatan),
                                style: Dell1996Typography.heading1.copyWith(color: Dell1996Colors.primary),
                              ),
                              const SizedBox(height: Dell1996Spacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: const BoxDecoration(color: Dell1996Colors.frameInk),
                                child: Text(
                                  "$totalPesananSelesai PESANAN SELESAI",
                                  style: Dell1996Typography.uiLabel.copyWith(color: Dell1996Colors.canvas),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dell1996Spacing.lg),
                          child: const Dell1996SectionEyebrow(
                            title: 'DAFTAR TRANSAKSI',
                            backgroundColor: Dell1996Colors.tintSky,
                          ),
                        ),

                        // --- 2. DAFTAR SELURUH TRANSAKSI (READ-ONLY) ---
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(Dell1996Spacing.lg),
                            itemCount: pesananList.length,
                            itemBuilder: (context, index) {
                              var data = pesananList[index].data() as Map<String, dynamic>;
                              
                              String waktuPesan = "-";
                              if (data['waktu_pesan'] != null) {
                                DateTime dt = (data['waktu_pesan'] as Timestamp).toDate();
                                waktuPesan = DateFormat('dd MMM yyyy, HH:mm').format(dt);
                              }

                              String status = data['status'] ?? '-';
                              Color tintColor = status == 'Selesai' ? Dell1996Colors.tintLime : Dell1996Colors.tintPeach;

                              return Container(
                                margin: const EdgeInsets.only(bottom: Dell1996Spacing.md),
                                decoration: BoxDecoration(
                                  color: tintColor,
                                  border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: Dell1996Spacing.md, vertical: Dell1996Spacing.xs),
                                      decoration: const BoxDecoration(
                                        color: Dell1996Colors.canvas,
                                        border: Border(bottom: BorderSide(color: Dell1996Colors.frameInk, width: 1)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              (data['perangkat'] ?? 'LAPTOP').toString().toUpperCase(),
                                              style: Dell1996Typography.heading3,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(waktuPesan, style: Dell1996Typography.bodySm),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(Dell1996Spacing.md),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("PELANGGAN: ${data['nama_user'] ?? 'Pelanggan'}", style: Dell1996Typography.uiLabel),
                                          const SizedBox(height: Dell1996Spacing.xs),
                                          Text("KELUHAN: ${data['keluhan'] ?? '-'}", style: Dell1996Typography.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                                          const Divider(color: Dell1996Colors.frameInk, thickness: 1, height: 20),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                color: Dell1996Colors.frameInk,
                                                child: Text(
                                                  status.toUpperCase(),
                                                  style: Dell1996Typography.uiLabel.copyWith(color: Dell1996Colors.canvas),
                                                ),
                                              ),
                                              if (data['total_bayar_akhir'] != null || data['biaya_servis'] != null)
                                                Text(
                                                  formatRupiah.format(data['total_bayar_akhir'] ?? data['biaya_servis']),
                                                  style: Dell1996Typography.heading3,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dell1996Spacing.lg),
                child: Dell1996ButtonPrimary(
                  text: 'KEMBALI KE MENU',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Dell1996FooterBand(text: 'Sistem Terpadu Teknisi Internal.'),
            ],
          ),
        ),
      ),
    );
  }
}
