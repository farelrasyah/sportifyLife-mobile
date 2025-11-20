import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

class RememberMeCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String text;

  const RememberMeCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.text = 'Ingatkan Saya',
  }) : super(key: key);

  @override
  State<RememberMeCheckbox> createState() => _RememberMeCheckboxState();
}

class _RememberMeCheckboxState extends State<RememberMeCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.1,
              child: Checkbox(
                value: widget.value,
                onChanged: (value) => widget.onChanged(value ?? false),
                activeColor: ColorPalette.kAuthButtonPrimary,
                checkColor: Colors.white,
                side: BorderSide(
                  color: widget.value
                      ? ColorPalette.kAuthButtonPrimary
                      : ColorPalette.kAuthInputBorder,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.text,
                style: AppTypography.authSmallText.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
