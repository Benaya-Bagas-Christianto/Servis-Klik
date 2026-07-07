import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 👇 Aktifkan baris ini sesuai lokasi file booking_page kamu agar grid-nya bisa di-klik
import 'booking/booking_page.dart';

import '../mitra/daftar_tugas_page.dart'; // Import halaman Daftar Tugas Baru

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Silakan login terlebih dahulu.")),
      );
    }

    // Menggunakan FutureBuilder untuk mengambil data 'role' dari Firestore
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String role = userData['role'] ?? 'user';
          String namaUser = userData['nama'] ?? 'Pengguna';

          // 🔀 LOGIKA PEMISAHAN TAMPILAN
          if (role == 'mitra') {
            return _buildMitraHome(namaUser);
          } else {
            return _buildCustomerHome(namaUser);
          }
        }

        return _buildCustomerHome("Pelanggan");
      },
    );
  }

  // =========================================================================
  // 1. TAMPILAN BERANDA KHUSUS TEKNISI (MITRA)
  // =========================================================================
  Widget _buildMitraHome(String nama) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Halo, $nama! 👋",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              "Siap menyelesaikan servis laptop hari ini?",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 25),

            const Text(
              "Ringkasan Tugas Anda",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // StreamBuilder untuk menghitung statistik orderan secara Real-time
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pesanan')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                int tugasBaru = 0;
                int diproses = 0;
                int selesai = 0;

                // Looping untuk menghitung jumlah masing-masing status
                for (var doc in snapshot.data!.docs) {
                  var data = doc.data() as Map<String, dynamic>;
                  String status = data['status'] ?? '';

                  if (status == 'Menunggu Teknisi') {
                    tugasBaru++;
                  } else if (status == 'Selesai') {
                    selesai++;
                  } else {
                    // Masuk ke hitungan diproses jika statusnya 'Sedang Dijemput' atau 'Proses Perbaikan'
                    diproses++;
                  }
                }

                return Row(
                  children: [
                    _buildStatCard(
                      "Tugas Baru",
                      tugasBaru.toString(),
                      Colors.redAccent,
                      Icons.assignment_late,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      "Diproses",
                      diproses.toString(),
                      Colors.blueAccent,
                      Icons.handyman,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      "Selesai",
                      selesai.toString(),
                      Colors.green,
                      Icons.check_circle,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tugas Perbaikan Aktif",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DaftarTugasPage(),
                      ),
                    );
                  },
                  child: const Text("Lihat Semua"),
                ),
              ],
            ),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pesanan')
                  .where('status', isNotEqualTo: 'Selesai')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Mantap! Tidak ada tunggakan servis hari ini.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                var activeOrders = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activeOrders.length,
                  itemBuilder: (context, index) {
                    var order =
                        activeOrders[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        // 👇 INI YANG MEMBUAT KARTUNYA BISA DIKLIK!
                        onTap: () {
                          _showUpdateStatusDialog(
                            context,
                            activeOrders[index].id,
                            order['status'] ?? '',
                            order['metode_penyerahan'] ?? 'Dijemput',
                            order['metode_pengambilan'] ?? 'Diantar',
                          );
                        },
                        leading: const CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          child: Icon(Icons.computer, color: Colors.white),
                        ),
                        title: Text(
                          order['perangkat'] ?? 'Laptop',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Keluhan: ${order['keluhan']}"),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            // 👇 Warna otomatis menyesuaikan status
                            color: order['status'] == 'Proses Perbaikan'
                                ? Colors.blue.withValues(alpha: 0.2)
                                : Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            order['status'] ?? 'Proses',
                            style: TextStyle(
                              color: order['status'] == 'Proses Perbaikan'
                                  ? Colors.blue
                                  : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 👇 ERROR KE-2 DIPERBAIKI DI SINI (Menggunakan boxShadow)
  Widget _buildStatCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 2. TAMPILAN BERANDA ORIGINAL UNTUK USER / CUSTOMER
  // =========================================================================
  Widget _buildCustomerHome(String nama) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Halo, $nama! 👋",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Laptopmu kenapa hari ini?",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 25),

            const Text(
              "Pilih Keluhan Perangkat",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              children: [
                _buildMenuIcon("Layar Blank", Icons.monitor, Colors.blue),
                _buildMenuIcon("Baterai Drop", Icons.battery_alert, Colors.red),
                _buildMenuIcon("Mati Total", Icons.power_off, Colors.grey),
                _buildMenuIcon("Keyboard", Icons.keyboard, Colors.orange),
                _buildMenuIcon("Kena Air", Icons.water_drop, Colors.teal),
                _buildMenuIcon("Kena Virus", Icons.bug_report, Colors.green),
                _buildMenuIcon("Audio Rusak", Icons.volume_off, Colors.purple),
                _buildMenuIcon("Upgrade", Icons.memory, Colors.indigo),
              ],
            ),
            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Color(0xFF0056D2)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Promo Servis Bulan Ini!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Diskon 20% untuk jasa pembersihan kipas dan ganti pasta thermal. Klaim sekarang!",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              "Artikel & Tips Pilihan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 👇 ERROR KE-1 DIPERBAIKI DI SINI (Menggunakan Icons.thermostat)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ListTile(
                leading: Icon(Icons.thermostat, color: Colors.redAccent),
                title: Text(
                  "Awas Overheat! Jangan Taruh Laptop di Atas Kasur",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: Text(
                  "Membahas risiko sirkulasi udara laptop tersumbat kasur.",
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcon(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingPage(
              gejalaLayanan: title,
            ), // 👇 Kini mengirim data judul keluhan
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // FUNGSI UNTUK MENGUBAH STATUS OLEH TEKNISI
  // =========================================================================
  void _showUpdateStatusDialog(
    BuildContext context,
    String docId,
    String currentStatus,
    String metodePenyerahan,
    String metodePengambilan,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // ==========================================
        // LOGIKA ALUR STATUS LINIER (WAJIB BERURUTAN)
        // ==========================================
        String? targetStatus;
        String buttonText = "";
        Color buttonColor = Colors.blue;
        IconData buttonIcon = Icons.check_circle;

        if (currentStatus == "Menunggu Teknisi") {
          targetStatus = "Proses Perbaikan";
          buttonText = "Mulai Proses Perbaikan";
          buttonColor = Colors.blueAccent;
          buttonIcon = Icons.build;
        } else if (currentStatus == "Proses Perbaikan") {
          targetStatus = "Menunggu Pembayaran";
          buttonText = "Selesai & Input Tagihan";
          buttonColor = Colors.purple;
          buttonIcon = Icons.payments;
        } else if (currentStatus == "Menunggu Pembayaran") {
          targetStatus = null; // Menunggu user
          buttonText = "Menunggu Pelanggan Membayar";
          buttonColor = Colors.grey;
          buttonIcon = Icons.hourglass_empty;
        } else if (currentStatus == "Sudah Dibayar") {
          if (metodePengambilan == 'Diantar' ||
              metodePengambilan == 'Dijemput') {
            targetStatus = "Siap Diantar";
            buttonText = "Tandai Siap Diantar";
          } else {
            targetStatus = "Siap Diambil";
            buttonText = "Tandai Siap Diambil";
          }
          buttonColor = Colors.teal;
          buttonIcon = Icons.local_shipping;
        } else if (currentStatus == "Siap Diantar" ||
            currentStatus == "Siap Diambil") {
          targetStatus = "Selesai";
          buttonText = "Selesaikan Pesanan";
          buttonColor = Colors.green;
          buttonIcon = Icons.done_all;
        } else if (currentStatus == "Selesai") {
          targetStatus = null; // Sudah mentok
          buttonText = "Pesanan Telah Selesai";
          buttonColor = Colors.grey;
          buttonIcon = Icons.verified;
        } else if (currentStatus == "Dibatalkan") {
          targetStatus = "DELETE"; // Flag khusus untuk hapus
          buttonText = "Hapus Data Ini";
          buttonColor = Colors.red;
          buttonIcon = Icons.delete;
        } else {
          targetStatus = null;
          buttonText = "Status Tidak Diketahui";
          buttonColor = Colors.redAccent;
          buttonIcon = Icons.error;
        }

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Update Fase Perbaikan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "Status Saat Ini: $currentStatus\nPenyerahan: $metodePenyerahan\nPengembalian: $metodePengambilan",
                style: const TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(buttonIcon, color: Colors.white),
                  label: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: targetStatus == null
                      ? null
                      : () async {
                          if (targetStatus == "Menunggu Pembayaran") {
                            Navigator.pop(context);
                            _tampilkanPopUpTagihan(context, docId);
                          } else if (targetStatus == "DELETE") {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('pesanan')
                                  .doc(docId)
                                  .delete();

                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Pesanan yang dibatalkan berhasil dihapus",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint("Error hapus: $e");
                            }
                          } else {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('pesanan')
                                  .doc(docId)
                                  .update({'status': targetStatus});

                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Status berhasil diubah ke: $targetStatus",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint("Error update: $e");
                            }
                          }
                        },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _tampilkanPopUpTagihan(BuildContext context, String docId) {
    final TextEditingController hargaController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.payments, color: Colors.purple),
              SizedBox(width: 10),
              Text(
                "Input Biaya Servis",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: TextField(
            controller: hargaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Total Biaya Perbaikan (Rp)",
              prefixText: "Rp ",
              hintText: "Contoh: 350000",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () async {
                String hargaText = hargaController.text.trim().replaceAll(
                  '.',
                  '',
                );
                if (hargaText.isEmpty) return;

                int biaya = int.parse(hargaText);

                await FirebaseFirestore.instance
                    .collection('pesanan')
                    .doc(docId)
                    .update({
                      'status': 'Menunggu Pembayaran',
                      'biaya_servis': biaya,
                    });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Tagihan biaya berhasil dikirim ke pelanggan!",
                      ),
                      backgroundColor: Colors.purple,
                    ),
                  );
                }
              },
              child: const Text(
                "Kirim Tagihan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
