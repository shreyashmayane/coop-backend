import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// Branded CTA button with loading state and gradient option.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  final bool gradient;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.gradient = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final content = loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    if (gradient && !outlined) {
      return SizedBox(
        width: width ?? double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            boxShadow: AppTheme.primaryShadow,
          ),
          child: ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: content,
          ),
        ),
      );
    }

    if (outlined) {
      return SizedBox(
        width: width ?? double.infinity,
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.primary, width: 1.5),
            foregroundColor: AppTheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
          child: content,
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: content,
      ),
    );
  }
}
