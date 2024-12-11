import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme_config.dart';

//REPOSITORIES
import 'repositories/transaction_repository.dart';
import 'repositories/shared_preferences_repository.dart';

//VIEW MODELS
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/transaction_viewmodel.dart';
import 'viewmodels/sendmoney_viewmodel.dart';
import 'viewmodels/connectivity_viewmodel.dart';

//VIEWS
import 'views/screens/splash_screen.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/send_money_screen.dart';
import 'views/screens/transactions_screen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(SharedPreferencesRepository())),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => TransactionViewModel(TransactionRepository())),
        ChangeNotifierProvider(create: (_) => SendMoneyViewModel(TransactionRepository())),
        ChangeNotifierProvider(create: (_) => ConnectivityViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Example',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: ThemeMode.system,
      scaffoldMessengerKey: scaffoldMessengerKey,
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/transactions': (context) => TransactionsScreen(),
        '/sendmoney': (context) => SendMoneyScreen(),
      },
    );
  }
}
