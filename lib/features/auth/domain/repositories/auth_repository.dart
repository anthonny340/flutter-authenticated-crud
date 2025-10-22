//El repositorio es lo mismo que el auto_datasource sin embargo nuestro
//repositorio es el que va a terminar teniendo en la implementacion la definicion del datasource
//que vamos a utilizar para autenticar

import 'package:teslo_shop/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<User> checkAuthStatus(String token);
}
