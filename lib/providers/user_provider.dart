import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  // Fake user to serve as the initial value
  final Map<String, dynamic> _fakeUser = {
    "_id": "6782b23fa948d51eda1d492d",
    "lastName": "Kassulke",
    "firstName": "Jaycee",
    "address": "8623 Lemke Spurs",
    "email": "Tate11@hotmail.com",
    "picture": "https://avatars.githubusercontent.com/u/40478982",
    "location": "Dominicfield",
    "notification": [],
    "phone": "1-408-650-9402 x885",
    "views": 0,
    "purchases_products": "",
    "status": "active",
    "blockedUsers": [],
    "createdAt": "2024-12-27T16:29:14.617Z",
    "updatedAt": "2024-12-27T16:29:14.617Z"
  };

  Map<String, dynamic>? _userDetails;

  UserProvider() {
    // Initialize with the fake user
    _isLoggedIn = true;
    _userDetails = _fakeUser;
  }

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userDetails => _userDetails;

  void logIn(Map<String, dynamic> user) {
    _isLoggedIn = true;
    _userDetails = user;
    notifyListeners();
  }

  void logOut() {
    _isLoggedIn = false;
    _userDetails = null;
    notifyListeners();
  }
}
