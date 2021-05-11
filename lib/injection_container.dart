// ignore: import_of_legacy_library_into_null_safe
import 'package:connectivity/connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/utils/date_converter.dart';
import 'features/user/data/datasources/user_local_datasource.dart';
import 'features/user/data/datasources/user_remote_datasource.dart';
import 'features/user/data/repositories/user_repository_impl.dart';
import 'features/user/domain/repositories/user_repository.dart';
import 'features/user/domain/usecases/add_social_user.dart';
import 'features/user/domain/usecases/get_logged_user.dart';
import 'features/user/domain/usecases/get_social_user.dart';
import 'features/user/domain/usecases/login_social_user.dart';
import 'features/user/domain/usecases/sign_out.dart';
import 'features/user/presentation/bloc/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - User
  // Bloc
  sl.registerFactory(
    () => UserBloc(
      getSocialUser: sl(),
      addSocialUser: sl(),
      loginSocialUser: sl(),
      signOut: sl(),
      getLoggedUser: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => GetSocialUser(sl()));
  sl.registerLazySingleton(() => AddSocialUser(sl()));
  sl.registerLazySingleton(() => LoginSocialUser(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetLoggedUser(sl()));
  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Data sources
  // [RemoteData]
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl()),
  );
  // [LocalData]
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<DateConverter>(() => DateConverter());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
