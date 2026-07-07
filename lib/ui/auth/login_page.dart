import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/dell_1996_theme.dart';
import '../../widget/dell_1996_components.dart';

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

  void _showForgotPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: Dell1996Colors.canvas,
          title: Text(
            "LUPA KATA SANDI",
            style: Dell1996Typography.heading2,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Masukkan email yang terdaftar. Kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda.",
                style: Dell1996Typography.body,
              ),
              const SizedBox(height: Dell1996Spacing.lg),
              Dell1996TextInput(
                controller: resetEmailController,
                hintText: 'Email Anda',
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            Dell1996ButtonPrimary(
              text: "Batal",
              onPressed: () => Navigator.pop(context),
            ),
            Dell1996ButtonPrimary(
              text: "Kirim Tautan",
              onPressed: () async {
                String email = resetEmailController.text.trim();
                if (email.isEmpty) return;

                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: email,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tautan reset kata sandi telah dikirim!"),
                      ),
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message ?? "Terjadi kesalahan")),
                    );
                  }
                }
              },
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
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
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
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Terjadi kesalahan")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                title: 'PORTAL SERVISKLIK',
                subtitle: 'Akses aman ke sistem perbaikan elektronik',
                trailingWidget: Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS'),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Dell1996Spacing.xl),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Dell1996Colors.surface,
                        border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                      ),
                      padding: const EdgeInsets.all(Dell1996Spacing.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isLogin ? 'LOGIN SISTEM' : 'REGISTRASI SISTEM',
                            style: Dell1996Typography.display.copyWith(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dell1996Spacing.lg),
                          Text(
                            _isLogin
                                ? 'Silakan masukkan kredensial Anda.'
                                : 'Silakan lengkapi formulir pendaftaran.',
                            style: Dell1996Typography.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dell1996Spacing.xl),
                          
                          if (!_isLogin) ...[
                            Text('NAMA LENGKAP', style: Dell1996Typography.uiLabel),
                            const SizedBox(height: Dell1996Spacing.xs),
                            Dell1996TextInput(
                              controller: _namaController,
                              hintText: 'Nama Lengkap',
                            ),
                            const SizedBox(height: Dell1996Spacing.md),
                          ],

                          Text('EMAIL', style: Dell1996Typography.uiLabel),
                          const SizedBox(height: Dell1996Spacing.xs),
                          Dell1996TextInput(
                            controller: _emailController,
                            hintText: 'user@example.com',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: Dell1996Spacing.md),

                          Text('KATA SANDI', style: Dell1996Typography.uiLabel),
                          const SizedBox(height: Dell1996Spacing.xs),
                          Dell1996TextInput(
                            controller: _passwordController,
                            hintText: '********',
                            obscureText: true,
                          ),
                          const SizedBox(height: Dell1996Spacing.md),

                          if (_isLogin)
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: _showForgotPasswordDialog,
                                child: Text(
                                  "(Lupa Kata Sandi?)",
                                  style: Dell1996Typography.link,
                                ),
                              ),
                            ),

                          if (!_isLogin) ...[
                            Text('TIPE AKUN', style: Dell1996Typography.uiLabel),
                            const SizedBox(height: Dell1996Spacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: Dell1996Colors.canvas,
                                border: Border.all(color: Dell1996Colors.frameInk, width: 1),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedRole,
                                  isExpanded: true,
                                  dropdownColor: Dell1996Colors.canvas,
                                  style: Dell1996Typography.body,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedRole = newValue!;
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'user',
                                      child: Text('Pelanggan (Customer)'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'mitra',
                                      child: Text('Teknisi (Mitra Servis)'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Dell1996Spacing.lg),
                          ],
                          
                          const SizedBox(height: Dell1996Spacing.lg),

                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Dell1996CtaBlockRed(
                                  text: _isLogin ? 'MASUK KE SISTEM' : 'DAFTARKAN AKUN',
                                  onTap: _submitForm,
                                ),

                          const SizedBox(height: Dell1996Spacing.lg),

                          Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Belum punya akun? (Daftar)'
                                    : 'Sudah punya akun? (Masuk)',
                                style: Dell1996Typography.link,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Dell1996FooterBand(
                text: 'Copyright © 2026 ServisKlik. All rights reserved.\nThis site is best viewed with browser versions 3.0 and higher.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
