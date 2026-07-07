import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 👇 Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // 👇 Import Firestore
import '../../main.dart'; // 👇 Path yang benar menuju main.dart
import '../../../theme/dell_1996_theme.dart';
import '../../../widget/dell_1996_components.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _prosesDaftar() async {
    if (_namaController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("MOHON LENGKAPI NAMA, EMAIL, DAN KATA SANDI!", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
          backgroundColor: Dell1996Colors.primary,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Buat akun di Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // 2. Simpan profil user ke Database Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'nama': _namaController.text.trim(),
            'telepon': _phoneController.text.trim(),
            'email': _emailController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });

      setState(() => _isLoading = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("PENDAFTARAN BERHASIL! MEMBUKA APLIKASI...", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
          backgroundColor: Dell1996Colors.primary,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("GAGAL DAFTAR: ${e.toString()}", style: Dell1996Typography.body.copyWith(color: Dell1996Colors.canvas)),
          backgroundColor: Dell1996Colors.primary,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                title: 'BUAT AKUN BARU',
                subtitle: 'Sistem Pendaftaran Pengguna',
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Dell1996Spacing.lg),
                    child: Container(
                      padding: const EdgeInsets.all(Dell1996Spacing.xl),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "FORMULIR PENDAFTARAN",
                            style: Dell1996Typography.heading2,
                          ),
                          const SizedBox(height: Dell1996Spacing.sm),
                          Text(
                            "Daftar sekarang dan nikmati kemudahan servis IT langsung dari rumahmu.",
                            style: Dell1996Typography.body,
                          ),
                          const SizedBox(height: Dell1996Spacing.xl),
          
                          Text("NAMA LENGKAP:", style: Dell1996Typography.uiLabel),
                          const SizedBox(height: Dell1996Spacing.xs),
                          Dell1996TextInput(controller: _namaController),
                          const SizedBox(height: Dell1996Spacing.md),
          
                          Text("NOMOR TELEPON / WHATSAPP:", style: Dell1996Typography.uiLabel),
                          const SizedBox(height: Dell1996Spacing.xs),
                          Dell1996TextInput(controller: _phoneController),
                          const SizedBox(height: Dell1996Spacing.md),
          
                          Text("EMAIL:", style: Dell1996Typography.uiLabel),
                          const SizedBox(height: Dell1996Spacing.xs),
                          Dell1996TextInput(controller: _emailController),
                          const SizedBox(height: Dell1996Spacing.md),
          
                          Text("KATA SANDI:", style: Dell1996Typography.uiLabel),
                          const SizedBox(height: Dell1996Spacing.xs),
                          Dell1996TextInput(controller: _passwordController, obscureText: true),
                          const SizedBox(height: Dell1996Spacing.xl),
          
                          _isLoading
                              ? const Center(child: CircularProgressIndicator(color: Dell1996Colors.primary))
                              : Dell1996CtaBlockRed(
                                  text: "DAFTAR AKUN",
                                  onTap: _prosesDaftar,
                                ),
                          
                          const SizedBox(height: Dell1996Spacing.lg),
                          Center(
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                "KEMBALI KE HALAMAN LOG MASUK",
                                style: Dell1996Typography.body.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: Dell1996Colors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
