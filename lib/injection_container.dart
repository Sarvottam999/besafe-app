// injection_container.dart
import 'package:besafe/features/auth/data/datasources/auth_datasource.dart';
import 'package:besafe/features/auth/domain/repositories/auth_repository.dart';
import 'package:besafe/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:besafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:besafe/features/email_monitor/services/subscription_service.dart';
import 'package:besafe/services/ApiClient.dart';
import 'package:besafe/services/local_notification_service.dart';
import 'package:dio/dio.dart';
import 'package:dio_intercept_to_curl/dio_intercept_to_curl.dart';
import 'package:get_it/get_it.dart';

// Data
import 'features/email_monitor/data/datasources/email_datasource.dart';
import 'features/email_monitor/data/repositories/email_repository_impl.dart';

// Domain
import 'features/email_monitor/domain/repositories/email_repository.dart';
import 'features/email_monitor/domain/usecases/get_device_emails.dart';
import 'features/email_monitor/domain/usecases/scan_email_breach.dart';

// Presentation
import 'features/email_monitor/presentation/providers/email_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
sl.registerLazySingleton<Dio>(() {
  final dio = Dio();
  dio.interceptors.add(
    DioInterceptToCurl(
      printOnSuccess: true,
    ),
  );
  return dio;
});

  // Data sources
  sl.registerLazySingleton<EmailDataSource>(
    () => EmailDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<EmailRepository>(
    () => EmailRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDeviceEmails(sl()));
  sl.registerLazySingleton(() => ScanEmailBreach(sl()));

  // Providers
  sl.registerFactory(
    () => EmailProvider(
      emailRepository: sl(),
      scanEmailBreach: sl(),
    ),
  );
  // Register notification service 
  sl.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(),
  );
  // Services


  // Auth Data sources
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(dio: sl()),
  );

  // Auth Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dataSource: sl()),
  );

  // Auth Providers
  sl.registerFactory(
    () => AuthProvider(authRepository: sl()),
  );

  sl.registerLazySingleton<ApiClient>(() => ApiClient(  sl()));
sl.registerFactory(() => SubscriptionService(
   sl()
  
));


}