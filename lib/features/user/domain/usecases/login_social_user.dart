import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class LoginSocialUser extends UseCase<User, SocialNetworkLoginParams> {
  final UserRepository repository;

  LoginSocialUser(this.repository);

  @override
  Future<Either<Failure, User>> call(SocialNetworkLoginParams params) async {
    return await repository.loginSocialUser(params.provider);
  }
}

class SocialNetworkLoginParams extends Equatable {
  final String provider;

  SocialNetworkLoginParams({required this.provider});

  @override
  List<Object> get props => [provider];
}
