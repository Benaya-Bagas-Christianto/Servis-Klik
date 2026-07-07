import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class GaransiPage extends StatefulWidget {
  const GaransiPage({super.key});

  @override
  State<GaransiPage> createState() => _GaransiPageState();
}

class _GaransiPageState extends State<GaransiPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Fungsi untuk memunculkan pop-up Form Pengajuan Klaim
  void _showFormKlaim() {
    final TextEditingController perangkatCtrl = TextEditingController();
    final TextEditingController seriCtrl = TextEditingController();
    final TextEditingController alasanCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Dell1996Colors.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text("AJUKAN KLAIM GARANSI", style: Dell1996Typography.heading2),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("MEREK & TIPE (CTH: ASUS ROG):", style: Dell1996Typography.uiLabel),
                const SizedBox(height: Dell1996Spacing.xs),
                Dell1996TextInput(controller: perangkatCtrl),
                const SizedBox(height: Dell1996Spacing.md),
                
                Text("NOMOR SERI (S/N):", style: Dell1996Typography.uiLabel),
                const SizedBox(height: Dell1996Spacing.xs),
                Dell1996TextInput(controller: seriCtrl),
                const SizedBox(height: Dell1996Spacing.md),
                
                Text("ALASAN KLAIM:", style: Dell1996Typography.uiLabel),
                const SizedBox(height: Dell1996Spacing.xs),
                Dell1996TextInput(controller: alasanCtrl, maxLines: 2),
              ],
            ),
          ),
          actions: [
            Dell1996ButtonPrimary(
              text: "BATAL",
              onPressed: () => Navigator.pop(context),
            ),
            Dell1996ButtonPrimary(
              text: "KIRIM KLAIM",
              onPressed: () async {
                if (perangkatCtrl.text.isEmpty || seriCtrl.text.isEmpty || alasanCtrl.text.isEmpty) return;

                // 👇 PROSES MENGAMBIL NAMA USER SEBELUM DISIMPAN
                String namaUser = "Pelanggan";
                if (currentUser != null) {
                  var userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
                  if (userDoc.exists) {
                    namaUser = userDoc.data()?['nama'] ?? 'Pelanggan';
                  }
                }

                // Kirim data ke Firestore
                await FirebaseFirestore.instance.collection('klaim_garansi').add({
                  'email_user': currentUser?.email ?? 'Unknown',
                  'nama_user': namaUser, // 🔥 Nama otomatis tersimpan di sini!
                  'perangkat': perangkatCtrl.text,
                  'nomor_seri': seriCtrl.text,
                  'alasan': alasanCtrl.text,
                  'status': 'Menunggu Peninjauan',
                  'waktu_klaim': FieldValue.serverTimestamp(),
                });

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("KLAIM GARANSI BERHASIL DIAJUKAN!", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
                      backgroundColor: Dell1996Colors.primary,
                    ),
                  );
                }
              },
            ),
          ],
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
            children: [
              const Dell1996TopBanner(
                title: 'GARANSI DIGITAL',
                subtitle: 'Portal Pengajuan Klaim',
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('klaim_garansi').where('email_user', isEqualTo: currentUser?.email).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Dell1996Colors.primary));
                    }
                    
                    var klaimList = [];
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      klaimList = snapshot.data!.docs.where((doc) {
                        var data = doc.data() as Map<String, dynamic>;
                        return data['is_deleted'] != true;
                      }).toList();
                    }

                    return ListView(
                      padding: const EdgeInsets.all(Dell1996Spacing.lg),
                      children: [
                        Dell1996CtaBlockRed(
                          text: "AJUKAN KLAIM BARU",
                          onTap: _showFormKlaim,
                        ),
                        const SizedBox(height: Dell1996Spacing.section),
                        
                        const Dell1996SectionEyebrow(
                          title: 'RIWAYAT KLAIM',
                          backgroundColor: Dell1996Colors.tintSky,
                        ),
                        const SizedBox(height: Dell1996Spacing.md),
                        
                        if (klaimList.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(Dell1996Spacing.lg),
                            decoration: BoxDecoration(
                              color: Dell1996Colors.canvas,
                              border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                            ),
                            child: Text(
                              "ANDA BELUM PERNAH MENGAJUKAN KLAIM GARANSI.",
                              style: Dell1996Typography.body,
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ...klaimList.map((doc) {
                            var data = doc.data() as Map<String, dynamic>;
                            String status = data['status'] ?? 'Menunggu Peninjauan';
                            
                            Color statusColor = Dell1996Colors.canvas;
                            if (status == 'Disetujui') statusColor = Dell1996Colors.tintLime;
                            if (status == 'Ditolak') statusColor = Dell1996Colors.tintPeach;
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: Dell1996Spacing.md),
                              padding: const EdgeInsets.all(Dell1996Spacing.md),
                              decoration: BoxDecoration(
                                color: statusColor,
                                border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (data['perangkat'] ?? 'Perangkat').toString().toUpperCase(),
                                        style: Dell1996Typography.heading3,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Dell1996Colors.canvas,
                                          border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                                        ),
                                        child: Text(
                                          status.toUpperCase(),
                                          style: Dell1996Typography.uiLabel,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dell1996Spacing.sm),
                                  Text("S/N: ${data['nomor_seri'] ?? '-'}", style: Dell1996Typography.body),
                                  const SizedBox(height: Dell1996Spacing.xs),
                                  Text("ALASAN: ${data['alasan'] ?? '-'}", style: Dell1996Typography.body),
                                ],
                              ),
                            );
                          }),
                      ],
                    );
                  },
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
            ],
          ),
        ),
      ),
    );
  }
}
