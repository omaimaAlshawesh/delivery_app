// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage = '',
  });

  final Email email;
  final Password password;

  final ConfirmedPassword confirmedPassword;

  final FormzSubmissionStatus status;
  final bool isValid;
  final String errorMessage;

  @override
  List<Object> get props {
    return [
      email,
      password,
      status,
      isValid,
      confirmedPassword,
      errorMessage,
    ];
  }

  AuthState copyWith(
      {Email? email,
      Password? password,
      ConfirmedPassword? confirmedPassword,
      FormzSubmissionStatus? status,
      bool? isValid,
      String? errorMessage}) {
    return AuthState(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
        status: status ?? this.status,
        isValid: isValid ?? this.isValid,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
