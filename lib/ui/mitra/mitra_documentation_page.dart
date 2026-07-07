import 'package:flutter/material.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

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

  bool _isLoading1 = false;
  bool _isLoading2 = false;
  bool _isLoading3 = false;

  @override
  Widget build(BuildContext context) {
    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Dell1996TopBanner(
                title: 'DOKUMENTASI TUGAS',
                showBackButton: true,
                subtitle: 'ID: ${widget.orderId}',
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dell1996Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "UNGGAH FOTO SEBAGAI BUKTI UNTUK PELANGGAN.",
                        style: Dell1996Typography.uiLabel,
                      ),
                      const SizedBox(height: Dell1996Spacing.xl),

                      const Dell1996SectionEyebrow(
                        title: '1. KONDISI AWAL DITERIMA',
                        backgroundColor: Dell1996Colors.tintSky,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      _buildPhotoBox(
                        isUploaded: _fotoAwalUploaded,
                        isLoading: _isLoading1,
                        title: "AMBIL FOTO KONDISI AWAL",
                        onTap: () => _simulasiBukaKamera(1),
                      ),
                      const SizedBox(height: Dell1996Spacing.xl),

                      const Dell1996SectionEyebrow(
                        title: '2. BUKTI KERUSAKAN KOMPONEN',
                        backgroundColor: Dell1996Colors.tintPeach,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      _buildPhotoBox(
                        isUploaded: _fotoRusakUploaded,
                        isLoading: _isLoading2,
                        title: "AMBIL FOTO KOMPONEN RUSAK",
                        onTap: () => _simulasiBukaKamera(2),
                      ),
                      const SizedBox(height: Dell1996Spacing.xl),

                      const Dell1996SectionEyebrow(
                        title: '3. KONDISI SETELAH DIPERBAIKI',
                        backgroundColor: Dell1996Colors.tintLime,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      _buildPhotoBox(
                        isUploaded: _fotoSelesaiUploaded,
                        isLoading: _isLoading3,
                        title: "AMBIL FOTO LAPTOP MENYALA",
                        onTap: () => _simulasiBukaKamera(3),
                      ),
                      const SizedBox(height: Dell1996Spacing.section),

                      Dell1996CtaBlockRed(
                        text: "SIMPAN DOKUMENTASI",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Dell1996Colors.canvas,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              title: Text("BERHASIL", style: Dell1996Typography.heading2),
                              content: Text(
                                "Dokumentasi telah disimpan dengan aman.",
                                style: Dell1996Typography.body,
                              ),
                              actions: [
                                Dell1996ButtonPrimary(
                                  text: "KEMBALI",
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(Dell1996Spacing.md),
                color: Dell1996Colors.canvas,
                child: Dell1996ButtonPrimary(
                  text: 'BATAL / KEMBALI',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Dell1996FooterBand(text: 'Modul Kamera Internal diaktifkan.'),
            ],
          ),
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
          color: isUploaded ? Dell1996Colors.tintLime : Dell1996Colors.canvas,
          border: Border.all(
            color: Dell1996Colors.frameInk,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator(color: Dell1996Colors.primary)
            else
              Icon(
                isUploaded ? Icons.check_box : Icons.camera_alt,
                size: 48,
                color: Dell1996Colors.frameInk,
              ),

            const SizedBox(height: Dell1996Spacing.md),
            if (!isLoading)
              Text(
                isUploaded ? "FOTO BERHASIL DIUNGGAH" : title,
                style: Dell1996Typography.body.copyWith(
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
