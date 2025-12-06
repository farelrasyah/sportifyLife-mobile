import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

/// Modern, elegant button for authentication screens
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56.0,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined
              ? Colors.transparent
              : (backgroundColor ?? ColorPalette.kButton),
          foregroundColor: isOutlined
              ? (textColor ?? ColorPalette.kButton)
              : (textColor ?? ColorPalette.kButtonText),
          elevation: isOutlined ? 0 : 8,
          shadowColor: ColorPalette.kButton.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: isOutlined
                ? BorderSide(
                    color: borderColor ?? ColorPalette.kBorder,
                    width: 1.0,
                  )
                : BorderSide.none,
          ),
          disabledBackgroundColor: isOutlined
              ? Colors.transparent
              : ColorPalette.kBorder,
          disabledForegroundColor: ColorPalette.kDisabled,
        ),
        child: isLoading
            ? SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOutlined
                        ? ColorPalette.kButton
                        : ColorPalette.kButtonText,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 12.0)],
                  Text(
                    text,
                    style: AppTypography.authButtonText.copyWith(
                      color: isOutlined
                          ? (textColor ?? ColorPalette.kButton)
                          : (textColor ?? ColorPalette.kButtonText),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Social login button widget
class SocialLoginButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.0,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: ColorPalette.kTextPrimary,
          side: const BorderSide(color: ColorPalette.kBorder, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 12.0),
            Text(
              text,
              style: AppTypography.authButtonText.copyWith(
                color: ColorPalette.kTextPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
