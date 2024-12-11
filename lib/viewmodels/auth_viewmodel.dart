import 'package:flutter/material.dart';
import '../repositories/shared_preferences_repository.dart';

class AuthViewModel extends ChangeNotifier {

  final SharedPreferencesRepository _sharedPreferencesRepository;

  AuthViewModel(this._sharedPreferencesRepository);

  Future<bool> checkLoginStatus() async {
    return await _sharedPreferencesRepository.isLoggedIn();
  }

  Future<void> logout() async {
    await _sharedPreferencesRepository.clearUserData();
    notifyListeners();
  }
}
