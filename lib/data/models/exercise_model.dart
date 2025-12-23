import 'package:equatable/equatable.dart';

/// Exercise Instruction Model
class ExerciseInstructionModel extends Equatable {
  final String id;
  final int stepNumber;
  final String instruction;
  final int? sets;
  final int? reps;
  final int? duration;
  final int? restTime;

  const ExerciseInstructionModel({
    required this.id,
    required this.stepNumber,
    required this.instruction,
    this.sets,
    this.reps,
    this.duration,
    this.restTime,
  });

  factory ExerciseInstructionModel.fromJson(Map<String, dynamic> json) {
    return ExerciseInstructionModel(
      id: json['id'] as String? ?? '',
      stepNumber: json['stepNumber'] as int? ?? 0,
      instruction: json['instruction'] as String? ?? '',
      sets: json['sets'] as int?,
      reps: json['reps'] as int?,
      duration: json['duration'] as int?,
      restTime: json['restTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stepNumber': stepNumber,
      'instruction': instruction,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'restTime': restTime,
    };
  }

  @override
  List<Object?> get props => [
    id,
    stepNumber,
    instruction,
    sets,
    reps,
    duration,
    restTime,
  ];
}

/// Exercise Tip Model
class ExerciseTipModel extends Equatable {
  final String id;
  final String tip;
  final bool isImportant;

  const ExerciseTipModel({
    required this.id,
    required this.tip,
    this.isImportant = false,
  });

  factory ExerciseTipModel.fromJson(Map<String, dynamic> json) {
    return ExerciseTipModel(
      id: json['id'] as String? ?? '',
      tip: json['tip'] as String? ?? '',
      isImportant: json['isImportant'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'tip': tip, 'isImportant': isImportant};
  }

  @override
  List<Object?> get props => [id, tip, isImportant];
}

/// Exercise Variation Model
class ExerciseVariationModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? difficulty;

  const ExerciseVariationModel({
    required this.id,
    required this.name,
    required this.description,
    this.difficulty,
  });

  factory ExerciseVariationModel.fromJson(Map<String, dynamic> json) {
    return ExerciseVariationModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
    };
  }

  @override
  List<Object?> get props => [id, name, description, difficulty];
}

/// Main Exercise Model
class ExerciseModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String type;
  final String bodyPart;
  final String equipment;
  final String targetMuscle;
  final String difficulty;
  final List<ExerciseInstructionModel> instructions;
  final List<ExerciseTipModel> tips;
  final List<ExerciseVariationModel> variations;
  final List<String> images;
  final List<String> videos;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.bodyPart,
    required this.equipment,
    required this.targetMuscle,
    required this.difficulty,
    required this.instructions,
    required this.tips,
    required this.variations,
    required this.images,
    required this.videos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? '',
      bodyPart: json['bodyPart'] as String? ?? '',
      equipment: json['equipment'] as String? ?? '',
      targetMuscle: json['targetMuscle'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map(
                (e) => ExerciseInstructionModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      tips:
          (json['tips'] as List<dynamic>?)
              ?.map((e) => ExerciseTipModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      variations:
          (json['variations'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ExerciseVariationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      videos:
          (json['videos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'bodyPart': bodyPart,
      'equipment': equipment,
      'targetMuscle': targetMuscle,
      'difficulty': difficulty,
      'instructions': instructions.map((e) => e.toJson()).toList(),
      'tips': tips.map((e) => e.toJson()).toList(),
      'variations': variations.map((e) => e.toJson()).toList(),
      'images': images,
      'videos': videos,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Get first image or placeholder
  String get primaryImage => images.isNotEmpty ? images.first : '';

  /// Get first video or empty
  String get primaryVideo => videos.isNotEmpty ? videos.first : '';

  /// Get difficulty color
  String get difficultyLabel {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return difficulty;
    }
  }

  /// Get formatted body part label
  String get bodyPartLabel {
    return bodyPart
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Get formatted equipment label
  String get equipmentLabel {
    return equipment
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Copy with method
  ExerciseModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? bodyPart,
    String? equipment,
    String? targetMuscle,
    String? difficulty,
    List<ExerciseInstructionModel>? instructions,
    List<ExerciseTipModel>? tips,
    List<ExerciseVariationModel>? variations,
    List<String>? images,
    List<String>? videos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      bodyPart: bodyPart ?? this.bodyPart,
      equipment: equipment ?? this.equipment,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      difficulty: difficulty ?? this.difficulty,
      instructions: instructions ?? this.instructions,
      tips: tips ?? this.tips,
      variations: variations ?? this.variations,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    type,
    bodyPart,
    equipment,
    targetMuscle,
    difficulty,
    instructions,
    tips,
    variations,
    images,
    videos,
    createdAt,
    updatedAt,
  ];
}

/// Pagination Info Model
class PaginationModel extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrev: json['hasPrev'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrev': hasPrev,
    };
  }

  @override
  List<Object?> get props => [page, limit, total, totalPages, hasNext, hasPrev];
}

/// Filter Option Model
class FilterOptionModel extends Equatable {
  final String value;
  final String label;
  final String? description;

  const FilterOptionModel({
    required this.value,
    required this.label,
    this.description,
  });

  factory FilterOptionModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionModel(
      value: json['value'] as String? ?? '',
      label: json['label'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'label': label, 'description': description};
  }

  @override
  List<Object?> get props => [value, label, description];
}

/// Exercise Filters Model
class ExerciseFiltersModel extends Equatable {
  final Map<String, dynamic> applied;
  final List<FilterOptionModel> types;
  final List<FilterOptionModel> bodyParts;
  final List<FilterOptionModel> equipments;
  final List<FilterOptionModel> targetMuscles;
  final List<FilterOptionModel> difficulties;

  const ExerciseFiltersModel({
    required this.applied,
    required this.types,
    required this.bodyParts,
    required this.equipments,
    required this.targetMuscles,
    required this.difficulties,
  });

  factory ExerciseFiltersModel.fromJson(Map<String, dynamic> json) {
    final available = json['available'] as Map<String, dynamic>? ?? {};
    return ExerciseFiltersModel(
      applied: json['applied'] as Map<String, dynamic>? ?? {},
      types:
          (available['types'] as List<dynamic>?)
              ?.map(
                (e) => FilterOptionModel.fromJson(
                  e is String
                      ? {'value': e, 'label': e}
                      : e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      bodyParts:
          (available['bodyParts'] as List<dynamic>?)
              ?.map(
                (e) => FilterOptionModel.fromJson(
                  e is String
                      ? {'value': e, 'label': e}
                      : e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      equipments:
          (available['equipments'] as List<dynamic>?)
              ?.map(
                (e) => FilterOptionModel.fromJson(
                  e is String
                      ? {'value': e, 'label': e}
                      : e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      targetMuscles:
          (available['targetMuscles'] as List<dynamic>?)
              ?.map(
                (e) => FilterOptionModel.fromJson(
                  e is String
                      ? {'value': e, 'label': e}
                      : e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      difficulties:
          (available['difficulties'] as List<dynamic>?)
              ?.map(
                (e) => FilterOptionModel.fromJson(
                  e is String
                      ? {'value': e, 'label': e}
                      : e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  factory ExerciseFiltersModel.empty() {
    return const ExerciseFiltersModel(
      applied: {},
      types: [],
      bodyParts: [],
      equipments: [],
      targetMuscles: [],
      difficulties: [],
    );
  }

  @override
  List<Object?> get props => [
    applied,
    types,
    bodyParts,
    equipments,
    targetMuscles,
    difficulties,
  ];
}

/// Exercise List Response Model
class ExerciseListResponseModel extends Equatable {
  final List<ExerciseModel> data;
  final PaginationModel pagination;
  final ExerciseFiltersModel filters;

  const ExerciseListResponseModel({
    required this.data,
    required this.pagination,
    required this.filters,
  });

  factory ExerciseListResponseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseListResponseModel(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>)
          : const PaginationModel(
              page: 1,
              limit: 20,
              total: 0,
              totalPages: 0,
              hasNext: false,
              hasPrev: false,
            ),
      filters: json['filters'] != null
          ? ExerciseFiltersModel.fromJson(
              json['filters'] as Map<String, dynamic>,
            )
          : ExerciseFiltersModel.empty(),
    );
  }

  @override
  List<Object?> get props => [data, pagination, filters];
}

/// Exercise Query Parameters
class ExerciseQueryParams extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final String? type;
  final String? bodyPart;
  final String? equipment;
  final String? targetMuscle;
  final String? difficulty;
  final String? sortBy;
  final String? sortOrder;

  const ExerciseQueryParams({
    this.page = 1,
    this.limit = 20,
    this.search,
    this.type,
    this.bodyPart,
    this.equipment,
    this.targetMuscle,
    this.difficulty,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toQueryMap() {
    final map = <String, dynamic>{'page': page, 'limit': limit};

    if (search != null && search!.isNotEmpty) map['search'] = search;
    if (type != null && type!.isNotEmpty) map['type'] = type;
    if (bodyPart != null && bodyPart!.isNotEmpty) map['bodyPart'] = bodyPart;
    if (equipment != null && equipment!.isNotEmpty)
      map['equipment'] = equipment;
    if (targetMuscle != null && targetMuscle!.isNotEmpty)
      map['targetMuscle'] = targetMuscle;
    if (difficulty != null && difficulty!.isNotEmpty)
      map['difficulty'] = difficulty;
    if (sortBy != null && sortBy!.isNotEmpty) map['sortBy'] = sortBy;
    if (sortOrder != null && sortOrder!.isNotEmpty)
      map['sortOrder'] = sortOrder;

    return map;
  }

  ExerciseQueryParams copyWith({
    int? page,
    int? limit,
    String? search,
    String? type,
    String? bodyPart,
    String? equipment,
    String? targetMuscle,
    String? difficulty,
    String? sortBy,
    String? sortOrder,
  }) {
    return ExerciseQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      type: type ?? this.type,
      bodyPart: bodyPart ?? this.bodyPart,
      equipment: equipment ?? this.equipment,
      targetMuscle: targetMuscle ?? this.targetMuscle,
      difficulty: difficulty ?? this.difficulty,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  /// Reset all filters
  ExerciseQueryParams resetFilters() {
    return ExerciseQueryParams(
      page: 1,
      limit: limit,
      search: null,
      type: null,
      bodyPart: null,
      equipment: null,
      targetMuscle: null,
      difficulty: null,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  /// Check if any filter is applied
  bool get hasFilters =>
      (search != null && search!.isNotEmpty) ||
      (type != null && type!.isNotEmpty) ||
      (bodyPart != null && bodyPart!.isNotEmpty) ||
      (equipment != null && equipment!.isNotEmpty) ||
      (targetMuscle != null && targetMuscle!.isNotEmpty) ||
      (difficulty != null && difficulty!.isNotEmpty);

  /// Get count of active filters
  int get activeFilterCount {
    int count = 0;
    if (type != null && type!.isNotEmpty) count++;
    if (bodyPart != null && bodyPart!.isNotEmpty) count++;
    if (equipment != null && equipment!.isNotEmpty) count++;
    if (targetMuscle != null && targetMuscle!.isNotEmpty) count++;
    if (difficulty != null && difficulty!.isNotEmpty) count++;
    return count;
  }

  @override
  List<Object?> get props => [
    page,
    limit,
    search,
    type,
    bodyPart,
    equipment,
    targetMuscle,
    difficulty,
    sortBy,
    sortOrder,
  ];
}
