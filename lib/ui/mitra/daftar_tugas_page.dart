import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class DaftarTugasPage extends StatelessWidget {
  const DaftarTugasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Dell1996PageFrame(
        child: Scaffold(
          backgroundColor: Dell1996Colors.canvas,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Dell1996TopBanner(
                  title: 'DAFTAR TUGAS',
                  subtitle: 'Manajemen perbaikan perangkat pelanggan',
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Dell1996Colors.canvas,
                    border: Border(bottom: BorderSide(color: Dell1996Colors.frameInk, width: 2)),
                  ),
                  child: TabBar(
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: Dell1996Colors.tintSky,
                      border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                    ),
                    indicatorPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    labelColor: Dell1996Colors.ink,
                    unselectedLabelColor: Dell1996Colors.ink,
                    labelStyle: Dell1996Typography.uiLabel,
                    unselectedLabelStyle: Dell1996Typography.uiLabel,
                    tabs: const [
                      Tab(text: "MENUNGGU"),
                      Tab(text: "PROSES"),
                      Tab(text: "MENUNGGU BAYAR"),
                      Tab(text: "SELESAI"),
                    ],
                  ),
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      _ListTugas(statusFilter: 'Menunggu Teknisi'),
                      _ListTugas(statusFilter: 'Proses Perbaikan'),
                      _ListTugas(statusFilter: 'Menunggu Pembayaran'),
                      _ListTugas(statusFilter: 'Selesai'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListTugas extends StatelessWidget {
  final String statusFilter;
  const _ListTugas({required this.statusFilter});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pesanan')
          .where('status', isEqualTo: statusFilter)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inbox, size: 64, color: Dell1996Colors.frameInk),
                const SizedBox(height: Dell1996Spacing.sm),
                Text(
                  "Tidak ada tugas di tahap ini.",
                  style: Dell1996Typography.body,
                ),
              ],
            ),
          );
        }

        var orders = snapshot.data!.docs.toList();

        orders.sort((a, b) {
          var dataA = a.data() as Map<String, dynamic>;
          var dataB = b.data() as Map<String, dynamic>;
          Timestamp? timeA = dataA['waktu_pesan'] as Timestamp?;
          Timestamp? timeB = dataB['waktu_pesan'] as Timestamp?;
          
          if (timeA == null && timeB == null) return 0;
          if (timeA == null) return 1;
          if (timeB == null) return -1;
          
          return timeB.compareTo(timeA);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(Dell1996Spacing.lg),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var data = orders[index].data() as Map<String, dynamic>;
            
            Color tintColor;
            switch (statusFilter) {
              case 'Menunggu Teknisi':
                tintColor = Dell1996Colors.tintPeach;
                break;
              case 'Proses Perbaikan':
                tintColor = Dell1996Colors.tintSky;
                break;
              case 'Selesai':
                tintColor = Dell1996Colors.tintLime;
                break;
              default:
                tintColor = Dell1996Colors.tintSalmon;
            }

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
                    padding: const EdgeInsets.all(Dell1996Spacing.md),
                    decoration: const BoxDecoration(
                      color: Dell1996Colors.canvas,
                      border: Border(bottom: BorderSide(color: Dell1996Colors.frameInk, width: 1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            (data['perangkat'] ?? 'PERANGKAT').toString().toUpperCase(),
                            style: Dell1996Typography.heading3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          color: Dell1996Colors.frameInk,
                          child: Text(
                            statusFilter.toUpperCase(),
                            style: Dell1996Typography.uiLabel.copyWith(color: Dell1996Colors.canvas),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dell1996Spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (data['kategori'] != null && data['kategori'].toString().trim().isNotEmpty) ...[
                          Text("KATEGORI: ${(data['kategori']).toString().toUpperCase()}", style: Dell1996Typography.uiLabel),
                          const SizedBox(height: Dell1996Spacing.xs),
                        ],
                        if (data['keluhan'] != null && data['keluhan'].toString().trim().isNotEmpty) ...[
                          Text("KELUHAN: ${data['keluhan']}", style: Dell1996Typography.body),
                          const SizedBox(height: Dell1996Spacing.xs),
                        ],
                        if (data['alamat'] != null && data['alamat'].toString().trim().isNotEmpty) ...[
                          Text("ALAMAT: ${data['alamat']}", style: Dell1996Typography.body),
                          const SizedBox(height: Dell1996Spacing.xs),
                        ],
                        const Divider(color: Dell1996Colors.frameInk, thickness: 1, height: 20),
                        Text(
                          "PELANGGAN: ${(data['nama_user'] ?? 'Anonim').toString().toUpperCase()}",
                          style: Dell1996Typography.uiLabel,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
