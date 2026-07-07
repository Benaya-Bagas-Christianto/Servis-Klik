import 'package:flutter/material.dart';
import 'mitra_documentation_page.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

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
    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              Dell1996TopBanner(
                title: 'ORDER DETAIL',
                subtitle: widget.orderId,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dell1996Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- SECTION 1: Info Pelanggan ---
                      const Dell1996SectionEyebrow(
                        title: '1. INFORMASI PELANGGAN',
                        backgroundColor: Dell1996Colors.tintSky,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      Container(
                        padding: const EdgeInsets.all(Dell1996Spacing.md),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("NAMA", widget.customerName),
                            _buildInfoRow("PERANGKAT", widget.device),
                            _buildInfoRow("KELUHAN", widget.initialIssue),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dell1996Spacing.xl),

                      // --- SECTION 2: Dokumentasi ---
                      const Dell1996SectionEyebrow(
                        title: '2. BUKTI FOTO KERUSAKAN',
                        backgroundColor: Dell1996Colors.tintPeach,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      Dell1996ButtonPrimary(
                        text: 'BUKA KAMERA & UNGGAH BUKTI',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MitraDocumentationPage(orderId: widget.orderId),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: Dell1996Spacing.xl),

                      // --- SECTION 3: Diagnosis & Kalkulator Biaya ---
                      const Dell1996SectionEyebrow(
                        title: '3. DIAGNOSIS & ESTIMASI BIAYA',
                        backgroundColor: Dell1996Colors.tintLime,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      Container(
                        padding: const EdgeInsets.all(Dell1996Spacing.md),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("DETAIL KERUSAKAN (HASIL CEK):", style: Dell1996Typography.uiLabel),
                            const SizedBox(height: Dell1996Spacing.xs),
                            Dell1996TextInput(
                              controller: _damageDetailController,
                              hintText: "Contoh: IC Power mati, perlu ganti.",
                              maxLines: 3,
                            ),
                            const SizedBox(height: Dell1996Spacing.md),
                            
                            Text("BIAYA SPAREPART (RP):", style: Dell1996Typography.uiLabel),
                            const SizedBox(height: Dell1996Spacing.xs),
                            Dell1996TextInput(
                              controller: _sparepartController,
                              keyboardType: TextInputType.number,
                              hintText: "0",
                            ),
                            const SizedBox(height: Dell1996Spacing.md),
                            
                            Text("BIAYA JASA TEKNISI (RP):", style: Dell1996Typography.uiLabel),
                            const SizedBox(height: Dell1996Spacing.xs),
                            Dell1996TextInput(
                              controller: _jasaController,
                              keyboardType: TextInputType.number,
                              hintText: "0",
                            ),
                            const Divider(color: Dell1996Colors.frameInk, thickness: 1, height: 30),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("TOTAL ESTIMASI:", style: Dell1996Typography.uiLabel),
                                Text(
                                  "Rp $_totalBiaya",
                                  style: Dell1996Typography.heading2.copyWith(color: Dell1996Colors.primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dell1996Spacing.xl),

                      // --- SECTION 4: Update Status ---
                      const Dell1996SectionEyebrow(
                        title: '4. UPDATE STATUS SAAT INI',
                        backgroundColor: Dell1996Colors.tintSteel,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dell1996Spacing.md),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedStatus,
                            icon: const Icon(Icons.arrow_drop_down, color: Dell1996Colors.frameInk),
                            style: Dell1996Typography.body,
                            dropdownColor: Dell1996Colors.canvas,
                            items: _statusList.map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status.toUpperCase()),
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
                      const SizedBox(height: Dell1996Spacing.section),

                      // --- SECTION 5: Tombol Simpan ---
                      Dell1996CtaBlockRed(
                        text: 'SIMPAN & KIRIM KE PELANGGAN',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Dell1996Colors.canvas,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              title: Text("STATUS DIUPDATE", style: Dell1996Typography.heading2),
                              content: Text(
                                "Status menjadi: ${_selectedStatus.toUpperCase()}\nTotal Biaya: Rp $_totalBiaya",
                                style: Dell1996Typography.body,
                              ),
                              actions: [
                                Dell1996ButtonPrimary(
                                  text: "TUTUP",
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context); // Kembali ke halaman sebelumnya
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
                  text: 'KEMBALI',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Dell1996FooterBand(text: 'Simpan pembaruan status secara berkala.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dell1996Spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Dell1996Typography.body),
          Expanded(
            child: Text(
              value,
              style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
