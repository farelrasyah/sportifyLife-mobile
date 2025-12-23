import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/colo_extension.dart';
import '../../../cubits/exercise/exercise_cubits.dart';
import '../../../data/models/exercise_model.dart';
import '../../widgets/exercise/exercise_widgets.dart';
import '../../widgets/custom_modern_appbar.dart';
import 'exercise_detail_screen.dart';

/// Exercise List Screen - Browse all exercises with filtering
class ExerciseListScreen extends StatefulWidget {
  final bool isSelectionMode;
  final List<String>? selectedExerciseIds;
  final Function(List<ExerciseModel>)? onSelectionComplete;

  const ExerciseListScreen({
    super.key,
    this.isSelectionMode = false,
    this.selectedExerciseIds,
    this.onSelectionComplete,
  });

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  bool _isGridView = false;
  List<ExerciseModel> _selectedExercises = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);

    // Initialize selected exercises if provided
    if (widget.selectedExerciseIds != null) {
      // Will be populated when exercises are loaded
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _loadData() {
    context.read<ExerciseListCubit>().loadExercises();
    context.read<ExerciseFiltersCubit>().loadFilters();
    context.read<FavoriteExercisesCubit>().loadFavorites();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ExerciseListCubit>().loadMoreExercises();
    }
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        context.read<ExerciseListCubit>().loadExercises();
      } else {
        context.read<ExerciseListCubit>().searchExercises(query);
      }
    });
  }

  void _showFilterBottomSheet() {
    final filterState = context.read<ExerciseFiltersCubit>().state;
    if (filterState is! ExerciseFiltersLoaded) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => ExerciseFilterBottomSheet(
          filters: filterState.filters,
          selectedType: filterState.activeFilters.type,
          selectedBodyPart: filterState.activeFilters.bodyPart,
          selectedEquipment: filterState.activeFilters.equipment,
          selectedTargetMuscle: filterState.activeFilters.targetMuscle,
          selectedDifficulty: filterState.activeFilters.difficulty,
          sortBy: filterState.activeFilters.sortBy,
          sortOrder: filterState.activeFilters.sortOrder,
          onApply: (filters) {
            final filtersCubit = context.read<ExerciseFiltersCubit>();
            filtersCubit.setType(filters['type']);
            filtersCubit.setBodyPart(filters['bodyPart']);
            filtersCubit.setEquipment(filters['equipment']);
            filtersCubit.setTargetMuscle(filters['targetMuscle']);
            filtersCubit.setDifficulty(filters['difficulty']);
            filtersCubit.setSorting(filters['sortBy'], filters['sortOrder']);

            context.read<ExerciseListCubit>().applyFilters(
              type: filters['type'],
              bodyPart: filters['bodyPart'],
              equipment: filters['equipment'],
              targetMuscle: filters['targetMuscle'],
              difficulty: filters['difficulty'],
              sortBy: filters['sortBy'],
              sortOrder: filters['sortOrder'],
            );
          },
        ),
      ),
    );
  }

  void _toggleExerciseSelection(ExerciseModel exercise) {
    setState(() {
      final index = _selectedExercises.indexWhere((e) => e.id == exercise.id);
      if (index >= 0) {
        _selectedExercises.removeAt(index);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  void _completeSelection() {
    widget.onSelectionComplete?.call(_selectedExercises);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: BlocBuilder<ExerciseFiltersCubit, ExerciseFiltersState>(
              builder: (context, filterState) {
                int filterCount = 0;
                if (filterState is ExerciseFiltersLoaded) {
                  filterCount = filterState.activeFilterCount;
                }
                return ExerciseSearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onFilterTap: _showFilterBottomSheet,
                  filterCount: filterCount,
                );
              },
            ),
          ),
          // Active filters chips
          BlocBuilder<ExerciseFiltersCubit, ExerciseFiltersState>(
            builder: (context, state) {
              if (state is ExerciseFiltersLoaded &&
                  state.activeFilters.hasFilters) {
                return _buildActiveFiltersChips(state);
              }
              return const SizedBox.shrink();
            },
          ),
          // Exercise list
          Expanded(
            child: BlocBuilder<ExerciseListCubit, ExerciseListState>(
              builder: (context, state) {
                if (state is ExerciseListLoading) {
                  return _buildLoadingState();
                }
                if (state is ExerciseListError) {
                  return ExerciseErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        context.read<ExerciseListCubit>().loadExercises(),
                  );
                }
                if (state is ExerciseListLoaded) {
                  if (state.exercises.isEmpty) {
                    return ExerciseEmptyWidget(
                      onAction: () {
                        context.read<ExerciseFiltersCubit>().clearAllFilters();
                        context.read<ExerciseListCubit>().clearFilters();
                      },
                      actionLabel: 'Clear Filters',
                    );
                  }
                  return _buildExerciseList(state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton:
          widget.isSelectionMode && _selectedExercises.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _completeSelection,
              backgroundColor: TColor.primary,
              icon: const Icon(Icons.check),
              label: Text('Add ${_selectedExercises.length} Exercises'),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (widget.isSelectionMode) {
      return AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: TColor.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Exercises',
          style: TextStyle(
            color: TColor.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          if (_selectedExercises.isNotEmpty)
            TextButton(
              onPressed: _completeSelection,
              child: Text(
                'Done (${_selectedExercises.length})',
                style: TextStyle(
                  color: TColor.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      );
    }

    return CustomModernAppBar(
      title: 'Exercises',
      showBackButton: true,
      actions: [
        IconButton(
          icon: Icon(
            _isGridView ? Icons.view_list : Icons.grid_view,
            color: TColor.gray,
          ),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActiveFiltersChips(ExerciseFiltersLoaded state) {
    final chips = <Widget>[];
    final filters = state.activeFilters;
    final filtersCubit = context.read<ExerciseFiltersCubit>();

    if (filters.type != null) {
      chips.add(
        _buildFilterChip('Type: ${filters.type}', () {
          filtersCubit.clearFilter('type');
          _applyFiltersFromState();
        }),
      );
    }
    if (filters.bodyPart != null) {
      chips.add(
        _buildFilterChip('Body: ${filters.bodyPart}', () {
          filtersCubit.clearFilter('bodyPart');
          _applyFiltersFromState();
        }),
      );
    }
    if (filters.equipment != null) {
      chips.add(
        _buildFilterChip('Equipment: ${filters.equipment}', () {
          filtersCubit.clearFilter('equipment');
          _applyFiltersFromState();
        }),
      );
    }
    if (filters.targetMuscle != null) {
      chips.add(
        _buildFilterChip('Muscle: ${filters.targetMuscle}', () {
          filtersCubit.clearFilter('targetMuscle');
          _applyFiltersFromState();
        }),
      );
    }
    if (filters.difficulty != null) {
      chips.add(
        _buildFilterChip('Difficulty: ${filters.difficulty}', () {
          filtersCubit.clearFilter('difficulty');
          _applyFiltersFromState();
        }),
      );
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: chips),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: TColor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TColor.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: TColor.primary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close, size: 14, color: TColor.primary),
          ),
        ],
      ),
    );
  }

  void _applyFiltersFromState() {
    final filterState = context.read<ExerciseFiltersCubit>().state;
    if (filterState is ExerciseFiltersLoaded) {
      final filters = filterState.activeFilters;
      context.read<ExerciseListCubit>().applyFilters(
        type: filters.type,
        bodyPart: filters.bodyPart,
        equipment: filters.equipment,
        targetMuscle: filters.targetMuscle,
        difficulty: filters.difficulty,
        sortBy: filters.sortBy,
        sortOrder: filters.sortOrder,
      );
    }
  }

  Widget _buildLoadingState() {
    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const ExerciseCardShimmer(),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const ExerciseListItemShimmer(),
    );
  }

  Widget _buildExerciseList(ExerciseListLoaded state) {
    return BlocBuilder<FavoriteExercisesCubit, FavoriteExercisesState>(
      builder: (context, favState) {
        final favorites = favState is FavoriteExercisesLoaded
            ? favState.favorites.map((e) => e.id).toSet()
            : <String>{};

        if (_isGridView) {
          return _buildGridView(state, favorites);
        }
        return _buildListView(state, favorites);
      },
    );
  }

  Widget _buildGridView(ExerciseListLoaded state, Set<String> favorites) {
    return RefreshIndicator(
      onRefresh: () => context.read<ExerciseListCubit>().refreshExercises(),
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: state.exercises.length + (state.isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= state.exercises.length) {
            return const ExerciseCardShimmer();
          }

          final exercise = state.exercises[index];
          final isFavorite = favorites.contains(exercise.id);
          final isSelected = _selectedExercises.any((e) => e.id == exercise.id);

          return Stack(
            children: [
              ExerciseCard(
                exercise: exercise,
                isFavorite: isFavorite,
                showFavoriteButton: !widget.isSelectionMode,
                onTap: () => widget.isSelectionMode
                    ? _toggleExerciseSelection(exercise)
                    : _navigateToDetail(exercise),
                onFavoriteTap: () => context
                    .read<FavoriteExercisesCubit>()
                    .toggleFavorite(exercise),
              ),
              if (widget.isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildSelectionCheckbox(isSelected),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListView(ExerciseListLoaded state, Set<String> favorites) {
    return RefreshIndicator(
      onRefresh: () => context.read<ExerciseListCubit>().refreshExercises(),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.exercises.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= state.exercises.length) {
            return const LoadMoreIndicator();
          }

          final exercise = state.exercises[index];
          final isFavorite = favorites.contains(exercise.id);
          final isSelected = _selectedExercises.any((e) => e.id == exercise.id);

          return Stack(
            children: [
              ExerciseListItem(
                exercise: exercise,
                isFavorite: isFavorite,
                showFavoriteButton: !widget.isSelectionMode,
                onTap: () => widget.isSelectionMode
                    ? _toggleExerciseSelection(exercise)
                    : _navigateToDetail(exercise),
                onFavoriteTap: () => context
                    .read<FavoriteExercisesCubit>()
                    .toggleFavorite(exercise),
              ),
              if (widget.isSelectionMode && isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: TColor.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: TColor.primary, width: 2),
                    ),
                  ),
                ),
              if (widget.isSelectionMode)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildSelectionCheckbox(isSelected),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectionCheckbox(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? TColor.primary : TColor.white,
        border: Border.all(
          color: isSelected ? TColor.primary : TColor.gray,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, color: TColor.white, size: 16)
          : null,
    );
  }

  void _navigateToDetail(ExerciseModel exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailScreen(exerciseId: exercise.id),
      ),
    );
  }
}
