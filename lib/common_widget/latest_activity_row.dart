import 'package:flutter/material.dart';
import '../common/colo_extension.dart';

class LatestActivityRow extends StatelessWidget {
  final Map<String, dynamic> activity;

  const LatestActivityRow({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final String image = activity['image'] ?? '';
    final String title = activity['title'] ?? '';
    final String time = activity['time'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildActivityImage(image),
          const SizedBox(width: 15),
          Expanded(child: _buildActivityInfo(title, time)),
          _buildMoreButton(),
        ],
      ),
    );
  }

  Widget _buildActivityImage(String image) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(Icons.local_activity, color: TColor.gray, size: 24),
            );
          },
        ),
      ),
    );
  }

  Widget _buildActivityInfo(String title, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: TColor.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(color: TColor.gray, fontSize: 11)),
      ],
    );
  }

  Widget _buildMoreButton() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(color: TColor.lightGray, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.chevron_right, color: TColor.gray, size: 18),
    );
  }
}
