# 🎨 Dell 1996 Design Language - Panduan Implementasi

## Tentang Desain Ini

Aplikasi ServisKlik sekarang menggunakan **Dell 1996 Design Language** - sebuah interpretasi dari desain website Dell.com era katalog enterprise tahun 1996. Ini adalah gaya desain yang khas dengan:

- **Frame hitam literal** di sekeliling setiap halaman
- **Ribbon cards berwarna** dengan palet vintage (sage, salmon, peach, lime, sky, steel, periwinkle)
- **Typography kontras** - Arial Black untuk display, Times New Roman untuk body text
- **Tidak ada border radius** - semua sudut tajam 90°
- **Stiker kuning** bergaya GIF era 90-an ("NEW!", "BUY NOW")
- **Warna merah Dell** hanya untuk CTA dan nomor telepon

## 📁 Struktur File

```
lib/
├── theme/
│   └── dell_1996_theme.dart          # Definisi tema, warna, typography
├── widget/
│   └── dell_1996_components.dart     # Komponen reusable (Ribbon Card, Banner, dll)
├── ui/
│   ├── dell_1996_demo_page.dart      # Halaman demo showcase komponen
│   └── home/
│       ├── home_page.dart            # Homepage original (backup)
│       └── home_page_dell1996.dart   # Homepage dengan gaya Dell 1996
└── main.dart                          # Entry point (sudah menggunakan tema Dell 1996)
```

## 🎨 Komponen Utama

### 1. Dell1996PageFrame
Frame hitam literal di sekeliling konten (signature design element).

```dart
Dell1996PageFrame(
  borderWidth: 8.0,
  child: YourContent(),
)
```

### 2. Dell1996TopBanner
Banner hitam di atas dengan judul dan subtitle putih.

```dart
Dell1996TopBanner(
  title: 'BUILD YOUR OWN SERVICE. ONLINE.',
  subtitle: 'Pilih, Pesan, dan Lacak Servis',
)
```

### 3. Dell1996SectionEyebrow
Blok warna besar untuk judul section (seperti "DIMENSION DESKTOPS").

```dart
Dell1996SectionEyebrow(
  title: 'LAYANAN SERVIS',
  backgroundColor: Dell1996Colors.tintOlive,
)
```

### 4. Dell1996RibbonCard ⭐ (KOMPONEN SIGNATURE)
Kartu dengan title bar putih + body berwarna (signature Dell 1996).

```dart
Dell1996RibbonCard(
  title: 'SERVIS AC',
  description: 'Perbaikan dan perawatan AC dengan garansi...',
  tintColor: Dell1996Colors.tintSage,
  leadingWidget: Icon(Icons.ac_unit, size: 48),
  onTap: () { /* action */ },
)
```

### 5. Dell1996CtaBlockRed
Panel merah Dell untuk call-to-action utama.

```dart
Dell1996CtaBlockRed(
  text: 'At ServisKlik.com, we\'ll help you find the right service...',
  onTap: () { /* action */ },
)
```

### 6. Dell1996YellowSticker
Stiker kuning bergaya GIF 90-an.

```dart
Dell1996YellowSticker(
  text: 'NEW!',
  rotated: true, // untuk efek "ditempel miring"
)
```

### 7. Dell1996PhoneCallout
Nomor telepon merah di background hitam.

```dart
Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS')
```

## 🎨 Palet Warna

### Warna Utama
```dart
Dell1996Colors.primary          // #E91D2A (Merah Dell)
Dell1996Colors.canvas           // #FFFFFF (Putih)
Dell1996Colors.frameInk         // #000000 (Hitam)
Dell1996Colors.yellowSticker    // #FCC20F (Kuning stiker)
Dell1996Colors.link             // #0000EE (Biru link klasik Netscape)
```

### Ribbon Card Tints (8 warna vintage)
```dart
Dell1996Colors.tintOlive        // #8E8A25
Dell1996Colors.tintSage         // #B3BD95
Dell1996Colors.tintSalmon       // #D77A7A
Dell1996Colors.tintPeach        // #E6915D
Dell1996Colors.tintLime         // #C0D4A7
Dell1996Colors.tintSky          // #9AB6C8
Dell1996Colors.tintSteel        // #A5B8C0
Dell1996Colors.tintPeriwinkle   // #8C9AE0
```

## 📝 Typography

```dart
Dell1996Typography.display      // Arial Black 36px/900 - Section eyebrows
Dell1996Typography.heading1     // Arial Black 24px/900 - Hero headlines
Dell1996Typography.heading2     // Helvetica 16px/700 - Banner copy
Dell1996Typography.heading3     // Helvetica 14px/700 - Ribbon card titles
Dell1996Typography.body         // Times New Roman 14px - Body text
Dell1996Typography.bodySm       // Times New Roman 12px - Small text
Dell1996Typography.button       // Helvetica 12px/700 - Button labels
Dell1996Typography.uiLabel      // Helvetica 12px/700 - UI labels
```

## 📐 Spacing

```dart
Dell1996Spacing.xs        // 4px
Dell1996Spacing.sm        // 8px
Dell1996Spacing.md        // 12px
Dell1996Spacing.lg        // 16px
Dell1996Spacing.xl        // 20px
Dell1996Spacing.xxl       // 24px
Dell1996Spacing.section   // 40px (jarak antar section)
```

## ✅ Do's (Aturan Desain)

1. ✅ **Pertahankan frame hitam** di sekeliling halaman - ini signature element
2. ✅ **Gunakan warna merah Dell** HANYA untuk CTA panel dan nomor telepon
3. ✅ **Pilih satu tint color** per product line dari 8 warna ribbon
4. ✅ **Set display text** di Arial Black weight 900
5. ✅ **Gunakan Times New Roman** untuk body copy
6. ✅ **Semua corner harus tajam** (border-radius: 0)
7. ✅ **Gunakan hard borders** 1px solid black, bukan soft shadow

## ❌ Don'ts (Yang Harus Dihindari)

1. ❌ **Jangan tambahkan border radius** - semua harus sudut tajam 90°
2. ❌ **Jangan gunakan gradients atau soft shadows** - hanya flat colors
3. ❌ **Jangan ganti Times New Roman body text** dengan sans-serif modern
4. ❌ **Jangan gunakan warna di luar palet** yang sudah ditentukan
5. ❌ **Jangan gunakan lebih dari 1 Dell1996CtaBlockRed** per halaman
6. ❌ **Jangan hilangkan frame hitam** - itu identitas desain

## 🚀 Cara Menggunakan

### Mengaktifkan Tema Dell 1996

Tema sudah aktif secara global di `main.dart`:

```dart
MaterialApp(
  theme: dell1996Theme(), // Tema Dell 1996
  // ...
)
```

### Membuat Halaman Baru dengan Gaya Dell 1996

```dart
import 'package:flutter/material.dart';
import '../theme/dell_1996_theme.dart';
import '../widget/dell_1996_components.dart';

class MyNewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Dell1996Colors.canvas,
      appBar: AppBar(
        title: Text('MY PAGE'),
        actions: [
          Dell1996PhoneCallout(phoneNumber: '1-800-SERVIS'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Dell1996TopBanner(
              title: 'WELCOME TO MY PAGE',
              subtitle: 'Subtitle here',
            ),
            
            Dell1996SectionEyebrow(
              title: 'MAIN SECTION',
              backgroundColor: Dell1996Colors.tintOlive,
            ),
            
            Padding(
              padding: EdgeInsets.all(Dell1996Spacing.lg),
              child: Dell1996RibbonCard(
                title: 'FEATURE 1',
                description: 'Your feature description here...',
                tintColor: Dell1996Colors.tintSage,
                leadingWidget: Icon(Icons.star, size: 48),
                onTap: () {
                  // Handle tap
                },
              ),
            ),
            
            Dell1996FooterBand(
              text: 'Copyright © 2026 Your App',
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎯 Demo Pages

### 1. Dell1996DemoPage
Showcase lengkap semua komponen Dell 1996.

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => Dell1996DemoPage()),
);
```

### 2. HomePageDell1996
Homepage ServisKlik versi Dell 1996 (sudah aktif sebagai default).

## 🔄 Kembali ke Desain Original

Jika ingin kembali ke desain modern original:

1. Buka `lib/main.dart`
2. Ganti `theme: dell1996Theme()` dengan:
```dart
theme: ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
  scaffoldBackgroundColor: Colors.grey[100],
),
```

3. Ganti `const HomePageDell1996()` dengan `const HomePage()`

## 🎨 Design Philosophy

Desain Dell 1996 adalah **snapshot dari era katalog enterprise web** - saat website didesain seperti brosur cetak dengan:

- **Flat colors** (tidak ada gradient)
- **Hard borders** (tidak ada soft shadow)
- **Chunky typography** (Arial Black untuk impact)
- **Serif body text** (Times New Roman untuk kesan formal katalog)
- **Frame literal** (halaman sebagai dokumen dalam bingkai)
- **Stiker overlay** (elemen dekoratif seperti ditempel)

Ini adalah **anti-thesis dari desain modern** yang menggunakan soft shadows, border radius, dan sans-serif body text - dan itulah yang membuatnya unik!

## 📚 Referensi

- `DESIGN-dell-1996.md` - Spesifikasi lengkap design language
- `lib/theme/dell_1996_theme.dart` - Implementasi tema
- `lib/widget/dell_1996_components.dart` - Komponen UI
- `lib/ui/dell_1996_demo_page.dart` - Demo showcase

---

**Built with 🎨 Dell 1996 Design Language**  
*"This site is best viewed with browser versions 3.0 and higher."*
