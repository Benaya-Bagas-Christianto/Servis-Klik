import 'package:flutter/material.dart';

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
  bool _isProcessing = false; // 👇 Variabel loading bayar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Pembayaran", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ID Pesanan",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        widget.orderId,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  const Text(
                    "Rincian Biaya",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildRincianRow("Biaya Sparepart", "Rp 450.000"),
                  _buildRincianRow("Jasa Teknisi", "Rp 150.000"),
                  _buildRincianRow("Biaya Layanan (Aplikasi)", "Rp 5.000"),
                  const Divider(height: 30),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Tagihan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp 605.000",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Pilih Metode Pembayaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildPaymentOption(
              "GoPay",
              Icons.account_balance_wallet,
              Colors.blue,
            ),
            _buildPaymentOption(
              "OVO",
              Icons.account_balance_wallet,
              Colors.purple,
            ),
            _buildPaymentOption(
              "BCA Virtual Account",
              Icons.account_balance,
              Colors.blue[800]!,
            ),
            _buildPaymentOption(
              "Mandiri Virtual Account",
              Icons.account_balance,
              Colors.yellow[800]!,
            ),

            const SizedBox(height: 40),

            // Tombol Bayar Dinamis
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isProcessing
                    ? null
                    : () async {
                        setState(() => _isProcessing = true);

                        // Simulasi koneksi ke server Bank/E-Wallet (2 detik)
                        await Future.delayed(const Duration(seconds: 2));

                        if (!context.mounted) return;
                        setState(() => _isProcessing = false);
                        _tampilkanSukses(context);
                      },
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Bayar Pakai $_selectedPayment",
                        style: const TextStyle(
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

  Widget _buildRincianRow(String title, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, Color iconColor) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: _selectedPayment == title
              ? Colors.blueAccent
              : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: RadioListTile<String>(
        title: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        value: title,
        groupValue: _selectedPayment,
        activeColor: Colors.blueAccent,
        onChanged: (String? value) {
          setState(() {
            _selectedPayment = value!;
          });
        },
      ),
    );
  }

  void _tampilkanSukses(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Teknisi akan segera memulai perbaikan perangkat Anda.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Kembali",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
