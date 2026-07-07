# 🔧 Troubleshooting - Dell 1996 Design

## 🐛 Masalah Umum & Solusi

### 1. ❌ Import Error: 'dell_1996_theme.dart' not found

**Masalah:**
```dart
Error: 'package:project_moprog/theme/dell_1996_theme.dart' not found.
```

**Solusi:**
- Pastikan file ada di `lib/theme/dell_1996_theme.dart`
- Check struktur folder:
```
lib/
├── theme/
│   └── dell_1996_theme.dart  ← Harus ada di sini
```
- Restart IDE (VS Code / Android Studio)
- Run `flutter clean` lalu `flutter pub get`

---

### 2. ❌ Import Error: 'dell_1996_components.dart' not found

**Masalah:**
```dart
Error: 'package:project_moprog/widget/dell_1996_components.dart' not found.
```

**Solusi:**
- Pastikan file ada di `lib/widget/dell_1996_components.dart`
- Check path import:
```dart
// ❌ SALAH
import 'theme/dell_1996_theme.dart';

// ✅ BENAR (jika di lib/)
import 'theme/dell_1996_theme.dart';

// ✅ BENAR (jika di subfolder lib/ui/)
import '../theme/dell_1996_theme.dart';
```

---

### 3. ❌ Dell1996Colors tidak dikenali

**Masalah:**
```dart
Undefined class 'Dell1996Colors'.
```

**Solusi:**
- Pastikan sudah import theme:
```dart
import '../theme/dell_1996_theme.dart';
```
- Atau gunakan full path:
```dart
import 'package:project_moprog/theme/dell_1996_theme.dart';
```

---

### 4. ❌ Border tidak muncul / tidak terlihat

**Masalah:**
Container tidak memiliki border meski sudah di-set.

**Solusi:**
- Pastikan menggunakan `BoxDecoration`:
```dart
// ❌ SALAH
Container(
  border: Border.all(color: Colors.black),
  child: Text('Test'),
)

// ✅ BENAR
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Dell1996Colors.frameInk, width: 1),
  ),
  child: Text('Test'),
)
```

---

### 5. ❌ Border radius masih terlihat (tidak tajam)

**Masalah:**
Sudut container masih rounded padahal sudah set radius = 0.

**Solusi:**
```dart
// ✅ Pastikan BorderRadius = zero
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.zero, // ← Harus zero
    border: Border.all(color: Dell1996Colors.frameInk, width: 1),
  ),
)

// Atau untuk Card
Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.zero, // ← Harus zero
  ),
)
```

---

### 6. ❌ Font tidak sesuai (tidak terlihat seperti Times New Roman)

**Masalah:**
Body text tidak terlihat serif / tidak seperti Times New Roman.

**Solusi:**
- System font mungkin berbeda di tiap platform
- Gunakan fallback:
```dart
TextStyle(
  fontFamily: 'Times New Roman',
  fontFamilyFallback: ['Times', 'serif'],
  fontSize: 14,
)
```
- Atau gunakan Dell1996Typography:
```dart
Text(
  'Body text',
  style: Dell1996Typography.body, // Sudah include fallback
)
```

---

### 7. ❌ Warna tidak sesuai / berbeda dari design

**Masalah:**
Warna terlihat berbeda dari yang diharapkan.

**Solusi:**
- Jangan hardcode hex color:
```dart
// ❌ SALAH
color: Color(0xFFB3BD95)

// ✅ BENAR
color: Dell1996Colors.tintSage
```
- List warna yang benar:
```dart
Dell1996Colors.tintSage      // #B3BD95
Dell1996Colors.tintSalmon    // #D77A7A
Dell1996Colors.tintPeach     // #E6915D
Dell1996Colors.tintLime      // #C0D4A7
Dell1996Colors.tintSky       // #9AB6C8
Dell1996Colors.tintSteel     // #A5B8C0
Dell1996Colors.tintPeriwinkle // #8C9AE0
Dell1996Colors.tintOlive     // #8E8A25
```

---

### 8. ❌ Spacing tidak konsisten

**Masalah:**
Jarak antar elemen tidak consistent.

**Solusi:**
- Gunakan Dell1996Spacing constants:
```dart
// ❌ SALAH (hardcode)
padding: EdgeInsets.all(16)

// ✅ BENAR
padding: EdgeInsets.all(Dell1996Spacing.lg)

// Spacing scale:
Dell1996Spacing.xs       // 4px
Dell1996Spacing.sm       // 8px
Dell1996Spacing.md       // 12px
Dell1996Spacing.lg       // 16px
Dell1996Spacing.xl       // 20px
Dell1996Spacing.xxl      // 24px
Dell1996Spacing.section  // 40px
```

---

### 9. ❌ Ribbon Card onTap tidak berfungsi

**Masalah:**
Ribbon card tidak merespons ketika diklik.

**Solusi:**
- Pastikan `onTap` parameter di-pass:
```dart
Dell1996RibbonCard(
  title: 'SERVIS AC',
  description: 'Perbaikan AC...',
  tintColor: Dell1996Colors.tintSage,
  onTap: () {  // ← Harus ada callback
    print('Clicked!');
    Navigator.push(...);
  },
)
```
- Atau gunakan InkWell wrapper jika custom:
```dart
InkWell(
  onTap: () { /* action */ },
  child: Dell1996RibbonCard(...),
)
```

---

### 10. ❌ AppBar title tidak center / tidak sesuai

**Masalah:**
Title di AppBar tidak sesuai dengan design.

**Solusi:**
```dart
AppBar(
  title: const Text(
    'SERVISKLIK 🔧',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),
  centerTitle: false, // ← Dell 1996 style (left align)
  elevation: 0,       // ← No shadow
  actions: [
    Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS'),
  ],
)
```

---

### 11. ❌ BottomNavigationBar tidak ada border atas

**Masalah:**
Bottom nav tidak memiliki border hitam di atasnya.

**Solusi:**
```dart
bottomNavigationBar: Container(
  decoration: const BoxDecoration(
    border: Border(
      top: BorderSide(
        color: Dell1996Colors.frameInk,
        width: 1,
      ),
    ),
  ),
  child: BottomNavigationBar(
    items: [...],
  ),
)
```

---

### 12. ❌ Hot Reload tidak apply changes

**Masalah:**
Perubahan pada theme tidak terlihat setelah hot reload.

**Solusi:**
1. Hot Restart (Shift + R di terminal)
2. Atau full restart:
```bash
flutter run
```
3. Jika masih tidak work:
```bash
flutter clean
flutter pub get
flutter run
```

---

### 13. ❌ Build Error: No Material widget found

**Masalah:**
```
No Material widget found. [Widget] widgets require a Material widget ancestor.
```

**Solusi:**
- Pastikan ada Scaffold atau MaterialApp:
```dart
// ✅ Harus ada Scaffold
Scaffold(
  body: Dell1996TopBanner(...),
)

// Atau MaterialApp untuk root
MaterialApp(
  theme: dell1996Theme(),
  home: Scaffold(...),
)
```

---

### 14. ❌ Firebase Error di Web

**Masalah:**
```
[core/no-app] No Firebase App '[DEFAULT]' has been created
```

**Solusi:**
- Check `main.dart` untuk Web config:
```dart
if (kIsWeb) {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "YOUR_API_KEY",
      authDomain: "your-app.firebaseapp.com",
      projectId: "your-project-id",
      storageBucket: "your-app.firebasestorage.app",
      messagingSenderId: "YOUR_SENDER_ID",
      appId: "YOUR_APP_ID", // ← Pastikan diisi!
    ),
  );
}
```

---

### 15. ❌ Overflow error pada Ribbon Card

**Masalah:**
```
A RenderFlex overflowed by XXX pixels on the right.
```

**Solusi:**
- Gunakan Expanded atau Flexible:
```dart
Row(
  children: [
    Icon(Icons.ac_unit, size: 48),
    SizedBox(width: Dell1996Spacing.md),
    Expanded( // ← Wrap dengan Expanded
      child: Text(
        'Long description text...',
        style: Dell1996Typography.body,
      ),
    ),
  ],
)
```
- Atau gunakan SingleChildScrollView:
```dart
SingleChildScrollView(
  child: Dell1996RibbonCard(...),
)
```

---

### 16. ❌ Navigator push error

**Masalah:**
```
Navigator operation requested with a context that does not include a Navigator.
```

**Solusi:**
- Pastikan context berasal dari widget yang ada di dalam MaterialApp:
```dart
// ✅ BENAR
onTap: () {
  Navigator.push(
    context, // Context dari build method
    MaterialPageRoute(builder: (context) => NewPage()),
  );
}

// Atau gunakan Builder
Builder(
  builder: (context) {
    return GestureDetector(
      onTap: () => Navigator.push(...),
    );
  },
)
```

---

### 17. ❌ Theme tidak apply ke semua widget

**Masalah:**
Beberapa widget tidak mengikuti tema Dell 1996.

**Solusi:**
- Pastikan tema di set di MaterialApp:
```dart
MaterialApp(
  theme: dell1996Theme(), // ← Harus ada
  home: YourHomePage(),
)
```
- Jika masih tidak work, gunakan explicit style:
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Dell1996Colors.frameInk,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),
  child: Text('BUTTON'),
)
```

---

### 18. ❌ Yellow Sticker rotation tidak terlihat

**Masalah:**
Sticker kuning tidak miring meski `rotated: true`.

**Solusi:**
- Transform.rotate perlu space di sekitarnya:
```dart
Padding(
  padding: EdgeInsets.all(Dell1996Spacing.lg),
  child: Dell1996YellowSticker(
    text: 'NEW!',
    rotated: true,
  ),
)
```
- Atau buat custom rotation:
```dart
Transform.rotate(
  angle: 0.26, // ~15 degrees
  child: Dell1996YellowSticker(text: 'NEW!'),
)
```

---

### 19. ❌ HomePage tidak muncul setelah login

**Masalah:**
Setelah login, stuck di loading atau error.

**Solusi:**
- Check AuthWrapper di main.dart:
```dart
StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (snapshot.hasData) {
      return MainScreen(); // ← Pastikan return MainScreen
    }
    return LoginPage();
  },
)
```

---

### 20. ❌ Gradle build error (Android)

**Masalah:**
```
Execution failed for task ':app:processDebugGoogleServices'
```

**Solusi:**
```bash
# 1. Clean project
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Rebuild
flutter run
```

Jika masih error, check `android/app/google-services.json` ada atau tidak.

---

## 🔍 Debugging Tips

### 1. Check Import Path
```dart
// Jika file di lib/
import 'theme/dell_1996_theme.dart';

// Jika file di lib/ui/ atau subfolder
import '../theme/dell_1996_theme.dart';

// Atau gunakan absolute path
import 'package:project_moprog/theme/dell_1996_theme.dart';
```

### 2. Print untuk Debug
```dart
onTap: () {
  print('Ribbon card clicked!'); // ← Debug tap
  Navigator.push(...);
}
```

### 3. Flutter Doctor
```bash
flutter doctor -v
```

### 4. Clear Cache
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

---

## 📞 Masih Stuck?

1. **Check dokumentasi:**
   - `QUICKSTART_DELL1996.md` - Quick start
   - `DELL_1996_GUIDE.md` - Panduan lengkap
   - `VISUAL_COMPONENTS.md` - Visual reference

2. **Check demo page:**
   - `lib/ui/dell_1996_demo_page.dart` - Contoh implementasi

3. **Check original file:**
   - `lib/ui/home/home_page_dell1996.dart` - Working example

4. **Restart IDE & emulator:**
   ```bash
   # Restart app
   flutter run
   
   # Full clean restart
   flutter clean && flutter pub get && flutter run
   ```

---

**Dibuat dengan ❤️ dan debugging yang panjang**

*"Debugging is like being the detective in a crime movie where you are also the murderer."*
