import 'dart:convert';

import 'package:momentswrap/models/product_models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _ssUserName = "ssUserName";
  static const String _jwtTokenKey = "jwtToken";
  static const String _loginDateKey = "loginDate";
  static const String _jsessionIdKey = 'jsession_id';
  static const String _phoneNumberKey = 'phoneNumber';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';
  static const String _userProfileImageKey = 'userProfileImage';

  static Future<void> setIsLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> getIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setUserName(String userName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_ssUserName, userName);
  }

  static Future<String?> getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ssUserName);
  }

  static Future<void> setJwtToken(String jwtToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jwtTokenKey, jwtToken);
  }

  static Future<String?> getJwtToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jwtTokenKey);
  }

  static Future<void> setLoginDate(DateTime loginDate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loginDateKey, loginDate.toIso8601String());
  }

  static Future<DateTime?> getLoginDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final loginDateString = prefs.getString(_loginDateKey);
    if (loginDateString != null) {
      return DateTime.parse(loginDateString);
    }
    return null;
  }

  static Future<void> setJsessionId(String jsessionId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jsessionIdKey, jsessionId);
  }

  static Future<String?> getJsessionId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_jsessionIdKey);
  }

  static Future<void> setPhoneNumber(String phoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumberKey, phoneNumber);
  }

  static Future<String?> getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumberKey);
  }

  static Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  //_userEmailKey

  static Future<void> setUserEmail(String userEmail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, userEmail);
  }

  static Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  //UserProfileImageKey
  static Future<void> setUserProfileImage(String userProfileImage) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileImageKey, userProfileImage);
  }

  static Future<String?> getUserProfileImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userProfileImageKey);
  }

  static Future<void> clearAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


  
}
