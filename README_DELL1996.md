# 🎨 Dell 1996 Design Language - ServisKlik

![Status](https://img.shields.io/badge/Status-Ready%20to%20Use-success)
![Design](https://img.shields.io/badge/Design-Dell%201996-red)
![Flutter](https://img.shields.io/badge/Flutter-3.11.4-blue)

## 📖 Tentang Proyek Ini

**ServisKlik** adalah aplikasi mobile untuk booking servis elektronik (AC, kulkas, laptop, dll) yang kini menggunakan **Dell 1996 Design Language** - sebuah interpretasi dari desain website Dell.com era katalog enterprise tahun 1996.

### 🎯 Apa itu Dell 1996 Design?

Ini adalah gaya desain vintage yang khas dengan:

- ⬛ **Frame hitam literal** di sekeliling halaman
- 🎨 **8 warna ribbon card** (sage, salmon, peach, lime, sky, steel, periwinkle, olive)
- 📝 **Typography kontras** - Arial Black untuk display, Times New Roman untuk body
- ⬜ **Tidak ada border radius** - semua sudut tajam 90°
- 🟨 **Stiker kuning** bergaya GIF 90-an
- 🟥 **Merah Dell** hanya untuk CTA dan nomor telepon

## ✨ Features

- ✅ **Tema Dell 1996** diterapkan secara global
- ✅ **10+ Komponen reusable** siap pakai
- ✅ **Homepage Customer** dengan Ribbon Cards untuk menu servis
- ✅ **Homepage Mitra** dengan statistik tugas
- ✅ **Demo Page** showcase semua komponen
- ✅ **Responsive Design** dengan breakpoints tablet & mobile
- ✅ **Dokumentasi lengkap** dengan visual guide

## 🚀 Quick Start

### 1. Clone & Install

```bash
cd "d:\Mobile Programming\Project_Moprog\project_moprog"
flutter pub get
```

### 2. Run

```bash
flutter run
```

**That's it!** Aplikasi sudah menggunakan Dell 1996 Design.

## 📁 Struktur File

```
project_moprog/
├── lib/
│   ├── main.dart                         # Entry point (tema Dell 1996 aktif)
│   ├── theme/
│   │   └── dell_1996_theme.dart         # Tema, warna, typography
│   ├── widget/
│   │   └── dell_1996_components.dart    # Komponen reusable
│   └── ui/
│       ├── dell_1996_demo_page.dart     # Demo showcase
│       └── home/
│           ├── home_page.dart            # Original (backup)
│           └── home_page_dell1996.dart   # Dell 1996 version
│
├── DESIGN-dell-1996.md                   # Spec design lengkap
├── README_DELL1996.md                    # File ini
├── QUICKSTART_DELL1996.md                # Panduan cepat
├── DELL_1996_GUIDE.md                    # Panduan lengkap
├── VISUAL_COMPONENTS.md                  # Visual guide
└── IMPLEMENTASI_DELL_1996.md            # Summary implementasi
```

## 🎨 Komponen Utama

### 1. Ribbon Card (Signature Component)

```dart
Dell1996RibbonCard(
  title: 'SERVIS AC',
  description: 'Perbaikan dan perawatan AC...',
  tintColor: Dell1996Colors.tintSage,
  leadingWidget: Icon(Icons.ac_unit, size: 48),
  onTap: () { /* aksi */ },
)
```

### 2. Top Banner

```dart
Dell1996TopBanner(
  title: 'SELAMAT DATANG',
  subtitle: 'Subtitle here',
)
```

### 3. Section Eyebrow

```dart
Dell1996SectionEyebrow(
  title: 'LAYANAN SERVIS',
  backgroundColor: Dell1996Colors.tintOlive,
)
```

### 4. CTA Block Red

```dart
Dell1996CtaBlockRed(
  text: 'Promo spesial! Diskon 20%...',
  onTap: () { /* aksi */ },
)
```

### 5. Yellow Sticker

```dart
Dell1996YellowSticker(text: 'NEW!', rotated: true)
```

### Dan 5 komponen lainnya...

👉 Lihat semua di `DELL_1996_GUIDE.md`

## 🎨 Color Palette

```dart
// Primary
Dell1996Colors.primary          // #E91D2A (Merah Dell)
Dell1996Colors.canvas           // #FFFFFF (Putih)
Dell1996Colors.frameInk         // #000000 (Hitam)
Dell1996Colors.yellowSticker    // #FCC20F (Kuning)

// 8 Ribbon Card Tints
Dell1996Colors.tintSage         // #B3BD95 (Hijau lembut)
Dell1996Colors.tintSalmon       // #D77A7A (Pink salmon)
Dell1996Colors.tintPeach        // #E6915D (Orange peach)
Dell1996Colors.tintLime         // #C0D4A7 (Hijau lime)
Dell1996Colors.tintSky          // #9AB6C8 (Biru langit)
Dell1996Colors.tintSteel        // #A5B8C0 (Abu-abu biru)
Dell1996Colors.tintPeriwinkle   // #8C9AE0 (Ungu biru)
Dell1996Colors.tintOlive        // #8E8A25 (Hijau olive)
```

## 📝 Typography

```dart
Dell1996Typography.display      // Arial Black 36px/900
Dell1996Typography.heading1     // Arial Black 24px/900
Dell1996Typography.heading2     // Helvetica 16px/700
Dell1996Typography.heading3     // Helvetica 14px/700
Dell1996Typography.body         // Times New Roman 14px
Dell1996Typography.bodySm       // Times New Roman 12px
Dell1996Typography.button       // Helvetica 12px/700
Dell1996Typography.uiLabel      // Helvetica 12px/700
```

## 📚 Documentation

| File | Deskripsi |
|------|-----------|
| `QUICKSTART_DELL1996.md` | ⚡ Panduan cepat untuk mulai |
| `DELL_1996_GUIDE.md` | 📖 Panduan lengkap dengan contoh kode |
| `VISUAL_COMPONENTS.md` | 🎨 Visual guide dengan diagram ASCII |
| `IMPLEMENTASI_DELL1996.md` | ✅ Summary implementasi |
| `DESIGN-dell-1996.md` | 📐 Spesifikasi design lengkap (referensi) |

## 🎯 Design Rules

### ✅ Do's

- Pertahankan frame hitam di sekeliling halaman
- Gunakan merah Dell HANYA untuk CTA dan nomor telepon
- Set display text di Arial Black weight 900
- Gunakan Times New Roman untuk body text
- Semua corner harus tajam (radius = 0)
- Gunakan hard borders 1px, bukan soft shadow

### ❌ Don'ts

- Jangan tambahkan border radius
- Jangan gunakan gradients atau soft shadows
- Jangan ganti Times New Roman dengan sans-serif modern
- Jangan gunakan warna di luar palet yang ditentukan
- Jangan gunakan lebih dari 1 CTA Red per halaman

## 🖼️ Screenshots

### Homepage Customer
```
┌─────────────────────────────────┐
│ ⬛ [8px Black Frame]            │
│ ┌─────────────────────────────┐ │
│ │ SERVISKLIK 🔧  |  1-800-... │ │ ← AppBar
│ ├─────────────────────────────┤ │
│ │ HALO, NAMA! 👋              │ │ ← Top Banner
│ ├─────────────────────────────┤ │
│ │ PILIH KELUHAN PERANGKAT     │ │ ← Section Eyebrow
│ ├─────────────────────────────┤ │
│ │ 📦 LAYAR BLANK (Sage)       │ │ ← Ribbon Cards
│ │ 📦 BATERAI DROP (Salmon)    │ │
│ │ 📦 MATI TOTAL (Steel)       │ │
│ ├─────────────────────────────┤ │
│ │ 🟥 PROMO SERVIS BULAN INI!  │ │ ← CTA Red
│ ├─────────────────────────────┤ │
│ │ Copyright © 2026...         │ │ ← Footer
│ └─────────────────────────────┘ │
└─────────────────────────────────┘
```

### Homepage Mitra
```
┌─────────────────────────────────┐
│ RINGKASAN TUGAS ANDA            │
├─────────────────────────────────┤
│ 📦 TUGAS BARU                   │
│    [5] 5 pesanan baru...        │
├─────────────────────────────────┤
│ 📦 DIPROSES                     │
│    [3] 3 pesanan sedang...      │
├─────────────────────────────────┤
│ 📦 SELESAI                      │
│    [12] 12 pesanan berhasil...  │
└─────────────────────────────────┘
```

## 🔄 Switch Design

### Saat ini: Dell 1996 ✅

```dart
// main.dart
MaterialApp(
  theme: dell1996Theme(), // ✅ AKTIF
)

final List<Widget> _pages = [
  const HomePageDell1996(), // ✅ AKTIF
];
```

### Kembali ke Modern (jika perlu)

```dart
// main.dart
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
  ),
)

final List<Widget> _pages = [
  const HomePage(), // Original tersimpan
];
```

## 🛠️ Development

### Menambah Halaman Baru

1. Import tema & komponen:
```dart
import '../theme/dell_1996_theme.dart';
import '../widget/dell_1996_components.dart';
```

2. Copy template dari `QUICKSTART_DELL1996.md`
3. Customize dengan komponen Dell 1996

### Menambah Komponen Baru

1. Buka `lib/widget/dell_1996_components.dart`
2. Tambahkan widget baru dengan:
   - Border hitam 1px
   - Border radius = 0
   - Gunakan Dell1996Colors
   - Gunakan Dell1996Typography
   - Gunakan Dell1996Spacing

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with hot reload
flutter run

# Build APK
flutter build apk

# Build Web
flutter build web
```

## 🤝 Contributing

1. Ikuti design rules di `DELL_1996_GUIDE.md`
2. Gunakan komponen existing dari `dell_1996_components.dart`
3. Maintain consistency dengan Dell 1996 design language
4. Test di multiple devices (Android, iOS, Web)

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.0.0
  firebase_auth: ^5.0.0
  cloud_firestore: ^5.0.0
  # ... dependencies lainnya
```

## 📄 License

Project ServisKlik - Educational Purpose

## 👥 Authors

- **Dell 1996 Design Implementation** - 2026

## 🎓 Learning Resources

- Dell 1996 Archive: [Archive.org](https://web.archive.org)
- Typography Guide: Panduan font system stack 90s
- Color Theory: GIF-era web-safe palette
- HTML Tables Layout: Pre-CSS layout techniques

## 📞 Support

Untuk pertanyaan tentang implementasi Dell 1996 Design:

1. Baca `QUICKSTART_DELL1996.md` untuk quick start
2. Baca `DELL_1996_GUIDE.md` untuk panduan lengkap
3. Lihat `VISUAL_COMPONENTS.md` untuk referensi visual
4. Check `dell_1996_demo_page.dart` untuk contoh implementasi

## 🎉 Acknowledgments

- **Dell.com 1996** - Design inspiration
- **Archive.org** - Historical reference
- **Flutter Team** - Framework
- **Material Design** - Base components

---

**Built with 🎨 Dell 1996 Design Language**

*"This app is best viewed with Flutter 3.11.4 and higher."*

---

## 📝 Changelog

### v1.0.0 (2026-07-03)
- ✅ Initial Dell 1996 Design implementation
- ✅ 10+ reusable components
- ✅ Homepage redesign (Customer & Mitra)
- ✅ Complete documentation
- ✅ Demo page showcase

---

**Made with ❤️ and a lot of ⬛ black borders**
