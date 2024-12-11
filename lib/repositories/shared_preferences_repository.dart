import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class SharedPreferencesRepository {
  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  // Save user data to SharedPreferences
  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.userId);
    await prefs.setString('username', user.username);
    await prefs.setString('token', user.token);
    await prefs.setString('accountNumber', user.accountNumber);
    await prefs.setString('firstName', user.firstName);
    await prefs.setString('lastName', user.lastName);
  }

  // Retrieve user data from SharedPreferences
  Future<User?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final username = prefs.getString('username');
    final token = prefs.getString('token');
    final accountNumber = prefs.getString('accountNumber');
    final firstName = prefs.getString('firstName');
    final lastName = prefs.getString('lastName');

    if (userId != null && username != null && token != null && accountNumber != null && firstName != null && lastName != null) {
      return User(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        username: username,
        token: token,
        accountNumber: accountNumber,
      );
    }
    return null; // Return null if data is not found
  }

  // Clear user data from SharedPreferences
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('username');
    await prefs.remove('token');
    await prefs.remove('accountNumber');
    await prefs.remove('firstName');
    await prefs.remove('lastName');
    await prefs.remove('transactions');
    await prefs.remove('balance');
  }
}
