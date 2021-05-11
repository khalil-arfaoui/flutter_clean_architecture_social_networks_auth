import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class AddSocialUser extends UseCase<User, RegisterSocialParams> {
  final UserRepository repository;

  AddSocialUser(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterSocialParams params) async {
    return await repository.addSocialUser(params.user);
  }
}

class RegisterSocialParams extends Equatable {
  final User user;

  RegisterSocialParams({required this.user});

  @override
  List<Object> get props => [user];
}
