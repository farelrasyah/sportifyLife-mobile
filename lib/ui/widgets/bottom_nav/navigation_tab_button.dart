import 'package:flutter/material.dart';
import '../../../common/colo_extension.dart';

/// Custom tab button widget for bottom navigation
///
/// Features:
/// - Active/inactive state management
/// - Custom icon support with different states
/// - Smooth animations and transitions
/// - Consistent styling across the app
class NavigationTabButton extends StatelessWidget {
  final String iconPath;
  final String activeIconPath;
  final bool isSelected;
  final VoidCallback onPressed;
  final String? label;

  const NavigationTabButton({
    super.key,
    required this.iconPath,
    required this.activeIconPath,
    required this.isSelected,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            if (label != null) ...[const SizedBox(height: 4), _buildLabel()],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      child: Image.asset(
        isSelected ? activeIconPath : iconPath,
        width: 24,
        height: 24,
        color: isSelected ? TColor.primaryColor1 : TColor.gray,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if image not found
          return Icon(
            _getFallbackIcon(),
            size: 24,
            color: isSelected ? TColor.primaryColor1 : TColor.gray,
          );
        },
      ),
    );
  }

  IconData _getFallbackIcon() {
    if (iconPath.contains('home')) return Icons.home;
    if (iconPath.contains('activity')) return Icons.fitness_center;
    if (iconPath.contains('camera')) return Icons.photo_camera;
    if (iconPath.contains('profile')) return Icons.person;
    return Icons.circle;
  }

  Widget _buildLabel() {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(
        color: isSelected ? TColor.primaryColor1 : TColor.gray,
        fontSize: 10,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      child: Text(label!),
    );
  }
}
