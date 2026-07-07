import 'package:flutter/material.dart';
import '../theme/dell_1996_theme.dart';

/// Page Frame - Literal black border around content
class Dell1996PageFrame extends StatelessWidget {
  final Widget child;
  final double borderWidth;

  const Dell1996PageFrame({
    super.key,
    required this.child,
    this.borderWidth = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Dell1996Colors.frameInk,
        border: Border.all(
          color: Dell1996Colors.frameInk,
          width: borderWidth,
        ),
      ),
      child: Container(
        color: Dell1996Colors.canvas,
        child: child,
      ),
    );
  }
}

/// Top Banner - Black strip with headline
class Dell1996TopBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailingWidget;

  const Dell1996TopBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Dell1996Colors.frameInk,
      padding: const EdgeInsets.symmetric(
        horizontal: Dell1996Spacing.lg,
        vertical: Dell1996Spacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: Dell1996Typography.heading2.copyWith(
                    color: Dell1996Colors.canvas,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: Dell1996Spacing.xs),
                  Text(
                    subtitle!,
                    style: Dell1996Typography.bodySm.copyWith(
                      color: Dell1996Colors.canvas,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailingWidget != null) ...[
            const SizedBox(width: Dell1996Spacing.md),
            trailingWidget!,
          ],
        ],
      ),
    );
  }
}

/// Section Eyebrow - Large colored title block
class Dell1996SectionEyebrow extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const Dell1996SectionEyebrow({
    super.key,
    required this.title,
    this.backgroundColor = Dell1996Colors.tintOlive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: Dell1996Spacing.lg,
        vertical: Dell1996Spacing.xxl,
      ),
      child: Text(
        title.toUpperCase(),
        style: Dell1996Typography.display,
      ),
    );
  }
}

/// Ribbon Card - The signature Dell 1996 component
class Dell1996RibbonCard extends StatelessWidget {
  final String title;
  final String description;
  final Color tintColor;
  final Widget? leadingWidget;
  final VoidCallback? onTap;

  const Dell1996RibbonCard({
    super.key,
    required this.title,
    required this.description,
    this.tintColor = Dell1996Colors.tintSage,
    this.leadingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Dell1996Spacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: Dell1996Colors.frameInk, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title bar (white)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Dell1996Spacing.md,
              vertical: Dell1996Spacing.s,
            ),
            decoration: const BoxDecoration(
              color: Dell1996Colors.canvas,
              border: Border(
                bottom: BorderSide(color: Dell1996Colors.frameInk, width: 1),
              ),
            ),
            child: Text(
              title.toUpperCase(),
              style: Dell1996Typography.heading3,
            ),
          ),
          // Body (tinted)
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              color: tintColor,
              padding: const EdgeInsets.all(Dell1996Spacing.lg),
              child: Row(
                children: [
                  if (leadingWidget != null) ...[
                    leadingWidget!,
                    const SizedBox(width: Dell1996Spacing.md),
                  ],
                  Expanded(
                    child: Text(
                      description,
                      style: Dell1996Typography.body,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CTA Block Red - Primary call-to-action
class Dell1996CtaBlockRed extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const Dell1996CtaBlockRed({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Dell1996Spacing.lg),
        decoration: BoxDecoration(
          color: Dell1996Colors.primary,
          border: Border.all(color: Dell1996Colors.frameInk, width: 1),
        ),
        child: Text(
          text,
          style: Dell1996Typography.body.copyWith(
            color: Dell1996Colors.onPrimary,
          ),
        ),
      ),
    );
  }
}

/// Phone Callout - Red phone number on black background
class Dell1996PhoneCallout extends StatelessWidget {
  final String phoneNumber;

  const Dell1996PhoneCallout({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dell1996Spacing.sm,
        vertical: Dell1996Spacing.xs,
      ),
      decoration: const BoxDecoration(
        color: Dell1996Colors.frameInk,
      ),
      child: Text(
        phoneNumber,
        style: Dell1996Typography.heading2.copyWith(
          color: Dell1996Colors.primary,
        ),
      ),
    );
  }
}

/// Yellow Sticker - "NEW!" or "BUY" badges
class Dell1996YellowSticker extends StatelessWidget {
  final String text;
  final bool rotated;

  const Dell1996YellowSticker({
    super.key,
    required this.text,
    this.rotated = false,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dell1996Spacing.sm,
        vertical: Dell1996Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: Dell1996Colors.yellowSticker,
        border: Border.all(color: Dell1996Colors.frameInk, width: 1),
      ),
      child: Text(
        text.toUpperCase(),
        style: Dell1996Typography.button,
      ),
    );

    if (rotated) {
      return Transform.rotate(
        angle: 0.26, // ~15 degrees
        child: widget,
      );
    }

    return widget;
  }
}

/// Cert Seal - Circular award badge
class Dell1996CertSeal extends StatelessWidget {
  final String text;
  final double size;

  const Dell1996CertSeal({
    super.key,
    required this.text,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Dell1996Colors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Dell1996Colors.frameInk, width: 2),
      ),
      child: Center(
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: Dell1996Typography.button.copyWith(
            color: Dell1996Colors.canvas,
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}

/// Icon Label Nav - Bottom navigation style
class Dell1996IconLabelNav extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isActive;

  const Dell1996IconLabelNav({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(Dell1996Spacing.sm),
        decoration: BoxDecoration(
          color: isActive ? Dell1996Colors.yellowSticker : Dell1996Colors.canvas,
          border: Border.all(
            color: isActive ? Dell1996Colors.frameInk : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Dell1996Colors.ink,
              size: 24,
            ),
            const SizedBox(height: Dell1996Spacing.xs),
            Text(
              label.toUpperCase(),
              style: Dell1996Typography.uiLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Footer Band - Bottom page info
class Dell1996FooterBand extends StatelessWidget {
  final String text;

  const Dell1996FooterBand({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dell1996Spacing.lg),
      decoration: const BoxDecoration(
        color: Dell1996Colors.canvas,
        border: Border(
          top: BorderSide(color: Dell1996Colors.frameInk, width: 1),
        ),
      ),
      child: Text(
        text,
        style: Dell1996Typography.bodySm,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Text Input - Sharp border with 1px black outline
class Dell1996TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String>? onChanged;

  const Dell1996TextInput({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Dell1996Colors.canvas,
        border: Border.all(color: Dell1996Colors.frameInk, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        style: Dell1996Typography.body,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: Dell1996Typography.body.copyWith(color: Colors.grey),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}

/// Primary Button - Black filled button
class Dell1996ButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const Dell1996ButtonPrimary({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: onPressed != null ? Dell1996Colors.frameInk : Colors.grey,
          border: Border.all(color: Dell1996Colors.frameInk, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          text.toUpperCase(),
          style: Dell1996Typography.button.copyWith(
            color: Dell1996Colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
