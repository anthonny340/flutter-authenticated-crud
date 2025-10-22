//Las reglas de negocio

//Como quiero que sean los requisitos de todos los sistemas de
//autenticacion que puede manejar la aplicacion

import 'package:teslo_shop/features/auth/domain/entities/user.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<User> checkAuthStatus(String token);
}
