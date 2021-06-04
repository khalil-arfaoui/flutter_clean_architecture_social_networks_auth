import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_social_networks_auth/features/user/data/models/social_networks_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/social_networks.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, SocialNetworks>> getSocialUser(String provider) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.getSocialUser(provider);
        return Right(remoteData);
      } on ServerException catch (error) {
        ServerFailure serverFailure = ServerFailure(
          message: error.message,
          code: error.code,
        );
        return Left(serverFailure);
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, User>> addSocialUser(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final UserModel userModel = UserModel(
          fullName: user.fullName,
          email: user.email,
          phone: user.phone,
          address: user.address,
          socialNetworks: user.socialNetworks as SocialNetworksModel,
        );
        final remoteData = await remoteDataSource.addSocialUser(userModel);
        localDataSource.cacheUser(remoteData);
        return Right(remoteData);
      } on ServerException catch (error) {
        ServerFailure serverFailure = ServerFailure(
          message: error.message,
          code: error.code,
        );
        return Left(serverFailure);
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, User>> loginSocialUser(String provider) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.loginSocialUser(provider);
        return Right(remoteData);
      } on ServerException catch (error) {
        ServerFailure serverFailure = ServerFailure(
          message: error.message,
          code: error.code,
        );
        return Left(serverFailure);
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteData = await remoteDataSource.signOut();
        await localDataSource.clearCachedUser();
        return Right(remoteData);
      } on ServerException catch (error) {
        ServerFailure serverFailure = ServerFailure(
          message: error.message,
          code: error.code,
        );
        return Left(serverFailure);
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, User>> getLoggedUser() async {
    // if (await networkInfo.isConnected) {
    //   try {
    //     final localUser = await localDataSource.getCachedUser();
    //     final remoteData = await remoteDataSource.getLoggedUser(localUser.id);
    //     return Right(remoteData);
    //   } on ServerException catch (error) {
    //     ServerFailure serverFailure = ServerFailure(
    //       message: error.message,
    //       code: error.code,
    //     );
    //     return Left(serverFailure);
    //   }
    // } else {
    try {
      final localData = await localDataSource.getCachedUser();
      return Right(localData);
    } on CacheException {
      return Left(CacheFailure());
    }
    // }
  }
}
