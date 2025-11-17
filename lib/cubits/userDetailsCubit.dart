import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/userDetailsModel.dart';
import '../data/repositories/userDetailsRepository.dart';

// States
abstract class UserDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final UserDetailsModel? userDetails;
  final bool isComplete;

  UserDetailsLoaded({this.userDetails, this.isComplete = false});

  @override
  List<Object?> get props => [userDetails, isComplete];
}

class UserDetailsSuccess extends UserDetailsState {
  final UserDetailsModel userDetails;
  final String message;

  UserDetailsSuccess(this.userDetails, this.message);

  @override
  List<Object?> get props => [userDetails, message];
}

class UserDetailsError extends UserDetailsState {
  final String error;
  UserDetailsError(this.error);

  @override
  List<Object?> get props => [error];
}

// Cubit
class UserDetailsCubit extends Cubit<UserDetailsState> {
  final UserDetailsRepository _repository;

  UserDetailsCubit(this._repository) : super(UserDetailsInitial());

  /// Get user details
  Future<void> getUserDetails() async {
    try {
      emit(UserDetailsLoading());

      final userDetails = await _repository.getUserDetails();

      emit(
        UserDetailsLoaded(
          userDetails: userDetails,
          isComplete: userDetails?.isComplete ?? false,
        ),
      );
    } catch (e) {
      emit(UserDetailsError(e.toString()));
    }
  }

  /// Complete profile (first time)
  Future<void> completeProfile({
    required double weight,
    required int height,
    required String gender,
    required DateTime dateOfBirth,
    required String phoneNumber,
  }) async {
    try {
      emit(UserDetailsLoading());

      final userDetails = await _repository.completeProfile(
        weight: weight,
        height: height,
        gender: gender,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
      );

      emit(UserDetailsSuccess(userDetails, 'Profile completed successfully'));
    } catch (e) {
      emit(UserDetailsError(e.toString()));
    }
  }

  /// Update user details
  Future<void> updateUserDetails({
    double? weight,
    int? height,
    String? gender,
    DateTime? dateOfBirth,
    String? phoneNumber,
  }) async {
    try {
      emit(UserDetailsLoading());

      final userDetails = await _repository.updateUserDetails(
        weight: weight,
        height: height,
        gender: gender,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
      );

      emit(UserDetailsSuccess(userDetails, 'Profile updated successfully'));
    } catch (e) {
      emit(UserDetailsError(e.toString()));
    }
  }
}
