import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import '../../common/colo_extension.dart';

class WorkoutRow extends StatelessWidget {
  final Map<String, dynamic> workout;
  final VoidCallback? onTap;

  const WorkoutRow({super.key, required this.workout, this.onTap});

  @override
  Widget build(BuildContext context) {
    final String name = workout['name'] ?? '';
    final String image = workout['image'] ?? '';
    final String kcal = workout['kcal'] ?? '0';
    final String time = workout['time'] ?? '0';
    final double progress = (workout['progress'] ?? 0.0).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Row(
        children: [
          _buildWorkoutImage(image),
          const SizedBox(width: 15),
          Expanded(child: _buildWorkoutDetails(name, kcal, time)),
          _buildProgressIndicator(progress, context),
        ],
      ),
    );
  }

  Widget _buildWorkoutImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        image,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 60,
            height: 60,
            color: TColor.lightGray,
            child: Icon(Icons.fitness_center, color: TColor.gray),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutDetails(String name, String kcal, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: TColor.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '$kcal Calories | ${time}min',
          style: TextStyle(color: TColor.gray, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(double progress, BuildContext context) {
    return SizedBox(
      width: 70,
      height: 35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SimpleAnimationProgressBar(
            height: 35,
            width: 70,
            backgroundColor: TColor.lightGray,
            foregroundColor: Colors.transparent,
            ratio: progress,
            direction: Axis.horizontal,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 800),
            borderRadius: BorderRadius.circular(20),
            gradientColor: LinearGradient(
              colors: TColor.primaryG,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              color: TColor.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
