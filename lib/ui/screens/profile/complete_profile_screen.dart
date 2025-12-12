import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/routes.dart';
import '../../../config/goal_type.dart';
import '../../../config/environment.dart';
import '../../../cubits/complete_profile_cubit.dart';

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
  DateTime? _selectedDate;
  GoalType? _selectedGoal;

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
      helpText: 'Select your date of birth',
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
      validationErrors.add('Please select your gender');
    }

    if (_selectedDate == null) {
      validationErrors.add('Please select your date of birth');
    }

    if (_selectedGoal == null) {
      validationErrors.add('Please select your goal');
    }

    if (validationErrors.isNotEmpty) {
      _showError(validationErrors.join('\n'));
      return;
    }

    if (_selectedDate!.isAfter(DateTime.now())) {
      _showError('Date of birth cannot be in the future');
      return;
    }

    final age = _calculateAge(_selectedDate!);
    if (age < Environment.minAge) {
      _showError('Minimum age is ${Environment.minAge} years');
      return;
    }

    if (age > Environment.maxAge) {
      _showError('Maximum age is ${Environment.maxAge} years');
      return;
    }

    // Submit profile using cubit
    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);

    context.read<CompleteProfileCubit>().submitProfile(
      gender: _selectedGender!.name,
      dateOfBirth: _selectedDate!,
      weight: weight,
      height: height,
      goalType: _selectedGoal!.value,
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
      return 'Please enter your weight';
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
      return 'Please enter your height';
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

  // ==================== Build Method ====================
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
      listener: (context, state) {
        if (state is CompleteProfileSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile completed successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to next screen
          Navigator.of(context).pushReplacementNamed(Routes.welcomeScreen);
        } else if (state is CompleteProfileFailure) {
          _showError(state.error);
        }
      },
      builder: (context, state) {
        final isLoading = state is CompleteProfileLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
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
                      Lottie.asset(
                        'assets/images/people.json',
                        width: media.width,
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(height: media.width * 0.05),

                      Text(
                        "Let's complete your profile",
                        style: TextStyle(
                          color: _black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "It will help us to know more about you!",
                        style: TextStyle(color: _gray, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: media.width * 0.05),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            _buildGenderDropdown(isLoading),
                            SizedBox(height: media.width * 0.04),
                            _buildDateField(isLoading),
                            SizedBox(height: media.width * 0.04),
                            _buildWeightField(isLoading),
                            SizedBox(height: media.width * 0.04),
                            _buildHeightField(isLoading),
                            SizedBox(height: media.width * 0.04),
                            _buildGoalDropdown(isLoading),
                            SizedBox(height: media.width * 0.07),
                            _buildGradientButton(
                              title: "Next",
                              onPressed: isLoading ? null : _completeProfile,
                              isLoading: isLoading,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ==================== Custom Widget Builders ====================

  Widget _buildGenderDropdown(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              "assets/images/gender.png",
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: _gray,
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
                          style: TextStyle(color: _gray, fontSize: 14),
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
                hint: Text(
                  "Choose Gender",
                  style: TextStyle(color: _gray, fontSize: 12),
                ),
                underline: Container(),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildDateField(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              "assets/images/date.png",
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: _gray,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _dateController,
              readOnly: true,
              enabled: !isLoading,
              onTap: isLoading ? null : _selectDate,
              decoration: InputDecoration(
                hintText: "Date of Birth",
                hintStyle: TextStyle(color: _gray, fontSize: 12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: TextStyle(color: _gray, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
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
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Image.asset(
                    "assets/images/weight.png",
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    color: _gray,
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
                    decoration: InputDecoration(
                      hintText: "Your Weight",
                      hintStyle: TextStyle(color: _gray, fontSize: 12),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      errorStyle: TextStyle(fontSize: 0.01),
                    ),
                    style: TextStyle(color: _gray, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_secondaryColor2, _secondaryColor1],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            _weightUnit,
            style: TextStyle(color: Colors.white, fontSize: 12),
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
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Image.asset(
                    "assets/images/height.png", // Assuming you have a height icon; adjust if needed
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    color: _gray,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    validator: _validateHeight,
                    enabled: !isLoading,
                    decoration: InputDecoration(
                      hintText: "Your Height",
                      hintStyle: TextStyle(color: _gray, fontSize: 12),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      errorStyle: TextStyle(fontSize: 0.01),
                    ),
                    style: TextStyle(color: _gray, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_secondaryColor2, _secondaryColor1],
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            _heightUnit,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalDropdown(bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: _lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset(
              "assets/images/exercise.json", // You can change this to a goal icon
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: _gray,
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<GoalType>(
                value: _selectedGoal,
                items: GoalType.values
                    .map(
                      (goal) => DropdownMenuItem<GoalType>(
                        value: goal,
                        child: Text(
                          goal.label,
                          style: TextStyle(color: _gray, fontSize: 14),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _selectedGoal = value;
                        });
                      },
                isExpanded: true,
                hint: Text(
                  "Choose Your Goal",
                  style: TextStyle(color: _gray, fontSize: 12),
                ),
                underline: Container(),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
