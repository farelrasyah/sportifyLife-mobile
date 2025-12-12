part of 'complete_profile_cubit.dart';

/// Base state for complete profile
abstract class CompleteProfileState extends Equatable {
  const CompleteProfileState();

  @override
  List<Object> get props => [];
}

/// Initial state
class CompleteProfileInitial extends CompleteProfileState {}

/// Loading state
class CompleteProfileLoading extends CompleteProfileState {}

/// Success state
class CompleteProfileSuccess extends CompleteProfileState {}

/// Failure state
class CompleteProfileFailure extends CompleteProfileState {
  final String error;

  const CompleteProfileFailure(this.error);

  @override
  List<Object> get props => [error];
}
