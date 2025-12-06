import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';

/// Primary button widget with consistent styling
/// Used for main call-to-action buttons throughout the app
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? Spacing.buttonHeight,
      decoration: BoxDecoration(
        color: ColorPalette.kButton,
        borderRadius: Spacing.radiusButton,
        boxShadow: const [
          BoxShadow(
            color: ColorPalette.kShadow,
            offset: Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: Spacing.radiusButton,
          child: Container(
            padding: Spacing.buttonPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ColorPalette.kButtonText,
                      ),
                    ),
                  ),
                  Spacing.horizontalMD,
                ] else if (icon != null) ...[
                  icon!,
                  Spacing.horizontalMD,
                ],
                Text(
                  text,
                  style: AppTypography.buttonPrimary,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
