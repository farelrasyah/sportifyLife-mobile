import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../cubits/user_details_cubit.dart';
import '../../app/routes.dart';
import '../../config/goal_type.dart';
import '../../config/environment.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  Gender? _selectedGender;
  GoalType? _selectedGoalType;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 25); // Default to 25 years old

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - Environment.maxAge),
      lastDate: DateTime(now.year - Environment.minAge),
      helpText: tr('date_of_birth_picker_help'),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _completeProfile() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate required selections
    final validationErrors = <String>[];

    if (_selectedGender == null) {
      validationErrors.add(tr('validation_gender_required'));
    }

    if (_selectedDate == null) {
      validationErrors.add(tr('validation_date_of_birth_required'));
    }

    if (_selectedGoalType == null) {
      validationErrors.add(tr('validation_fitness_goal_required'));
    }

    // Show validation errors
    if (validationErrors.isNotEmpty) {
      _showError(validationErrors.join('\n'));
      return;
    }

    // Additional validations
    if (_selectedDate!.isAfter(DateTime.now())) {
      _showError(tr('validation_date_future'));
      return;
    }

    // Calculate age
    final age = _calculateAge(_selectedDate!);
    if (age < Environment.minAge) {
      _showError(
        tr(
          'validation_age_min',
        ).replaceAll('{age}', Environment.minAge.toString()),
      );
      return;
    }

    if (age > Environment.maxAge) {
      _showError(
        tr(
          'validation_age_max',
        ).replaceAll('{age}', Environment.maxAge.toString()),
      );
      return;
    }

    // Submit to backend
    context.read<UserDetailsCubit>().completeProfile(
      weight: double.parse(_weightController.text),
      height: int.parse(_heightController.text),
      gender: _selectedGender!,
      dateOfBirth: _selectedDate!,
      goalType: _selectedGoalType!,
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return tr('validation_weight_required');
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }

    if (weight < Environment.minWeight || weight > Environment.maxWeight) {
      return tr('validation_weight_range')
          .replaceAll('{min}', Environment.minWeight.toString())
          .replaceAll('{max}', Environment.maxWeight.toString());
    }

    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return tr('validation_height_required');
    }

    final height = int.tryParse(value);
    if (height == null) {
      return 'Please enter a valid number';
    }

    if (height < Environment.minHeight || height > Environment.maxHeight) {
      return tr('validation_height_range')
          .replaceAll('{min}', Environment.minHeight.toString())
          .replaceAll('{max}', Environment.maxHeight.toString());
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('complete_profile_title')),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<UserDetailsCubit, UserDetailsState>(
        listener: (context, state) {
          if (state is UserDetailsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pushReplacementNamed(Routes.homeScreen);
          } else if (state is UserDetailsError) {
            // Show detailed error message from backend
            _showError(state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is UserDetailsLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Icon(
                      Icons.person_add_alt_1,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      tr('complete_profile_title'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      tr('complete_profile_subtitle'),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Weight Field
                    TextFormField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: _validateWeight,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: tr('weight_label'),
                        hintText: tr('weight_hint'),
                        prefixIcon: const Icon(Icons.monitor_weight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText: tr('weight_helper')
                            .replaceAll(
                              '{min}',
                              Environment.minWeight.toString(),
                            )
                            .replaceAll(
                              '{max}',
                              Environment.maxWeight.toString(),
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Height Field
                    TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      validator: _validateHeight,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        labelText: tr('height_label'),
                        hintText: tr('height_hint'),
                        prefixIcon: const Icon(Icons.height),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText: tr('height_helper')
                            .replaceAll(
                              '{min}',
                              Environment.minHeight.toString(),
                            )
                            .replaceAll(
                              '{max}',
                              Environment.maxHeight.toString(),
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gender Dropdown
                    DropdownButtonFormField<Gender>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: tr('gender_label'),
                        prefixIcon: const Icon(Icons.wc),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText: tr('gender_helper'),
                      ),
                      items: Gender.values
                          .map(
                            (gender) => DropdownMenuItem<Gender>(
                              value: gender,
                              child: Text(gender.label),
                            ),
                          )
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                            },
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth
                    InkWell(
                      onTap: isLoading ? null : _selectDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: tr('date_of_birth_label'),
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          helperText: tr('date_of_birth_helper'),
                          enabled: !isLoading,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? DateFormat(
                                      'dd MMM yyyy',
                                    ).format(_selectedDate!)
                                  : tr('select_date_placeholder'),
                              style: TextStyle(
                                color: _selectedDate != null
                                    ? Colors.black
                                    : Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            if (_selectedDate != null)
                              Text(
                                '${_calculateAge(_selectedDate!)} ${tr('years_old_suffix')}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Goal Type Dropdown with proper mapping
                    DropdownButtonFormField<GoalType>(
                      value: _selectedGoalType,
                      decoration: InputDecoration(
                        labelText: 'Fitness Goal *',
                        prefixIcon: const Icon(Icons.flag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText: 'What is your primary fitness goal?',
                      ),
                      items: GoalType.values
                          .map(
                            (goal) => DropdownMenuItem<GoalType>(
                              value: goal,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    goal.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    goal.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _selectedGoalType = value;
                              });
                            },
                      isExpanded: true,
                    ),
                    const SizedBox(height: 8),

                    // Info text about required fields
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '* Required fields',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Complete Profile Button
                    ElevatedButton(
                      onPressed: isLoading ? null : _completeProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Complete Profile',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),

                    // Skip Button
                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(Routes.homeScreen);
                            },
                      child: const Text('Skip for now'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
