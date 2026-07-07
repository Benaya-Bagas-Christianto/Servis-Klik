import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class BookingPage extends StatefulWidget {
  final String gejalaLayanan;

  const BookingPage({super.key, required this.gejalaLayanan});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _deviceController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  bool _isLoading = false;
  bool _isProcessing = false;

  String _metodePenyerahan = 'Dijemput';
  String _metodePengambilan = 'Diantar';

  @override
  void dispose() {
    _deviceController.dispose();
    _keluhanController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _prosesPemesanan() async {
    if (_keluhanController.text.trim().isEmpty ||
        _deviceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Merek Perangkat & Keluhan harus diisi."),
        ),
      );
      return;
    }

    if (_isProcessing) return;
    _isProcessing = true;

    setState(() => _isLoading = true);

    try {
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

      Map<String, dynamic> dataPesanan = {
        'email_user': user?.email ?? 'unknown',
        'nama_user': namaPemesan,
        'perangkat': _deviceController.text,
        'kategori': widget.gejalaLayanan,
        'keluhan': _keluhanController.text,
        'metode_penyerahan': _metodePenyerahan,
        'metode_pengambilan': _metodePengambilan,
        'alamat': (_metodePenyerahan == 'Bawa Sendiri' && _metodePengambilan == 'Ambil Sendiri')
            ? 'Datang Langsung ke Toko'
            : (_alamatController.text.isEmpty
                  ? 'Alamat tidak diisi'
                  : _alamatController.text),
        'status': 'Menunggu Teknisi',
        'waktu_pesan': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('pesanan').add(dataPesanan);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pesanan berhasil dibuat."),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error kirim data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengirim pesanan.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              const Dell1996TopBanner(
                title: 'FORM PEMESANAN',
                subtitle: 'Isi detail masalah perangkat Anda',
                showBackButton: true,
                trailingWidget: Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dell1996Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- 1. INFORMASI PERANGKAT ---
                      const Dell1996SectionEyebrow(
                        title: '1. INFO PERANGKAT',
                        backgroundColor: Dell1996Colors.tintSky,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      Text(
                        'MEREK & TIPE (Cth: Dell Latitude 1996)',
                        style: Dell1996Typography.uiLabel,
                      ),
                      const SizedBox(height: Dell1996Spacing.xs),
                      Dell1996TextInput(
                        controller: _deviceController,
                        hintText: 'Merek & Tipe...',
                      ),
                      
                      const SizedBox(height: Dell1996Spacing.xl),

                      // --- 2. LAYANAN & KELUHAN ---
                      const Dell1996SectionEyebrow(
                        title: '2. KELUHAN',
                        backgroundColor: Dell1996Colors.tintSalmon,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      
                      Dell1996RibbonCard(
                        title: 'KATEGORI LAYANAN',
                        description: widget.gejalaLayanan,
                        tintColor: Dell1996Colors.tintPeach,
                        leadingWidget: const Icon(Icons.build, size: 32, color: Dell1996Colors.ink),
                      ),
                      
                      const SizedBox(height: Dell1996Spacing.md),
                      Text(
                        'DETAIL KELUHAN',
                        style: Dell1996Typography.uiLabel,
                      ),
                      const SizedBox(height: Dell1996Spacing.xs),
                      Container(
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                        ),
                        child: TextField(
                          controller: _keluhanController,
                          maxLines: 4,
                          style: Dell1996Typography.body,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ceritakan detailnya...',
                            contentPadding: EdgeInsets.all(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: Dell1996Spacing.xl),

                      // --- 3 & 4. METODE ---
                      const Dell1996SectionEyebrow(
                        title: '3. LOGISTIK',
                        backgroundColor: Dell1996Colors.tintLime,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      
                      Text('PENYERAHAN', style: Dell1996Typography.uiLabel),
                      const SizedBox(height: Dell1996Spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _metodePenyerahan,
                            isExpanded: true,
                            dropdownColor: Dell1996Colors.canvas,
                            style: Dell1996Typography.body,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _metodePenyerahan = newValue;
                                });
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: 'Dijemput', child: Text('Dijemput oleh Kurir Toko')),
                              DropdownMenuItem(value: 'Bawa Sendiri', child: Text('Bawa Sendiri ke Toko')),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: Dell1996Spacing.lg),

                      Text('PENGEMBALIAN', style: Dell1996Typography.uiLabel),
                      const SizedBox(height: Dell1996Spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _metodePengambilan,
                            isExpanded: true,
                            dropdownColor: Dell1996Colors.canvas,
                            style: Dell1996Typography.body,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _metodePengambilan = newValue;
                                });
                              }
                            },
                            items: const [
                              DropdownMenuItem(value: 'Diantar', child: Text('Diantar oleh Kurir Toko')),
                              DropdownMenuItem(value: 'Ambil Sendiri', child: Text('Ambil Sendiri ke Toko')),
                            ],
                          ),
                        ),
                      ),

                      if (_metodePenyerahan == 'Dijemput' || _metodePengambilan == 'Diantar') ...[
                        const SizedBox(height: Dell1996Spacing.lg),
                        Container(
                          padding: const EdgeInsets.all(Dell1996Spacing.md),
                          decoration: BoxDecoration(
                            color: Dell1996Colors.yellowSticker,
                            border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                          ),
                          child: Text(
                            "CATATAN: Layanan antar-jemput dikenakan ongkos kirim yang akan dihitung teknisi.",
                            style: Dell1996Typography.bodySm.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: Dell1996Spacing.lg),
                        Text('ALAMAT', style: Dell1996Typography.uiLabel),
                        const SizedBox(height: Dell1996Spacing.xs),
                        Container(
                          decoration: BoxDecoration(
                            color: Dell1996Colors.canvas,
                            border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                          ),
                          child: TextField(
                            controller: _alamatController,
                            maxLines: 2,
                            style: Dell1996Typography.body,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Alamat lengkap...',
                              contentPadding: EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: Dell1996Spacing.section),

                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Dell1996CtaBlockRed(
                              text: 'KONFIRMASI PESANAN',
                              onTap: _prosesPemesanan,
                            ),
                      
                      const SizedBox(height: Dell1996Spacing.xl),
                    ],
                  ),
                ),
              ),
              const Dell1996FooterBand(
                text: 'Membatalkan pesanan harus melalui Dashboard Teknisi.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
