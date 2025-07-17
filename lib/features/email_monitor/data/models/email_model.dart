import 'package:besafe/features/email_monitor/data/models/breach_model.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/email_entity.dart';

part 'email_model.g.dart';

 

@HiveType(typeId: 0)
class EmailModel {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final bool isMonitored;

  @HiveField(2)
  final DateTime? lastScanned;

  @HiveField(3)
  final bool isBreached;

  @HiveField(4)
  final List<BreachModel> breachDetails;

  EmailModel({
    required this.email,
    required this.isMonitored,
    required this.lastScanned,
    required this.isBreached,
    required this.breachDetails,
  });

  /// Convert Hive model to domain entity
  EmailEntity toEntity() {
    return EmailEntity(
      email: email,
      isMonitored: isMonitored,
      lastScanned: lastScanned,
      isBreached: isBreached,
      breachDetails: breachDetails, // still returning titles if entity expects that
    );
  }

  /// Create Hive model from domain entity
  factory EmailModel.fromEntity(EmailEntity entity) {
    return EmailModel(
      email: entity.email,
      isMonitored: entity.isMonitored,
      lastScanned: entity.lastScanned,
      isBreached: entity.isBreached,
      breachDetails: entity.breachDetails ,
    );
  }
}
 

