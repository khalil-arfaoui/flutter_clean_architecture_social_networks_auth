import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

const String userKey = 'CACHED_USER';
const String tokenKey = 'CACHED_TOKEN';

abstract class UserLocalDataSource {
  /// Gets the cached [UserModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<UserModel> getCachedUser();

  /// Gets the cached [AuthToken] which was gotten the last time
  /// the user is logged in.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<String> getCachedToken();

  Future<bool> cacheUser(UserModel userToCache);

  Future<bool> cacheToken(String authToken);

  /// Clear cached data [AuthToken, UserModel] from local datasources
  Future<bool> clearCachedUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getCachedUser() {
    final jsonString = sharedPreferences.getString(userKey);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<String> getCachedToken() {
    final authToken = sharedPreferences.getString(tokenKey);
    if (authToken != null) {
      return Future.value(authToken);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheUser(UserModel userToCache) {
    final jsonString = json.encode(userToCache.toCacheJson());

    return sharedPreferences.setString(userKey, jsonString);
  }

  @override
  Future<bool> cacheToken(String tokenToCache) {
    return sharedPreferences.setString(tokenKey, tokenToCache);
  }

  @override
  Future<bool> clearCachedUser() {
    final result = sharedPreferences.remove(userKey);
    return result;
  }
}
