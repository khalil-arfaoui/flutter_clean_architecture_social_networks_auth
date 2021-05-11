import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/social_networks.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User>> getLoggedUser();
  Future<Either<Failure, SocialNetworks>> getSocialUser(String provider);
  Future<Either<Failure, User>> addSocialUser(User user);
  Future<Either<Failure, User>> loginSocialUser(String provider);
}
