import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KelolaGaransiPage extends StatelessWidget {
  const KelolaGaransiPage({super.key});

  Future<void> _updateGaransiStatus(String docId, String statusBaru) async {
    await FirebaseFirestore.instance.collection('klaim_garansi').doc(docId).update({'status': statusBaru});
  }

  Future<void> _softDeleteGaransi(BuildContext context, String docId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Arsipkan Data"),
        content: const Text("Sembunyikan laporan garansi ini dari daftar Anda?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Sembunyikan")),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('klaim_garansi').doc(docId).update({'is_deleted': true});
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data garansi berhasil diarsipkan.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Klaim Garansi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('klaim_garansi').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user_outlined, size: 70, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Tidak ada pengajuan klaim garansi.", style: TextStyle(color: Colors.grey, fontSize: 15)),
                ],
              ),
            );
          }

          var klaimList = snapshot.data!.docs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['is_deleted'] != true;
          }).toList();

          if (klaimList.isEmpty) {
            return const Center(child: Text("Semua data garansi telah diarsipkan.", style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: klaimList.length,
            itemBuilder: (context, index) {
              var data = klaimList[index].data() as Map<String, dynamic>;
              String docId = klaimList[index].id;
              String status = data['status'] ?? 'Menunggu Peninjauan';
              String emailUser = data['email_user'] ?? '';
              String namaUser = data['nama_user'] ?? '';

              // 👇 LOGIKA UNTUK MENANGANI DATA LAMA YANG BELUM ADA NAMA-NYA
              return FutureBuilder<QuerySnapshot>(
                future: namaUser.isEmpty
                    ? FirebaseFirestore.instance.collection('users').where('email', isEqualTo: emailUser.trim()).limit(1).get()
                    : null,
                builder: (context, userSnap) {
                  String displayNama = namaUser;
                  if (displayNama.isEmpty) {
                    if (userSnap.connectionState == ConnectionState.waiting) {
                      displayNama = "Memuat nama...";
                    } else if (userSnap.hasData && userSnap.data!.docs.isNotEmpty) {
                      var userData = userSnap.data!.docs.first.data() as Map<String, dynamic>;
                      displayNama = userData['nama'] ?? emailUser;
                    } else {
                      displayNama = emailUser; // Jika nama tetap tidak ditemukan, pakai email
                    }
                  }

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data['perangkat'] ?? 'Perangkat', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: status == 'Disetujui' ? Colors.green.withValues(alpha: 0.1) : status == 'Ditolak' ? Colors.red.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(color: status == 'Disetujui' ? Colors.green : status == 'Ditolak' ? Colors.red : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                  if (status != 'Menunggu Peninjauan') ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onPressed: () => _softDeleteGaransi(context, docId),
                                    )
                                  ]
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          
                          // 🔥 MENAMPILKAN NAMA USER DI DASHBOARD TEKNISI
                          Text("Pemilik: $displayNama", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                          
                          const SizedBox(height: 4),
                          Text("No. Seri: ${data['nomor_seri'] ?? '-'}"),
                          Text("Alasan Klaim: ${data['alasan'] ?? '-'}"),

                          if (status == 'Menunggu Peninjauan') ...[
                            const Divider(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => _updateGaransiStatus(docId, 'Ditolak'),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: const Text("Tolak"),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => _updateGaransiStatus(docId, 'Disetujui'),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text("Setujui", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
