part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  final List<dynamic>? properties;
  UserEvent([this.properties]);

  @override
  List<Object> get props => [
        [properties]
      ];
}

class Logout extends UserEvent {
  final BuildContext context;

  Logout({required this.context});
}

class IsLogged extends UserEvent {
  final BuildContext context;

  IsLogged({required this.context});
}

class RegisterWithSocialNetwork extends UserEvent {
  final User user;

  RegisterWithSocialNetwork({required this.user});
}

class LoginWithSocialNetwork extends UserEvent {
  final String provider;

  LoginWithSocialNetwork({required this.provider});
}

class GetSocialNetwork extends UserEvent {
  final String provider;

  GetSocialNetwork({required this.provider});
}

class UndoRegistration extends UserEvent {}
