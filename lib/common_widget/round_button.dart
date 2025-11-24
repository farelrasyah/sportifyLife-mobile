import 'package:flutter/material.dart';
import '../common/colo_extension.dart';

enum RoundButtonType { bgGradient, bgSGradient, textGradient }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final double elevation;
  final FontWeight fontWeight;

  const RoundButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.type = RoundButtonType.bgGradient,
    this.fontSize = 16,
    this.elevation = 1,
    this.fontWeight = FontWeight.w700,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: type == RoundButtonType.bgSGradient
              ? [TColor.secondaryLight, TColor.secondary]
              : [TColor.primaryLight, TColor.primary],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: type == RoundButtonType.textGradient
            ? null
            : [
                BoxShadow(
                  color: type == RoundButtonType.bgSGradient
                      ? TColor.secondary.withOpacity(0.25)
                      : TColor.primary.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        height: 60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: TColor.primaryLight,
        minWidth: double.maxFinite,
        elevation: type == RoundButtonType.textGradient ? 0 : elevation,
        color: type == RoundButtonType.textGradient ? Colors.transparent : null,
        child: Text(
          title,
          style: TextStyle(
            color: TColor.white,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
