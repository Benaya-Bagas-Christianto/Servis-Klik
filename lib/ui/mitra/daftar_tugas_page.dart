import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../home/home_page.dart'; // Digunakan untuk mengakses _showUpdateStatusDialog jika perlu, tapi karena itu ada di state HomePage, kita bisa mengatasinya.
// Karena method _showUpdateStatusDialog ada di _HomePageState, kita akan buat dialog sederhana atau biarkan saja read-only/bisa di tap di sini.

class DaftarTugasPage extends StatelessWidget {
  const DaftarTugasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // 4 Tab Status
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Daftar Semua Tugas',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Menunggu"),
              Tab(text: "Proses"),
              Tab(text: "Menunggu Bayar"),
              Tab(text: "Selesai"),
            ],
          ),
        ),
        backgroundColor: Colors.grey[100],
        body: const TabBarView(
          children: [
            _ListTugas(statusFilter: 'Menunggu Teknisi'),
            _ListTugas(statusFilter: 'Proses Perbaikan'),
            _ListTugas(statusFilter: 'Menunggu Pembayaran'),
            _ListTugas(statusFilter: 'Selesai'),
          ],
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
                Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 10),
                Text(
                  "Tidak ada tugas di tahap ini.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        var orders = snapshot.data!.docs.toList();

        // 👈 SORTING BERDASARKAN WAKTU TERBARU (Descending)
        // Kita lakukan sorting di level Dart untuk menghindari error "Missing Index" di Firebase
        // karena kita sudah menggunakan filter .where('status') sebelumnya.
        orders.sort((a, b) {
          var dataA = a.data() as Map<String, dynamic>;
          var dataB = b.data() as Map<String, dynamic>;
          Timestamp? timeA = dataA['waktu_pesan'] as Timestamp?;
          Timestamp? timeB = dataB['waktu_pesan'] as Timestamp?;
          
          if (timeA == null && timeB == null) return 0;
          if (timeA == null) return 1;
          if (timeB == null) return -1;
          
          return timeB.compareTo(timeA); // Waktu terbaru di atas
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var data = orders[index].data() as Map<String, dynamic>;
            
            Color statusColor;
            switch (statusFilter) {
              case 'Menunggu Teknisi':
                statusColor = Colors.orange;
                break;
              case 'Proses Perbaikan':
                statusColor = Colors.blue;
                break;
              case 'Selesai':
                statusColor = Colors.green;
                break;
              default:
                statusColor = Colors.purple;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.2),
                  child: Icon(Icons.computer, color: statusColor),
                ),
                title: Text(
                  data['perangkat'] ?? 'Perangkat',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
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
                    Text(
                      "Pelanggan: ${data['nama_user'] ?? 'Anonim'}",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusFilter,
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
