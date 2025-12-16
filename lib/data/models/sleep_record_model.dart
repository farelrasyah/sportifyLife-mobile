import 'package:equatable/equatable.dart';
import 'sleep_schedule_model.dart';

/// Sleep Record Summary Model for API responses
class SleepRecordSummaryModel extends Equatable {
  final String id;
  final DateTime sleepTime;
  final DateTime wakeTime;
  final int durationMinutes;
  final int qualityRating;
  final String? notes;
  final DateTime createdAt;

  const SleepRecordSummaryModel({
    required this.id,
    required this.sleepTime,
    required this.wakeTime,
    required this.durationMinutes,
    required this.qualityRating,
    this.notes,
    required this.createdAt,
  });

  factory SleepRecordSummaryModel.fromJson(Map<String, dynamic> json) {
    return SleepRecordSummaryModel(
      id: json['id'] as String,
      sleepTime: DateTime.parse(json['sleepTime'] as String),
      wakeTime: DateTime.parse(json['wakeTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      qualityRating: json['qualityRating'] as int,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Get formatted duration as "8h 20m"
  String get formattedDuration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  /// Get sleep quality description
  String get qualityDescription {
    switch (qualityRating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Unknown';
    }
  }

  @override
  List<Object?> get props => [
        id,
        sleepTime,
        wakeTime,
        durationMinutes,
        qualityRating,
        notes,
        createdAt,
      ];
}

/// Sleep Calendar Data Model for API responses
class SleepCalendarDataModel extends Equatable {
  final String date;
  final int totalSleepDuration;
  final double averageQuality;
  final List<SleepRecordSummaryModel> sleepRecords;
  final List<SleepScheduleModel> activeSchedules;
  final bool hasAlarm;
  final String? nextAlarmTime;

  const SleepCalendarDataModel({
    required this.date,
    required this.totalSleepDuration,
    required this.averageQuality,
    required this.sleepRecords,
    required this.activeSchedules,
    required this.hasAlarm,
    this.nextAlarmTime,
  });

  factory SleepCalendarDataModel.fromJson(Map<String, dynamic> json) {
    return SleepCalendarDataModel(
      date: json['date'] as String,
      totalSleepDuration: json['totalSleepDuration'] as int,
      averageQuality: (json['averageQuality'] as num).toDouble(),
      sleepRecords: (json['sleepRecords'] as List<dynamic>)
          .map((record) => SleepRecordSummaryModel.fromJson(record as Map<String, dynamic>))
          .toList(),
      activeSchedules: (json['activeSchedules'] as List<dynamic>)
          .map((schedule) => SleepScheduleModel.fromJson(schedule as Map<String, dynamic>))
          .toList(),
      hasAlarm: json['hasAlarm'] as bool,
      nextAlarmTime: json['nextAlarmTime'] as String?,
    );
  }

  /// Get formatted total sleep duration as "8h 20m"
  String get formattedTotalDuration {
    final hours = totalSleepDuration ~/ 60;
    final minutes = totalSleepDuration % 60;
    
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  /// Get formatted next alarm time as "09:00 PM"
  String? get formattedNextAlarmTime {
    if (nextAlarmTime == null) return null;
    
    try {
      final timeParts = nextAlarmTime!.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      
      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return nextAlarmTime;
    }
  }

  @override
  List<Object?> get props => [
        date,
        totalSleepDuration,
        averageQuality,
        sleepRecords,
        activeSchedules,
        hasAlarm,
        nextAlarmTime,
      ];
}

/// Sleep Daily Summary Model for API responses
class SleepDailySummaryModel extends Equatable {
  final String date;
  final int totalSleepTime;
  final DateTime? bedtimeActual;
  final DateTime? wakeTimeActual;
  final double? averageQuality;
  final List<SleepRecordSummaryModel> records;
  final String? scheduledBedtime;
  final String? scheduledWakeTime;
  final bool adherenceToSchedule;

  const SleepDailySummaryModel({
    required this.date,
    required this.totalSleepTime,
    this.bedtimeActual,
    this.wakeTimeActual,
    this.averageQuality,
    required this.records,
    this.scheduledBedtime,
    this.scheduledWakeTime,
    required this.adherenceToSchedule,
  });

  factory SleepDailySummaryModel.fromJson(Map<String, dynamic> json) {
    return SleepDailySummaryModel(
      date: json['date'] as String,
      totalSleepTime: json['totalSleepTime'] as int,
      bedtimeActual: json['bedtimeActual'] != null 
          ? DateTime.parse(json['bedtimeActual'] as String)
          : null,
      wakeTimeActual: json['wakeTimeActual'] != null
          ? DateTime.parse(json['wakeTimeActual'] as String)
          : null,
      averageQuality: json['averageQuality'] != null
          ? (json['averageQuality'] as num).toDouble()
          : null,
      records: (json['records'] as List<dynamic>)
          .map((record) => SleepRecordSummaryModel.fromJson(record as Map<String, dynamic>))
          .toList(),
      scheduledBedtime: json['scheduledBedtime'] as String?,
      scheduledWakeTime: json['scheduledWakeTime'] as String?,
      adherenceToSchedule: json['adherenceToSchedule'] as bool,
    );
  }

  /// Get formatted total sleep time as "8h 20m"
  String get formattedTotalSleepTime {
    final hours = totalSleepTime ~/ 60;
    final minutes = totalSleepTime % 60;
    
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }

  /// Get adherence status text
  String get adherenceStatusText {
    return adherenceToSchedule ? 'On Schedule' : 'Off Schedule';
  }

  /// Get adherence progress percentage (0.0 to 1.0)
  double get adherenceProgress {
    return adherenceToSchedule ? 1.0 : 0.5;
  }

  @override
  List<Object?> get props => [
        date,
        totalSleepTime,
        bedtimeActual,
        wakeTimeActual,
        averageQuality,
        records,
        scheduledBedtime,
        scheduledWakeTime,
        adherenceToSchedule,
      ];
}

