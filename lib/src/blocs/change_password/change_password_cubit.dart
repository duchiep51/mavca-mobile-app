import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:capstone_mobile/src/data/models/change_password/password.dart';
import 'package:capstone_mobile/src/data/repositories/user/user_repository.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordRequested> {
  ChangePasswordCubit({
    this.userRepository,
  }) : super(ChangePasswordRequested());

  final UserRepository userRepository;

  void oldPasswordChanged(
    String password,
  ) {
    final oldPassword = Password.dirty(password);
    emit(state.copyWith(
      oldPassword: oldPassword,
      status: Formz.validate([state.newPassword, oldPassword]),
    ));
  }

  void newPasswordChanged(
    String password,
  ) {
    final newPassword = Password.dirty(password);
    emit(state.copyWith(
      newPassword: newPassword,
      status: Formz.validate([newPassword, state.oldPassword]),
    ));
  }

  Future<void> changePassword(
    String token,
    String username,
  ) async {
    try {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      var message = await userRepository.changePassword(
        token,
        username,
        state.oldPassword.value,
        state.newPassword.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
