import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';

class InboxTeknisiPage extends StatelessWidget {
  const InboxTeknisiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inbox Pelanggan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        // Mengambil daftar semua user dari database
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada pelanggan."));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>;
              String email = userData['email'] ?? '';
              String nama = userData['nama'] ?? 'Pelanggan';
              String role = userData['role'] ?? 'user';

              // Menyembunyikan akun sesama teknisi dari daftar Inbox
              if (role == 'mitra') return const SizedBox.shrink();

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    email,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () async {
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Hapus Pelanggan"),
                              content: Text("Yakin ingin menghapus $nama dari daftar? Ini akan menghapus akunnya dari database beserta riwayat pesannya."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Hapus", style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              // Hapus data pengguna dari koleksi users
                              await FirebaseFirestore.instance.collection('users').doc(users[index].id).delete();
                              
                              // Hapus semua pesan di ruang chat pelanggan ini (opsional tapi disarankan agar bersih)
                              String targetChatId = email.isNotEmpty ? email : users[index].id;
                              var chatDocs = await FirebaseFirestore.instance
                                  .collection('ruang_chat')
                                  .doc(targetChatId) // 👈 Diperbaiki: Hapus berdasarkan Email (jika ada), sama seperti pembuatan ruang chat
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
                                  SnackBar(content: Text("Pelanggan $nama berhasil dihapus.")),
                                );
                              }
                            } catch (e) {
                              debugPrint("Error menghapus pelanggan: $e");
                            }
                          }
                        },
                      ),
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.indigo,
                      ),
                    ],
                  ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
