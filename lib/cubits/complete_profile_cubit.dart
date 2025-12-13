import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/user_repository.dart';
import '../../data/models/profile_models.dart';

part 'complete_profile_state.dart';

/// Cubit for managing complete profile functionality
class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  final UserRepository _userRepository;

  CompleteProfileCubit(this._userRepository) : super(CompleteProfileInitial());

  /// Submit complete profile data
  Future<void> submitProfile({
    required String gender,
    required DateTime dateOfBirth,
    required double weight,
    required double height,
  }) async {
    emit(CompleteProfileLoading());

    try {
      final request = CompleteProfileRequest(
        gender: gender,
        dateOfBirth: dateOfBirth.toIso8601String(),
        weight: weight,
        height: height,
      );

      await _userRepository.completeProfile(request);
      emit(CompleteProfileSuccess());
    } catch (e) {
      emit(CompleteProfileFailure(e.toString()));
    }
  }
}
