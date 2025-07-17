import 'package:besafe/services/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_intercept_to_curl/dio_intercept_to_curl.dart'; // 👈 Add this

class ApiClient {
  late final Dio _dio;
    Dio get dio => _dio; // Add this getter


  ApiClient(this._dio) {
    // _dio = Dio(BaseOptions(
    //   // baseUrl: ApiConstants.baseUrl,
    //   connectTimeout: const Duration(minutes: 1),
    //   receiveTimeout: const Duration(minutes: 1),
    // ));

    // For debugging curl commands
    assert(() {
      _dio.interceptors.add(DioInterceptToCurl(printOnSuccess: true));
      return true;
    }());

    // Add authentication interceptor
    _dio.interceptors.add(AuthInterceptor());
  }


  // GET Request
  Future<Response> get(String endpoint)   {
   return _dio.get(endpoint);
  }
  // POST Request
 Future<Response> post(String endpoint, {
  dynamic data,
  bool noAuth = false,
}) async {
  return await _dio.post(
    endpoint,
    data: data,
    options: Options(extra: {'noAuth': noAuth}),
  );
}

  // PUT Request
  Future<Response> put(String endpoint, {dynamic data}) async {
    return await _dio.put(endpoint, data: data);
  }
  // DELETE Request
  Future<Response> delete(String endpoint) async {
    return await _dio.delete(endpoint);
  }

}