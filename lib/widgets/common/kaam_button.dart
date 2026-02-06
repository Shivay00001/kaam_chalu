import 'package:flutter/material.dart';

/// Primary button with bilingual labels and loading state
class KaamButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String labelEn;
  final String labelHi;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final double? width;

  const KaamButton({
    super.key,
    required this.onPressed,
    required this.labelEn,
    required this.labelHi,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // For now, use English. Can be made dynamic based on user preference
    final label = labelEn;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(label),
      ],
    );

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: child,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: backgroundColor != null
                ? ElevatedButton.styleFrom(backgroundColor: backgroundColor)
                : null,
            child: child,
          );

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }
}

/// Success button variant
class KaamSuccessButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String labelEn;
  final String labelHi;
  final bool isLoading;
  final IconData? icon;

  const KaamSuccessButton({
    super.key,
    required this.onPressed,
    required this.labelEn,
    required this.labelHi,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return KaamButton(
      onPressed: onPressed,
      labelEn: labelEn,
      labelHi: labelHi,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: const Color(0xFF10B981),
    );
  }
}

/// Danger button variant
class KaamDangerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String labelEn;
  final String labelHi;
  final bool isLoading;
  final IconData? icon;

  const KaamDangerButton({
    super.key,
    required this.onPressed,
    required this.labelEn,
    required this.labelHi,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return KaamButton(
      onPressed: onPressed,
      labelEn: labelEn,
      labelHi: labelHi,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: const Color(0xFFEF4444),
    );
  }
}
