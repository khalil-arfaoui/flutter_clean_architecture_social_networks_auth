import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.message, this.code});

  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  final String? message;
  final String? code;

  @override
  List<Object> get props => [
        [message],
        [code]
      ];
}

// General failures
class ServerFailure extends Failure {
  final String? message;
  final String? code;

  ServerFailure({this.message, this.code});
}

class CacheFailure extends Failure {}

class NetworkFailure extends Failure {}
