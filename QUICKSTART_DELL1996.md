# 🚀 Quick Start - Dell 1996 Design

## ⚡ TL;DR - Mulai Cepat

Aplikasi Anda **SUDAH MENGGUNAKAN** Dell 1996 Design! Langsung jalankan:

```bash
cd "d:\Mobile Programming\Project_Moprog\project_moprog"
flutter run
```

## ✅ Apa yang Sudah Otomatis?

- ✅ Tema Dell 1996 sudah aktif secara global
- ✅ Homepage sudah menggunakan Ribbon Cards
- ✅ AppBar sudah ada nomor telepon merah
- ✅ BottomNav sudah ada border hitam
- ✅ Semua button, input, card sudah style Dell 1996

## 🎨 Cara Pakai Komponen (Copy-Paste Ready)

### 1. Ribbon Card (Komponen Paling Sering Dipakai)

```dart
import '../theme/dell_1996_theme.dart';
import '../widget/dell_1996_components.dart';

Dell1996RibbonCard(
  title: 'SERVIS AC',
  description: 'Perbaikan dan perawatan AC rumah dan kantor',
  tintColor: Dell1996Colors.tintSage, // Pilih warna
  leadingWidget: Icon(Icons.ac_unit, size: 48),
  onTap: () {
    // Aksi ketika diklik
  },
)
```

**Pilih Tint Color:**
- `Dell1996Colors.tintSage` - Hijau lembut
- `Dell1996Colors.tintSalmon` - Pink salmon
- `Dell1996Colors.tintPeach` - Orange peach
- `Dell1996Colors.tintLime` - Hijau lime
- `Dell1996Colors.tintSky` - Biru langit
- `Dell1996Colors.tintSteel` - Abu-abu biru
- `Dell1996Colors.tintPeriwinkle` - Ungu biru
- `Dell1996Colors.tintOlive` - Hijau olive

### 2. Top Banner

```dart
Dell1996TopBanner(
  title: 'SELAMAT DATANG',
  subtitle: 'Deskripsi singkat di sini',
)
```

### 3. Section Title (Eyebrow)

```dart
Dell1996SectionEyebrow(
  title: 'PILIH LAYANAN',
  backgroundColor: Dell1996Colors.tintOlive,
)
```

### 4. CTA Button Merah

```dart
Dell1996CtaBlockRed(
  text: 'Promo spesial! Diskon 20% untuk servis hari ini!',
  onTap: () {
    // Aksi promo
  },
)
```

### 5. Yellow Sticker Badge

```dart
// Normal
Dell1996YellowSticker(text: 'NEW!')

// Rotated (miring)
Dell1996YellowSticker(text: 'NEW!', rotated: true)
```

### 6. Phone Number

```dart
Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS')
```

## 📱 Template Halaman Lengkap

Copy-paste ini untuk membuat halaman baru:

```dart
import 'package:flutter/material.dart';
import '../theme/dell_1996_theme.dart';
import '../widget/dell_1996_components.dart';

class MyNewPage extends StatelessWidget {
  const MyNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Dell1996Colors.canvas,
      appBar: AppBar(
        title: const Text('MY PAGE'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            const Dell1996TopBanner(
              title: 'WELCOME TO MY PAGE',
              subtitle: 'Subtitle here',
            ),
            
            const SizedBox(height: Dell1996Spacing.lg),
            
            // Section Title
            const Dell1996SectionEyebrow(
              title: 'MAIN SECTION',
              backgroundColor: Dell1996Colors.tintOlive,
            ),
            
            const SizedBox(height: Dell1996Spacing.lg),
            
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dell1996Spacing.lg,
              ),
              child: Column(
                children: [
                  // Card 1
                  Dell1996RibbonCard(
                    title: 'FEATURE 1',
                    description: 'Description here...',
                    tintColor: Dell1996Colors.tintSage,
                    leadingWidget: const Icon(Icons.star, size: 48),
                  ),
                  
                  // Card 2
                  Dell1996RibbonCard(
                    title: 'FEATURE 2',
                    description: 'Description here...',
                    tintColor: Dell1996Colors.tintSalmon,
                    leadingWidget: const Icon(Icons.favorite, size: 48),
                  ),
                  
                  const SizedBox(height: Dell1996Spacing.section),
                  
                  // CTA
                  Dell1996CtaBlockRed(
                    text: 'Special promo text here!',
                    onTap: () {
                      // Handle tap
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: Dell1996Spacing.section),
            
            // Footer
            const Dell1996FooterBand(
              text: 'Copyright © 2026 Your App',
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎯 Spacing Cheat Sheet

```dart
// Padding dalam card
padding: EdgeInsets.all(Dell1996Spacing.lg)     // 16px

// Margin antar cards
margin: EdgeInsets.only(bottom: Dell1996Spacing.sm)  // 8px

// Gap kecil
SizedBox(height: Dell1996Spacing.sm)            // 8px

// Gap medium
SizedBox(height: Dell1996Spacing.lg)            // 16px

// Gap antar sections
SizedBox(height: Dell1996Spacing.section)       // 40px
```

## 🎨 Color Quick Reference

```dart
// Warna utama
Dell1996Colors.primary          // Merah Dell
Dell1996Colors.canvas           // Putih
Dell1996Colors.frameInk         // Hitam
Dell1996Colors.yellowSticker    // Kuning
Dell1996Colors.link             // Biru link

// Tint untuk Ribbon Cards
Dell1996Colors.tintSage         // Hijau lembut
Dell1996Colors.tintSalmon       // Pink salmon
Dell1996Colors.tintPeach        // Orange
Dell1996Colors.tintLime         // Hijau terang
Dell1996Colors.tintSky          // Biru langit
Dell1996Colors.tintSteel        // Abu-abu
Dell1996Colors.tintPeriwinkle   // Ungu
Dell1996Colors.tintOlive        // Hijau tua
```

## 📝 Text Style Quick Reference

```dart
// Judul besar
Text('TITLE', style: Dell1996Typography.display)

// Heading
Text('Heading', style: Dell1996Typography.heading1)
Text('Subheading', style: Dell1996Typography.heading2)

// Body text
Text('Body text here', style: Dell1996Typography.body)

// Small text
Text('Small text', style: Dell1996Typography.bodySm)

// Button label
Text('BUTTON', style: Dell1996Typography.button)
```

## 🔧 Customization

### Ganti Warna Tint
Buka `lib/theme/dell_1996_theme.dart`, cari:

```dart
static const Color tintSage = Color(0xFFB3BD95);
```

Ganti dengan warna hex Anda.

### Ganti Spacing
Buka `lib/theme/dell_1996_theme.dart`, cari:

```dart
static const double lg = 16;
```

Ganti dengan nilai pixel Anda.

### Ganti Typography
Buka `lib/theme/dell_1996_theme.dart`, cari:

```dart
static const TextStyle body = TextStyle(
  fontFamily: 'Times New Roman',
  fontSize: 14,
  // ...
);
```

## 🐛 Troubleshooting Cepat

### Border tidak muncul?
Pastikan pakai `BoxDecoration`:
```dart
Container(
  decoration: BoxDecoration(
    border: Border.all(color: Dell1996Colors.frameInk, width: 1),
  ),
  // ...
)
```

### Warna tidak sesuai?
Jangan hardcode, pakai konstanta:
```dart
// ❌ SALAH
color: Color(0xFFB3BD95)

// ✅ BENAR
color: Dell1996Colors.tintSage
```

### Import error?
Pastikan import path benar:
```dart
import '../theme/dell_1996_theme.dart';
import '../widget/dell_1996_components.dart';
```

## 📚 File Penting

- `lib/theme/dell_1996_theme.dart` - Warna & tema
- `lib/widget/dell_1996_components.dart` - Komponen UI
- `DELL_1996_GUIDE.md` - Panduan lengkap
- `VISUAL_COMPONENTS.md` - Visual guide
- `IMPLEMENTASI_DELL_1996.md` - Summary implementasi

## 💡 Tips Pro

1. **Satu Ribbon Card = Satu Fitur** - Jangan terlalu banyak teks
2. **Pilih Tint yang Konsisten** - Satu kategori = Satu warna
3. **Merah Dell untuk Urgency** - Pakai CTA Red untuk promo/urgent
4. **Yellow Sticker untuk Highlight** - "NEW!", "PROMO", "HOT"
5. **Spacing Konsisten** - Selalu pakai konstanta, jangan hardcode

## 🎯 Next Steps

1. ✅ Jalankan aplikasi (`flutter run`)
2. ✅ Lihat homepage yang sudah Dell 1996
3. ✅ Coba edit `home_page_dell1996.dart`
4. ✅ Buat halaman baru dengan template di atas
5. ✅ Baca `DELL_1996_GUIDE.md` untuk detail lengkap

---

**That's it!** 🎉

Aplikasi Anda sudah Dell 1996. Tinggal jalankan dan lihat hasilnya!

*Built with 🎨 Dell 1996 Design Language*
