import 'package:equatable/equatable.dart';

class SocialNetworks extends Equatable {
  final String id;
  final String provider;
  final String? accessToken;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNumber;
  final String? avatar;
  final String? birthday;
  final String? gender;
  final String? location;
  final String? profileUrl;
  final String? ageRange;

  SocialNetworks({
    required this.id,
    required this.accessToken,
    required this.provider,
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.avatar,
    this.birthday,
    this.gender,
    this.location,
    this.profileUrl,
    this.ageRange,
  });

  @override
  List<Object> get props => [
        id,
        provider,
        [accessToken],
        [fullName],
        [firstName],
        [lastName],
        [email],
        [phoneNumber],
        [avatar],
        [birthday],
        [gender],
        [location],
        [profileUrl],
        [ageRange],
      ];
}
