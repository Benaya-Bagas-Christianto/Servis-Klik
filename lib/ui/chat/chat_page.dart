import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String customerUid;
  final String customerName;

  // Parameter untuk mengetahui ini adalah ruang chat milik siapa
  const ChatPage({
    super.key,
    required this.customerUid,
    required this.customerName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String _namaSaya = "Pengguna";
  String _roleSaya = "user";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    if (currentUser != null) {
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _namaSaya = doc.data()?['nama'] ?? 'Pengguna';
          _roleSaya = doc.data()?['role'] ?? 'user';
        });
      }
    }
  }

  void _sendMessage() async {
    String text = _chatController.text.trim();
    if (text.isEmpty) return;

    _chatController.clear();

    try {
      // 👇 RAHASIANYA DI SINI: Chat disimpan di dalam "folder" email pelanggan
      await FirebaseFirestore.instance
          .collection('ruang_chat')
          .doc(widget.customerUid) // ID Ruangan = UID Pelanggan
          .collection('pesan')
          .add({
            'text': text,
            'senderEmail': currentUser?.email ?? 'unknown',
            'senderName': _namaSaya,
            'role': _roleSaya,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      debugPrint("Error kirim pesan: $e");
    }
  }

  void _deleteMessage(String docId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Pesan"),
        content: const Text("Apakah Anda yakin ingin menghapus pesan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('ruang_chat')
            .doc(widget.customerUid)
            .collection('pesan')
            .doc(docId)
            .delete();
      } catch (e) {
        debugPrint("Error hapus pesan: $e");
      }
    }
  }

  Future<void> _clearChatHistory() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Semua Chat"),
        content: const Text("Apakah Anda yakin ingin menghapus seluruh riwayat chat ini? Data yang dihapus tidak dapat dikembalikan."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        var docs = await FirebaseFirestore.instance
            .collection('ruang_chat')
            .doc(widget.customerUid)
            .collection('pesan')
            .get();
        
        // Menghapus semua dokumen dalam koleksi pesan
        var batch = FirebaseFirestore.instance.batch();
        for (var doc in docs.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Riwayat chat berhasil dihapus.")),
          );
        }
      } catch (e) {
        debugPrint("Error hapus history: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan judul atas menyesuaikan siapa yang login
    String appBarTitle = _roleSaya == 'mitra'
        ? "Chat: ${widget.customerName}"
        : "Live Chat Teknisi";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _roleSaya == 'mitra'
            ? Colors.indigo
            : Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Hapus Semua Chat',
            onPressed: _clearChatHistory,
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // 👇 Menarik data HANYA dari ruang obrolan milik pelanggan ini
              stream: FirebaseFirestore.instance
                  .collection('ruang_chat')
                  .doc(widget.customerUid)
                  .collection('pesan')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      _roleSaya == 'mitra'
                          ? "Belum ada pesan dari pelanggan ini."
                          : "Sapa teknisi kami sekarang!",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var data = messages[index].data() as Map<String, dynamic>;
                    String docId = messages[index].id;
                    bool isMe = data['senderEmail'] == currentUser?.email;
                    bool isTeknisi = data['role'] == 'mitra';

                    return _buildChatBubble(
                      data['text'] ?? '',
                      isMe,
                      data['senderName'] ?? 'Anonim',
                      isTeknisi,
                      docId,
                    );
                  },
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              minLines: 1,
              maxLines: 4, // Akan membesar ke bawah maksimal 4 baris sebelum bisa di-scroll
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Ketik pesan...",
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
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: _roleSaya == 'mitra'
                ? Colors.indigo
                : Colors.blueAccent,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(
    String text,
    bool isMe,
    String senderName,
    bool isTeknisi,
    String docId,
  ) {
    return GestureDetector(
      onLongPress: () => _deleteMessage(docId),
      child: Align(
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe
                    ? (_roleSaya == 'mitra' ? Colors.indigo : Colors.blueAccent)
                    : Colors.white,
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
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
