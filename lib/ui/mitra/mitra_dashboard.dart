import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Digunakan untuk format mata uang Rupiah

class MitraDashboard extends StatelessWidget {
  const MitraDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan & Rekap Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
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

          // ==========================================
          // LOGIKA AGREGASI: Menghitung Total Pendapatan
          // ==========================================
          int totalPendapatan = 0;
          int totalPesananSelesai = 0;

          for (var doc in pesananList) {
            var data = doc.data() as Map<String, dynamic>;
            if (data['status'] == 'Selesai') {
              totalPesananSelesai++;
              // Ambil dari total bayar akhir (termasuk ongkir) atau biaya servis dasar
              totalPendapatan += (data['total_bayar_akhir'] ?? data['biaya_servis'] ?? 0) as int;
            }
          }

          // Format angka menjadi mata uang Rupiah (contoh: Rp 150.000)
          final formatRupiah = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

          return Column(
            children: [
              // --- 1. KARTU REKAP PENDAPATAN (HEADER) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                  ]
                ),
                child: Column(
                  children: [
                    const Text("Total Omzet (Pesanan Selesai)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 5),
                    Text(
                      formatRupiah.format(totalPendapatan),
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: Text("$totalPesananSelesai Pesanan Telah Diselesaikan", style: const TextStyle(color: Colors.white, fontSize: 12)),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // --- 2. DAFTAR SELURUH TRANSAKSI (READ-ONLY) ---
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pesananList.length,
                  itemBuilder: (context, index) {
                    var data = pesananList[index].data() as Map<String, dynamic>;
                    
                    // Format Waktu ke bentuk tanggal yang mudah dibaca
                    String waktuPesan = "-";
                    if (data['waktu_pesan'] != null) {
                      DateTime dt = (data['waktu_pesan'] as Timestamp).toDate();
                      waktuPesan = DateFormat('dd MMM yyyy, HH:mm').format(dt);
                    }

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    data['perangkat'] ?? 'Laptop',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(waktuPesan, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("Pelanggan: ${data['nama_user'] ?? 'Pelanggan'}", style: const TextStyle(fontSize: 13, color: Colors.black87)),
                            Text("Keluhan: ${data['keluhan'] ?? '-'}", style: const TextStyle(fontSize: 13, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Badge Status Pesanan
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: data['status'] == 'Selesai' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    data['status'] ?? '-',
                                    style: TextStyle(
                                      color: data['status'] == 'Selesai' ? Colors.green : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                // Menampilkan harga jika sudah ada tagihan
                                if (data['total_bayar_akhir'] != null || data['biaya_servis'] != null)
                                  Text(
                                    formatRupiah.format(data['total_bayar_akhir'] ?? data['biaya_servis']),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 15),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
