import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import '../../cubits/user_details_cubit.dart';
import '../../app/routes.dart';
import '../../config/goal_type.dart';
import '../../config/environment.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _dateController = TextEditingController();

  // Form Data
  Gender? _selectedGender;
  GoalType? _selectedGoalType;
  DateTime? _selectedDate;

  // UI Constants
  final String _weightUnit = 'KG';
  final String _heightUnit = 'CM';

  // Color Constants
  static const Color _lightGray = Color(0xFFF7F8F8);
  static const Color _gray = Color(0xFFADA4A5);
  static const Color _black = Color(0xFF1D1617);
  static const Color _brandBlue = Color(0xFF92A3FD);
  static const Color _brandPurple = Color(0xFFC58BF2);
  static const Color _secondaryColor1 = Color(0xFFC58BF2);
  static const Color _secondaryColor2 = Color(0xFFEEA4CE);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // ==================== Date Selection ====================
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 25);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - Environment.maxAge),
      lastDate: DateTime(now.year - Environment.minAge),
      helpText: tr('date_of_birth_picker_help'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _brandBlue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  // ==================== Form Submission ====================
  Future<void> _completeProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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

    if (validationErrors.isNotEmpty) {
      _showError(validationErrors.join('\n'));
      return;
    }

    if (_selectedDate!.isAfter(DateTime.now())) {
      _showError(tr('validation_date_future'));
      return;
    }

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

    context.read<UserDetailsCubit>().completeProfile(
      weight: double.parse(_weightController.text),
      height: int.parse(_heightController.text),
      gender: _selectedGender!,
      dateOfBirth: _selectedDate!,
      goalType: _selectedGoalType!,
    );
  }

  // ==================== Validation Methods ====================
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

  // ==================== Build Method ====================
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
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
            _showError(state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is UserDetailsLoading;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Animated Lottie Header
                      FadeTransition(
                        opacity: _animationController,
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, -0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: Lottie.asset(
                            'assets/images/people.json',
                            width: media.width * 0.6,
                            height: media.width * 0.6,
                            fit: BoxFit.contain,
                            repeat: true,
                            animate: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Animated Title
                      FadeTransition(
                        opacity: _animationController,
                        child: SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, 0.5),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [_brandBlue, _brandPurple],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(bounds),
                                child: const Text(
                                  "Complete Your Profile",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Let's get to know you better for a\npersonalized experience!",
                                style: TextStyle(
                                  color: _gray,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Animated Form Fields
                      _buildAnimatedField(
                        delay: 100,
                        child: _buildGenderDropdown(isLoading),
                      ),
                      const SizedBox(height: 16),

                      _buildAnimatedField(
                        delay: 200,
                        child: _buildDateField(isLoading),
                      ),
                      const SizedBox(height: 16),

                      _buildAnimatedField(
                        delay: 300,
                        child: _buildWeightField(isLoading),
                      ),
                      const SizedBox(height: 16),

                      _buildAnimatedField(
                        delay: 400,
                        child: _buildHeightField(isLoading),
                      ),
                      const SizedBox(height: 16),

                      _buildAnimatedField(
                        delay: 500,
                        child: _buildGoalTypeDropdown(isLoading),
                      ),
                      const SizedBox(height: 40),

                      // Submit Button with Animation
                      _buildAnimatedField(
                        delay: 600,
                        child: _buildGradientButton(
                          title: "Complete Profile",
                          onPressed: isLoading ? null : _completeProfile,
                          isLoading: isLoading,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== Custom Widget Builders ====================

  Widget _buildAnimatedField({required int delay, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  Widget _buildGenderDropdown(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedGender != null
              ? _brandBlue.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _selectedGender != null
                ? _brandBlue.withOpacity(0.08)
                : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 56,
            height: 56,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _brandBlue.withOpacity(0.1),
                    _brandPurple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wc_rounded, color: _brandBlue, size: 22),
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Gender>(
                value: _selectedGender,
                items: Gender.values
                    .map(
                      (gender) => DropdownMenuItem<Gender>(
                        value: gender,
                        child: Text(
                          gender.label,
                          style: const TextStyle(
                            color: _black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                isExpanded: true,
                hint: const Text(
                  "Choose Gender",
                  style: TextStyle(color: _gray, fontSize: 14),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _gray,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildDateField(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _dateController.text.isNotEmpty
              ? _brandBlue.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _dateController.text.isNotEmpty
                ? _brandBlue.withOpacity(0.08)
                : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 56,
            height: 56,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _brandBlue.withOpacity(0.1),
                    _brandPurple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: _brandBlue,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _dateController,
              readOnly: true,
              enabled: !isLoading,
              onTap: isLoading ? null : _selectDate,
              decoration: const InputDecoration(
                hintText: "Date of Birth",
                hintStyle: TextStyle(color: _gray, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
              style: const TextStyle(
                color: _black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildWeightField(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _lightGray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _weightController.text.isNotEmpty
                    ? _brandBlue.withOpacity(0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _weightController.text.isNotEmpty
                      ? _brandBlue.withOpacity(0.08)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 56,
                  height: 56,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _brandBlue.withOpacity(0.1),
                          _brandPurple.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.monitor_weight_rounded,
                      color: _brandBlue,
                      size: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: _validateWeight,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      hintText: "Your Weight",
                      hintStyle: TextStyle(color: _gray, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      errorStyle: TextStyle(fontSize: 0.01),
                    ),
                    style: const TextStyle(
                      color: _black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 64,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_secondaryColor2, _secondaryColor1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _secondaryColor1.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _weightUnit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeightField(bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _lightGray,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _heightController.text.isNotEmpty
                    ? _brandBlue.withOpacity(0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _heightController.text.isNotEmpty
                      ? _brandBlue.withOpacity(0.08)
                      : Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 56,
                  height: 56,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _brandBlue.withOpacity(0.1),
                          _brandPurple.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.height_rounded,
                      color: _brandBlue,
                      size: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    validator: _validateHeight,
                    enabled: !isLoading,
                    decoration: const InputDecoration(
                      hintText: "Your Height",
                      hintStyle: TextStyle(color: _gray, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      errorStyle: TextStyle(fontSize: 0.01),
                    ),
                    style: const TextStyle(
                      color: _black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 64,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_secondaryColor2, _secondaryColor1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _secondaryColor1.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            _heightUnit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalTypeDropdown(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedGoalType != null
              ? _brandBlue.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _selectedGoalType != null
                ? _brandBlue.withOpacity(0.08)
                : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 56,
            height: 56,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _brandBlue.withOpacity(0.1),
                    _brandPurple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: _brandBlue,
                size: 22,
              ),
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<GoalType>(
                value: _selectedGoalType,
                items: GoalType.values
                    .map(
                      (goal) => DropdownMenuItem<GoalType>(
                        value: goal,
                        child: Text(
                          goal.label,
                          style: const TextStyle(
                            color: _black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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
                hint: const Text(
                  "Choose Your Fitness Goal",
                  style: TextStyle(color: _gray, fontSize: 14),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _gray,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildGradientButton({
    required String title,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed == null
            ? LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              )
            : const LinearGradient(
                colors: [_brandBlue, _brandPurple],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        borderRadius: BorderRadius.circular(99),
        boxShadow: onPressed == null
            ? []
            : [
                BoxShadow(
                  color: _brandBlue.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: _brandPurple.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(99),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            height: 60,
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
