// features/email_monitor/domain/repositories/email_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/email_entity.dart';

abstract class EmailRepository {
  Future<Either<Failure, bool>> toggleMonitoring(String email, bool newValue);
  Future<Either<Failure, EmailEntity>> scanEmailForBreaches(String email);
  // Future<Either<Failure, void>> saveMonitoredEmail(EmailEntity email);
  Future<Either<Failure, List<EmailEntity>>> getMonitoredEmails();
}