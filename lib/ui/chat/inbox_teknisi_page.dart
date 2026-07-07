import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class InboxTeknisiPage extends StatelessWidget {
  const InboxTeknisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              const Dell1996TopBanner(
                title: 'INBOX PELANGGAN',
                subtitle: 'Daftar Pesan Masuk',
                showBackButton: true,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  // Mengambil daftar semua user dari database
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Dell1996Colors.primary));
                    }
          
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(Dell1996Spacing.lg),
                          decoration: BoxDecoration(
                            border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                          ),
                          child: Text("BELUM ADA PELANGGAN.", style: Dell1996Typography.body),
                        ),
                      );
                    }
          
                    var users = snapshot.data!.docs;
          
                    return ListView.builder(
                      padding: const EdgeInsets.all(Dell1996Spacing.lg),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var userData = users[index].data() as Map<String, dynamic>;
                        String email = userData['email'] ?? '';
                        String nama = userData['nama'] ?? 'Pelanggan';
                        String role = userData['role'] ?? 'user';
          
                        // Menyembunyikan akun sesama teknisi dari daftar Inbox
                        if (role == 'mitra') return const SizedBox.shrink();
          
                        return InkWell(
                          onTap: () {
                            // Jika ditekan, buka Ruang Chat khusus pelanggan tersebut
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatPage(customerUid: email.isNotEmpty ? email : users[index].id, customerName: nama),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: Dell1996Spacing.md),
                            padding: const EdgeInsets.all(Dell1996Spacing.md),
                            decoration: BoxDecoration(
                              color: Dell1996Colors.canvas,
                              border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Dell1996Colors.frameInk,
                                  offset: Offset(4, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Dell1996Colors.tintSky,
                                    border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                                  ),
                                  child: const Icon(Icons.person, color: Dell1996Colors.frameInk),
                                ),
                                const SizedBox(width: Dell1996Spacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nama.toUpperCase(),
                                        style: Dell1996Typography.heading3,
                                      ),
                                      const SizedBox(height: Dell1996Spacing.xs),
                                      Text(
                                        email,
                                        style: Dell1996Typography.uiLabel,
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    bool? confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Dell1996Colors.canvas,
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                        title: Text("HAPUS PELANGGAN", style: Dell1996Typography.heading2),
                                        content: Text(
                                          "Yakin ingin menghapus ${nama.toUpperCase()} dari daftar? Ini akan menghapus akunnya dari database beserta riwayat pesannya.",
                                          style: Dell1996Typography.body,
                                        ),
                                        actions: [
                                          Dell1996ButtonPrimary(
                                            text: "BATAL",
                                            onPressed: () => Navigator.pop(context, false),
                                          ),
                                          Dell1996ButtonPrimary(
                                            text: "HAPUS",
                                            onPressed: () => Navigator.pop(context, true),
                                          ),
                                        ],
                                      ),
                                    );
          
                                    if (confirm == true) {
                                      try {
                                        // Hapus data pengguna dari koleksi users
                                        await FirebaseFirestore.instance.collection('users').doc(users[index].id).delete();
                                        
                                        // Hapus semua pesan di ruang chat pelanggan ini
                                        String targetChatId = email.isNotEmpty ? email : users[index].id;
                                        var chatDocs = await FirebaseFirestore.instance
                                            .collection('ruang_chat')
                                            .doc(targetChatId)
                                            .collection('pesan')
                                            .get();
                                        
                                        if (chatDocs.docs.isNotEmpty) {
                                          var batch = FirebaseFirestore.instance.batch();
                                          for (var doc in chatDocs.docs) {
                                            batch.delete(doc.reference);
                                          }
                                          await batch.commit();
                                        }
          
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("PELANGGAN ${nama.toUpperCase()} BERHASIL DIHAPUS.", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
                                              backgroundColor: Dell1996Colors.primary,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        debugPrint("Error menghapus pelanggan: $e");
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(Dell1996Spacing.sm),
                                    decoration: BoxDecoration(
                                      color: Dell1996Colors.primary,
                                      border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                                    ),
                                    child: const Icon(Icons.delete, color: Dell1996Colors.canvas, size: 20),
                                  ),
                                ),
                                const SizedBox(width: Dell1996Spacing.sm),
                                Container(
                                  padding: const EdgeInsets.all(Dell1996Spacing.sm),
                                  decoration: BoxDecoration(
                                    color: Dell1996Colors.tintSky,
                                    border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                                  ),
                                  child: const Icon(Icons.chat_bubble, color: Dell1996Colors.frameInk, size: 20),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
