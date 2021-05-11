part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  final List<dynamic>? properties;
  const UserState([this.properties]);

  @override
  List<Object> get props => [
        [properties]
      ];
}

class InitialUserState extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded({required this.user});
}

class UserError extends UserState {
  final String message;
  final String? id;

  UserError({required this.message, this.id});
}

class SocialUserLoaded extends UserState {
  final SocialNetworks socialNetworks;

  SocialUserLoaded({required this.socialNetworks});
}
