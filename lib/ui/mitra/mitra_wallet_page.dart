import 'package:flutter/material.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class MitraWalletPage extends StatefulWidget {
  const MitraWalletPage({super.key});

  @override
  State<MitraWalletPage> createState() => _MitraWalletPageState();
}

class _MitraWalletPageState extends State<MitraWalletPage> {
  int saldoSaatIni = 2450000;
  final TextEditingController _nominalController = TextEditingController();

  List<Map<String, dynamic>> riwayatTransaksi = [
    {
      "title": "Servis Asus ROG - Layar Blank",
      "date": "10 Mei 2026",
      "amount": "+ Rp 850.000",
      "isIncome": true,
    },
    {
      "title": "Servis MacBook M1 - Baterai",
      "date": "08 Mei 2026",
      "amount": "+ Rp 1.600.000",
      "isIncome": true,
    },
  ];

  void _showSuccessDialog(int nominal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Dell1996Colors.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text("PENARIKAN BERHASIL", style: Dell1996Typography.heading2),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_box, color: Dell1996Colors.primary, size: 64),
              const SizedBox(height: Dell1996Spacing.lg),
              Text(
                "Dana sebesar Rp ${nominal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} berhasil dikirim.",
                style: Dell1996Typography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dell1996Spacing.xl),
              Dell1996ButtonPrimary(
                text: "TUTUP",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Dell1996Colors.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(title.toUpperCase(), style: Dell1996Typography.heading2.copyWith(color: Dell1996Colors.primary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Dell1996Colors.primary, size: 64),
              const SizedBox(height: Dell1996Spacing.lg),
              Text(
                message,
                style: Dell1996Typography.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dell1996Spacing.xl),
              Dell1996ButtonPrimary(
                text: "TUTUP",
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWithdrawMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Dell1996Colors.canvas,
            border: Border.all(color: Dell1996Colors.frameInk, width: 2),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + Dell1996Spacing.section,
            left: Dell1996Spacing.lg,
            right: Dell1996Spacing.lg,
            top: Dell1996Spacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MASUKKAN NOMINAL PENARIKAN",
                style: Dell1996Typography.heading3,
              ),
              const SizedBox(height: Dell1996Spacing.md),
              Dell1996TextInput(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                hintText: "Contoh: 500000",
              ),
              const SizedBox(height: Dell1996Spacing.xl),
              Dell1996CtaBlockRed(
                text: "KONFIRMASI PENARIKAN",
                onTap: () {
                  int nominal = int.tryParse(_nominalController.text) ?? 0;
                  Navigator.pop(context);

                  if (nominal <= 0) {
                    _showErrorDialog(
                      "Nominal Tidak Valid",
                      "Silakan masukkan angka nominal yang benar dan lebih dari Rp 0.",
                    );
                  } else if (nominal > saldoSaatIni) {
                    _showErrorDialog(
                      "Saldo Tidak Mencukupi",
                      "Anda mencoba menarik Rp ${nominal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}, namun saldo Anda hanya Rp ${saldoSaatIni.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}.",
                    );
                  } else {
                    setState(() {
                      saldoSaatIni -= nominal;

                      String formatUang = nominal.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.',
                      );
                      riwayatTransaksi.insert(0, {
                        "title": "Penarikan Dana ke Rekening",
                        "date": "Hari ini",
                        "amount": "- Rp $formatUang",
                        "isIncome": false,
                      });
                    });

                    _showSuccessDialog(nominal);
                    _nominalController.clear();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                title: 'DOMPET TEKNISI',
                subtitle: 'Sistem Pembayaran Internal',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dell1996Spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Dell1996Spacing.lg),
                        decoration: BoxDecoration(
                          color: Dell1996Colors.yellowSticker,
                          border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TOTAL SALDO AKTIF",
                              style: Dell1996Typography.uiLabel,
                            ),
                            const SizedBox(height: Dell1996Spacing.xs),
                            Text(
                              "Rp ${saldoSaatIni.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                              style: Dell1996Typography.heading1.copyWith(
                                color: Dell1996Colors.primary,
                              ),
                            ),
                            const SizedBox(height: Dell1996Spacing.lg),
                            Dell1996ButtonPrimary(
                              text: "TARIK DANA",
                              onPressed: _showWithdrawMenu,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dell1996Spacing.section),
                      
                      const Dell1996SectionEyebrow(
                        title: 'RIWAYAT TRANSAKSI',
                        backgroundColor: Dell1996Colors.tintSky,
                      ),
                      const SizedBox(height: Dell1996Spacing.md),
                      
                      Expanded(
                        child: ListView.builder(
                          itemCount: riwayatTransaksi.length,
                          itemBuilder: (context, index) {
                            final trx = riwayatTransaksi[index];
                            return _buildTransactionItem(
                              trx["title"],
                              trx["date"],
                              trx["amount"],
                              trx["isIncome"],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(Dell1996Spacing.md),
                color: Dell1996Colors.canvas,
                child: Dell1996ButtonPrimary(
                  text: 'KEMBALI KE MENU',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Dell1996FooterBand(text: 'Dikelola oleh Keuangan Internal.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String date,
    String amount,
    bool isIncome,
  ) {
    Color tintColor = isIncome ? Dell1996Colors.tintLime : Dell1996Colors.tintPeach;
    
    return Container(
      margin: const EdgeInsets.only(bottom: Dell1996Spacing.sm),
      decoration: BoxDecoration(
        color: tintColor,
        border: Border.all(color: Dell1996Colors.frameInk, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dell1996Spacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Dell1996Spacing.xs),
              decoration: BoxDecoration(
                color: Dell1996Colors.canvas,
                border: Border.all(color: Dell1996Colors.frameInk, width: 1),
              ),
              child: Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: Dell1996Colors.frameInk,
                size: 20,
              ),
            ),
            const SizedBox(width: Dell1996Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: Dell1996Typography.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(date.toUpperCase(), style: Dell1996Typography.bodySm),
                ],
              ),
            ),
            Text(
              amount,
              style: Dell1996Typography.heading3,
            ),
          ],
        ),
      ),
    );
  }
}
