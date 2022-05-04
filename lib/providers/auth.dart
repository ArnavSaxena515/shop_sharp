import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_sharp/utilities/url_links.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expirationTime;
  String? _userID;
  Timer? _authenticationTimer;

  // to check if a user is authenticated. If authenticated, token will not be null. Token and expiration date will be set
  bool get isAuthenticated {
    return token != null;
  }

  String? get token {
    // check if token is there and has not expired
    if (_expirationTime != null && _expirationTime!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    if (isAuthenticated) {
      return _userID;
    }
    return null;
  }

  //Auth(this._expirationTime, this._token, this._userID);
  Future<void> _authenticate({String? email = "", String? password = "", required authAction action}) async {
    try {
      if (email!.isEmpty || password!.isEmpty) {
        throw Exception("Email or password field is empty. Please provide a valid email ID and password");
      }
      final url = Uri.parse(generateURL(action));
      final response = await http.post(url,
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData["error"]["message"]);
      }
      // set up the user data (credentials and token and ID) from the response we have received from our API
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expirationTime = DateTime.now().add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _autoLogout();
      notifyListeners();
      //Store user data locally to allow for automatic login through user credentials stored in user's device
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(
          'userData',
          json.encode({
            'token': _token,
            'userID': _userID,
            'expirationTime': _expirationTime!.toIso8601String(),
          }));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp({String? email = "", String? password = ""}) async {
    try {
      return await _authenticate(email: email, password: password, action: authAction.signUp);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signIn({String? email = "", String? password = ""}) async {
    try {
      return await _authenticate(email: email, password: password, action: authAction.login);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userID = null;
    _expirationTime = null;
    if (_authenticationTimer != null) {
      //cancel the ongoing timer if a user chooses to logout
      _authenticationTimer!.cancel();
      _authenticationTimer = null;
    }
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    // time to expiry is the expiration time minus the current time. So that gives us the number of seconds before the token expires and user must be logged out.
    if (_authenticationTimer != null) {
      _authenticationTimer!.cancel(); // cancel the timer if it already exists to set up a new one.
    }
    final timeToExpiry = _expirationTime!.difference(DateTime.now()).inSeconds;
    _authenticationTimer = Timer(Duration(seconds: timeToExpiry), logout); //after timer expires, logout is triggered.
  }

  Future<bool> autoLogin() async {
    // print("Autologin called");
    final sharedPrefs = await SharedPreferences.getInstance();
    final storedData = json.decode(sharedPrefs.getString('userData')!) as Map<String, dynamic>;
    // print("SHARED PREFS USER DATA:");
    // print(sharedPrefs.getString('userData'));
    if (storedData.isEmpty) {
      // print("Autologin failed, no user data found");
      // shared preference empty, no user data stored, so automatic login fails.
      return false;
    }

    final expiryTime = DateTime.parse(storedData['expirationTime']);
    if (DateTime.now().isAfter(expiryTime)) {
      //print("Autologin failed, token expired");

      // if time right now, is after the expiration time, that means the token for the user has expired, so auto login fails.
      return false;
    }
    // print("AUTOLOGIN SUCCESSFUL");
    _token = storedData['token'];
    _userID = storedData['userID'];
    _expirationTime = expiryTime;
    notifyListeners();
    _autoLogout();
    return true;
  }
}
