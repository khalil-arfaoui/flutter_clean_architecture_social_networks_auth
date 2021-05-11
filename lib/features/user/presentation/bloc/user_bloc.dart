import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/social_networks.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/add_social_user.dart';
import '../../domain/usecases/get_logged_user.dart';
import '../../domain/usecases/get_social_user.dart';
import '../../domain/usecases/login_social_user.dart';
import '../../domain/usecases/sign_out.dart';
import '../models_providers/auth_provider.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SignOut signOut;
  final GetLoggedUser getLoggedUser;
  final GetSocialUser getSocialUser;
  final AddSocialUser addSocialUser;
  final LoginSocialUser loginSocialUser;

  UserBloc({
    required this.signOut,
    required this.getLoggedUser,
    required this.getSocialUser,
    required this.addSocialUser,
    required this.loginSocialUser,
  }) : super(InitialUserState());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is Logout) {
      final failureOrSuccess = await signOut(
        NoParams(),
      );
      yield* _eitherLoggedOutOrErrorState(failureOrSuccess, event.context);
    } else if (event is IsLogged) {
      AuthProvider authProvider = Provider.of<AuthProvider>(
        event.context,
        listen: false,
      );
      final failureOrSuccess = await getLoggedUser(NoParams());
      yield failureOrSuccess.fold(
        (failure) => InitialUserState(),
        (user) {
          authProvider.loggedInOrOut = true;
          authProvider.setUser = user;
          authProvider.setUid = user.id!;
          return UserLoaded(user: user);
        },
      );
    } else if (event is GetSocialNetwork) {
      Utils utils = Utils();
      yield UserLoading();
      final failureOrSuccess = await getSocialUser(
        SocialNetworkGetParams(provider: event.provider),
      );
      yield failureOrSuccess.fold(
        (failure) => UserError(message: utils.mapFailureToMessage(failure)),
        (socialNetwork) => SocialUserLoaded(socialNetworks: socialNetwork),
      );
    } else if (event is RegisterWithSocialNetwork) {
      yield UserLoading();
      final failureOrUser = await addSocialUser(
        RegisterSocialParams(user: event.user),
      );
      yield* _eitherLoadedOrErrorState(failureOrUser);
    } else if (event is LoginWithSocialNetwork) {
      yield UserLoading();
      final failureOrUser = await loginSocialUser(
        SocialNetworkLoginParams(provider: event.provider),
      );
      yield* _eitherLoadedOrErrorState(failureOrUser);
    } else if (event is UndoRegistration) {
      yield InitialUserState();
    }
  }
}

Stream<UserState> _eitherLoadedOrErrorState(
  Either<Failure, User> either,
) async* {
  Utils utils = Utils();
  yield either.fold(
    (failure) => UserError(message: utils.mapFailureToMessage(failure)),
    (user) => UserLoaded(user: user),
  );
}

Stream<UserState> _eitherLoggedOutOrErrorState(
    Either<Failure, void> either, BuildContext context) async* {
  AuthProvider authProvider = Provider.of<AuthProvider>(
    context,
    listen: false,
  );
  Utils utils = Utils();
  yield either.fold(
    (failure) => UserError(message: utils.mapFailureToMessage(failure)),
    (_) {
      authProvider.loggedInOrOut = false;
      authProvider.setUser = null;
      authProvider.setUid = null;
      return InitialUserState();
    },
  );
}
