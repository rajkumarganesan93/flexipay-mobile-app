import 'package:flutter/material.dart';
import '../repositories/auth_repository.dart';
import '../repositories/shared_preferences_repository.dart';
import '../models/user.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final SharedPreferencesRepository _sharedPreferencesRepository = SharedPreferencesRepository();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<User?> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.login(username, password);
      if(user != null){
        await _sharedPreferencesRepository.saveUserData(user);
      }
      return user;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
