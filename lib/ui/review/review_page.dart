import 'package:flutter/material.dart';
import 'package:project_moprog/main.dart'; // 👇 Sesuaikan path-nya pakai Lampu Kuning jika merah

class ReviewPage extends StatefulWidget {
  final String technicianName;

  const ReviewPage({super.key, required this.technicianName});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _rating = 0;
  final TextEditingController _ulasanController = TextEditingController();

  bool _isSubmitting = false; // 👇 Variabel loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Beri Ulasan", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.thumb_up_alt,
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Perbaikan Selesai! 🎉",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Bagaimana kinerja ${widget.technicianName} dalam memperbaiki perangkat Anda?",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 30),

            // --- BINTANG INTERAKTIF ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  iconSize: 40,
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(
              _getRatingText(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 30),

            // --- KOLOM KOMENTAR ---
            TextField(
              controller: _ulasanController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Tuliskan pengalaman Anda... (Opsional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 40),

            // --- TOMBOL KIRIM ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _rating > 0
                      ? Colors.blueAccent
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: (_rating > 0 && !_isSubmitting)
                    ? () async {
                        setState(() => _isSubmitting = true);

                        // Simulasi ngirim data ke server (1.5 detik)
                        await Future.delayed(
                          const Duration(milliseconds: 1500),
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Terima kasih atas ulasan Anda!"),
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    : null,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Kirim Ulasan",
                        style: TextStyle(
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

  String _getRatingText() {
    switch (_rating) {
      case 1:
        return "Sangat Buruk 😞";
      case 2:
        return "Buruk 😕";
      case 3:
        return "Cukup 😐";
      case 4:
        return "Bagus 🙂";
      case 5:
        return "Sangat Memuaskan! 🤩";
      default:
        return "Pilih bintang";
    }
  }
}
