import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

class ElegantTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool obscureText;
  final IconData icon;
  final Widget? suffixWidget;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;

  const ElegantTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.obscureText,
    required this.icon,
    required this.focusNode,
    this.suffixWidget,
    this.keyboardType,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<ElegantTextField> createState() => _ElegantTextFieldState();
}

class _ElegantTextFieldState extends State<ElegantTextField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupFocusListener();
    _startAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  void _setupFocusListener() {
    widget.focusNode.addListener(() {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    });
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: ColorPalette.kButton.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
          border: Border.all(
            color: _isFocused ? ColorPalette.kButton : ColorPalette.kBorder,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: isSmallScreen ? 8 : 12),
              child: Text(
                widget.labelText,
                style: AppTypography.authInputLabel.copyWith(
                  color: _isFocused
                      ? ColorPalette.kButton
                      : ColorPalette.kDisabled,
                  fontSize: isSmallScreen ? 12 : 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              maxLines: widget.maxLines,
              style: AppTypography.authInputText.copyWith(
                fontSize: isSmallScreen ? 15 : 16,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.authInputText.copyWith(
                  color: ColorPalette.kDisabled,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: isSmallScreen ? 8 : 12,
                  ),
                  child: Icon(
                    widget.icon,
                    color: _isFocused
                        ? ColorPalette.kButton
                        : ColorPalette.kDisabled,
                    size: isSmallScreen ? 20 : 22,
                  ),
                ),
                suffixIcon: widget.suffixWidget,
                border: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(
                  0,
                  isSmallScreen ? 8 : 10,
                  16,
                  16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
