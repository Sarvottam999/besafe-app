// features/email_monitor/domain/usecases/scan_email_breach.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/validators.dart';
import '../entities/email_entity.dart';
import '../repositories/email_repository.dart';
 
class ScanEmailBreach {
  final EmailRepository repository;

  ScanEmailBreach(this.repository);

  Future<Either<Failure, EmailEntity>> call(String email) async {
    if (!Validators.isValidEmail(email)) {
      return Left(ValidationFailure('Invalid email format'));
    }
    
    return await repository.scanEmailForBreaches(email);
  }
}