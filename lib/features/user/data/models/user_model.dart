import '../../domain/entities/user.dart';
import 'social_networks_model.dart';

class UserModel extends User {
  UserModel({
    String? id,
    required String fullName,
    required String email,
    required String phone,
    required String address,
    required SocialNetworksModel socialNetworks,
    String? refreshToken,
    String? photoUrl,
    String? accessToken,
  }) : super(
          id: id,
          fullName: fullName,
          email: email,
          phone: phone,
          address: address,
          accessToken: accessToken,
          refreshToken: refreshToken,
          photoUrl: photoUrl,
          socialNetworks: socialNetworks,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user')) {
      Map<String, dynamic> jsonUser = json['user'];
      return UserModel(
        id: jsonUser.containsKey('id') ? jsonUser['id'] : json['_id'],
        fullName: jsonUser['fullName'],
        email: jsonUser['email'],
        phone: jsonUser['phone'],
        address: jsonUser['address'],
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        socialNetworks:
            SocialNetworksModel.fromJson(jsonUser['socialNetworks']),
        photoUrl: json['photoUrl'],
      );
    } else {
      return UserModel(
        id: json.containsKey('id') ? json['id'] : json['_id'],
        fullName: json['fullName'],
        email: json['email'],
        phone: json['phone'],
        address: json['address'],
        socialNetworks: SocialNetworksModel.fromJson(json['socialNetworks']),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'fullName': fullName,
      'email': email,
      "phone": phone,
      "address": address,
      "socialNetworks": socialNetworks,
    };
  }

  Map<String, dynamic> toCacheJson() {
    return {
      "user": {
        "id": id,
        'fullName': fullName,
        'email': email,
        "phone": phone,
        "address": address,
        "socialNetworks": socialNetworks,
      },
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
  }
}
