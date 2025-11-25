import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';

class TodayTargetCell extends StatelessWidget {
  final String icon;
  final String value;
  final String title;

  const TodayTargetCell({
    super.key,
    required this.icon,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 10),
          Expanded(child: _buildTargetInfo()),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryG,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        icon,
        width: 25,
        height: 25,
        fit: BoxFit.contain,
        color: TColor.white,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.check_circle, color: TColor.white, size: 25);
        },
      ),
    );
  }

  Widget _buildTargetInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: TColor.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
          },
          child: Text(
            value,
            style: TextStyle(
              color: TColor.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(title, style: TextStyle(color: TColor.gray, fontSize: 12)),
      ],
    );
  }
}
