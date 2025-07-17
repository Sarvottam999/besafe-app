// features/email_monitor/domain/entities/email_entity.dart
import 'package:besafe/features/email_monitor/data/models/breach_model.dart';
import 'package:equatable/equatable.dart';

class EmailEntity extends Equatable {
  final String email;
  final bool isMonitored;
  final DateTime? lastScanned;
  final bool isBreached;
  final List<BreachModel> breachDetails;

  const EmailEntity({
    required this.email,
    this.isMonitored = false,
    this.lastScanned,
    this.isBreached = false,
    this.breachDetails = const [],
  });
  

  EmailEntity copyWith({
    String? email,
    bool? isMonitored,
    DateTime? lastScanned,
    bool? isBreached,
    List<BreachModel>? breachDetails,
  }) {
    return EmailEntity(
      email: email ?? this.email,
      isMonitored: isMonitored ?? this.isMonitored,
      lastScanned: lastScanned ?? this.lastScanned,
      isBreached: isBreached ?? this.isBreached,
      breachDetails: breachDetails ?? this.breachDetails,
    );
  }

  @override
  List<Object?> get props => [email, isMonitored, lastScanned, isBreached, breachDetails];
}