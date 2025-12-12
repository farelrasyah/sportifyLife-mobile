import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/user_repository.dart';
import '../../data/models/profile_models.dart';

part 'goal_state.dart';

/// Cubit for managing goal selection functionality
class GoalCubit extends Cubit<GoalState> {
  final UserRepository _userRepository;

  GoalCubit(this._userRepository) : super(GoalInitial());

  /// Submit selected goal
  Future<void> submitGoal(String goalType) async {
    emit(GoalLoading());

    try {
      final request = GoalRequest(goalType: goalType);
      await _userRepository.postGoal(request);
      emit(GoalSuccess());
    } catch (e) {
      emit(GoalFailure(e.toString()));
    }
  }
}
