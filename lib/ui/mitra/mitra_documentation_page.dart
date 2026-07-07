import 'package:flutter/material.dart';

class MitraDocumentationPage extends StatefulWidget {
  final String orderId;

  const MitraDocumentationPage({super.key, required this.orderId});

  @override
  State<MitraDocumentationPage> createState() => _MitraDocumentationPageState();
}

class _MitraDocumentationPageState extends State<MitraDocumentationPage> {
  bool _fotoAwalUploaded = false;
  bool _fotoRusakUploaded = false;
  bool _fotoSelesaiUploaded = false;

  // Status loading untuk masing-masing foto
  bool _isLoading1 = false;
  bool _isLoading2 = false;
  bool _isLoading3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Dokumentasi Visual",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order: ${widget.orderId}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Unggah foto untuk bukti transparansi ke pelanggan.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),

            const Text(
              "1. Kondisi Awal Diterima",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildPhotoBox(
              isUploaded: _fotoAwalUploaded,
              isLoading: _isLoading1,
              title: "Ambil Foto Kondisi Awal",
              onTap: () => _simulasiBukaKamera(1),
            ),
            const SizedBox(height: 25),

            const Text(
              "2. Bukti Kerusakan Komponen",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildPhotoBox(
              isUploaded: _fotoRusakUploaded,
              isLoading: _isLoading2,
              title: "Ambil Foto Komponen Rusak",
              onTap: () => _simulasiBukaKamera(2),
            ),
            const SizedBox(height: 25),

            const Text(
              "3. Kondisi Setelah Diperbaiki",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildPhotoBox(
              isUploaded: _fotoSelesaiUploaded,
              isLoading: _isLoading3,
              title: "Ambil Foto Laptop Menyala",
              onTap: () => _simulasiBukaKamera(3),
            ),
            const SizedBox(height: 40),

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
                    const SnackBar(
                      content: Text("Foto dokumentasi berhasil disimpan!"),
                    ),
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.cloud_upload, color: Colors.white),
                label: const Text(
                  "Simpan Dokumentasi",
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

  Widget _buildPhotoBox({
    required bool isUploaded,
    required bool isLoading,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: (isUploaded || isLoading) ? null : onTap,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isUploaded ? Colors.teal.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded ? Colors.teal : Colors.grey.withValues(alpha: 0.5),
            style: isUploaded ? BorderStyle.solid : BorderStyle.none,
          ),
          boxShadow: isUploaded
              ? []
              : [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator(color: Colors.teal)
            else
              Icon(
                isUploaded ? Icons.check_circle : Icons.camera_alt,
                size: 50,
                color: isUploaded ? Colors.teal : Colors.grey,
              ),

            const SizedBox(height: 10),
            if (!isLoading)
              Text(
                isUploaded ? "Foto Berhasil Diunggah" : title,
                style: TextStyle(
                  color: isUploaded ? Colors.teal : Colors.black54,
                  fontWeight: isUploaded ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _simulasiBukaKamera(int id) {
    setState(() {
      if (id == 1) _isLoading1 = true;
      if (id == 2) _isLoading2 = true;
      if (id == 3) _isLoading3 = true;
    });

    // Loading buatan selama 1.5 detik agar terasa nyata
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        if (id == 1) {
          _fotoAwalUploaded = true;
          _isLoading1 = false;
        }
        if (id == 2) {
          _fotoRusakUploaded = true;
          _isLoading2 = false;
        }
        if (id == 3) {
          _fotoSelesaiUploaded = true;
          _isLoading3 = false;
        }
      });
    });
  }
}
