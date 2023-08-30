import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:location/location.dart';

import '../../../core/services/category_repository/category_repository.dart';
import '../../../core/services/form_input/form_input.dart';
import '../repository/authentication_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authenticationRepository) : super(const AuthState());

  final AuthenticationRepository _authenticationRepository;

  final PageController controller = PageController();
  LocationData? locationData;

  Map<String, dynamic> placeDatals = {};
  List<Category> categories = [];
  String? logoPath;
  String? coverPath;
  String selectedCategory = '';
  Category category = Category.empty();

  void emailChanged(String value) {
    final email = Email.dirty(value);

    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([
          email,
          state.password,
        ]),
      ),
    );
  }

  void emailChangedSignUp(String value) {
    final email = Email.dirty(value);

    emit(
      state.copyWith(
        email: email,
        isValid:
            Formz.validate([email, state.password, state.confirmedPassword]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);

    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([
          state.email,
          password,
        ]),
      ),
    );
  }

  void passwordChangedSignUp(String value) {
    final password = Password.dirty(value);

    emit(
      state.copyWith(
        password: password,
        isValid:
            Formz.validate([state.email, password, state.confirmedPassword]),
      ),
    );
  }

  void confirmedPasswordChanged(String value) {
    final conPassword =
        ConfirmedPassword.dirty(password: state.password.value, value: value);

    emit(
      state.copyWith(
        confirmedPassword: conPassword,
        isValid: Formz.validate([
          state.email,
          state.password,
          conPassword,
        ]),
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> signUpWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.signUpWithEmailAndPassowrd(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
