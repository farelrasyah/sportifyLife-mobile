import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';

class NotificationRow extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationRow({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final String image = notification['image'] ?? '';
    final String title = notification['title'] ?? '';
    final String time = notification['time'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotificationImage(image),
          const SizedBox(width: 15),
          Expanded(child: _buildNotificationContent(title, time)),
        ],
      ),
    );
  }

  Widget _buildNotificationImage(String image) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
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
              child: Icon(Icons.notifications, color: TColor.gray, size: 24),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationContent(String title, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: TColor.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(color: TColor.gray, fontSize: 11)),
      ],
    );
  }
}
