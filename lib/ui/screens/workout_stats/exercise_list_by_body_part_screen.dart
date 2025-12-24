import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/colo_extension.dart';
import '../../../cubits/exercise/exercise_list_cubit.dart';
import '../../../cubits/exercise/exercise_list_state.dart';
import '../../../data/models/exercise_model.dart';
import '../../widgets/custom_modern_appbar.dart';
import 'exercise_detail_screen.dart';
import 'package:lottie/lottie.dart';

/// Screen that displays exercises filtered by body part
class ExerciseListByBodyPartScreen extends StatefulWidget {
  final String bodyPart;

  const ExerciseListByBodyPartScreen({super.key, required this.bodyPart});

  @override
  State<ExerciseListByBodyPartScreen> createState() =>
      _ExerciseListByBodyPartScreenState();
}

class _ExerciseListByBodyPartScreenState
    extends State<ExerciseListByBodyPartScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Load exercises for this body part
    context.read<ExerciseListCubit>().loadExercises(
      ExerciseQueryParams(bodyPart: widget.bodyPart),
    );

    // Setup pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Load more when 80% scrolled
      context.read<ExerciseListCubit>().loadMoreExercises();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: CustomModernAppBar(
        title: '${_formatBodyPart(widget.bodyPart)} Exercises',
        icon: Icons.fitness_center,
        fabAnimationController: _fabAnimationController,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: TColor.primaryG),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: BlocBuilder<ExerciseListCubit, ExerciseListState>(
                  builder: (context, state) {
                    if (state is ExerciseListLoading) {
                      return _buildLoadingState();
                    }

                    if (state is ExerciseListError) {
                      return _buildErrorState(state.message);
                    }

                    if (state is ExerciseListLoaded) {
                      if (state.exercises.isEmpty) {
                        return _buildEmptyState();
                      }

                      return _buildExerciseList(state);
                    }

                    return _buildLoadingState();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your exercise',
            style: TextStyle(
              color: TColor.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${_formatBodyPart(widget.bodyPart)} Workout',
            style: TextStyle(
              color: TColor.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList(ExerciseListLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ExerciseListCubit>().refreshExercises();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        itemCount: state.exercises.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.exercises.length) {
            return _buildLoadingMore();
          }

          final exercise = state.exercises[index];
          return _buildExerciseCard(exercise);
        },
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseModel exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetailScreen(
                  exerciseData: {
                    'id': exercise.id,
                    'title': exercise.name,
                    'name': exercise.name,
                    'description': exercise.description,
                    'type': exercise.type,
                    'bodyPart': exercise.bodyPart,
                    'equipment': exercise.equipment,
                    'targetMuscle': exercise.targetMuscle,
                    'difficulty': exercise.difficulty,
                    'instructions': exercise.instructions,
                    'tips': exercise.tips,
                    'images': exercise.images,
                    'videos': exercise.videos,
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                // Exercise Image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: TColor.secondaryG),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: exercise.images.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            exercise.images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          ),
                        )
                      : _buildPlaceholderImage(),
                ),
                const SizedBox(width: 15),
                // Exercise Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      if (exercise.targetMuscles != null)
                        Text(
                          'Target: ${exercise.targetMuscles}',
                          style: TextStyle(color: TColor.gray, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: TColor.primaryColor2.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              exercise.type,
                              style: TextStyle(
                                color: TColor.primaryColor1,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (exercise.equipment != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: TColor.secondaryColor2.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                exercise.equipment!,
                                style: TextStyle(
                                  color: TColor.secondaryColor1,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: TColor.gray.withOpacity(0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Center(
      child: Icon(Icons.fitness_center, size: 30, color: TColor.white),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
          ),
          const SizedBox(height: 15),
          Text(
            'Loading exercises...',
            style: TextStyle(color: TColor.gray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMore() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(TColor.primaryColor1),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: TColor.gray),
            const SizedBox(height: 15),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(color: TColor.gray, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<ExerciseListCubit>().loadExercises(
                  ExerciseQueryParams(bodyPart: widget.bodyPart),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primaryColor1,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(
                'assets/images/exercise.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Exercises Found',
              style: TextStyle(
                color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'No exercises available for ${_formatBodyPart(widget.bodyPart)}',
              style: TextStyle(color: TColor.gray, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatBodyPart(String bodyPart) {
    // Format body part string for display
    return bodyPart
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}
