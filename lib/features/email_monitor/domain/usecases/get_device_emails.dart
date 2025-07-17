// features/email_monitor/domain/usecases/get_device_emails.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/email_repository.dart';

class GetDeviceEmails {
  final EmailRepository repository;

  GetDeviceEmails(this.repository);

  // Future<Either<Failure, List<String>>> call() async {
  //   return await repository.getDeviceEmails();
  // }
}