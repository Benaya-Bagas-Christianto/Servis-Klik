import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // 👈 IMPORT BARU UNTUK MENDETEKSI WEB


import 'ui/home/home_page_dell1996.dart';
import 'ui/home/tracking/live_tracking_page.dart';
import 'ui/profile/profile_page.dart';
import 'ui/auth/login_page.dart';

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
    const HomePageDell1996(),
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
    return Dell1996PageFrame(
      child: Scaffold(
        backgroundColor: Dell1996Colors.canvas,
        body: SafeArea(
          child: _pages[_selectedIndex],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Dell1996Colors.frameInk, width: 1),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Dell1996IconLabelNav(
                  icon: Icons.home,
                  label: 'BERANDA',
                  isActive: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
              ),
              Expanded(
                child: Dell1996IconLabelNav(
                  icon: Icons.track_changes,
                  label: 'TRACKING',
                  isActive: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
              ),
              Expanded(
                child: Dell1996IconLabelNav(
                  icon: Icons.person,
                  label: 'PROFIL',
                  isActive: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
