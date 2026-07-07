import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

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

  String _namaSaya = "PENGGUNA";
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
          _namaSaya = (doc.data()?['nama'] ?? 'Pengguna').toString().toUpperCase();
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
        backgroundColor: Dell1996Colors.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text("HAPUS PESAN", style: Dell1996Typography.heading2),
        content: Text("Apakah Anda yakin ingin menghapus pesan ini?", style: Dell1996Typography.body),
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
        backgroundColor: Dell1996Colors.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text("HAPUS SEMUA CHAT", style: Dell1996Typography.heading2),
        content: Text(
          "Apakah Anda yakin ingin menghapus seluruh riwayat chat ini? Data yang dihapus tidak dapat dikembalikan.",
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
            SnackBar(
              content: Text("RIWAYAT CHAT BERHASIL DIHAPUS.", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
              backgroundColor: Dell1996Colors.primary,
            ),
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
        ? "CHAT: ${widget.customerName.toUpperCase()}"
        : "LIVE CHAT TEKNISI";

    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              Dell1996TopBanner(
                title: appBarTitle,
                showBackButton: true,
                trailingWidget: InkWell(
                  onTap: _clearChatHistory,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Dell1996Colors.canvas,
                      border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                    ),
                    child: const Icon(Icons.delete_sweep, size: 20, color: Dell1996Colors.frameInk),
                  ),
                ),
              ),
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
                      return const Center(child: CircularProgressIndicator(color: Dell1996Colors.primary));
                    }
          
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(Dell1996Spacing.lg),
                          decoration: BoxDecoration(
                            color: Dell1996Colors.canvas,
                            border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                          ),
                          child: Text(
                            _roleSaya == 'mitra'
                                ? "BELUM ADA PESAN DARI PELANGGAN INI."
                                : "SAPA TEKNISI KAMI SEKARANG!",
                            style: Dell1996Typography.body,
                          ),
                        ),
                      );
                    }
          
                    var messages = snapshot.data!.docs;
          
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(Dell1996Spacing.lg),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var data = messages[index].data() as Map<String, dynamic>;
                        String docId = messages[index].id;
                        bool isMe = data['senderEmail'] == currentUser?.email;
                        bool isTeknisi = data['role'] == 'mitra';
          
                        return _buildChatBubble(
                          data['text'] ?? '',
                          isMe,
                          (data['senderName'] ?? 'Anonim').toString().toUpperCase(),
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
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(Dell1996Spacing.md),
      decoration: const BoxDecoration(
        color: Dell1996Colors.tintSteel,
        border: Border(top: BorderSide(color: Dell1996Colors.frameInk, width: 2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Dell1996TextInput(
              controller: _chatController,
              maxLines: 1, // Kita set 1 baris saja agar sederhana seperti UI 90an
            ),
          ),
          const SizedBox(width: Dell1996Spacing.sm),
          InkWell(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Dell1996Colors.primary,
                border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                boxShadow: const [
                  BoxShadow(color: Dell1996Colors.frameInk, offset: Offset(2, 2)),
                ],
              ),
              child: Text(
                "KIRIM",
                style: Dell1996Typography.body.copyWith(
                  color: Dell1996Colors.canvas,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
          margin: const EdgeInsets.only(bottom: Dell1996Spacing.md),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: Dell1996Spacing.xs),
                child: Text(
                  isTeknisi ? "🔧 $senderName (TEKNISI)" : senderName,
                  style: Dell1996Typography.uiLabel,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Dell1996Spacing.md, vertical: Dell1996Spacing.sm),
                decoration: BoxDecoration(
                  color: isMe
                      ? (_roleSaya == 'mitra' ? Dell1996Colors.tintSky : Dell1996Colors.tintLime)
                      : Dell1996Colors.canvas,
                  border: Border.all(color: Dell1996Colors.frameInk, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Dell1996Colors.frameInk, offset: Offset(2, 2)),
                  ],
                ),
                child: Text(
                  text,
                  style: Dell1996Typography.body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
