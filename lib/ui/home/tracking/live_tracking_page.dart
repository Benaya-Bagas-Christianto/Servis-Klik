import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LiveTrackingPage extends StatelessWidget {
  const LiveTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("Silakan login"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tracking Servis",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          String role = 'user';
          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            role = (userSnapshot.data!.data() as Map<String, dynamic>)['role'] ?? 'user';
          }

          Stream<QuerySnapshot> streamPesanan;
          if (role == 'mitra') {
            streamPesanan = FirebaseFirestore.instance.collection('pesanan').snapshots();
          } else {
            streamPesanan = FirebaseFirestore.instance
                .collection('pesanan')
                .where('email_user', isEqualTo: currentUser.email)
                .snapshots();
          }

          return StreamBuilder<QuerySnapshot>(
            stream: streamPesanan,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Belum ada perangkat yang sedang diservis.", style: TextStyle(color: Colors.grey)),
                );
              }

              var allOrders = snapshot.data!.docs;
              
              // 👇 PENERAPAN FILTER SOFT DELETE & FILTER SELESAI
              var activeOrders = allOrders.where((doc) {
                var data = doc.data() as Map<String, dynamic>;
                bool isSelesai = data['status'] == 'Selesai';
                bool isDibatalkan = data['status'] == 'Dibatalkan';
                bool isDeleted = data['is_deleted'] == true;
                
                // Hanya tampilkan yang BELUM selesai, BELUM dibatalkan, dan TIDAK dihapus
                return !isSelesai && !isDibatalkan && !isDeleted;
              }).toList();

              if (activeOrders.isEmpty) {
                return const Center(
                  child: Text("Belum ada perangkat yang sedang diservis.", style: TextStyle(color: Colors.grey)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: activeOrders.length,
                itemBuilder: (context, index) {
                  var data = activeOrders[index].data() as Map<String, dynamic>;
                  String namaPelanggan = data['nama_user'] ?? 'Pelanggan';

                  int biayaServis = data['biaya_servis'] ?? 0;
                  String metode = data['metode_penyerahan'] ?? 'Dijemput';
                  int ongkir = (metode == 'Dijemput') ? 20000 : 0;
                  int totalBayar = biayaServis + ongkir;

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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: data['status'] == 'Menunggu Pembayaran' ? Colors.purple.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  data['status'] ?? 'Proses',
                                  style: TextStyle(
                                    color: data['status'] == 'Menunggu Pembayaran' ? Colors.purple : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          if (role == 'mitra') ...[
                            Text("Pemilik: $namaPelanggan", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                            const SizedBox(height: 5),
                          ],
                          Text("Kategori: ${data['kategori'] ?? '-'}"),
                          const SizedBox(height: 5),
                          Text("Keluhan: ${data['keluhan'] ?? '-'}"),

                          // TOMBOL BATALKAN PESANAN
                          if (data['status'] == 'Menunggu Teknisi' && role == 'user') ...[
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.redAccent),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.cancel, size: 18),
                                label: const Text("Batalkan Pesanan", style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  _konfirmasiBatal(context, activeOrders[index].id);
                                },
                              ),
                            ),
                          ],

                          // NOTA PEMBAYARAN
                          if (data['status'] == 'Menunggu Pembayaran' && role == 'user') ...[
                            Divider(height: 25, thickness: 1, color: Colors.purple.shade200),
                            const Text("Rincian Nota Tagihan:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                            const SizedBox(height: 8),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Biaya Servis"), Text("Rp $biayaServis")]),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Ongkos Kirim ($metode)"), Text("Rp $ongkir")]),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total Tagihan", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("Rp $totalBayar", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
                                label: const Text("Pilih Pembayaran & Konfirmasi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  _tampilkanPopUpBayarUser(context, activeOrders[index].id, metode, totalBayar);
                                },
                              ),
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

  void _tampilkanPopUpBayarUser(BuildContext context, String docId, String metode, int total) {
    String metodePembayaranTerpilih = "COD";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total yang harus dibayar: Rp $total", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.purple)),
                  const SizedBox(height: 15),
                  RadioListTile<String>(
                    title: const Text("COD (Bayar Tunai)"),
                    secondary: const Icon(Icons.money, color: Colors.green),
                    value: "COD",
                    groupValue: metodePembayaranTerpilih,
                    onChanged: (value) => setStateDialog(() => metodePembayaranTerpilih = value!),
                  ),
                  RadioListTile<String>(
                    title: const Text("Transfer Bank (Simulasi VA)"),
                    secondary: const Icon(Icons.credit_card, color: Colors.blue),
                    value: "Transfer",
                    groupValue: metodePembayaranTerpilih,
                    onChanged: (value) => setStateDialog(() => metodePembayaranTerpilih = value!),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    String statusSelanjutnya = 'Sudah Dibayar';
                    await FirebaseFirestore.instance.collection('pesanan').doc(docId).update({
                      'status': statusSelanjutnya,
                      'metode_pembayaran_pilihan': metodePembayaranTerpilih,
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Pembayaran via $metodePembayaranTerpilih Berhasil!"), backgroundColor: Colors.green),
                      );
                    }
                  },
                  child: const Text("Konfirmasi Bayar", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _konfirmasiBatal(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Batalkan Pesanan?"),
          content: const Text("Apakah Anda yakin ingin membatalkan pesanan servis ini? Data pesanan akan dihapus dan teknisi tidak akan datang."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("Tutup")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                Navigator.pop(dialogContext);
                try {
                  // 👇 PENERAPAN SOFT DELETE: Mengubah status dan memberi tanda is_deleted
                  await FirebaseFirestore.instance.collection('pesanan').doc(docId).update({
                    'status': 'Dibatalkan',
                    'is_deleted': true 
                  });

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pesanan berhasil dibatalkan."), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  debugPrint("Error membatalkan pesanan: $e");
                }
              },
              child: const Text("Ya, Batalkan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
