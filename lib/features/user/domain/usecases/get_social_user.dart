import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/social_networks.dart';
import '../repositories/user_repository.dart';

class GetSocialUser extends UseCase<SocialNetworks, SocialNetworkGetParams> {
  final UserRepository repository;

  GetSocialUser(this.repository);

  @override
  Future<Either<Failure, SocialNetworks>> call(
      SocialNetworkGetParams params) async {
    return await repository.getSocialUser(params.provider);
  }
}

class SocialNetworkGetParams extends Equatable {
  final String provider;

  SocialNetworkGetParams({required this.provider});

  @override
  List<Object> get props => [provider];
}
