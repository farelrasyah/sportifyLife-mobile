import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../cubits/userDetailsCubit.dart';
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
      helpText: 'Select your date of birth',
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
      validationErrors.add('Please select your gender');
    }

    if (_selectedDate == null) {
      validationErrors.add('Please select your date of birth');
    }

    if (_selectedGoalType == null) {
      validationErrors.add('Please select your fitness goal');
    }

    // Show validation errors
    if (validationErrors.isNotEmpty) {
      _showError(validationErrors.join('\n'));
      return;
    }

    // Additional validations
    if (_selectedDate!.isAfter(DateTime.now())) {
      _showError('Date of birth cannot be in the future');
      return;
    }

    // Calculate age
    final age = _calculateAge(_selectedDate!);
    if (age < Environment.minAge) {
      _showError('You must be at least ${Environment.minAge} years old');
      return;
    }

    if (age > Environment.maxAge) {
      _showError('Age must be less than ${Environment.maxAge} years');
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
      return 'Weight is required';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid number';
    }

    if (weight < Environment.minWeight || weight > Environment.maxWeight) {
      return 'Weight must be between ${Environment.minWeight} and ${Environment.maxWeight} kg';
    }

    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    }

    final height = int.tryParse(value);
    if (height == null) {
      return 'Please enter a valid number';
    }

    if (height < Environment.minHeight || height > Environment.maxHeight) {
      return 'Height must be between ${Environment.minHeight} and ${Environment.maxHeight} cm';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
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
                    const Text(
                      'Complete Your Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Help us personalize your fitness journey',
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
                        labelText: 'Weight (kg)',
                        hintText: 'e.g., 70.5',
                        prefixIcon: const Icon(Icons.monitor_weight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText:
                            'Enter your current weight (${Environment.minWeight}-${Environment.maxWeight} kg)',
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
                        labelText: 'Height (cm)',
                        hintText: 'e.g., 175',
                        prefixIcon: const Icon(Icons.height),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText:
                            'Enter your height (${Environment.minHeight}-${Environment.maxHeight} cm)',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Gender Dropdown
                    DropdownButtonFormField<Gender>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender *',
                        prefixIcon: const Icon(Icons.wc),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        helperText: 'Select your gender',
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
                          labelText: 'Date of Birth *',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          helperText: 'Tap to select your birth date',
                          enabled: !isLoading,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? DateFormat('dd MMM yyyy')
                                      .format(_selectedDate!)
                                  : 'Select date',
                              style: TextStyle(
                                color: _selectedDate != null
                                    ? Colors.black
                                    : Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            if (_selectedDate != null)
                              Text(
                                '${_calculateAge(_selectedDate!)} years old',
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
                              Navigator.of(context)
                                  .pushReplacementNamed(Routes.homeScreen);
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
