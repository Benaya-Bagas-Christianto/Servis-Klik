import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class KelolaGaransiPage extends StatelessWidget {
  const KelolaGaransiPage({super.key});

  Future<void> _updateGaransiStatus(String docId, String statusBaru) async {
    await FirebaseFirestore.instance.collection('klaim_garansi').doc(docId).update({'status': statusBaru});
  }

  Future<void> _softDeleteGaransi(BuildContext context, String docId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Dell1996Colors.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text("ARSIPKAN DATA", style: Dell1996Typography.heading2),
        content: Text("Sembunyikan laporan garansi ini dari daftar Anda?", style: Dell1996Typography.body),
        actions: [
          Dell1996ButtonPrimary(
            text: "BATAL",
            onPressed: () => Navigator.pop(context, false),
          ),
          Dell1996ButtonPrimary(
            text: "SEMBUNYIKAN",
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('klaim_garansi').doc(docId).update({'is_deleted': true});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("DATA GARANSI BERHASIL DIARSIPKAN.", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
            backgroundColor: Dell1996Colors.primary,
          ),
        );
      }
    }
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
                title: 'KELOLA GARANSI',
                subtitle: 'Daftar Klaim Pelanggan',
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('klaim_garansi').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Dell1996Colors.primary));
                    }
          
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.all(Dell1996Spacing.lg),
                        padding: const EdgeInsets.all(Dell1996Spacing.lg),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                        ),
                        child: Text(
                          "TIDAK ADA PENGAJUAN KLAIM GARANSI.",
                          style: Dell1996Typography.body,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
          
                    var klaimList = snapshot.data!.docs.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      return data['is_deleted'] != true;
                    }).toList();
          
                    if (klaimList.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.all(Dell1996Spacing.lg),
                        padding: const EdgeInsets.all(Dell1996Spacing.lg),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                        ),
                        child: Text(
                          "SEMUA DATA GARANSI TELAH DIARSIPKAN.",
                          style: Dell1996Typography.body,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
          
                    return ListView.builder(
                      padding: const EdgeInsets.all(Dell1996Spacing.lg),
                      itemCount: klaimList.length,
                      itemBuilder: (context, index) {
                        var data = klaimList[index].data() as Map<String, dynamic>;
                        String docId = klaimList[index].id;
                        String status = data['status'] ?? 'Menunggu Peninjauan';
                        String emailUser = data['email_user'] ?? '';
                        String namaUser = data['nama_user'] ?? '';
                        
                        Color statusColor = Dell1996Colors.canvas;
                        if (status == 'Disetujui') statusColor = Dell1996Colors.tintLime;
                        if (status == 'Ditolak') statusColor = Dell1996Colors.tintPeach;
          
                        // 👇 LOGIKA UNTUK MENANGANI DATA LAMA YANG BELUM ADA NAMA-NYA
                        return FutureBuilder<QuerySnapshot>(
                          future: namaUser.isEmpty
                              ? FirebaseFirestore.instance.collection('users').where('email', isEqualTo: emailUser.trim()).limit(1).get()
                              : null,
                          builder: (context, userSnap) {
                            String displayNama = namaUser;
                            if (displayNama.isEmpty) {
                              if (userSnap.connectionState == ConnectionState.waiting) {
                                displayNama = "MEMUAT NAMA...";
                              } else if (userSnap.hasData && userSnap.data!.docs.isNotEmpty) {
                                var userData = userSnap.data!.docs.first.data() as Map<String, dynamic>;
                                displayNama = userData['nama'] ?? emailUser;
                              } else {
                                displayNama = emailUser; // Jika nama tetap tidak ditemukan, pakai email
                              }
                            }
          
                            return Container(
                              margin: const EdgeInsets.only(bottom: Dell1996Spacing.md),
                              padding: const EdgeInsets.all(Dell1996Spacing.md),
                              decoration: BoxDecoration(
                                color: statusColor,
                                border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text((data['perangkat'] ?? 'Perangkat').toString().toUpperCase(), style: Dell1996Typography.heading3),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Dell1996Colors.canvas,
                                              border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                                            ),
                                            child: Text(
                                              status.toUpperCase(),
                                              style: Dell1996Typography.uiLabel,
                                            ),
                                          ),
                                          if (status != 'Menunggu Peninjauan') ...[
                                            const SizedBox(width: Dell1996Spacing.sm),
                                            InkWell(
                                              onTap: () => _softDeleteGaransi(context, docId),
                                              child: Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Dell1996Colors.primary,
                                                  border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                                                ),
                                                child: const Icon(Icons.close, color: Dell1996Colors.canvas, size: 16),
                                              ),
                                            ),
                                          ]
                                        ],
                                      )
                                    ],
                                  ),
                                  const Divider(color: Dell1996Colors.frameInk, thickness: 1, height: Dell1996Spacing.lg),
                                  
                                  // 🔥 MENAMPILKAN NAMA USER DI DASHBOARD TEKNISI
                                  Text("PEMILIK: ${displayNama.toUpperCase()}", style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold)),
                                  
                                  const SizedBox(height: Dell1996Spacing.xs),
                                  Text("NO. SERI: ${data['nomor_seri'] ?? '-'}", style: Dell1996Typography.body),
                                  const SizedBox(height: Dell1996Spacing.xs),
                                  Text("ALASAN KLAIM: ${data['alasan'] ?? '-'}", style: Dell1996Typography.body),
          
                                  if (status == 'Menunggu Peninjauan') ...[
                                    const SizedBox(height: Dell1996Spacing.md),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => _updateGaransiStatus(docId, 'Ditolak'),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: Dell1996Spacing.sm),
                                              decoration: BoxDecoration(
                                                color: Dell1996Colors.canvas,
                                                border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text("TOLAK", style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold, color: Dell1996Colors.primary)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: Dell1996Spacing.sm),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => _updateGaransiStatus(docId, 'Disetujui'),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: Dell1996Spacing.sm),
                                              decoration: BoxDecoration(
                                                color: Dell1996Colors.frameInk,
                                                border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text("SETUJUI", style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold, color: Dell1996Colors.canvas)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(Dell1996Spacing.md),
                color: Dell1996Colors.canvas,
                child: Dell1996ButtonPrimary(
                  text: 'KEMBALI KE MENU',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
