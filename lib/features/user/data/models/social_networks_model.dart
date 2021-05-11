import '../../domain/entities/social_networks.dart';

class SocialNetworksModel extends SocialNetworks {
  SocialNetworksModel({
    required String id,
    required String provider,
    String? accessToken,
    String? fullName,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? avatar,
    String? birthday,
    String? gender,
    String? location,
    String? profileUrl,
    String? ageRange,
  }) : super(
          id: id,
          accessToken: accessToken,
          provider: provider,
          fullName: fullName,
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          avatar: avatar,
          birthday: birthday,
          gender: gender,
          location: location,
          profileUrl: profileUrl,
          ageRange: ageRange,
        );

  /// From JSON
  factory SocialNetworksModel.fromJson(Map<String, dynamic> json) =>
      SocialNetworksModel(
        id: json['id'],
        accessToken: json['accessToken'],
        provider: json['provider'],
        fullName: json['fullName'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        avatar: json['avatar'],
        birthday: json['birthday'],
        gender: json['gender'],
        location: json['location'],
        profileUrl: json['profileUrl'],
        ageRange: json['ageRange'],
      );

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "accessToken": accessToken,
      "provider": provider,
      "fullName": fullName,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "avatar": avatar,
      "birthday": birthday,
      "gender": gender,
      "location": location,
      "profileUrl": profileUrl,
      "ageRange": ageRange,
    };
  }
}
