// lib/core/network/auth_interceptor.dart
import 'package:besafe/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class AuthInterceptor extends Interceptor {

  AuthInterceptor( );

  @override
  Future<void> onRequest(
    RequestOptions options, 
    RequestInterceptorHandler handler
  ) async {
        final bool noAuth = options.extra['noAuth'] == true;

    // final token = await tokenStorage.getAccessToken();


    // Add token to request headers if available
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }

    if (!noAuth) {
    final user = await _getStoredUser();

    // final token = await tokenStorage.getAccessToken();
      if (user?.token != null) {
        options.headers['Authorization'] = 'Bearer ${user?.token}';
      }
    }

    return handler.next(options);
  }

  Future<UserModel?> _getStoredUser() async {
    final box = await Hive.openBox("auth_box");
    final userData = box.get("current_user");
    if (userData == null) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(userData));
  }

  @override
  Future<void> onError(
    DioException err, 
    ErrorInterceptorHandler handler
  ) async {
    // Handle unauthorized errors (401)
    if (err.response?.statusCode == 401) {
      // Token might be expired, so clear it
      // await tokenStorage.deleteToken();
      
      // You could add logic to refresh token or redirect to login
    }
    return handler.next(err);
  }
}