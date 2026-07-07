import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class PusatBantuanPage extends StatefulWidget {
  const PusatBantuanPage({super.key});

  @override
  State<PusatBantuanPage> createState() => _PusatBantuanPageState();
}

class _PusatBantuanPageState extends State<PusatBantuanPage> {
  final TextEditingController _chatController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String _namaUser = "Pengguna";
  String _roleUser = "user";
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Mengambil nama dan role user saat ini untuk identitas chat
  Future<void> _getUserData() async {
    if (currentUser != null) {
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _namaUser = doc.data()?['nama'] ?? 'Pengguna';
          _roleUser = doc.data()?['role'] ?? 'user';
        });
      }
    }
  }

  // Fungsi mengirim pesan ke Firebase
  void _sendMessage() async {
    String text = _chatController.text.trim();
    if (text.isEmpty) return;

    _chatController.clear(); // Bersihkan kotak ketik langsung agar responsif

    try {
      await FirebaseFirestore.instance.collection('bantuan_chat').add({
        'text': text,
        'senderEmail': currentUser?.email ?? 'unknown',
        'senderName': _namaUser,
        'role': _roleUser,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error kirim pesan: $e");
    }
  }

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      File file = File(image.path);
      await _uploadImage(file);
    }
  }

  // Fungsi mengunggah gambar ke Firebase Storage dan kirim sebagai pesan
  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = 'chat_images/${DateTime.now().millisecondsSinceEpoch}_${currentUser?.uid ?? 'unknown'}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Kirim ke Firestore
      await FirebaseFirestore.instance.collection('bantuan_chat').add({
        'text': '📸 Mengirim gambar',
        'imageUrl': downloadUrl,
        'senderEmail': currentUser?.email ?? 'unknown',
        'senderName': _namaUser,
        'role': _roleUser,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error upload gambar: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengirim gambar: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Live Chat Bantuan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Peringatan bahwa ini adalah ruang chat langsung
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.orange.withValues(alpha: 0.2),
            child: const Text(
              "Anda terhubung langsung dengan Tim Teknisi ServisKlik",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Area Daftar Chat (Membaca dari Firebase secara Live)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bantuan_chat')
                  .orderBy(
                    'timestamp',
                    descending: true,
                  ) // Urutkan dari yang terbaru
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada pesan. Sapa teknisi kami sekarang!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse:
                      true, // Membalik list agar pesan baru muncul di bawah
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var data = messages[index].data() as Map<String, dynamic>;

                    // Cek apakah pesan ini dikirim oleh kita sendiri
                    bool isMe = data['senderEmail'] == currentUser?.email;
                    // Cek apakah pengirimnya adalah seorang teknisi
                    bool isTeknisi = data['role'] == 'mitra';

                    return _buildChatBubble(
                      data['text'] ?? '',
                      isMe,
                      data['senderName'] ?? 'Anonim',
                      isTeknisi,
                      imageUrl: data['imageUrl'],
                    );
                  },
                );
              },
            ),
          ),

          // Area Kotak Input Teks
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.blueAccent),
                  onPressed: _isUploading ? null : _pickAndUploadImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: _isUploading ? "Mengunggah gambar..." : "Ketik pesan Anda di sini...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: _isUploading ? null : (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: _isUploading ? Colors.grey : Colors.blueAccent,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _isUploading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Desain Gelembung Chat
  Widget _buildChatBubble(
    String text,
    bool isMe,
    String senderName,
    bool isTeknisi, {
    String? imageUrl,
  }) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Nama Pengirim (Khusus untuk Teknisi diberi label)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
              child: Text(
                isTeknisi ? "🔧 $senderName (Teknisi)" : senderName,
                style: TextStyle(
                  fontSize: 11,
                  color: isTeknisi ? Colors.indigo : Colors.grey[600],
                  fontWeight: isTeknisi ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),

            // Kotak Pesan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.blueAccent
                    : (isTeknisi ? Colors.indigo.shade50 : Colors.white),
                border: Border.all(
                  color: isTeknisi && !isMe
                      ? Colors.indigo.shade100
                      : Colors.transparent,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 200,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 200,
                              height: 200,
                              color: isMe ? Colors.blue[300] : Colors.grey[300],
                              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
