import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  final Connectivity _connectivity = Connectivity();

  ConnectivityViewModel() {
    _checkInitialConnectivity();
    _listenToConnectivityChanges();
  }

  // Check initial connectivity
  Future<void> _checkInitialConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(connectivityResult);
  }

  // Listen to connectivity changes
  void _listenToConnectivityChanges() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      final wasConnected = _isConnected;
      _isConnected = result != ConnectivityResult.none;

      // Show Snackbar only if the connection status changes
      if (wasConnected != isConnected) {
        _showConnectivitySnackbar();
      }

      _updateConnectivityStatus(result);
    });
  }

void _showConnectivitySnackbar() {
    final message = isConnected
        ? "You're back online!"
        : "No internet connection.";

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Update connectivity status
  void _updateConnectivityStatus(ConnectivityResult result) {
    _isConnected = result != ConnectivityResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivity.onConnectivityChanged.drain();
    super.dispose();
  }
}
