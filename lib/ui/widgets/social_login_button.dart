import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../common/colo_extension.dart';

/// Social login button widget for OAuth authentication
class SocialLoginButton extends StatelessWidget {
  final String provider; // 'google' or 'facebook'
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, // Changed to square: width and height equal
      height: 50, // Changed to square: width and height equal
      margin: const EdgeInsets.all(
        0,
      ), // Removed margins for tight horizontal layout
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(
            15,
          ), // Changed back to rounded corners
          child: Container(
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(
                15,
              ), // Changed back to rounded corners
              border: Border.all(color: _getBorderColor(), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              // Centered the icon
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getTextColor(),
                        ),
                      ),
                    )
                  : _buildIcon(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider.toLowerCase()) {
      case 'google':
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://developers.google.com/identity/images/g-logo.png',
              ),
              fit: BoxFit.contain,
            ),
          ),
        );
      case 'facebook':
        return Icon(Icons.facebook, size: 20, color: _getIconColor());
      default:
        return Icon(Icons.login, size: 20, color: _getIconColor());
    }
  }

  Color _getBackgroundColor() {
    switch (provider.toLowerCase()) {
      case 'google':
        return Colors.white;
      case 'facebook':
        return const Color(0xFF1877F2); // Facebook blue
      default:
        return Colors.white;
    }
  }

  Color _getBorderColor() {
    switch (provider.toLowerCase()) {
      case 'google':
        return TColor.gray.withOpacity(0.3);
      case 'facebook':
        return const Color(0xFF1877F2);
      default:
        return TColor.gray.withOpacity(0.3);
    }
  }

  Color _getTextColor() {
    switch (provider.toLowerCase()) {
      case 'google':
        return TColor.black;
      case 'facebook':
        return Colors.white;
      default:
        return TColor.black;
    }
  }

  Color _getIconColor() {
    switch (provider.toLowerCase()) {
      case 'facebook':
        return Colors.white;
      default:
        return TColor.black;
    }
  }
}
