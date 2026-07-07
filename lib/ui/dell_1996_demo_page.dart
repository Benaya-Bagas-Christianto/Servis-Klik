import 'package:flutter/material.dart';
import '../theme/dell_1996_theme.dart';
import '../widget/dell_1996_components.dart';

/// Demo Page showcasing Dell 1996 Design Language
class Dell1996DemoPage extends StatelessWidget {
  const Dell1996DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DELL 1996 DEMO'),
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
            // Top Banner
            const Dell1996TopBanner(
              title: 'BUILD YOUR OWN SERVICE. ONLINE.',
              subtitle: 'Pilih, Pesan, dan Lacak Servis Elektronik Anda',
            ),

            const SizedBox(height: Dell1996Spacing.lg),

            // Section Eyebrow - DIMENSION DESKTOPS style
            const Dell1996SectionEyebrow(
              title: 'LAYANAN SERVIS',
              backgroundColor: Dell1996Colors.tintOlive,
            ),

            const SizedBox(height: Dell1996Spacing.md),

            // Ribbon Cards dengan berbagai tint
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dell1996Spacing.lg),
              child: Column(
                children: [
                  // Sage - Servis AC
                  Dell1996RibbonCard(
                    title: 'SERVIS AC',
                    description:
                        'Perbaikan dan perawatan AC rumah dan kantor dengan teknisi berpengalaman. Garansi hasil kerja hingga 30 hari.',
                    tintColor: Dell1996Colors.tintSage,
                    leadingWidget: const Icon(
                      Icons.ac_unit,
                      size: 48,
                      color: Dell1996Colors.ink,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Servis AC dipilih')),
                      );
                    },
                  ),

                  // Salmon - Servis Kulkas
                  Dell1996RibbonCard(
                    title: 'SERVIS KULKAS',
                    description:
                        'Reliable service untuk kulkas 1 pintu hingga side-by-side. Penanganan cepat untuk masalah tidak dingin, bocor, atau berisik.',
                    tintColor: Dell1996Colors.tintSalmon,
                    leadingWidget: const Icon(
                      Icons.kitchen,
                      size: 48,
                      color: Dell1996Colors.ink,
                    ),
                  ),

                  // Peach - Servis Mesin Cuci
                  Dell1996RibbonCard(
                    title: 'SERVIS MESIN CUCI',
                    description:
                        'Perbaikan untuk semua jenis mesin cuci: front load, top load, 2 tabung. Dari Dell\'s award-winning service and support teams.',
                    tintColor: Dell1996Colors.tintPeach,
                    leadingWidget: const Icon(
                      Icons.local_laundry_service,
                      size: 48,
                      color: Dell1996Colors.ink,
                    ),
                  ),

                  // Lime - Servis TV
                  Dell1996RibbonCard(
                    title: 'SERVIS TV',
                    description:
                        'Perbaikan TV LED, LCD, dan Plasma dari berbagai merek. Teknisi bersertifikat dengan spare part original.',
                    tintColor: Dell1996Colors.tintLime,
                    leadingWidget: const Icon(
                      Icons.tv,
                      size: 48,
                      color: Dell1996Colors.ink,
                    ),
                  ),

                  // Sky - Servis Laptop
                  Dell1996RibbonCard(
                    title: 'SERVIS LAPTOP',
                    description:
                        'Service center untuk laptop dan notebook. Upgrade hardware, install software, cleaning, dan perbaikan kerusakan.',
                    tintColor: Dell1996Colors.tintSky,
                    leadingWidget: const Icon(
                      Icons.laptop,
                      size: 48,
                      color: Dell1996Colors.ink,
                    ),
                  ),

                  // Periwinkle - Servis HP
                  Dell1996RibbonCard(
                    title: 'SERVIS HP',
                    description:
                        'PowerEdge-class service untuk smartphone Android dan iOS. Ganti layar, baterai, dan perbaikan software.',
                    tintColor: Dell1996Colors.tintPeriwinkle,
                    leadingWidget: const Icon(
                      Icons.smartphone,
                      size: 48,
                      color: Dell1996Colors.ink,
                    ),
                  ),

                  const SizedBox(height: Dell1996Spacing.section),

                  // CTA Block Red
                  Dell1996CtaBlockRed(
                    text:
                        'At ServisKlik.com, we\'ll help you find the right service, configure it, price it, and order it online. Fast, easy, and secure.',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mulai booking servis!')),
                      );
                    },
                  ),

                  const SizedBox(height: Dell1996Spacing.section),

                  // Yellow Stickers Demo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Dell1996YellowSticker(text: 'BOOK NOW'),
                      Dell1996YellowSticker(
                        text: 'NEW!',
                        rotated: true,
                      ),
                      const Dell1996CertSeal(
                        text: 'TRUSTED\nSERVICE',
                        size: 80,
                      ),
                    ],
                  ),

                  const SizedBox(height: Dell1996Spacing.section),

                  // Button Examples
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('PRIMARY'),
                        ),
                      ),
                      const SizedBox(width: Dell1996Spacing.md),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('SECONDARY'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: Dell1996Spacing.md),

                  // Input Example
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari layanan servis...',
                    ),
                  ),

                  const SizedBox(height: Dell1996Spacing.section),
                ],
              ),
            ),

            // Footer
            const Dell1996FooterBand(
              text:
                  'Copyright © 2026 ServisKlik. All rights reserved.\nThis site is best viewed with browser versions 3.0 and higher.',
            ),
          ],
        ),
      ),
    );
  }
}
