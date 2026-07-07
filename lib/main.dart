import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // 👈 IMPORT BARU UNTUK MENDETEKSI WEB

import 'ui/home/home_page.dart';
import 'ui/home/home_page_dell1996.dart';
import 'ui/home/tracking/live_tracking_page.dart';
import 'ui/profile/profile_page.dart';
import 'ui/auth/login_page.dart';
import 'ui/dell_1996_demo_page.dart';
import 'theme/dell_1996_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 LOGIKA INISIALISASI FIREBASE DIPISAH (WEB vs ANDROID)
  if (kIsWeb) {
    // 🌐 Jika dijalankan di Web / Chrome
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC_DRoi3b_He1NkCXvI_5Nj4Tq5F2JICnQ",
        authDomain: "project-mobprog-56024.firebaseapp.com",
        projectId: "project-mobprog-56024",
        storageBucket: "project-mobprog-56024.firebasestorage.app",
        messagingSenderId: "821887691868",
        // ⚠️ PENTING: Untuk appId (khusus Web), silakan copy dari Firebase Console (Project Settings > General > Web App)
        appId: "ISI_DENGAN_APP_ID_WEB_DARI_FIREBASE",
      ),
    );
  } else {
    // 📱 Jika dijalankan di Emulator Android
    await Firebase.initializeApp();
  }

  runApp(const ServisKlikApp());
}

// ==========================================
// PENGATURAN SCROLL GLOBAL (Menghilangkan Stretch)
// ==========================================
class NoStretchScrollBehavior extends ScrollBehavior {
  const NoStretchScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Mengubah efek memantul menjadi "Mentok" (Clamping) tanpa stretch
    return const ClampingScrollPhysics();
  }
}

class ServisKlikApp extends StatelessWidget {
  const ServisKlikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ServisKlik',
      theme: dell1996Theme(), // 🎨 TEMA DELL 1996
      scrollBehavior: const NoStretchScrollBehavior(), // 👈 PASANG DI SINI
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainScreen();
        }

        return const LoginPage();
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageDell1996(), // 🎨 MENGGUNAKAN VERSI DELL 1996
    const LiveTrackingPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SERVISKLIK 🔧',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Dell1996Colors.primary,
                border: Border.all(color: Dell1996Colors.canvas, width: 1),
              ),
              child: const Text(
                '1-800-SERVIS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Dell1996Colors.frameInk, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'BERANDA',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_outlined),
              activeIcon: Icon(Icons.track_changes),
              label: 'TRACKING',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'PROFIL',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
