import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:project_moprog/service/nvidia_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingPage extends StatefulWidget {
  // Variabel untuk menangkap lemparan gejala dari Homepage
  final String gejalaLayanan;

  // Wajibkan memasukkan gejalaLayanan saat memanggil halaman ini
  const BookingPage({super.key, required this.gejalaLayanan});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // Controller untuk mengambil teks yang diketik pengguna
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _deviceController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  bool _isLoading = false;
  bool _isProcessing = false; // Synchronous lock for double-taps

  // 👇 TAMBAH INI: Untuk menyimpan opsi penyerahan (Default: Dijemput)
  String _metodePenyerahan = 'Dijemput';
  String _metodePengambilan = 'Diantar';

  @override
  void dispose() {
    _deviceController.dispose(); // Jangan lupa hapus dari memori
    _keluhanController.dispose();
    super.dispose();
  }

  // FUNGSI UNTUK PROSES PEMESANAN (Tanpa AI)
  Future<void> _prosesPemesanan() async {
    if (_keluhanController.text.trim().isEmpty ||
        _deviceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Mohon isi Merek Laptop dan Keluhan Anda terlebih dahulu.",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Mencegah double-click / klik berulang kali saat masih proses
    if (_isProcessing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "⏳ Harap tunggu, pesanan Anda sedang diproses...",
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    _isProcessing = true; // Kunci proses secara instan

    setState(() => _isLoading = true);

    try {
      // Ambil data user yang sedang login
      final user = FirebaseAuth.instance.currentUser;
      String namaPemesan = "Pelanggan";

      if (user != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          namaPemesan = userDoc.data()?['nama'] ?? 'Pelanggan';
        }
      }

      // 1. Ambil data asli dari ketikan user DITAMBAH Identitas Pemesan & Metode
      Map<String, dynamic> dataPesanan = {
        'email_user': user?.email ?? 'unknown',
        'nama_user': namaPemesan,
        'perangkat': _deviceController.text,
        'kategori': widget.gejalaLayanan,
        'keluhan': _keluhanController.text,
        'metode_penyerahan': _metodePenyerahan,
        'metode_pengambilan': _metodePengambilan,
        // 👇 Jika bawa sendiri dan ambil sendiri, alamat tidak wajib
        'alamat': (_metodePenyerahan == 'Bawa Sendiri' && _metodePengambilan == 'Ambil Sendiri')
            ? 'Datang Langsung ke Toko'
            : (_alamatController.text.isEmpty
                  ? 'Alamat tidak diisi'
                  : _alamatController.text),
        'status': 'Menunggu Teknisi',
        'waktu_pesan': FieldValue.serverTimestamp(),
      };

      // 2. Kirim ke Firebase Firestore
      await FirebaseFirestore.instance.collection('pesanan').add(dataPesanan);

      // 3. Kembali ke menu utama
      if (mounted) {
        Navigator.pop(context); // Kembali ke menu
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Berhasil! Teknisi akan segera mengecek pesanan Anda.",
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error kirim data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal mengirim pesanan. Silakan coba lagi."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      _isProcessing = false; // Buka kunci proses
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Detail Pesanan Servis",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. INFORMASI PERANGKAT ---
            const Text(
              "1. Informasi Perangkat",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              "Merek & Tipe Laptop (Contoh: Asus ROG Zephyrus)",
              Icons.laptop,
              controller: _deviceController,
            ),

            const SizedBox(height: 30),

            // --- 2. LAYANAN & KELUHAN ---
            const Text(
              "2. Layanan & Keluhan Utama",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),

            // Kotak Gejala Permanen (Hasil lemparan dari Homepage)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 
                  0.05,
                ), // Warna background kebiruan tipis
                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.build_circle, color: Colors.blueAccent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kategori Layanan:",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          widget
                              .gejalaLayanan, // Menampilkan data dari parameter
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ), // Indikator sudah terpilih
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Kolom Teks untuk Mengetik Curhatan Keluhan
            TextField(
              controller: _keluhanController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    "Ceritakan detailnya di sini... (Contoh: Pas lagi main game tiba-tiba mati sendiri, lalu sekarang ga bisa dicas).",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. METODE PENYERAHAN LAPTOP ---
            const Text(
              "3. Metode Penyerahan Perangkat",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<String>(
                  initialSelection: _metodePenyerahan,
                  width: constraints.maxWidth,
                  leadingIcon: const Icon(
                    Icons.local_shipping,
                    color: Colors.blueAccent,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.grey[50]),
                    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                    elevation: WidgetStateProperty.all(3),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: 'Dijemput',
                      label: "🛵 Dijemput oleh Kurir Toko",
                    ),
                    DropdownMenuEntry(
                      value: 'Bawa Sendiri',
                      label: "🏢 Bawa Sendiri Langsung ke Toko",
                    ),
                  ],
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        _metodePenyerahan = value;
                      });
                    }
                  },
                );
              },
            ),

            // --- 4. METODE PENGEMBALIAN LAPTOP ---
            const SizedBox(height: 30),
            const Text(
              "4. Metode Pengembalian Perangkat",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<String>(
                  initialSelection: _metodePengambilan,
                  width: constraints.maxWidth,
                  leadingIcon: const Icon(
                    Icons.home_work,
                    color: Colors.blueAccent,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                  ),
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.grey[50]),
                    surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
                    elevation: WidgetStateProperty.all(3),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: 'Diantar',
                      label: "🛵 Diantar oleh Kurir Toko ke Rumah",
                    ),
                    DropdownMenuEntry(
                      value: 'Ambil Sendiri',
                      label: "🏢 Ambil Sendiri ke Toko",
                    ),
                  ],
                  onSelected: (value) {
                    if (value != null) {
                      setState(() {
                        _metodePengambilan = value;
                      });
                    }
                  },
                );
              },
            ),

            // 👇 KONDISI SAKTI: Kolom alamat hanya muncul jika perlu layanan antar/jemput
            if (_metodePenyerahan == 'Dijemput' || _metodePengambilan == 'Diantar') ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Catatan: Layanan antar-jemput kurir akan dikenakan biaya ongkos kirim. Rincian biaya tambahan ini akan dihitung dan ditambahkan ke dalam total tagihan oleh teknisi kami.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade900,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "5. Alamat Penjemputan / Pengantaran",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                "Alamat lengkap rumah / kos Anda...",
                Icons.location_on,
                maxLines: 2,
                controller: _alamatController,
              ),
            ],

            const SizedBox(height: 40),

            // --- 4. TOMBOL PESAN ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // 👇 Selalu panggil fungsinya agar peringatan bisa muncul jika di-klik ganda
                onPressed: _prosesPemesanan,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Konfirmasi",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 👇 Tambahkan "TextEditingController? controller" di dalam kurung
  Widget _buildTextField(
    String hint,
    IconData icon, {
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller, // 👇 Tambahkan ini
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 15.0 : 0),
          child: Icon(icon, color: Colors.grey),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}
