import 'package:flutter/material.dart';
import '../screens/login_screen.dart';  // Import the LoginScreen
import '../../repositories/wallet_repository.dart';
import '../../repositories/shared_preferences_repository.dart';

class LogoutButton extends StatelessWidget {
final SharedPreferencesRepository _sharedPreferencesRepository = SharedPreferencesRepository();

LogoutButton({
    Key? key
  }) : super(key: key);

  Future<void> _logOut() async {
    await _sharedPreferencesRepository.clearUserData();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _logOut();
              // Navigate to LoginScreen when logout button is pressed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          );
  }
}
