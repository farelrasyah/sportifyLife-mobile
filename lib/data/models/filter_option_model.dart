import 'package:equatable/equatable.dart';

/// Filter Option Model
/// Represents a selectable filter option (e.g., body parts, equipment types)
class FilterOptionModel extends Equatable {
  final String id;
  final String name;
  final String? icon;
  final bool isSelected;

  const FilterOptionModel({
    required this.id,
    required this.name,
    this.icon,
    this.isSelected = false,
  });

  /// Create from JSON
  factory FilterOptionModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString(),
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon, 'isSelected': isSelected};
  }

  /// Copy with modifications
  FilterOptionModel copyWith({
    String? id,
    String? name,
    String? icon,
    bool? isSelected,
  }) {
    return FilterOptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, isSelected];
}
