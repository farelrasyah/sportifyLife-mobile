/// Goal Type enum for fitness goals
/// Backend allowed values: improve_shape, lean_tone, lose_fat
enum GoalType {
  /// Improve overall body shape and fitness
  improveShape(
    'improve_shape',
    'Improve Shape',
    'Build a better overall physique',
  ),

  /// Get lean and toned body
  leanTone('lean_tone', 'Lean & Tone', 'Build lean muscle and definition'),

  /// Lose body fat
  loseFat('lose_fat', 'Lose Fat', 'Reduce body fat percentage');

  const GoalType(this.value, this.label, this.description);

  /// Backend value (API request)
  final String value;

  /// User-friendly label (UI display)
  final String label;

  /// Goal description
  final String description;

  /// Convert backend value to enum
  static GoalType? fromValue(String? value) {
    if (value == null) return null;
    try {
      return GoalType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }

  /// Get all goal types as list of maps (for UI)
  static List<Map<String, String>> get options {
    return GoalType.values
        .map(
          (goal) => {
            'value': goal.value,
            'label': goal.label,
            'description': goal.description,
          },
        )
        .toList();
  }

  /// Validate if a value is allowed
  static bool isValid(String? value) {
    if (value == null || value.isEmpty) return false;
    return GoalType.values.any((goal) => goal.value == value);
  }

  /// Get allowed values as list (for validation)
  static List<String> get allowedValues {
    return GoalType.values.map((goal) => goal.value).toList();
  }
}

/// Gender enum
enum Gender {
  male('male', 'Male'),
  female('female', 'Female'),
  other('other', 'Other');

  const Gender(this.value, this.label);

  final String value;
  final String label;

  static Gender? fromValue(String? value) {
    if (value == null) return null;
    try {
      return Gender.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }

  static List<Map<String, String>> get options {
    return Gender.values
        .map((gender) => {'value': gender.value, 'label': gender.label})
        .toList();
  }
}
