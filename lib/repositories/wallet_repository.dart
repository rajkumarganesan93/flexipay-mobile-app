import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_handler.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../repositories/shared_preferences_repository.dart';
import '../repositories/offline_repository.dart';

// Repository Class to fetch Wallet Balance
class WalletRepository {
  final ApiHandler _apiServices = ApiHandler();
  final SharedPreferencesRepository _sharedPreferencesRepository = SharedPreferencesRepository();
  final OfflineRepository _offlineRepository = OfflineRepository();
  // Function to fetch wallet balance from a fake API
  Future<String> fetchWalletBalance() async {
    try {
      User? currentUser = await _sharedPreferencesRepository.getUserData();
      var accountNumber = null;
      if (currentUser != null) {
        // If the current session has Account Number
        accountNumber = currentUser.accountNumber;
      } else {
        // If the current session has not Account Number
        throw Exception('Failed to load balance');
      }

      // Fake API URL
      final response = await _apiServices.sendRequest(MethodType.get, (ApiConfig.fetchWalletBalance + "?accountNumber=" + accountNumber), {});

      if (response.statusCode == 200) {
        // If the API returns a successful response
        var data = jsonDecode(response.body)[0];
        //Store transaction data in local storage;
        await _offlineRepository.storeBalanceInLocalStorage(data['balance'].toString());
        return data['balance'].toString();
      } else {
        // If the response is not successful, throw an error
        throw Exception('Failed to load balance');
      }
    } catch (e) {
      // Handle any errors during the HTTP request
      throw Exception('Error fetching balance: $e');
    }
  }
}
