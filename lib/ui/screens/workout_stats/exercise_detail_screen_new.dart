import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:readmore/readmore.dart';
import 'package:lottie/lottie.dart';

import '../../../common/colo_extension.dart';
import '../../../cubits/exercise/exercise_cubits.dart';
import '../../../data/models/exercise_model.dart';
import '../../widgets/round_button.dart';
import '../../widgets/custom_modern_appbar.dart';
import '../../widgets/exercise/exercise_shimmer.dart';

/// Exercise Detail Screen with Backend Integration
class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseId;
  final ExerciseModel? initialExercise;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.initialExercise,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  int _selectedRepetitions = 10;
  int _selectedSets = 3;
  double _selectedWeight = 0;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Load exercise detail
    context.read<ExerciseDetailCubit>().loadExercise(widget.exerciseId);
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseDetailCubit, ExerciseDetailState>(
      builder: (context, state) {
        if (state is ExerciseDetailLoading) {
          return _buildLoadingScreen();
        }
        if (state is ExerciseDetailError) {
          return _buildErrorScreen(state.message);
        }
        if (state is ExerciseDetailLoaded) {
          return _buildDetailScreen(state);
        }
        return _buildLoadingScreen();
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: CustomModernAppBar(
        title: 'Exercise Detail',
        icon: Icons.fitness_center,
        fabAnimationController: _fabAnimationController,
        primaryColor: TColor.primaryColor1,
        lightColor: TColor.primaryColor2,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TColor.primary),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String message) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: CustomModernAppBar(
        title: 'Exercise Detail',
        icon: Icons.fitness_center,
        fabAnimationController: _fabAnimationController,
        primaryColor: TColor.primaryColor1,
        lightColor: TColor.primaryColor2,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: ExerciseErrorWidget(
        message: message,
        onRetry: () =>
            context.read<ExerciseDetailCubit>().loadExercise(widget.exerciseId),
      ),
    );
  }

  Widget _buildDetailScreen(ExerciseDetailLoaded state) {
    final exercise = state.exercise;
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomModernAppBar(
        title: exercise.name,
        icon: Icons.fitness_center,
        fabAnimationController: _fabAnimationController,
        primaryColor: TColor.primaryColor1,
        lightColor: TColor.primaryColor2,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: Icon(
              state.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: state.isFavorite ? Colors.red : TColor.gray,
            ),
            onPressed: () =>
                context.read<ExerciseDetailCubit>().toggleFavorite(),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(screenSize, exercise),
              const SizedBox(height: 15),
              _buildExerciseInfo(exercise),
              const SizedBox(height: 15),
              _buildMetricsSection(exercise),
              const SizedBox(height: 15),
              _buildDescriptionSection(exercise),
              const SizedBox(height: 15),
              if (exercise.instructions.isNotEmpty)
                _buildInstructionsSection(exercise),
              if (exercise.tips.isNotEmpty) ...[
                const SizedBox(height: 15),
                _buildTipsSection(exercise),
              ],
              if (exercise.variations.isNotEmpty) ...[
                const SizedBox(height: 15),
                _buildVariationsSection(exercise),
              ],
              const SizedBox(height: 15),
              _buildCustomRepetitionsSection(),
              const SizedBox(height: 20),
              _buildAddToWorkoutButton(exercise),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(Size screenSize, ExerciseModel exercise) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.width * 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColor.primaryG),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _buildExerciseImage(exercise),
          ),
        ),
        // Difficulty badge
        Positioned(top: 12, left: 12, child: _buildDifficultyBadge(exercise)),
        // Play button if has video
        if (exercise.videoUrl != null)
          IconButton(
            onPressed: () => _playVideo(exercise.videoUrl!),
            icon: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: TColor.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.play_arrow, color: TColor.primary, size: 30),
            ),
          ),
      ],
    );
  }

  Widget _buildExerciseImage(ExerciseModel exercise) {
    final imageUrl = exercise.primaryImage;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.endsWith('.gif')) {
        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildImagePlaceholder(),
          errorWidget: (context, url, error) => _buildImagePlaceholder(),
        );
      }
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildImagePlaceholder(),
        errorWidget: (context, url, error) => _buildImagePlaceholder(),
      );
    }
    return _buildImagePlaceholder();
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryG,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.fitness_center,
          color: TColor.white.withOpacity(0.5),
          size: 60,
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(ExerciseModel exercise) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        exercise.difficultyLabel,
        style: TextStyle(
          color: TColor.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExerciseInfo(ExerciseModel exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.name,
          style: TextStyle(
            color: TColor.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildInfoTag(Icons.fitness_center, exercise.type ?? 'Exercise'),
            const SizedBox(width: 12),
            _buildInfoTag(Icons.accessibility_new, exercise.bodyPartLabel),
            if (exercise.duration != null) ...[
              const SizedBox(width: 12),
              _buildInfoTag(Icons.timer_outlined, '${exercise.duration} min'),
            ],
          ],
        ),
        if (exercise.targetMuscles?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: exercise.targetMuscles!.map((muscle) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: TColor.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  muscle,
                  style: TextStyle(
                    color: TColor.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: TColor.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: TColor.gray,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(ExerciseModel exercise) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: TColor.primaryG.map((c) => c.withOpacity(0.1)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(
            Icons.repeat,
            '${exercise.defaultReps ?? 10}',
            'Reps',
          ),
          Container(width: 1, height: 40, color: TColor.gray.withOpacity(0.2)),
          _buildMetricItem(
            Icons.layers,
            '${exercise.defaultSets ?? 3}',
            'Sets',
          ),
          Container(width: 1, height: 40, color: TColor.gray.withOpacity(0.2)),
          _buildMetricItem(
            Lottie.asset("assets/images/fire.json", width: 24, height: 24),
            '${exercise.caloriesPerRep ?? 0}',
            'Cal/Rep',
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(dynamic icon, String value, String label) {
    return Column(
      children: [
        if (icon is IconData)
          Icon(icon, color: TColor.primary, size: 24)
        else
          icon as Widget,
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: TColor.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: TextStyle(color: TColor.gray, fontSize: 12)),
      ],
    );
  }

  Widget _buildDescriptionSection(ExerciseModel exercise) {
    if (exercise.description == null || exercise.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        ReadMoreText(
          exercise.description!,
          trimLines: 4,
          colorClickableText: TColor.primary,
          trimMode: TrimMode.Line,
          trimCollapsedText: ' Read More',
          trimExpandedText: ' Read Less',
          style: TextStyle(color: TColor.gray, fontSize: 14, height: 1.5),
          moreStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TColor.primary,
          ),
          lessStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: TColor.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsSection(ExerciseModel exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "How To Do It",
              style: TextStyle(
                color: TColor.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "${exercise.instructions.length} Steps",
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: exercise.instructions.length,
          itemBuilder: (context, index) {
            final instruction = exercise.instructions[index];
            final isLast = index == exercise.instructions.length - 1;
            return _buildInstructionStep(instruction, index + 1, isLast);
          },
        ),
      ],
    );
  }

  Widget _buildInstructionStep(
    ExerciseInstructionModel instruction,
    int stepNumber,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: TColor.primaryG),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: TColor.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: TColor.primary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (instruction.title != null)
                  Text(
                    instruction.title!,
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (instruction.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    instruction.description!,
                    style: TextStyle(
                      color: TColor.gray,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection(ExerciseModel exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tips",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...exercise.tips.map((tip) => _buildTipItem(tip)),
      ],
    );
  }

  Widget _buildTipItem(ExerciseTipModel tip) {
    Color iconColor;
    IconData icon;

    switch (tip.type?.toLowerCase()) {
      case 'warning':
        iconColor = Colors.orange;
        icon = Icons.warning_amber_rounded;
        break;
      case 'safety':
        iconColor = Colors.red;
        icon = Icons.security;
        break;
      case 'pro':
        iconColor = Colors.purple;
        icon = Icons.star;
        break;
      default:
        iconColor = TColor.primary;
        icon = Icons.lightbulb_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip.content,
              style: TextStyle(color: TColor.black, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariationsSection(ExerciseModel exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Variations",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: exercise.variations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final variation = exercise.variations[index];
              return _buildVariationCard(variation);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVariationCard(ExerciseVariationModel variation) {
    return GestureDetector(
      onTap: () {
        if (variation.exerciseId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ExerciseDetailScreen(exerciseId: variation.exerciseId!),
            ),
          );
        }
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: TColor.lightGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              variation.name,
              style: TextStyle(
                color: TColor.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              variation.difficulty ?? 'Variation',
              style: TextStyle(color: TColor.gray, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomRepetitionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customize Your Workout",
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildRepetitionsPicker()),
            const SizedBox(width: 16),
            Expanded(child: _buildSetsPicker()),
          ],
        ),
      ],
    );
  }

  Widget _buildRepetitionsPicker() {
    return Column(
      children: [
        Text("Repetitions", style: TextStyle(color: TColor.gray, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: TColor.lightGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CupertinoPicker(
            itemExtent: 36,
            selectionOverlay: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: TColor.primary.withOpacity(0.3)),
                  bottom: BorderSide(color: TColor.primary.withOpacity(0.3)),
                ),
              ),
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedRepetitions = index + 1;
              });
            },
            children: List.generate(30, (index) {
              return Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSetsPicker() {
    return Column(
      children: [
        Text("Sets", style: TextStyle(color: TColor.gray, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: TColor.lightGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CupertinoPicker(
            itemExtent: 36,
            selectionOverlay: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: TColor.primary.withOpacity(0.3)),
                  bottom: BorderSide(color: TColor.primary.withOpacity(0.3)),
                ),
              ),
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedSets = index + 1;
              });
            },
            children: List.generate(10, (index) {
              return Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAddToWorkoutButton(ExerciseModel exercise) {
    return RoundButton(
      title: "Add to Workout Plan",
      elevation: 0,
      onPressed: () {
        _showAddToWorkoutDialog(exercise);
      },
    );
  }

  void _showAddToWorkoutDialog(ExerciseModel exercise) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TColor.gray.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add to Workout',
              style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${exercise.name}\n$_selectedSets sets × $_selectedRepetitions reps',
              textAlign: TextAlign.center,
              style: TextStyle(color: TColor.gray, fontSize: 14),
            ),
            const SizedBox(height: 24),
            RoundButton(
              title: "Add to New Workout",
              elevation: 0,
              onPressed: () {
                Navigator.pop(context);
                // Navigate to create workout with this exercise
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${exercise.name} will be added to your workout',
                    ),
                    backgroundColor: TColor.primary,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: TColor.gray, fontSize: 14),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _playVideo(String videoUrl) {
    // Implement video playback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Video playback coming soon'),
        backgroundColor: TColor.primary,
      ),
    );
  }
}
