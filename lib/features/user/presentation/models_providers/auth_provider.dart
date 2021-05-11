import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class AuthProvider with ChangeNotifier {
  bool _isLogged = false;
  User? _user;
  String? _uid;
  // String _accessToken;

  bool get isLogged => _isLogged;

  User? get getUser => _user;

  String? get getUid => _uid;

  // Sign In Or Out User
  set loggedInOrOut(bool isLogged) {
    _isLogged = isLogged;
    notifyListeners();
  }

  // Set User
  set setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // Set User Uid
  set setUid(String? uid) {
    _uid = uid;
    notifyListeners();
  }
}
