import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:rest_api_login/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_login/utils/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  final String mainUrl = Api.authUrl;
  // final String authKey = Api.authKey;

  String? _token;
  String? _userId;
  String? _userEmail;
  DateTime? _expiryDate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null && token!.isNotEmpty;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null &&
        _token!.isNotEmpty) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  String? get userEmail {
    return _userEmail;
  }

  Future<void> logout() async {
    _token = null;
    _userEmail = null;
    _userId = null;
    _expiryDate = null;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void _autologout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    if (_expiryDate == null) return;

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryautoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(pref.getString('userData')!) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _userEmail = extractedUserData['userEmail'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autologout();

    return true;
  }

  Future<void> saveUserData(String responseBody) async {
    final responseData = json.decode(responseBody);
    final user = responseData['data']['user'];
    final _token = responseData['data']['token'];
    final userId = user['id'].toString();
    final userEmail = user['email'];
    final cartCount = responseData['data']['cart_count'] ?? 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token);
    await prefs.setString('userId', userId);
    await prefs.setString('userEmail', userEmail);
    await prefs.setInt('cartCount', cartCount);
  }

  Future<void> authenticate(
      String email, String password, String endpoint) async {
    try {
      final response = await http.post(
        Uri.parse('${mainUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final responseData = json.decode(response.body);

      print(responseData);
      if (responseData['error'] != null &&
          responseData['error']['message'] != null) {
        final errorMessage = responseData['error']['message'];
        // Tampilkan errorMessage kepada pengguna
        throw HttpException(errorMessage);
      }

      await saveUserData(response.body);
      final prefs = await SharedPreferences.getInstance();
      final _token = prefs.getString('token');
      final _userId = prefs.getString('userId');
      final _userEmail = prefs.getString('userEmail');
      // _token = responseData['idToken'];
      // _userId = responseData['localId'];
      // _userEmail = responseData['email'];

      // _expiryDate = DateTime.now()
      //     .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autologout();
      notifyListeners();

      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'userEmail': _userEmail,
      });

      prefs.setString('userData', userData);

      print('check $userData');
      // return true; // Login berhasil
    } catch (error) {
      // Tampilkan pesan kesalahan umum kepada pengguna
      print('Terjadi kesalahan saat login: $error');
      // return false; // Login gagal
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${mainUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null &&
          responseData['error']['message'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      await saveUserData(response.body);

      return true; // Login berhasil
    } catch (error) {
      print('Terjadi kesalahan saat login: $error');
      return false; // Login gagal
    }
  }

  Future<void> signUp(String email, String password) {
    return authenticate(email, password, 'signUp');
  }
}
