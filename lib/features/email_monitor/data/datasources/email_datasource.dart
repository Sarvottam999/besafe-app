// features/email_monitor/data/datasources/email_datasource.dart
import 'package:besafe/features/email_monitor/data/models/breach_model.dart';
import 'package:besafe/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'dart:io' show Platform;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../models/email_model.dart';
import 'dart:developer';

abstract class EmailDataSource {
  Future<void> toggleMonitored(String email, bool newValue);
  Future<EmailModel> scanEmailForBreaches(String email);
  Future<void> saveMonitoredEmail(EmailModel email);
  Future<List<EmailModel>> getMonitoredEmails();
  // Future<List<EmailModel>> getMonitoredEmails();

}

class EmailDataSourceImpl implements EmailDataSource {
  final Dio dio;

  EmailDataSourceImpl({required this.dio});
 
     
  @override
  Future<EmailModel> scanEmailForBreaches(String email) async {
    try {
      final url = 'https://haveibeenpwned.com/unifiedsearch/$email';
      

      final response = await dio.get(url,
        options: Options(
          headers: {
            'accept': '*/*',
            'accept-language': 'en-IN,en-GB;q=0.9,en-US;q=0.8,en;q=0.7',
            'cf-turnstile-response': '',
            'priority': 'u=1, i',
            'referer': 'https://haveibeenpwned.com/',
            'request-id': '|ea17d161de31455284ccbed355733a5b.2826d29b2d214e1b',
            'sec-ch-ua': '"Google Chrome";v="129", "Not=A?Brand";v="8", "Chromium";v="129"',
            'sec-ch-ua-arch': '"x86"',
            'sec-ch-ua-bitness': '"64"',
            'sec-ch-ua-full-version': '"129.0.6668.70"',
            'sec-ch-ua-full-version-list':
                '"Google Chrome";v="129.0.6668.70", "Not=A?Brand";v="8.0.0.0", "Chromium";v="129.0.6668.70"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-model': '""',
            'sec-ch-ua-platform': '"Linux"',
            'sec-ch-ua-platform-version': '"6.8.0"',
            'sec-fetch-dest': 'empty',
            'sec-fetch-mode': 'cors',
            'sec-fetch-site': 'same-origin',
            'traceparent': '00-ea17d161de31455284ccbed355733a5b-2826d29b2d214e1b-01',
            'cookie':
                '__cf_bm=QY0lhQFQgexYs8QmeJFHACD3U.D.ARVEQ.AsFNzkx6U-1752077774-1.0.1.1-YQlc95VXH8q0txP7345LHd0jmXcOEyVn1w1dlnhaJ1WCbRHEdXnWFsAX4ht6fxmqvlhuhA.4j3knTAzSrDy13gCwQzQBJwtLVRk9DPr1qjA'
          },
        ),
      );


      final data = response.data;
      log(data.toString());


      final breaches = data['Breaches'] as List<dynamic>? ?? [];
      final parsedBreaches = breaches.map((e) => BreachModel.fromJson(e)).toList();

      return EmailModel(
        email: email,
        isMonitored: false,
        lastScanned: DateTime.now(),
        isBreached: breaches.isNotEmpty,
        breachDetails: parsedBreaches,
      );
    } on DioException catch (e) {
      print("## Error DioException scanning email: ${e.response?.statusCode}");
      print("## Error DioException scanning email: ${e.message}");
      if (
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.badResponse ||
          e.type == DioExceptionType.cancel ||
          e.type == DioExceptionType.unknown
      ){
        return EmailModel(
        email: email,
        isMonitored: false,
        lastScanned: DateTime.now(),
        isBreached: false,
        breachDetails: [],
      );
      }
      throw NetworkFailure('Network error: ${e.message}');
    } catch (e) {
      print("## Error scanning email: ${e.toString()}");
      throw NetworkFailure('Failed to scan email: ${e.toString()}');
    }
  }

  @override
  Future<void> saveMonitoredEmail(EmailModel email) async {
    try {
      final box = await Hive.openBox<EmailModel>(monitored_emails_table_key);
      await box.put(email.email, email); // using email as key
    } catch (e) {
      throw NetworkFailure('Failed to save email: ${e.toString()}');
    }
  }

  @override
  Future<List<EmailModel>> getMonitoredEmails() async {
    try {
      final box = await Hive.openBox<EmailModel>(monitored_emails_table_key);
      final emails = box.values.toList();
      if (emails.isEmpty) {
        return [];
      }
      // await Future.delayed(Duration(milliseconds: 200));

      return emails.cast<EmailModel>();
    } catch (e) {
      throw NetworkFailure('Failed to get monitored emails: ${e.toString()}');
    }
  } 
  @override
  Future<void> toggleMonitored(String email, bool newValue) async {
  final box = await Hive.openBox<EmailModel>(monitored_emails_table_key);

  final existing = box.get(email);
  if (existing != null) {
    final updated = EmailModel(
      email: existing.email,
      isMonitored: newValue,
      lastScanned: existing.lastScanned,
      isBreached: existing.isBreached,
      breachDetails: existing.breachDetails,
    );

    await box.put(email, updated);
  } else {
      // throw NetworkFailure('Email not found: $email');
      // create it 
      final newEmail = EmailModel(
        email: email,
        isMonitored: newValue,
        lastScanned: DateTime.now(),
        isBreached: false,
        breachDetails: [],
      );
      await box.put(email, newEmail);
      
  }
}

//  gett monitor email list






  // chnage the monitoring 
}