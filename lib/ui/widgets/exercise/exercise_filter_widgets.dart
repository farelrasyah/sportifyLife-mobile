import 'package:flutter/material.dart';
import '../../../common/colo_extension.dart';
import '../../../data/models/exercise_model.dart';

/// Filter chip widget for exercise filters
class ExerciseFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ExerciseFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: TColor.primaryG,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isSelected ? null : TColor.lightGray,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: TColor.gray.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? TColor.white : TColor.gray,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// Filter section with horizontal scrollable chips
class FilterSection extends StatelessWidget {
  final String title;
  final List<FilterOptionModel> options;
  final String? selectedValue;
  final ValueChanged<String?> onSelected;
  final bool showAll;

  const FilterSection({
    super.key,
    required this.title,
    required this.options,
    this.selectedValue,
    required this.onSelected,
    this.showAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (showAll)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ExerciseFilterChip(
                    label: 'All',
                    isSelected: selectedValue == null,
                    onTap: () => onSelected(null),
                  ),
                ),
              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ExerciseFilterChip(
                    label: option.displayName,
                    isSelected: selectedValue == option.value,
                    onTap: () => onSelected(option.value),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet for advanced filter options
class ExerciseFilterBottomSheet extends StatefulWidget {
  final ExerciseFiltersModel filters;
  final String? selectedType;
  final String? selectedBodyPart;
  final String? selectedEquipment;
  final String? selectedTargetMuscle;
  final String? selectedDifficulty;
  final String? sortBy;
  final String? sortOrder;
  final Function(Map<String, String?>) onApply;

  const ExerciseFilterBottomSheet({
    super.key,
    required this.filters,
    this.selectedType,
    this.selectedBodyPart,
    this.selectedEquipment,
    this.selectedTargetMuscle,
    this.selectedDifficulty,
    this.sortBy,
    this.sortOrder,
    required this.onApply,
  });

  @override
  State<ExerciseFilterBottomSheet> createState() =>
      _ExerciseFilterBottomSheetState();
}

class _ExerciseFilterBottomSheetState extends State<ExerciseFilterBottomSheet> {
  late String? _selectedType;
  late String? _selectedBodyPart;
  late String? _selectedEquipment;
  late String? _selectedTargetMuscle;
  late String? _selectedDifficulty;
  late String? _sortBy;
  late String? _sortOrder;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
    _selectedBodyPart = widget.selectedBodyPart;
    _selectedEquipment = widget.selectedEquipment;
    _selectedTargetMuscle = widget.selectedTargetMuscle;
    _selectedDifficulty = widget.selectedDifficulty;
    _sortBy = widget.sortBy;
    _sortOrder = widget.sortOrder;
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedType != null) count++;
    if (_selectedBodyPart != null) count++;
    if (_selectedEquipment != null) count++;
    if (_selectedTargetMuscle != null) count++;
    if (_selectedDifficulty != null) count++;
    return count;
  }

  void _clearAllFilters() {
    setState(() {
      _selectedType = null;
      _selectedBodyPart = null;
      _selectedEquipment = null;
      _selectedTargetMuscle = null;
      _selectedDifficulty = null;
      _sortBy = null;
      _sortOrder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TColor.gray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    color: TColor.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (_activeFilterCount > 0)
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: TColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Filters
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  // Type filter
                  FilterSection(
                    title: 'Exercise Type',
                    options: widget.filters.types,
                    selectedValue: _selectedType,
                    onSelected: (value) =>
                        setState(() => _selectedType = value),
                  ),
                  const SizedBox(height: 20),
                  // Body Part filter
                  FilterSection(
                    title: 'Body Part',
                    options: widget.filters.bodyParts,
                    selectedValue: _selectedBodyPart,
                    onSelected: (value) =>
                        setState(() => _selectedBodyPart = value),
                  ),
                  const SizedBox(height: 20),
                  // Equipment filter
                  FilterSection(
                    title: 'Equipment',
                    options: widget.filters.equipments,
                    selectedValue: _selectedEquipment,
                    onSelected: (value) =>
                        setState(() => _selectedEquipment = value),
                  ),
                  const SizedBox(height: 20),
                  // Target Muscle filter
                  FilterSection(
                    title: 'Target Muscle',
                    options: widget.filters.targetMuscles,
                    selectedValue: _selectedTargetMuscle,
                    onSelected: (value) =>
                        setState(() => _selectedTargetMuscle = value),
                  ),
                  const SizedBox(height: 20),
                  // Difficulty filter
                  FilterSection(
                    title: 'Difficulty',
                    options: widget.filters.difficulties,
                    selectedValue: _selectedDifficulty,
                    onSelected: (value) =>
                        setState(() => _selectedDifficulty = value),
                  ),
                  const SizedBox(height: 20),
                  // Sort options
                  _buildSortSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Apply button
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply({
                        'type': _selectedType,
                        'bodyPart': _selectedBodyPart,
                        'equipment': _selectedEquipment,
                        'targetMuscle': _selectedTargetMuscle,
                        'difficulty': _selectedDifficulty,
                        'sortBy': _sortBy,
                        'sortOrder': _sortOrder,
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColor.primary,
                      foregroundColor: TColor.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      _activeFilterCount > 0
                          ? 'Apply Filters ($_activeFilterCount)'
                          : 'Apply Filters',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    const sortOptions = [
      FilterOptionModel(value: 'name', label: 'Name'),
      FilterOptionModel(value: 'difficulty', label: 'Difficulty'),
      FilterOptionModel(value: 'type', label: 'Type'),
      FilterOptionModel(value: 'createdAt', label: 'Latest'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Sort By',
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: sortOptions.map((option) {
              final isSelected = _sortBy == option.value;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_sortBy == option.value) {
                        // Toggle sort order
                        _sortOrder = _sortOrder == 'asc' ? 'desc' : 'asc';
                      } else {
                        _sortBy = option.value;
                        _sortOrder = 'asc';
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: TColor.primaryG,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                          : null,
                      color: isSelected ? null : TColor.lightGray,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          option.displayName,
                          style: TextStyle(
                            color: isSelected ? TColor.white : TColor.gray,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 4),
                          Icon(
                            _sortOrder == 'asc'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: TColor.white,
                            size: 14,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Search bar for exercises
class ExerciseSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final int? filterCount;
  final String hintText;

  const ExerciseSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onFilterTap,
    this.filterCount,
    this.hintText = 'Search exercises...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: TColor.gray),
                  prefixIcon: Icon(Icons.search, color: TColor.gray),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: TColor.gray),
                          onPressed: () {
                            controller.clear();
                            onChanged?.call('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          if (onFilterTap != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onFilterTap,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: TColor.primaryG,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Icon(Icons.tune, color: TColor.white, size: 22),
                    if (filterCount != null && filterCount! > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            filterCount.toString(),
                            style: TextStyle(
                              color: TColor.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
