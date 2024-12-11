import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../repositories/shared_preferences_repository.dart';
import '../repositories/offline_repository.dart';

class TransactionRepository {
  final SharedPreferencesRepository _sharedPreferencesRepository = SharedPreferencesRepository();
  final OfflineRepository _offlineRepository = OfflineRepository();
  Future<List<Transaction>> fetchTransactions() async {
    try {

      User? currentUser = await _sharedPreferencesRepository.getUserData();
      var accountNumber = null;
      if (currentUser != null) {
        // If the current session has Account Number
        accountNumber = currentUser.accountNumber;
      } else {
        // If the current session has not Account Number
        throw Exception('Failed to fetching transactions');
      }

      final response = await http.get(Uri.parse(ApiConfig.fetchTransactions + "?accountNumber=" + accountNumber));

      if (response.statusCode == 200) {
        //Store transaction data in SharedPreferences;
        await _offlineRepository.storeTransactions(response.body);
        //Convert the Response to Transaction Model and return;
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((item) => Transaction.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch transactions. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  // Simulate an API call for sending money
  Future<Transaction> sendMoney(double amount, String recipientName, String accountNumber) async {
    // Simulating a network request delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulating a successful response, you can modify this according to the real API
    // Here we create a transaction mock response
    return Transaction(
      amount: amount.toString(),
      description: 'Transfer to $recipientName',
      transactionType: 'Sent',
      transactionDate: DateTime.now().toString().split(' ')[0],
      recipientName: recipientName,
      accountNumber: accountNumber,
      userId: "",
    );
  }
}
