import 'package:flutter/material.dart';
import 'mitra_documentation_page.dart';

class MitraOrderDetail extends StatefulWidget {
  final String orderId;
  final String customerName;
  final String device;
  final String initialIssue;

  const MitraOrderDetail({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.device,
    required this.initialIssue,
  });

  @override
  State<MitraOrderDetail> createState() => _MitraOrderDetailState();
}

class _MitraOrderDetailState extends State<MitraOrderDetail> {
  String _selectedStatus = "Menunggu Pengecekan";

  // 👇 Tambahkan controller untuk kalkulator biaya
  final TextEditingController _damageDetailController = TextEditingController();
  final TextEditingController _sparepartController = TextEditingController();
  final TextEditingController _jasaController = TextEditingController();

  int _totalBiaya = 0;

  final List<String> _statusList = [
    "Menunggu Pengecekan",
    "Diagnosis Selesai",
    "Proses Perbaikan",
    "Quality Control",
    "Siap Diambil / Diantar",
  ];

  // --- FUNGSI HITUNG TOTAL BIAYA ---
  void _hitungTotal() {
    int biayaSparepart = int.tryParse(_sparepartController.text) ?? 0;
    int biayaJasa = int.tryParse(_jasaController.text) ?? 0;
    setState(() {
      _totalBiaya = biayaSparepart + biayaJasa;
    });
  }

  @override
  void dispose() {
    _damageDetailController.dispose();
    _sparepartController.dispose();
    _jasaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Order ${widget.orderId}",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: Info Pelanggan ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informasi Pelanggan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const Divider(),
                  _buildInfoRow("Nama", widget.customerName),
                  _buildInfoRow("Perangkat", widget.device),
                  _buildInfoRow("Keluhan", widget.initialIssue),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- SECTION 2: Dokumentasi ---
            const Text(
              "Dokumentasi Foto",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MitraDocumentationPage(orderId: widget.orderId),
                    ),
                  );
                },
                icon: const Icon(Icons.photo_camera),
                label: const Text(
                  "Buka Kamera & Unggah Bukti",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- SECTION 3: Diagnosis & Kalkulator Biaya ---
            const Text(
              "Diagnosis & Estimasi Biaya",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _damageDetailController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Detail Kerusakan (Hasil Cek)",
                      hintText: "Contoh: IC Power mati, perlu ganti.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _sparepartController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _hitungTotal(), // Hitung tiap kali ngetik
                    decoration: InputDecoration(
                      labelText: "Biaya Sparepart (Rp)",
                      prefixIcon: const Icon(Icons.money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _jasaController,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _hitungTotal(), // Hitung tiap kali ngetik
                    decoration: InputDecoration(
                      labelText: "Biaya Jasa Teknisi (Rp)",
                      prefixIcon: const Icon(Icons.handyman),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const Divider(height: 30),

                  // Tampilan total biaya dinamis
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Estimasi:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Rp $_totalBiaya",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- SECTION 4: Update Status ---
            const Text(
              "Update Status Saat Ini",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.withValues(alpha: 0.5)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedStatus,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                  items: _statusList.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(
                        status,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- SECTION 5: Tombol Simpan ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Berhasil! Status diupdate menjadi: $_selectedStatus dan total biaya Rp $_totalBiaya",
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Simpan & Kirim ke Pelanggan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
