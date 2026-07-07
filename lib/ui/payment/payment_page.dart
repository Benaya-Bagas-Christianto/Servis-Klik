import 'package:flutter/material.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class PaymentPage extends StatefulWidget {
  final String orderId;
  final int totalTagihan;

  const PaymentPage({
    super.key,
    required this.orderId,
    required this.totalTagihan,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = "GoPay";
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Dell1996TopBanner(
                title: 'PEMBAYARAN',
                subtitle: 'Selesaikan transaksi servis perangkat Anda',
                trailingWidget: Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS'),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Dell1996Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Dell1996SectionEyebrow(
                        title: '1. RINCIAN TAGIHAN',
                        backgroundColor: Dell1996Colors.tintSky,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      Container(
                        padding: const EdgeInsets.all(Dell1996Spacing.lg),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.canvas,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("ID PESANAN", style: Dell1996Typography.uiLabel),
                                Text(widget.orderId, style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Divider(color: Dell1996Colors.frameInk, height: 30, thickness: 1),
                            Text("KOMPONEN BIAYA", style: Dell1996Typography.uiLabel),
                            const SizedBox(height: Dell1996Spacing.sm),
                            _buildRincianRow("BIAYA SPAREPART", "Rp 450.000"),
                            _buildRincianRow("JASA TEKNISI", "Rp 150.000"),
                            _buildRincianRow("BIAYA LAYANAN", "Rp 5.000"),
                            const Divider(color: Dell1996Colors.frameInk, height: 30, thickness: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("TOTAL TAGIHAN", style: Dell1996Typography.uiLabel),
                                Text("Rp 605.000", style: Dell1996Typography.heading2.copyWith(color: Dell1996Colors.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dell1996Spacing.xl),

                      const Dell1996SectionEyebrow(
                        title: '2. METODE PEMBAYARAN',
                        backgroundColor: Dell1996Colors.tintLime,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),

                      _buildPaymentOption("GoPay", Icons.account_balance_wallet, Colors.green),
                      _buildPaymentOption("OVO", Icons.account_balance_wallet, Colors.purple),
                      _buildPaymentOption("BCA Virtual Account", Icons.account_balance, Colors.blue),
                      _buildPaymentOption("Mandiri Virtual Account", Icons.account_balance, Colors.orange),

                      const SizedBox(height: Dell1996Spacing.section),

                      _isProcessing
                          ? const Center(child: CircularProgressIndicator())
                          : Dell1996CtaBlockRed(
                              text: "BAYAR PAKAI ${_selectedPayment.toUpperCase()}",
                              onTap: () async {
                                setState(() => _isProcessing = true);
                                await Future.delayed(const Duration(seconds: 2));
                                if (!context.mounted) return;
                                setState(() => _isProcessing = false);
                                _tampilkanSukses(context);
                              },
                            ),
                    ],
                  ),
                ),
              ),
              const Dell1996FooterBand(text: 'Semua transaksi diamankan oleh sistem enkripsi internal.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRincianRow(String title, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dell1996Spacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Dell1996Typography.body),
          Text(price, style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, Color iconColor) {
    bool isSelected = _selectedPayment == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: Dell1996Spacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? Dell1996Colors.tintSky : Dell1996Colors.canvas,
          border: Border.all(
            color: isSelected ? Dell1996Colors.primary : Dell1996Colors.frameInk,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: RadioListTile<String>(
          activeColor: Dell1996Colors.primary,
          title: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: Dell1996Spacing.sm),
              Text(title.toUpperCase(), style: Dell1996Typography.body.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
          value: title,
          groupValue: _selectedPayment,
          onChanged: (String? value) {
            setState(() {
              _selectedPayment = value!;
            });
          },
        ),
      ),
    );
  }

  void _tampilkanSukses(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Dell1996Colors.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text("PEMBAYARAN BERHASIL", style: Dell1996Typography.heading2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Dell1996Colors.primary, size: 64),
            const SizedBox(height: Dell1996Spacing.lg),
            Text(
              "Transaki berhasil diproses. Teknisi akan segera memulai perbaikan perangkat Anda.",
              style: Dell1996Typography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dell1996Spacing.xl),
            Dell1996ButtonPrimary(
              text: "KEMBALI KE MENU",
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
