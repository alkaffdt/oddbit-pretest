import 'package:oddbit_mobile/features/auth/domain/models/token_model.dart';

import '../models/user_model.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<void> logout();
  Future<String?> getRefreshToken();
  Future<Token> refreshToken(String refreshToken);
}
