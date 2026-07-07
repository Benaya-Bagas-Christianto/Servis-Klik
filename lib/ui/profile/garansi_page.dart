import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GaransiPage extends StatefulWidget {
  const GaransiPage({super.key});

  @override
  State<GaransiPage> createState() => _GaransiPageState();
}

class _GaransiPageState extends State<GaransiPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Fungsi untuk memunculkan pop-up Form Pengajuan Klaim
  void _showFormKlaim() {
    final TextEditingController perangkatCtrl = TextEditingController();
    final TextEditingController seriCtrl = TextEditingController();
    final TextEditingController alasanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Ajukan Klaim Garansi", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: perangkatCtrl,
                  decoration: const InputDecoration(labelText: "Merek & Tipe (Cth: Asus ROG)"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: seriCtrl,
                  decoration: const InputDecoration(labelText: "Nomor Seri (S/N)"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: alasanCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: "Alasan Klaim"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () async {
                if (perangkatCtrl.text.isEmpty || seriCtrl.text.isEmpty || alasanCtrl.text.isEmpty) return;

                // 👇 PROSES MENGAMBIL NAMA USER SEBELUM DISIMPAN
                String namaUser = "Pelanggan";
                if (currentUser != null) {
                  var userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
                  if (userDoc.exists) {
                    namaUser = userDoc.data()?['nama'] ?? 'Pelanggan';
                  }
                }

                // Kirim data ke Firestore
                await FirebaseFirestore.instance.collection('klaim_garansi').add({
                  'email_user': currentUser?.email ?? 'Unknown',
                  'nama_user': namaUser, // 🔥 Nama otomatis tersimpan di sini!
                  'perangkat': perangkatCtrl.text,
                  'nomor_seri': seriCtrl.text,
                  'alasan': alasanCtrl.text,
                  'status': 'Menunggu Peninjauan',
                  'waktu_klaim': FieldValue.serverTimestamp(),
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Klaim garansi berhasil diajukan!"), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text("Kirim Klaim", style: TextStyle(color: Colors.white)),
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
        title: const Text("Klaim Garansi Digital", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFormKlaim,
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Ajukan Klaim", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('klaim_garansi').where('email_user', isEqualTo: currentUser?.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Anda belum pernah mengajukan klaim garansi.", style: TextStyle(color: Colors.grey)));
          }

          var klaimList = snapshot.data!.docs.where((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return data['is_deleted'] != true;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: klaimList.length,
            itemBuilder: (context, index) {
              var data = klaimList[index].data() as Map<String, dynamic>;
              String status = data['status'] ?? 'Menunggu Peninjauan';

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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: status == 'Disetujui' ? Colors.green.withValues(alpha: 0.1) : status == 'Ditolak' ? Colors.red.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: status == 'Disetujui' ? Colors.green : status == 'Ditolak' ? Colors.red : Colors.orange,
                                fontWeight: FontWeight.bold, fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text("S/N: ${data['nomor_seri'] ?? '-'}"),
                      Text("Alasan: ${data['alasan'] ?? '-'}", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
