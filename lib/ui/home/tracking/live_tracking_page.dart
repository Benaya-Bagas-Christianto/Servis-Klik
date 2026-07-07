import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class LiveTrackingPage extends StatelessWidget {
  const LiveTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text("Silakan login"));
    }

    return Scaffold(
      backgroundColor: Dell1996Colors.canvas,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          String role = 'user';
          if (userSnapshot.hasData && userSnapshot.data!.exists) {
            role = (userSnapshot.data!.data() as Map<String, dynamic>)['role'] ?? 'user';
          }

          Stream<QuerySnapshot> streamPesanan;
          if (role == 'mitra') {
            streamPesanan = FirebaseFirestore.instance.collection('pesanan').snapshots();
          } else {
            streamPesanan = FirebaseFirestore.instance
                .collection('pesanan')
                .where('email_user', isEqualTo: currentUser.email)
                .snapshots();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Dell1996TopBanner(
                title: 'TRACKING SERVIS',
                subtitle: 'Pantau status perbaikan perangkat Anda',
                trailingWidget: Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS'),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: streamPesanan,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text("Belum ada perangkat yang sedang diservis."),
                      );
                    }

                    var allOrders = snapshot.data!.docs;
                    
                    var activeOrders = allOrders.where((doc) {
                      var data = doc.data() as Map<String, dynamic>;
                      bool isSelesai = data['status'] == 'Selesai';
                      bool isDibatalkan = data['status'] == 'Dibatalkan';
                      bool isDeleted = data['is_deleted'] == true;
                      
                      return !isSelesai && !isDibatalkan && !isDeleted;
                    }).toList();

                    if (activeOrders.isEmpty) {
                      return const Center(
                        child: Text("Belum ada perangkat yang sedang diservis."),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(Dell1996Spacing.lg),
                      itemCount: activeOrders.length,
                      itemBuilder: (context, index) {
                        var data = activeOrders[index].data() as Map<String, dynamic>;
                        String namaPelanggan = data['nama_user'] ?? 'Pelanggan';

                        int biayaServis = data['biaya_servis'] ?? 0;
                        String metode = data['metode_penyerahan'] ?? 'Dijemput';
                        int ongkir = (metode == 'Dijemput') ? 20000 : 0;
                        int totalBayar = biayaServis + ongkir;
                        String status = data['status'] ?? 'Proses';
                        
                        Color tintColor;
                        if (status == 'Menunggu Pembayaran') {
                          tintColor = Dell1996Colors.tintPeach;
                        } else if (status == 'Menunggu Teknisi') {
                          tintColor = Dell1996Colors.tintSky;
                        } else {
                          tintColor = Dell1996Colors.tintLime;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: Dell1996Spacing.lg),
                          decoration: BoxDecoration(
                            border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                            color: tintColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dell1996Spacing.md,
                                  vertical: Dell1996Spacing.s,
                                ),
                                decoration: const BoxDecoration(
                                  color: Dell1996Colors.canvas,
                                  border: Border(
                                    bottom: BorderSide(color: Dell1996Colors.frameInk, width: 1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (data['perangkat'] ?? 'LAPTOP').toString().toUpperCase(),
                                      style: Dell1996Typography.heading3,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      color: Dell1996Colors.frameInk,
                                      child: Text(
                                        status.toUpperCase(),
                                        style: Dell1996Typography.uiLabel.copyWith(color: Dell1996Colors.canvas),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(Dell1996Spacing.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (role == 'mitra') ...[
                                      Text("PEMILIK: ${namaPelanggan.toUpperCase()}", style: Dell1996Typography.uiLabel),
                                      const SizedBox(height: Dell1996Spacing.xs),
                                    ],
                                    Text("KATEGORI: ${(data['kategori'] ?? '-').toString().toUpperCase()}", style: Dell1996Typography.body),
                                    const SizedBox(height: Dell1996Spacing.xs),
                                    Text("KELUHAN: ${data['keluhan'] ?? '-'}", style: Dell1996Typography.body),
                                    
                                    if (status == 'Menunggu Teknisi' && role == 'user') ...[
                                      const SizedBox(height: Dell1996Spacing.md),
                                      Dell1996ButtonPrimary(
                                        text: "BATALKAN PESANAN",
                                        onPressed: () {
                                          _konfirmasiBatal(context, activeOrders[index].id);
                                        },
                                      ),
                                    ],
                                    
                                    if (status == 'Menunggu Pembayaran' && role == 'user') ...[
                                      const SizedBox(height: Dell1996Spacing.md),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(Dell1996Spacing.sm),
                                        decoration: BoxDecoration(
                                          color: Dell1996Colors.canvas,
                                          border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("NOTA TAGIHAN:", style: Dell1996Typography.heading3),
                                            const SizedBox(height: Dell1996Spacing.xs),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Biaya Servis", style: Dell1996Typography.body), Text("Rp $biayaServis", style: Dell1996Typography.body)]),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Ongkos Kirim ($metode)", style: Dell1996Typography.body), Text("Rp $ongkir", style: Dell1996Typography.body)]),
                                            const Divider(color: Dell1996Colors.frameInk),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("TOTAL TAGIHAN", style: Dell1996Typography.uiLabel),
                                                Text("Rp $totalBayar", style: Dell1996Typography.heading3),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: Dell1996Spacing.md),
                                      Dell1996CtaBlockRed(
                                        text: "PILIH PEMBAYARAN & KONFIRMASI",
                                        onTap: () {
                                          _tampilkanPopUpBayarUser(context, activeOrders[index].id, metode, totalBayar);
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _tampilkanPopUpBayarUser(BuildContext context, String docId, String metode, int total) {
    String metodePembayaranTerpilih = "COD";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Dell1996Colors.canvas,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              title: Text("METODE PEMBAYARAN", style: Dell1996Typography.heading2),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("TOTAL: Rp $total", style: Dell1996Typography.heading3),
                  const SizedBox(height: Dell1996Spacing.lg),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Dell1996Colors.frameInk, width: 1)),
                    child: RadioListTile<String>(
                      activeColor: Dell1996Colors.primary,
                      title: Text("COD (Bayar Tunai)", style: Dell1996Typography.body),
                      value: "COD",
                      // ignore: deprecated_member_use
                      groupValue: metodePembayaranTerpilih,
                      // ignore: deprecated_member_use
                      onChanged: (value) => setStateDialog(() => metodePembayaranTerpilih = value!),
                    ),
                  ),
                  const SizedBox(height: Dell1996Spacing.sm),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Dell1996Colors.frameInk, width: 1)),
                    child: RadioListTile<String>(
                      activeColor: Dell1996Colors.primary,
                      title: Text("Transfer Bank (Simulasi)", style: Dell1996Typography.body),
                      value: "Transfer",
                      // ignore: deprecated_member_use
                      groupValue: metodePembayaranTerpilih,
                      // ignore: deprecated_member_use
                      onChanged: (value) => setStateDialog(() => metodePembayaranTerpilih = value!),
                    ),
                  ),
                ],
              ),
              actions: [
                Dell1996ButtonPrimary(
                  text: "BATAL",
                  onPressed: () => Navigator.pop(context),
                ),
                Dell1996CtaBlockRed(
                  text: "KONFIRMASI",
                  onTap: () async {
                    String statusSelanjutnya = 'Sudah Dibayar';
                    await FirebaseFirestore.instance.collection('pesanan').doc(docId).update({
                      'status': statusSelanjutnya,
                      'metode_pembayaran_pilihan': metodePembayaranTerpilih,
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Pembayaran via $metodePembayaranTerpilih Berhasil!")),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _konfirmasiBatal(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Dell1996Colors.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text("BATALKAN PESANAN?", style: Dell1996Typography.heading2),
          content: Text("Apakah Anda yakin ingin membatalkan pesanan servis ini? Data pesanan akan dihapus dan teknisi tidak akan datang.", style: Dell1996Typography.body),
          actions: [
            Dell1996ButtonPrimary(text: "TUTUP", onPressed: () => Navigator.pop(dialogContext)),
            Dell1996CtaBlockRed(
              text: "YA, BATALKAN",
              onTap: () async {
                Navigator.pop(dialogContext);
                try {
                  await FirebaseFirestore.instance.collection('pesanan').doc(docId).update({
                    'status': 'Dibatalkan',
                    'is_deleted': true 
                  });

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pesanan berhasil dibatalkan.")),
                    );
                  }
                } catch (e) {
                  debugPrint("Error membatalkan pesanan: $e");
                }
              },
            ),
          ],
        );
      },
    );
  }
}
