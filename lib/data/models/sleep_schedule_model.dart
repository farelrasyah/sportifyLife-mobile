import 'package:equatable/equatable.dart';

/// Sleep Schedule Model for API responses
class SleepScheduleModel extends Equatable {
  final String id;
  final String bedtime;
  final double sleepHours;
  final String wakeTime;
  final List<String> repeatDays;
  final bool isVibrate;
  final String alarmSound;
  final bool isActive;
  final bool alarmEnabled;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SleepScheduleModel({
    required this.id,
    required this.bedtime,
    required this.sleepHours,
    required this.wakeTime,
    required this.repeatDays,
    required this.isVibrate,
    required this.alarmSound,
    required this.isActive,
    required this.alarmEnabled,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SleepScheduleModel.fromJson(Map<String, dynamic> json) {
    return SleepScheduleModel(
      id: json['id'] as String,
      bedtime: json['bedtime'] as String,
      sleepHours: (json['sleepHours'] as num).toDouble(),
      wakeTime: json['wakeTime'] as String,
      repeatDays: List<String>.from(json['repeatDays'] as List),
      isVibrate: json['isVibrate'] as bool,
      alarmSound: json['alarmSound'] as String,
      isActive: json['isActive'] as bool,
      alarmEnabled: json['alarmEnabled'] as bool,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bedtime': bedtime,
      'sleepHours': sleepHours,
      'wakeTime': wakeTime,
      'repeatDays': repeatDays,
      'isVibrate': isVibrate,
      'alarmSound': alarmSound,
      'isActive': isActive,
      'alarmEnabled': alarmEnabled,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SleepScheduleModel copyWith({
    String? id,
    String? bedtime,
    double? sleepHours,
    String? wakeTime,
    List<String>? repeatDays,
    bool? isVibrate,
    String? alarmSound,
    bool? isActive,
    bool? alarmEnabled,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SleepScheduleModel(
      id: id ?? this.id,
      bedtime: bedtime ?? this.bedtime,
      sleepHours: sleepHours ?? this.sleepHours,
      wakeTime: wakeTime ?? this.wakeTime,
      repeatDays: repeatDays ?? this.repeatDays,
      isVibrate: isVibrate ?? this.isVibrate,
      alarmSound: alarmSound ?? this.alarmSound,
      isActive: isActive ?? this.isActive,
      alarmEnabled: alarmEnabled ?? this.alarmEnabled,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get formatted sleep duration as "8h 30m"
  String get formattedSleepDuration {
    final hours = sleepHours.floor();
    final minutes = ((sleepHours - hours) * 60).round();

    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  /// Get formatted bedtime as "09:00 PM"
  String get formattedBedtime {
    try {
      final timeParts = bedtime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return bedtime;
    }
  }

  /// Get formatted wake time as "05:30 AM"
  String get formattedWakeTime {
    try {
      final timeParts = wakeTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return wakeTime;
    }
  }

  /// Get short repeat days format "Mon to Fri" or "Weekdays" etc
  String get formattedRepeatDays {
    if (repeatDays.length == 7) {
      return 'Every day';
    }

    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final weekends = ['Saturday', 'Sunday'];

    if (repeatDays.length == 5 &&
        weekdays.every((day) => repeatDays.contains(day))) {
      return 'Weekdays';
    }

    if (repeatDays.length == 2 &&
        weekends.every((day) => repeatDays.contains(day))) {
      return 'Weekends';
    }

    if (repeatDays.length == 1) {
      return _getShortDay(repeatDays.first);
    }

    return repeatDays.map((day) => _getShortDay(day)).join(', ');
  }

  String _getShortDay(String day) {
    switch (day.toLowerCase()) {
      case 'sunday':
        return 'Sun';
      case 'monday':
        return 'Mon';
      case 'tuesday':
        return 'Tue';
      case 'wednesday':
        return 'Wed';
      case 'thursday':
        return 'Thu';
      case 'friday':
        return 'Fri';
      case 'saturday':
        return 'Sat';
      default:
        return day;
    }
  }

  @override
  List<Object?> get props => [
    id,
    bedtime,
    sleepHours,
    wakeTime,
    repeatDays,
    isVibrate,
    alarmSound,
    isActive,
    alarmEnabled,
    notes,
    createdAt,
    updatedAt,
  ];
}

/// Create Sleep Schedule Request Model
class CreateSleepScheduleRequest {
  final String bedtime;
  final double sleepHours;
  final List<String> repeatDays;
  final bool isVibrate;
  final String alarmSound;
  final bool alarmEnabled;
  final String? notes;

  const CreateSleepScheduleRequest({
    required this.bedtime,
    required this.sleepHours,
    required this.repeatDays,
    this.isVibrate = true,
    this.alarmSound = 'default',
    this.alarmEnabled = true,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'bedtime': bedtime,
      'sleepHours': sleepHours,
      'repeatDays': repeatDays,
      'isVibrate': isVibrate,
      'alarmSound': alarmSound,
      'alarmEnabled': alarmEnabled,
      'notes': notes,
    };
  }
}

/// Update Sleep Schedule Request Model
class UpdateSleepScheduleRequest {
  final String? bedtime;
  final double? sleepHours;
  final List<String>? repeatDays;
  final bool? isVibrate;
  final String? alarmSound;
  final bool? isActive;
  final bool? alarmEnabled;
  final String? notes;

  const UpdateSleepScheduleRequest({
    this.bedtime,
    this.sleepHours,
    this.repeatDays,
    this.isVibrate,
    this.alarmSound,
    this.isActive,
    this.alarmEnabled,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bedtime != null) map['bedtime'] = bedtime;
    if (sleepHours != null) map['sleepHours'] = sleepHours;
    if (repeatDays != null) map['repeatDays'] = repeatDays;
    if (isVibrate != null) map['isVibrate'] = isVibrate;
    if (alarmSound != null) map['alarmSound'] = alarmSound;
    if (isActive != null) map['isActive'] = isActive;
    if (alarmEnabled != null) map['alarmEnabled'] = alarmEnabled;
    if (notes != null) map['notes'] = notes;
    return map;
  }
}

/// Enum for alarm sound types
enum AlarmSoundType {
  defaultSound('default'),
  gentle('gentle'),
  nature('nature'),
  classical('classical'),
  vibrationOnly('vibration_only');

  const AlarmSoundType(this.value);
  final String value;

  static AlarmSoundType fromString(String value) {
    return AlarmSoundType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => AlarmSoundType.defaultSound,
    );
  }
}

/// Enum for days of week
enum DayOfWeek {
  sunday('Sunday'),
  monday('Monday'),
  tuesday('Tuesday'),
  wednesday('Wednesday'),
  thursday('Thursday'),
  friday('Friday'),
  saturday('Saturday');

  const DayOfWeek(this.value);
  final String value;

  static DayOfWeek fromString(String value) {
    return DayOfWeek.values.firstWhere(
      (day) => day.value == value,
      orElse: () => DayOfWeek.monday,
    );
  }

  static List<String> get weekdays => [
    DayOfWeek.monday.value,
    DayOfWeek.tuesday.value,
    DayOfWeek.wednesday.value,
    DayOfWeek.thursday.value,
    DayOfWeek.friday.value,
  ];

  static List<String> get weekends => [
    DayOfWeek.saturday.value,
    DayOfWeek.sunday.value,
  ];

  static List<String> get allDays =>
      DayOfWeek.values.map((day) => day.value).toList();
}
