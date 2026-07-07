import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RiwayatServisPage extends StatelessWidget {
  const RiwayatServisPage({super.key});

  void _deleteRiwayat(BuildContext context, String docId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Riwayat"),
        content: const Text("Apakah Anda yakin ingin menyembunyikan riwayat servis ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // 👇 PENERAPAN SOFT DELETE UNTUK RIWAYAT: Data disembunyikan pakai update
        await FirebaseFirestore.instance.collection('pesanan').doc(docId).update({
          'is_deleted': true
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Riwayat berhasil dihapus dari tampilan Anda.")),
          );
        }
      } catch (e) {
        debugPrint("Error hapus riwayat: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return const Scaffold(body: Center(child: Text("Silakan login")));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Servis", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          String role = 'user';
          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            role = (userSnapshot.data!.data() as Map<String, dynamic>)['role'] ?? 'user';
          }

          Stream<QuerySnapshot> streamRiwayat;
          if (role == 'mitra') {
            streamRiwayat = FirebaseFirestore.instance.collection('pesanan').snapshots();
          } else {
            streamRiwayat = FirebaseFirestore.instance.collection('pesanan').where('email_user', isEqualTo: currentUser.email).snapshots();
          }

          return StreamBuilder<QuerySnapshot>(
            stream: streamRiwayat,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("Belum ada riwayat servis.", style: TextStyle(color: Colors.grey)));
              }

              var allOrders = snapshot.data!.docs;
              
              // 👇 FILTERING: Hanya tampilkan status Selesai yang BELUM disembunyikan
              var riwayatList = allOrders.where((doc) {
                var data = doc.data() as Map<String, dynamic>;
                bool isSelesai = data['status'] == 'Selesai';
                bool isDeleted = data['is_deleted'] == true;
                return isSelesai && !isDeleted;
              }).toList();

              if (riwayatList.isEmpty) {
                return const Center(child: Text("Belum ada riwayat servis yang selesai.", style: TextStyle(color: Colors.grey)));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: riwayatList.length,
                itemBuilder: (context, index) {
                  var data = riwayatList[index].data() as Map<String, dynamic>;
                  String namaPelanggan = data['nama_user'] ?? 'Pelanggan';

                  String tanggalSelesai = "Tanggal tidak diketahui";
                  if (data['waktu_pesan'] != null) {
                    DateTime dt = (data['waktu_pesan'] as Timestamp).toDate();
                    tanggalSelesai = DateFormat('dd MMM yyyy, HH:mm').format(dt);
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
                              Text(data['perangkat'] ?? 'Laptop', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                                    child: const Text("Selesai", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    onPressed: () => _deleteRiwayat(context, riwayatList[index].id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          if (role == 'mitra') ...[
                            Text("Pemilik: $namaPelanggan", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                            const SizedBox(height: 5),
                          ],
                          Text("Tanggal: $tanggalSelesai", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          if (data['kategori'] != null && data['kategori'].toString().trim().isNotEmpty) ...[
                            Text("Kategori: ${data['kategori']}"),
                            const SizedBox(height: 5),
                          ],
                          if (data['keluhan'] != null && data['keluhan'].toString().trim().isNotEmpty) ...[
                            Text("Keluhan: ${data['keluhan']}"),
                            const SizedBox(height: 5),
                          ],
                          if (data['alamat'] != null && data['alamat'].toString().trim().isNotEmpty) ...[
                            Text("Alamat: ${data['alamat']}"),
                            const SizedBox(height: 5),
                          ],
                        ], // 👈 KEMBALIKAN KURUNG SIKU INI
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
