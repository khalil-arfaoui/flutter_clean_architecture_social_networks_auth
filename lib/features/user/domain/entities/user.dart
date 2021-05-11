import 'package:equatable/equatable.dart';

import 'social_networks.dart';

class User extends Equatable {
  final String? id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String? accessToken;
  final String? refreshToken;
  final String? photoUrl;
  final SocialNetworks socialNetworks;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.socialNetworks,
    this.accessToken,
    this.refreshToken,
    this.photoUrl,
  });

  @override
  List<Object> get props => [
        [id],
        fullName,
        email,
        phone,
        address,
        [accessToken],
        [refreshToken],
        [photoUrl],
        socialNetworks,
      ];
}
