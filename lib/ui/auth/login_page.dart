import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 👇 Sesuaikan import ini ke file main.dart kamu agar setelah login sukses,
// layar berpindah ke menu utama (AuthWrapper).
import '../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();

  String _selectedRole = 'user';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  // =========================================================================
  // FUNGSI UNTUK MERESET PASSWORD (LUPA KATA SANDI)
  // =========================================================================
  void _showForgotPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.lock_reset, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text(
                "Lupa Kata Sandi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Masukkan email yang terdaftar. Kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda.",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Anda',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                String email = resetEmailController.text.trim();
                if (email.isEmpty) return;

                try {
                  // 👇 Ini adalah kode sakti Firebase untuk mengirim email reset!
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: email,
                  );

                  if (context.mounted) {
                    Navigator.pop(context); // Tutup pop-up
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Tautan reset kata sandi telah dikirim ke email Anda!",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message ?? "Terjadi kesalahan"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                "Kirim Tautan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // PROSES LOGIN
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        // PROSES REGISTER
        if (_namaController.text.trim().isEmpty) {
          throw Exception("Nama lengkap harus diisi!");
        }

        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set({
              'email': _emailController.text.trim(),
              'nama': _namaController.text.trim(),
              'role': _selectedRole,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isLogin ? "Login Berhasil!" : "Akun berhasil dibuat!"),
          backgroundColor: Colors.green,
        ),
      );

      // Navigator dihapus karena AuthWrapper di main.dart otomatis mendeteksi perubahan sesi dan akan langsung memindahkan pengguna ke MainScreen.
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Terjadi kesalahan pada Firebase"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.handyman, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),

              Text(
                _isLogin ? 'Selamat Datang Kembali!' : 'Bergabung Bersama Kami',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isLogin
                    ? 'Silakan masuk untuk melanjutkan.'
                    : 'Buat akun untuk mulai menggunakan ServisKlik.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              if (!_isLogin) ...[
                TextField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // 👇 TOMBOL LUPA KATA SANDI (Hanya muncul di mode Login)
              if (_isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: const Text(
                      "Lupa Kata Sandi?",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              if (!_isLogin) const SizedBox(height: 15),

              if (!_isLogin) ...[
                const Text(
                  "Mendaftar sebagai:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                PopupMenuButton<String>(
                  initialValue: _selectedRole,
                  offset: const Offset(0, 55), // 👈 Memaksa menu muncul tepat di BAWAH tombol (ke bawah)
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 48,
                    maxWidth: MediaQuery.of(context).size.width - 48,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (String item) {
                    setState(() {
                      _selectedRole = item;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'user',
                      child: Text('👤 Pelanggan (Customer)'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'mitra',
                      child: Text('🔧 Teknisi (Mitra Servis)'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedRole == 'user'
                              ? "👤 Pelanggan (Customer)"
                              : "🔧 Teknisi (Mitra Servis)",
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 10),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isLogin ? 'Masuk' : 'Daftar Sekarang',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(
                  _isLogin
                      ? 'Belum punya akun? Daftar di sini'
                      : 'Sudah punya akun? Masuk di sini',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
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
