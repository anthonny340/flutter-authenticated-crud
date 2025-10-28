import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

//! Tercero crear el provider

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

//! Segundo crear el Notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String, String) registerUserCallback;
  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([
          newEmail,
          state.password,
          state.fullName,
          state.confirmPassword,
        ]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state.copyWith(
        password: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.email,
          state.fullName,
          state.confirmPassword,
        ]));
  }

  onConfirmPasswordChanged(String value) {
    final newConfirmPassword = Password.dirty(value);
    state.copyWith(
        confirmPassword: newConfirmPassword,
        isValid: Formz.validate([
          newConfirmPassword,
          state.password,
          state.email,
          state.fullName,
        ]));
  }

  onFullNameChanged(String value) {
    final newFullName = FullName.dirty(value);

    state = state.copyWith(
        fullName: newFullName,
        isValid: Formz.validate([
          newFullName,
          state.password,
          state.email,
          state.confirmPassword,
        ]));
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    // print(state);
    await registerUserCallback(state.email.value, state.password.value,
        state.confirmPassword.value, state.fullName.value);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = Password.dirty(state.confirmPassword.value);
    final fullName = FullName.dirty(state.fullName.value);

    state = state.copyWith(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      fullName: fullName,
      isValid: Formz.validate([
        email,
        password,
        confirmPassword,
        fullName,
      ]),
    );
  }
}

//! Primero se hace el state
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final Password confirmPassword;
  final FullName fullName;

  RegisterFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.confirmPassword = const Password.pure(),
      this.fullName = const FullName.pure()});

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    Password? confirmPassword,
    FullName? fullName,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        fullName: fullName ?? this.fullName,
      );
  @override
  String toString() {
    return '''
===== RegisterFormState =====
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    confirmPassword: $confirmPassword
    fullName: $fullName
==========================
''';
  }
}
