import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

import '/repositories/repositories.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanged(String value) {
    final email = Email.dirty(value);

    emit(state.copyWith(
      email: email,
      status: Formz.validate([email, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    emit(state.copyWith(
      password: password,
      status: Formz.validate([state.email, password]),
    ));
  }

  void statusChanged(FormzStatus status) {
    print(state);
    emit(state.copyWith(status: status));
    print(state);
  }

  Future<void> logInWithCredentials() async {
    print("1");
    if (!state.status.isValidated) return;
    print("2");
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    print("3");
    try {
      print("4");
      await _authRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception catch (error) {
      print("5");
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          errorMessage: error.toString(),
        ),
      );
    } catch (_) {
      print("6");
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
