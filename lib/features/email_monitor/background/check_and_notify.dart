import 'package:besafe/features/email_monitor/data/datasources/email_datasource.dart';
import 'package:besafe/features/email_monitor/data/models/email_model.dart';
import 'package:besafe/services/local_notification_service.dart';
import 'package:besafe/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../core/constants/app_constants.dart';

final _notifications = FlutterLocalNotificationsPlugin();

Future<void> checkAndNotifyBreaches() async {
   await Hive.initFlutter();
  Hive.registerAdapter(EmailModelAdapter());
  final box = await Hive.openBox<EmailModel>(monitored_emails_table_key);

  final dio = Dio();
  final dataSource = EmailDataSourceImpl(dio: dio);

  for (var email in box.values) {
    print("## Checking breaches for: ${email.email}");
    try {
      final updated = await dataSource.scanEmailForBreaches(email.email);

      final oldBreaches = email.breachDetails.toSet();
      final newBreaches = updated.breachDetails.toSet();

      final isNewBreach = !newBreaches.difference(oldBreaches).isEmpty;
      print("## Breaches found: ${updated.breachDetails.length}");

      // if (isNewBreach) {
      // await _showNotification(
      //   title: "⚠️ New Breach Detected!",
      //   body: "${email.email} was found in new data breaches.",
      // );
      await LocalNotificationService.show(
  title: '⚠️ New Breach Detected!',
  body: "${email.email} was found in new data breaches.",
);
      if (isNewBreach) {
        // Update in Hive
        // email.breachDetails
        final updatedEmail = EmailModel(
          email: email.email,
          isMonitored: true,
          lastScanned: DateTime.now(),
          isBreached: updated.isBreached,
          breachDetails: updated.breachDetails,
        );
        await box.put(email.email, updatedEmail);
      }
    } catch (_) {
      // Ignore errors for background task
    }
  }
}
 