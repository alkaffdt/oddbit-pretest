import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  static const String defaultMessage =
      'Hmm… something went wrong. No worries - you can try again in a moment!';

  const Failure([this.message = defaultMessage]);

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Error occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connectivity issue']);
}
