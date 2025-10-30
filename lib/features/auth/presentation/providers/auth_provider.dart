import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

//! Tercero crear el provider
final authProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, AuthState>((ref) {
  final authRepositoryImpl = AuthRepositoryImpl();
  return AuthNotifier(authRepository: authRepositoryImpl);
});

//! Segundo se crear el Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  AuthNotifier({required this.authRepository}) : super(AuthState());

  // Estos metodos terminan delegando el trabajo al repositorio por este motivo se crea
  // una instancia de AuthRepository en el provider y se lo manda como parametro al Notifier
  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (error) {
      logout(error.message);
    }
  }

  void registerUser(String email, String password, String confirmPassword,
      String fullName) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (password != confirmPassword) {
      logout('Las contraseñas no son iguales');
      return;
    }

    try {
      final user = await authRepository.register(email, password, fullName);
      _setLoggedUser(user);
    } on CustomError catch (error) {
      logout(error.message);
    }
  }

  void checkAuthStatus() async {}

  void _setLoggedUser(User user) {
    //TODO: necesito guardar el token fisicamente para que sea persistente
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.autenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    //TODO: limpia token
    state = state.copyWith(
        authStatus: AuthStatus.notAutenticated,
        user: null,
        errorMessage: errorMessage);
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: '');
  }
}

//! Primero se crea el State
enum AuthStatus { checking, autenticated, notAutenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
