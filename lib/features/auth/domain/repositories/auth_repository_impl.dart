 
// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:besafe/features/auth/data/datasources/auth_datasource.dart';
import 'package:besafe/features/auth/data/models/auth_request.dart';
import 'package:besafe/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
 

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  static const String _boxName = 'auth_box';
  static const String _userKey = 'current_user';

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<UserEntity> signup(String username, String password, String email) async {
    final request = SignupRequest(
      username: username,
      password: password,
      email: email,
    );
    
    final userModel = await dataSource.signup(request);
    final userEntity = UserEntity(
      username: userModel.username,
      email: userModel.email,
      token: userModel.token,
    );
    
    await _saveUser(userModel);
    return userEntity;
  }

  @override
  Future<String> login(String username, String password) async {
    final request = LoginRequest(username: username, password: password);
    final token = await dataSource.login(request);
    
    final userModel = UserModel(
      username: username,
      email: '', // Email not returned in login response
      token: token,
    );
    
    await _saveUser(userModel);
    return token;
  }

  @override
  Future<void> logout() async {
    final user = 
    await _getStoredUser();
    if (user != null) {
      await dataSource.logout(user.token);
      await _clearUser();
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await _getStoredUser();
    return user != null && user.token.isNotEmpty;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await _getStoredUser();
    if (userModel == null) return null;
    
    return UserEntity(
      username: userModel.username,
      email: userModel.email,
      token: userModel.token,
    );
  }

  Future<void> _saveUser(UserModel user) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_userKey, user.toJson());
  } 

  Future<UserModel?> _getStoredUser() async {
    final box = await Hive.openBox(_boxName);
    final userData = box.get(_userKey);
    if (userData == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(userData));
  }

  Future<void> _clearUser() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_userKey);
  }


}