// features/email_monitor/data/repositories/email_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/email_entity.dart';
import '../../domain/repositories/email_repository.dart';
import '../datasources/email_datasource.dart';
import '../models/email_model.dart';

class EmailRepositoryImpl implements EmailRepository {
  final EmailDataSource dataSource;

  EmailRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, EmailEntity>> scanEmailForBreaches(
      String email) async {
    try {
      final emailModel = await dataSource.scanEmailForBreaches(email);

      return Right(emailModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  // @override
  // Future<Either<Failure, void>> saveMonitoredEmail(EmailEntity email) async {
  //   try {
  //     final emailModel = EmailModel.fromEntity(email);
  //     await dataSource.saveMonitoredEmail(emailModel);
  //     return const Right(null);
  //   } on Failure catch (failure) {
  //     return Left(failure);
  //   } catch (e) {
  //     return Left(NetworkFailure(e.toString()));
  //   }
  // }

  @override
  Future<Either<Failure, List<EmailEntity>>> getMonitoredEmails() async {
    try {
      final emailModels = await dataSource.getMonitoredEmails();
      final emailEntities =
          emailModels.map((e) => e.toEntity()).toList(); // <== FIX
      return Right(emailEntities);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleMonitoring(
      String email, bool newValue ) async {
    try {
        await dataSource.toggleMonitored(email, newValue);


      // if (newEmail != null) {
      //   // If newEmail is provided, save it as a monitored email
      //   final emailModel = EmailModel.fromEntity(newEmail);
      //   await dataSource.saveMonitoredEmail(emailModel);
      // }else{
      // }
      return Right(true);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
