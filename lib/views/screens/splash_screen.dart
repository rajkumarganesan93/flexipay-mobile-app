import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flexipay/viewmodels/auth_viewmodel.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return FutureBuilder<bool>(
      future: authViewModel.checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          final isLoggedIn = snapshot.data ?? false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              isLoggedIn ? '/home' : '/login',
            );
          });
          return const SizedBox.shrink();
        }
      },
    );
  }
}
