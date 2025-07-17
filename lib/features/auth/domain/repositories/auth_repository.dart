
import 'package:besafe/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signup(String username, String password, String email);
  Future<String> login(String username, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<UserEntity?> getCurrentUser();
}
