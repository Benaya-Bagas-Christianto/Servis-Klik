import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 👇 Import Firebase Auth
import 'dart:async';
import '../auth/login_page.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _cekStatusLogin();
  }

  Future<void> _cekStatusLogin() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    // 👇 Cek apakah ada sesi user aktif di memori Firebase
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    if (currentUser != null) {
      // Jika sudah login, langsung ke Beranda
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Jika belum, arahkan ke Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.build_circle,
                size: 100,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "ServisKlik",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Solusi IT Transparan,\nLangsung dari Genggaman.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
