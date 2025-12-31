import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

//! Tercero crear el provider
final authProvider =
    StateNotifierProvider.autoDispose<AuthNotifier, AuthState>((ref) {
  final authRepositoryImpl = AuthRepositoryImpl();
  final keyValueStorageServiceImpl = KeyValueStorageServieImpl();
  ref.keepAlive();
  return AuthNotifier(
      authRepository: authRepositoryImpl,
      keyValueStorageService: keyValueStorageServiceImpl);
});

//! Segundo se crear el Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

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

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');

    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('toker', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.autenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey('token');

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
