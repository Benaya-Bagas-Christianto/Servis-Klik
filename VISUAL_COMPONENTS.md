# 🎨 Dell 1996 Visual Component Guide

## 📐 Layout Structure

```
┌─────────────────────────────────────────────────────────┐
│ ⬛ PAGE FRAME (Black Border 8px)                       │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ ⬛ TOP BANNER (Black Background)                    │ │
│ │ ┌─────────────────────────────────┬───────────────┐ │ │
│ │ │ 🔧 SERVISKLIK                   │ 🟥 1-800-     │ │ │
│ │ │                                  │    SERVIS     │ │ │
│ │ └─────────────────────────────────┴───────────────┘ │ │
│ ├─────────────────────────────────────────────────────┤ │
│ │                                                       │ │
│ │ 🎨 SECTION EYEBROW (Colored Block)                  │ │
│ │ ┌───────────────────────────────────────────────┐   │ │
│ │ │ PILIH KELUHAN PERANGKAT (Olive/Salmon/etc)   │   │ │
│ │ └───────────────────────────────────────────────┘   │ │
│ │                                                       │ │
│ │ 📦 RIBBON CARD #1                                    │ │
│ │ ┌───────────────────────────────────────────────┐   │ │
│ │ │ ⬜ Title Bar (White)                          │   │ │
│ │ │ SERVIS AC                                     │   │ │
│ │ ├───────────────────────────────────────────────┤   │ │
│ │ │ 🟦 Body (Tinted - Sage/Salmon/Peach/etc)     │   │ │
│ │ │ 🖼️ [Icon] Perbaikan dan perawatan AC...      │   │ │
│ │ └───────────────────────────────────────────────┘   │ │
│ │                                                       │ │
│ │ 📦 RIBBON CARD #2                                    │ │
│ │ ┌───────────────────────────────────────────────┐   │ │
│ │ │ ⬜ SERVIS KULKAS                              │   │ │
│ │ ├───────────────────────────────────────────────┤   │ │
│ │ │ 🟨 Reliable service untuk kulkas...           │   │ │
│ │ └───────────────────────────────────────────────┘   │ │
│ │                                                       │ │
│ │ 🟥 CTA BLOCK RED                                     │ │
│ │ ┌───────────────────────────────────────────────┐   │ │
│ │ │ At ServisKlik.com, we'll help you find       │   │ │
│ │ │ the right service, configure it, price it...  │   │ │
│ │ └───────────────────────────────────────────────┘   │ │
│ │                                                       │ │
│ │ ─────────────────────────────────────────────────   │ │
│ │ 📄 FOOTER BAND                                       │ │
│ │ Copyright © 2026 ServisKlik. All rights reserved.   │ │
│ └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## 🎨 Color Palette Visual

### Primary Colors
```
🟥 Dell Red (primary)         #E91D2A  ████████
⬜ Canvas (white)             #FFFFFF  ░░░░░░░░
⬛ Frame Ink (black)          #000000  ████████
🟨 Yellow Sticker             #FCC20F  ████████
🟦 Classic Link Blue          #0000EE  ████████
```

### Ribbon Card Tints (8 Colors)
```
🟫 Olive (tintOlive)          #8E8A25  ████████
🟩 Sage (tintSage)            #B3BD95  ████████
🟥 Salmon (tintSalmon)        #D77A7A  ████████
🟧 Peach (tintPeach)          #E6915D  ████████
🟨 Lime (tintLime)            #C0D4A7  ████████
🟦 Sky (tintSky)              #9AB6C8  ████████
🔵 Steel (tintSteel)          #A5B8C0  ████████
🟣 Periwinkle (tintPeriwinkle) #8C9AE0  ████████
```

## 📦 Ribbon Card Anatomy

```
┌─────────────────────────────────────────────────────┐
│ Title Bar (White Background, Black Border)          │
│ ┌───────────────────────────────────────────────┐   │
│ │ SERVIS AC                                     │   │ ← Helvetica Bold 14px
│ │ (All caps, Black text on White)              │   │
│ └───────────────────────────────────────────────┘   │
│ ─────────────────────────────────────────────────   │ ← 1px Black Border
│                                                       │
│ Body (Tinted Background)                             │
│ ┌───────────────────────────────────────────────┐   │
│ │  🖼️         Perbaikan dan perawatan AC       │   │ ← Times New Roman 14px
│ │ [Icon]      rumah dan kantor dengan teknisi   │   │   (Black text on Tint)
│ │ 48x48       berpengalaman. Garansi hasil      │   │
│ │             kerja hingga 30 hari.             │   │
│ └───────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

## 🔤 Typography Scale

```
Display (36px, Arial Black 900)
████████████████████████████
DIMENSION DESKTOPS

Heading 1 (24px, Arial Black 900)
████████████████████
SubPage Hero Title

Heading 2 (16px, Helvetica Bold)
██████████████
Banner Headline

Heading 3 (14px, Helvetica Bold)
█████████████
Card Title

Body (14px, Times New Roman)
█████████████
Default paragraph copy with serifs for
catalog-era enterprise feel.

Body Small (12px, Times New Roman)
████████████
Small print and disclaimers.

Button (12px, Helvetica Bold)
██████████
BUTTON LABEL

Caption (11px, Times New Roman)
███████████
Footer copyright text.
```

## 🎯 Component Usage Examples

### Example 1: Service Menu
```
┌─────────┬─────────┐
│ LAYAR   │ BATERAI │
│ BLANK   │  DROP   │
│         │         │
│ 🖥️      │ 🔋      │
│ (Sage)  │(Salmon) │
└─────────┴─────────┘
```

### Example 2: Statistics Dashboard (Mitra)
```
┌──────────────────────────────────────┐
│ TUGAS BARU                           │
├──────────────────────────────────────┤
│  ┌────┐                              │
│  │ 5  │  5 pesanan baru menunggu     │
│  └────┘  untuk diproses.             │
│  (Red)   (Salmon Tint)               │
└──────────────────────────────────────┘
```

### Example 3: CTA Block
```
┌──────────────────────────────────────┐
│ 🟥 AT SERVISKLIK.COM, WE'LL HELP    │
│    YOU FIND THE RIGHT SERVICE,       │
│    CONFIGURE IT, PRICE IT...         │
│    (White text on Dell Red)          │
└──────────────────────────────────────┘
```

## 🔲 Border & Corner Rules

### ✅ CORRECT (Sharp Corners)
```
┌─────────┐
│         │  ← Border radius: 0
│  Card   │     (90° corners)
│         │
└─────────┘
```

### ❌ WRONG (Rounded Corners)
```
╭─────────╮
│         │  ← Border radius: 12px
│  Card   │     (NOT Dell 1996!)
│         │
╰─────────╯
```

## 📏 Spacing System

```
xxs  2px   ██
xs   4px   ████
s    6px   ██████
sm   8px   ████████
m    10px  ██████████
md   12px  ████████████
lg   16px  ████████████████
xl   20px  ████████████████████
xxl  24px  ████████████████████████
section-sm 32px  ████████████████████████████████
section    40px  ████████████████████████████████████████
```

### Spacing Usage
```
Card Padding:       lg (16px)
Card Margin:        sm (8px)
Section Gap:        section (40px)
Button Padding:     6px × 16px
Input Padding:      4px × 6px
```

## 🎭 Special Elements

### Yellow Sticker (Normal)
```
┌─────────────┐
│ 🟨 NEW!     │ ← Yellow bg, black text
└─────────────┘   Black 1px border
```

### Yellow Sticker (Rotated 15°)
```
    ┌───────┐
   ╱ NEW! ╱   ← Rotated ~15°
  ╱_______╱      for "pinned" effect
```

### Cert Seal (Circular)
```
    ⭕
   ╱   ╲
  │ PC  │   ← Red circle
  │ MAG │      White text
   ╲   ╱       64px × 64px
    ⭕
```

### Phone Callout
```
┌──────────────────┐
│ 🟥 1-800-213-   │ ← Red text
│    DELL          │   Black bg
└──────────────────┘
```

## 🖼️ Layout Patterns

### Two-Column Menu Grid
```
┌─────────┬─────────┐
│ Item 1  │ Item 2  │
│ (Sage)  │(Salmon) │
├─────────┼─────────┤
│ Item 3  │ Item 4  │
│ (Peach) │ (Lime)  │
├─────────┼─────────┤
│ Item 5  │ Item 6  │
│ (Sky)   │ (Steel) │
└─────────┴─────────┘
```

### Full-Width Ribbon Stack
```
┌───────────────────────────┐
│ RIBBON CARD 1 (Sage)      │
└───────────────────────────┘

┌───────────────────────────┐
│ RIBBON CARD 2 (Salmon)    │
└───────────────────────────┘

┌───────────────────────────┐
│ RIBBON CARD 3 (Peach)     │
└───────────────────────────┘
```

## 🎨 Color Usage Guidelines

### ✅ CORRECT Usage
```
🟥 Dell Red → CTA Block, Phone Number ONLY
🟨 Yellow   → Stickers ("NEW!", "BUY")
🎨 8 Tints  → Ribbon Card bodies (one per category)
⬛ Black    → Frame, borders, text
⬜ White    → Canvas, card title bars
```

### ❌ INCORRECT Usage
```
❌ Dell Red for buttons (use black instead)
❌ Yellow for backgrounds (use tints)
❌ Multiple tints in one card (pick one)
❌ Gradients on any element
❌ Colors outside the defined palette
```

## 📱 Responsive Breakpoints

### Desktop (Default)
```
┌──────────────────────────────────────┐
│ [8px Black Frame]                    │
│ ┌──────────────────────────────────┐ │
│ │ Full layout with all elements    │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

### Tablet (≤768px)
```
┌────────────────────────────┐
│ [4px Black Frame]          │
│ ┌────────────────────────┐ │
│ │ Compressed layout      │ │
│ └────────────────────────┘ │
└────────────────────────────┘
```

### Mobile (≤480px)
```
┌──────────────────┐
│ [2px Frame]      │
│ ┌──────────────┐ │
│ │ Single       │ │
│ │ Column       │ │
│ └──────────────┘ │
└──────────────────┘
```

---

**Visual Guide Created for** 🎨 **Dell 1996 Design Language**

*"This guide is best viewed with monospace fonts."*
