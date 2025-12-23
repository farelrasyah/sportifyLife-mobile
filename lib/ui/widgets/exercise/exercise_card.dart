import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/colo_extension.dart';
import '../../data/models/exercise_model.dart';

/// Exercise Card Widget for displaying exercise in list/grid view
class ExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;
  final bool showFavoriteButton;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: TColor.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Stack(
                children: [
                  _buildImage(),
                  // Difficulty badge
                  Positioned(top: 8, left: 8, child: _buildDifficultyBadge()),
                  // Favorite button
                  if (showFavoriteButton)
                    Positioned(top: 8, right: 8, child: _buildFavoriteButton()),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
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
                    exercise.bodyPartLabel,
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.fitness_center,
                        exercise.type ?? 'Exercise',
                      ),
                      const SizedBox(width: 8),
                      if (exercise.duration != null)
                        _buildInfoChip(
                          Icons.timer_outlined,
                          '${exercise.duration} min',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = exercise.primaryImage;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        height: 120,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryG,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.fitness_center,
        color: TColor.white.withOpacity(0.7),
        size: 40,
      ),
    );
  }

  Widget _buildDifficultyBadge() {
    Color badgeColor;
    switch (exercise.difficulty?.toLowerCase()) {
      case 'beginner':
        badgeColor = Colors.green;
        break;
      case 'intermediate':
        badgeColor = Colors.orange;
        break;
      case 'advanced':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = TColor.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        exercise.difficultyLabel,
        style: TextStyle(
          color: TColor.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: onFavoriteTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: TColor.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : TColor.gray,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: TColor.gray),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: TColor.gray, fontSize: 10)),
        ],
      ),
    );
  }
}

/// Exercise List Item Widget for list view display
class ExerciseListItem extends StatelessWidget {
  final ExerciseModel exercise;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;
  final bool showFavoriteButton;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    required this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: TColor.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
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
                    '${exercise.bodyPartLabel} • ${exercise.difficultyLabel}',
                    style: TextStyle(color: TColor.gray, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 12,
                        color: TColor.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        exercise.type ?? 'Exercise',
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (exercise.equipment?.isNotEmpty == true) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.sports_gymnastics,
                          size: 12,
                          color: TColor.secondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            exercise.equipment!.first,
                            style: TextStyle(
                              color: TColor.secondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            Column(
              children: [
                if (showFavoriteButton)
                  IconButton(
                    onPressed: onFavoriteTap,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : TColor.gray,
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(height: 8),
                Icon(Icons.arrow_forward_ios, color: TColor.gray, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = exercise.primaryImage;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryG,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.fitness_center,
        color: TColor.white.withOpacity(0.7),
        size: 28,
      ),
    );
  }
}
