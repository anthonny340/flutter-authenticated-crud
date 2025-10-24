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
  void loginUser(String email, String password) async {
    // final user = await authRepository.login(email, password);
    // state = state.copyWith(user: user, authStatus: AuthStatus.autenticated);
  }

  void registerUser(String email, String password) async {}
  void checkAuthStatus() async {}
  Future<void> logout() async {}
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
