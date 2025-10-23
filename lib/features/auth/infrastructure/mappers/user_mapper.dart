import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        fullName: json['fullName'],
        //El json regresa una lista segun la respuesta de la peticion
        roles: List<String>.from(json['roles'].map((role) => role)),
        token: json['token'],
      );
}
