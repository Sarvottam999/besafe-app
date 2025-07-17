// core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
  
  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {
  final String message;
  const NetworkFailure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;
  const ValidationFailure(this.message);
  
  @override
  List<Object> get props => [message];
}

class DeviceEmailFailure extends Failure {
  final String message;
  const DeviceEmailFailure(this.message);
  
  @override
  List<Object> get props => [message];
}