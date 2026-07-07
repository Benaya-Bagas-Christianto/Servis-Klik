import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class RiwayatServisPage extends StatelessWidget {
  const RiwayatServisPage({super.key});

  void _deleteRiwayat(BuildContext context, String docId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Dell1996Colors.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text("HAPUS RIWAYAT", style: Dell1996Typography.heading2),
        content: Text(
          "Apakah Anda yakin ingin menyembunyikan riwayat servis ini?",
          style: Dell1996Typography.body,
        ),
        actions: [
          Dell1996ButtonPrimary(
            text: "BATAL",
            onPressed: () => Navigator.pop(context, false),
          ),
          Dell1996ButtonPrimary(
            text: "HAPUS",
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('pesanan').doc(docId).update({
          'is_deleted': true
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("RIWAYAT BERHASIL DIHAPUS.", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
              backgroundColor: Dell1996Colors.primary,
            ),
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
          child: Column(
            children: [
              const Dell1996TopBanner(
                title: 'RIWAYAT SERVIS',
                subtitle: 'Data Pesanan Selesai',
              ),
              Expanded(
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Dell1996Colors.primary));
                    }
          
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
                              "BELUM ADA RIWAYAT SERVIS.",
                              style: Dell1996Typography.body,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
          
                        var allOrders = snapshot.data!.docs;
                        
                        var riwayatList = allOrders.where((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          bool isSelesai = data['status'] == 'Selesai';
                          bool isDeleted = data['is_deleted'] == true;
                          return isSelesai && !isDeleted;
                        }).toList();
          
                        if (riwayatList.isEmpty) {
                          return Container(
                            margin: const EdgeInsets.all(Dell1996Spacing.lg),
                            padding: const EdgeInsets.all(Dell1996Spacing.lg),
                            decoration: BoxDecoration(
                              color: Dell1996Colors.canvas,
                              border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                            ),
                            child: Text(
                              "BELUM ADA RIWAYAT SERVIS YANG SELESAI.",
                              style: Dell1996Typography.body,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
          
                        return ListView.builder(
                          padding: const EdgeInsets.all(Dell1996Spacing.lg),
                          itemCount: riwayatList.length,
                          itemBuilder: (context, index) {
                            var data = riwayatList[index].data() as Map<String, dynamic>;
                            String namaPelanggan = data['nama_user'] ?? 'Pelanggan';
          
                            String tanggalSelesai = "TANGGAL TIDAK DIKETAHUI";
                            if (data['waktu_pesan'] != null) {
                              DateTime dt = (data['waktu_pesan'] as Timestamp).toDate();
                              tanggalSelesai = DateFormat('dd MMM yyyy, HH:mm').format(dt).toUpperCase();
                            }
          
                            return Container(
                              margin: const EdgeInsets.only(bottom: Dell1996Spacing.md),
                              padding: const EdgeInsets.all(Dell1996Spacing.md),
                              decoration: BoxDecoration(
                                color: Dell1996Colors.tintSky,
                                border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (data['perangkat'] ?? 'Laptop').toString().toUpperCase(),
                                        style: Dell1996Typography.heading3,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Dell1996Colors.tintLime,
                                              border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                                            ),
                                            child: Text("SELESAI", style: Dell1996Typography.uiLabel),
                                          ),
                                          const SizedBox(width: Dell1996Spacing.sm),
                                          InkWell(
                                            onTap: () => _deleteRiwayat(context, riwayatList[index].id),
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Dell1996Colors.primary,
                                                border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                                              ),
                                              child: const Icon(Icons.close, color: Dell1996Colors.canvas, size: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Dell1996Colors.frameInk, thickness: 1, height: Dell1996Spacing.lg),
                                  if (role == 'mitra') ...[
                                    Text("PEMILIK: ${namaPelanggan.toUpperCase()}", style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: Dell1996Spacing.xs),
                                  ],
                                  Text("TANGGAL: $tanggalSelesai", style: Dell1996Typography.body),
                                  if (data['kategori'] != null && data['kategori'].toString().trim().isNotEmpty) ...[
                                    const SizedBox(height: Dell1996Spacing.xs),
                                    Text("KATEGORI: ${(data['kategori']).toString().toUpperCase()}", style: Dell1996Typography.body),
                                  ],
                                  if (data['keluhan'] != null && data['keluhan'].toString().trim().isNotEmpty) ...[
                                    const SizedBox(height: Dell1996Spacing.xs),
                                    Text("KELUHAN: ${(data['keluhan']).toString().toUpperCase()}", style: Dell1996Typography.body),
                                  ],
                                  if (data['alamat'] != null && data['alamat'].toString().trim().isNotEmpty) ...[
                                    const SizedBox(height: Dell1996Spacing.xs),
                                    Text("ALAMAT: ${(data['alamat']).toString().toUpperCase()}", style: Dell1996Typography.body),
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
