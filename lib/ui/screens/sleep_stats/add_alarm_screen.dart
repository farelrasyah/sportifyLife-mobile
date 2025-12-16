import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/colo_extension.dart';
import '../../../common/common.dart';
import '../../../data/models/sleep_schedule_model.dart';
import '../../../cubits/sleep_schedule_cubit.dart';
import '../../../cubits/sleep_schedule_state.dart';
import '../../widgets/icon_title_next_row.dart';
import '../../widgets/round_button.dart';
import '../../widgets/custom_modern_appbar.dart';

class AddAlarmScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddAlarmScreen({super.key, required this.selectedDate});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen>
    with TickerProviderStateMixin {
  bool _isVibrateEnabled = false;
  late AnimationController _fabAnimationController;

  // Form state variables
  String _selectedBedtime = "21:00";
  double _selectedSleepHours = 8.0;
  List<String> _selectedRepeatDays = DayOfWeek.weekdays;
  String _selectedAlarmSound = AlarmSoundType.defaultSound.value;
  bool _alarmEnabled = true;
  String? _notes;

  // Controllers
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BlocListener<SleepScheduleCubit, SleepScheduleState>(
      listener: (context, state) {
        if (state is SleepScheduleCreated) {
          _showSuccessSnackBar('Sleep schedule created successfully!');
          Navigator.pop(context, state.schedule);
        } else if (state is SleepScheduleError) {
          _showErrorSnackBar(state.message);
        }
      },
      child: Scaffold(
        appBar: CustomModernAppBar(
          title: "Add Alarm",
          icon: Icons.alarm_add,
          fabAnimationController: _fabAnimationController,
          primaryColor: TColor.primaryColor1,
          lightColor: TColor.primaryColor2,
          onBackPressed: () => Navigator.pop(context),
        ),
        backgroundColor: TColor.white,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildBedtimeRow(),
              const SizedBox(height: 10),
              _buildSleepHoursRow(),
              const SizedBox(height: 10),
              _buildRepeatDaysRow(),
              const SizedBox(height: 10),
              _buildVibrateToggleSection(),
              const SizedBox(height: 10),
              _buildAlarmSoundRow(),
              const SizedBox(height: 10),
              _buildNotesSection(),
              const Spacer(),
              _buildAddButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlarmSettingRow({
    required String icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return IconTitleNextRow(
      icon: icon,
      title: title,
      time: value,
      color: TColor.lightGray,
      onPressed: onTap,
    );
  }

  Widget _buildVibrateToggleSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 15),
          _buildVibrateIcon(),
          const SizedBox(width: 8),
          _buildVibrateLabel(),
          _buildCustomToggleSwitch(),
        ],
      ),
    );
  }

  Widget _buildVibrateIcon() {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      child: Image.asset(
        "assets/images/Vibrate.png",
        width: 18,
        height: 18,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildVibrateLabel() {
    return Expanded(
      child: Text(
        "Vibrate When Alarm Sound",
        style: TextStyle(color: TColor.gray, fontSize: 12),
      ),
    );
  }

  Widget _buildCustomToggleSwitch() {
    return SizedBox(
      height: 30,
      child: Transform.scale(
        scale: 0.7,
        child: CustomAnimatedToggleSwitch<bool>(
          current: _isVibrateEnabled,
          values: [false, true],
          indicatorSize: const Size.square(30.0),
          animationDuration: const Duration(milliseconds: 200),
          animationCurve: Curves.linear,
          onChanged: (value) => setState(() => _isVibrateEnabled = value),
          iconBuilder: (context, local, global) {
            return const SizedBox();
          },
          onTap: (value) =>
              setState(() => _isVibrateEnabled = !_isVibrateEnabled),
          iconsTappable: false,
          wrapperBuilder: (context, global, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 10.0,
                  right: 10.0,
                  height: 30.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.secondaryG),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                child,
              ],
            );
          },
          foregroundIndicatorBuilder: (context, global) {
            return SizedBox.fromSize(
              size: const Size(10, 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: TColor.white,
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      spreadRadius: 0.05,
                      blurRadius: 1.1,
                      offset: Offset(0.0, 0.8),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return BlocBuilder<SleepScheduleCubit, SleepScheduleState>(
      builder: (context, state) {
        final isLoading = state is SleepScheduleCreating;

        return RoundButton(
          title: isLoading ? "Creating..." : "Add",
          onPressed: isLoading ? () {} : _createSleepSchedule,
        );
      },
    );
  }

  // New helper methods
  Widget _buildBedtimeRow() {
    final formattedTime = _formatTime(_selectedBedtime);
    return _buildAlarmSettingRow(
      icon: "assets/images/Bed_Add.png",
      title: "Bedtime",
      value: formattedTime,
      onTap: _showBedtimePicker,
    );
  }

  Widget _buildSleepHoursRow() {
    final hours = _selectedSleepHours.floor();
    final minutes = ((_selectedSleepHours - hours) * 60).round();
    final formattedDuration = minutes > 0
        ? "${hours}h ${minutes}m"
        : "${hours}h";

    return _buildAlarmSettingRow(
      icon: "assets/images/HoursTime.png",
      title: "Hours of sleep",
      value: formattedDuration,
      onTap: _showSleepDurationPicker,
    );
  }

  Widget _buildRepeatDaysRow() {
    String formattedDays;
    if (_selectedRepeatDays.length == 7) {
      formattedDays = "Every day";
    } else if (_selectedRepeatDays.length == 5 &&
        DayOfWeek.weekdays.every((day) => _selectedRepeatDays.contains(day))) {
      formattedDays = "Weekdays";
    } else if (_selectedRepeatDays.length == 2 &&
        DayOfWeek.weekends.every((day) => _selectedRepeatDays.contains(day))) {
      formattedDays = "Weekends";
    } else {
      formattedDays = _selectedRepeatDays
          .map((day) => _getAbbreviatedDay(day))
          .join(", ");
    }

    return _buildAlarmSettingRow(
      icon: "assets/images/Repeat.png",
      title: "Repeat",
      value: formattedDays,
      onTap: _showRepeatDaysPicker,
    );
  }

  Widget _buildAlarmSoundRow() {
    String soundName;
    switch (AlarmSoundType.fromString(_selectedAlarmSound)) {
      case AlarmSoundType.defaultSound:
        soundName = "Default";
        break;
      case AlarmSoundType.gentle:
        soundName = "Gentle";
        break;
      case AlarmSoundType.nature:
        soundName = "Nature";
        break;
      case AlarmSoundType.classical:
        soundName = "Classical";
        break;
      case AlarmSoundType.vibrationOnly:
        soundName = "Vibration Only";
        break;
    }

    return _buildAlarmSettingRow(
      icon: "assets/images/Sound.png",
      title: "Alarm Sound",
      value: soundName,
      onTap: _showAlarmSoundPicker,
    );
  }

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notes (Optional)",
            style: TextStyle(
              color: TColor.gray,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Add any notes about this sleep schedule...",
              hintStyle: TextStyle(
                color: TColor.gray.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            style: TextStyle(color: TColor.black, fontSize: 12),
            onChanged: (value) {
              _notes = value.trim().isEmpty ? null : value.trim();
            },
          ),
        ],
      ),
    );
  }

  // Action methods
  void _showBedtimePicker() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(_selectedBedtime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: TColor.primaryColor1),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedBedtime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void _showSleepDurationPicker() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sleep Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hours: ${_selectedSleepHours.toStringAsFixed(1)}'),
            Slider(
              value: _selectedSleepHours,
              min: 1.0,
              max: 12.0,
              divisions: 22,
              label: '${_selectedSleepHours.toStringAsFixed(1)}h',
              activeColor: TColor.primaryColor1,
              onChanged: (value) {
                setState(() {
                  _selectedSleepHours = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showRepeatDaysPicker() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Repeat Days'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: DayOfWeek.allDays.map((day) {
                return CheckboxListTile(
                  title: Text(day),
                  value: _selectedRepeatDays.contains(day),
                  activeColor: TColor.primaryColor1,
                  onChanged: (bool? value) {
                    setDialogState(() {
                      if (value == true) {
                        if (!_selectedRepeatDays.contains(day)) {
                          _selectedRepeatDays.add(day);
                        }
                      } else {
                        _selectedRepeatDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showAlarmSoundPicker() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alarm Sound'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AlarmSoundType.values.map((soundType) {
            String soundName;
            switch (soundType) {
              case AlarmSoundType.defaultSound:
                soundName = "Default";
                break;
              case AlarmSoundType.gentle:
                soundName = "Gentle";
                break;
              case AlarmSoundType.nature:
                soundName = "Nature";
                break;
              case AlarmSoundType.classical:
                soundName = "Classical";
                break;
              case AlarmSoundType.vibrationOnly:
                soundName = "Vibration Only";
                break;
            }

            return RadioListTile<String>(
              title: Text(soundName),
              value: soundType.value,
              groupValue: _selectedAlarmSound,
              activeColor: TColor.primaryColor1,
              onChanged: (String? value) {
                setState(() {
                  _selectedAlarmSound = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _createSleepSchedule() {
    if (_selectedRepeatDays.isEmpty) {
      _showErrorSnackBar('Please select at least one repeat day');
      return;
    }

    // Check for conflicts
    final sleepScheduleCubit = context.read<SleepScheduleCubit>();
    final hasConflict = sleepScheduleCubit.hasConflictingSchedule(
      _selectedRepeatDays,
      _selectedBedtime,
      _selectedSleepHours,
    );

    if (hasConflict) {
      _showErrorSnackBar('Schedule conflicts with existing schedule');
      return;
    }

    // Use full day names for API with proper capitalization
    final apiRepeatDays = _selectedRepeatDays.map((day) {
      // Convert abbreviated days back to full names if needed
      switch (day.toLowerCase()) {
        case 'mon':
          return 'Monday';
        case 'tue':
          return 'Tuesday';
        case 'wed':
          return 'Wednesday';
        case 'thu':
          return 'Thursday';
        case 'fri':
          return 'Friday';
        case 'sat':
          return 'Saturday';
        case 'sun':
          return 'Sunday';
        default:
          // Already full name, ensure proper capitalization
          final dayLower = day.toLowerCase();
          return dayLower[0].toUpperCase() + dayLower.substring(1);
      }
    }).toList();

    // Create the schedule
    sleepScheduleCubit.createSleepSchedule(
      bedtime: _selectedBedtime,
      sleepHours: _selectedSleepHours, // Keep as double
      repeatDays: apiRepeatDays,
      isVibrate: _isVibrateEnabled,
      alarmSound: _selectedAlarmSound,
      alarmEnabled: _alarmEnabled,
      notes: _notes?.isNotEmpty == true ? _notes : null,
    );
  }

  // Helper methods
  String _formatTime(String time) {
    try {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time;
    }
  }

  TimeOfDay _parseTime(String time) {
    try {
      final timeParts = time.split(':');
      return TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    } catch (e) {
      return const TimeOfDay(hour: 21, minute: 0);
    }
  }

  String _getAbbreviatedDay(String fullDay) {
    switch (fullDay.toLowerCase()) {
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
        return fullDay;
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
