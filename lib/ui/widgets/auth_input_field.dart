import 'package:flutter/material.dart';
import '../theme/color_palette.dart';
import '../theme/typography.dart';

/// Modern, elegant input field for authentication screens
class AuthInputField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int maxLines;
  final TextCapitalization textCapitalization;

  const AuthInputField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTypography.authInputLabel),
          const SizedBox(height: 8.0),
        ],
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorPalette.kSurface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: _isFocused
                    ? ColorPalette.kBorderFocus
                    : ColorPalette.kBorder,
                width: _isFocused ? 2.0 : 1.0,
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: _obscureText,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              maxLines: widget.maxLines,
              textCapitalization: widget.textCapitalization,
              style: AppTypography.authInputText,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.authInputPlaceholder,
                prefixIcon: widget.prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: widget.prefixIcon,
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: ColorPalette.kDisabled,
                          size: 20.0,
                        ),
                        onPressed: _togglePasswordVisibility,
                      )
                    : widget.suffixIcon,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 48.0,
                  minHeight: 48.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
