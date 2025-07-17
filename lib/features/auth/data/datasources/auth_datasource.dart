// lib/features/auth/data/datasources/auth_datasource.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/auth_request.dart';

abstract class AuthDataSource {
  Future<UserModel> signup(SignupRequest request);
  Future<String> login(LoginRequest request);
  Future<void> logout(String token);
}

class AuthDataSourceImpl implements AuthDataSource {
  final Dio dio;
  static const String baseUrl = 'http://192.168.102.215:8000/api/iap';

  AuthDataSourceImpl({required this.dio});

  @override
  Future<UserModel> signup(SignupRequest request) async {
    try {
      final response = await dio.post(
        '$baseUrl/signup/',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return UserModel(
        username: request.username,
        email: request.email,
        token: response.data['token'],
      );
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  @override
  Future<String> login(LoginRequest request) async {
    try {
      final response = await dio.post(
        '$baseUrl/login/',
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response.data['token'];
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await dio.post(
        '$baseUrl/logout/',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}