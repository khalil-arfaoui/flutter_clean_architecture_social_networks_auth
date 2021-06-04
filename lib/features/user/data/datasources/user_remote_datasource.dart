import 'dart:convert';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/date_converter.dart';
import '../models/social_networks_model.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  /// Verify user profile and get back data from social network
  ///
  /// Throws a [ServerException] for all error codes.
  Future<SocialNetworksModel> getSocialUser(String provider);

  /// Calls the http://usersapi.com/signin endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> addSocialUser(UserModel user);

  /// Login user with social network
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> loginSocialUser(String provider);

  /// Sign out User
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> signOut();

  /// Get local loggedIn user
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> getLoggedUser(String id);
}

// const BASE_URL = 'http://base_url.com';
const BASE_URL = 'http://192.168.1.10:3000/buyer';

const googleScopes = [
  'profile',
  'email',
  'openid',
  'https://www.googleapis.com/auth/user.birthday.read',
  'https://www.googleapis.com/auth/user.gender.read',
  'https://www.googleapis.com/auth/user.phonenumbers.read',
  'https://www.googleapis.com/auth/user.addresses.read',
];

const fbPermissions = [
  'email',
  'public_profile',
  'user_location',
  'user_gender',
  'user_birthday',
  'user_age_range',
  'user_link',
];

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final GoogleSignIn googleSignIn;
  final FacebookAuth facebookLogin;

  UserRemoteDataSourceImpl({required this.client})
      : googleSignIn = GoogleSignIn(scopes: googleScopes),
        facebookLogin = FacebookAuth.instance;

  @override
  Future<SocialNetworksModel> getSocialUser(String provider) async {
    try {
      if (provider == 'facebook') {
        return await loginWithFacebook(provider);
      }
      return await loginWithGoogle(provider);
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> loginSocialUser(String provider) async {
    try {
      if (provider == 'facebook') {
        final socialNetworks = await loginWithFacebook(provider);
        return await getUserBySocialNetworks(socialNetworks);
      }
      final socialNetworks = await loginWithGoogle(provider);
      return await getUserBySocialNetworks(socialNetworks);
    } catch (error) {
      throw ServerException();
    }
  }

  Future<UserModel> getUserBySocialNetworks(
    SocialNetworksModel socialNetworks,
  ) async {
    final Map<String, String> body = {
      "email": socialNetworks.email!,
      "id": socialNetworks.id,
    };
    final jsonString = json.encode(body);
    final response = await client.post(
      Uri.parse('$BASE_URL/login-third-party'),
      body: jsonString,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('statusCode')) {
        if (jsonResponse['statusCode'] == 401) {
          ServerException serverException = ServerException(
            message: jsonResponse['message'],
            code: jsonResponse['code'].toString(),
          );
          throw serverException;
        }
      }
      final user = UserModel.fromJson(jsonResponse);
      return user;
    } else {
      Map<String, dynamic> error = {
        'message': json.decode(response.body)['message'],
        'code': json.decode(response.body)['statusCode'].toString(),
      };
      throw error;
    }
  }

  Future<SocialNetworksModel> loginWithFacebook(String provider) async {
    await facebookLogin.logOut();
    //! Let's force the users to login using the login dialog based on Native facebook installed application.
    String loginBehavior = LoginBehavior.NATIVE_WITH_FALLBACK;
    final LoginResult result = await facebookLogin.login(
      permissions: fbPermissions,
      loginBehavior: loginBehavior,
    );

    if (result.status == LoginStatus.success) {
      final token = result.accessToken!.token;
      String link =
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,location,gender,birthday,age_range,link,picture.height(200)&access_token=$token';
      Uri uri = Uri.parse(link);
      final graphResponse = await http.get(uri);
      //! The default image size is 50x50 which is quite small. To change the image size, just use picture.height(200) in the URL instead of picture .
      final Map<String, dynamic> profile = json.decode(graphResponse.body);
      final socialNetworks = SocialNetworksModel(
        id: result.accessToken!.userId,
        accessToken: result.accessToken!.token,
        provider: provider,
        fullName: getProfileData(profile, 'name'),
        firstName: getProfileData(profile, 'first_name'),
        lastName: getProfileData(profile, 'last_name'),
        email: getProfileData(profile, 'email'),
        avatar: getProfileData(
          getProfileData(getProfileData(profile, 'picture'), 'data'),
          'url',
        ),
        birthday: getProfileData(profile, 'birthday'),
        gender: getProfileData(profile, 'gender'),
        profileUrl: getProfileData(profile, 'link'),
        location: getProfileData(getProfileData(profile, 'location'), 'name'),
        ageRange: getAgeRange(getProfileData(profile, 'age_range')),
      );

      return socialNetworks;
    } else if (result.status == LoginStatus.cancelled) {
      throw ServerException(
        message: result.message,
        code: result.status.index.toString(),
      );
    } else if (result.status == LoginStatus.failed) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }

  Future<SocialNetworksModel> loginWithGoogle(String provider) async {
    await googleSignIn.signOut();
    final googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;

      final googleApiResponse = await client.get(
        Uri.parse(
            'https://oauth2.googleapis.com/tokeninfo?id_token=${googleAuth.idToken}'),
        headers: {'Content-Type': 'application/json'},
      );

      final peopleApiResponse = await client.get(
        Uri.parse(
            'https://people.googleapis.com/v1/people/${googleUser.id}?personFields=birthdays,genders,ageRanges,locales,locations,phoneNumbers,addresses&key=$GOOGLE_API_KEY&access_token=${googleAuth.accessToken}'),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> profile = json.decode(
        googleApiResponse.body,
      );
      final Map<String, dynamic> metaData = json.decode(
        peopleApiResponse.body,
      );

      final socialNetworks = SocialNetworksModel(
        id: googleUser.id,
        accessToken: googleAuth.accessToken,
        provider: provider,
        fullName: googleUser.displayName,
        firstName: getProfileData(profile, 'given_name'),
        lastName: getProfileData(profile, 'family_name'),
        email: googleUser.email,
        avatar: googleUser.photoUrl,
        phoneNumber: getMetaData(metaData, 'phoneNumbers', 'value'),
        location: getMetaData(metaData, 'addresses', 'formattedValue'),
        gender: getMetaData(metaData, 'genders', 'value'),
        birthday: getBirthday(getMetaData(metaData, 'birthdays', 'date')),
        ageRange: getMetaData(metaData, 'ageRanges', 'ageRange'),
      );

      return socialNetworks;
    } else {
      Map<String, dynamic> error = {
        'message': 'Sign up canceled',
        'code': '0',
      };
      throw error;
    }
  }

  dynamic getProfileData(Map<String, dynamic> profile, String str) {
    if (profile.containsKey(str)) {
      return profile[str];
    }
    return null;
  }

  dynamic getMetaData(
    Map<String, dynamic> metaData,
    String strList,
    String str,
  ) {
    if (metaData.containsKey(strList)) {
      final Map<String, dynamic> data = metaData[strList][0];
      if (data.containsKey(str)) {
        return data[str];
      }
    }
    return null;
  }

  String? getAgeRange(Map<String, dynamic> ageRange) {
    if (ageRange.containsKey('min') && ageRange.containsKey('max')) {
      return "Entre ${ageRange['min'].toString()} et ${ageRange['max'].toString()}";
    } else if (ageRange.containsKey('min')) {
      return "Plus âgé que ${ageRange['min'].toString()}";
    } else if (ageRange.containsKey('max')) {
      return "Plus jeune que ${ageRange['max'].toString()}";
    }
    return null;
  }

  String? getBirthday(Map<String, dynamic> birthday) {
    DateConverter dateConverter = DateConverter();
    if (birthday.containsKey('day') &&
        birthday.containsKey('month') &&
        birthday.containsKey('year')) {
      final day = birthday['day'];
      final month = birthday['month'];
      final year = birthday['year'];
      return dateConverter.dateToSlashString(new DateTime(year, month, day));
    }
    return null;
  }

  @override
  Future<UserModel> addSocialUser(UserModel user) async {
    try {
      final Map<String, dynamic> body = user.toJson();
      final jsonString = json.encode(body);
      final response = await client.post(
        Uri.parse('$BASE_URL/third-party'),
        body: jsonString,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonUser = json.decode(response.body);
        final _user = UserModel.fromJson(jsonUser);
        return _user;
      } else {
        Map<String, dynamic> error = {
          'message': json.decode(response.body)['message'],
          'code': json.decode(response.body)['statusCode'].toString(),
        };
        throw error;
      }
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() {
    return Future.wait([
      googleSignIn.signOut(),
      facebookLogin.logOut(),
    ]);
  }

  @override
  Future<UserModel> getLoggedUser(String id) {
    // TODO: implement getLoggedUser
    throw UnimplementedError();
  }
}
