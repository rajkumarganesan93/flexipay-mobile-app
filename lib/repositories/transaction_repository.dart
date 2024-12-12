import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_handler.dart';
import '../config/api_config.dart';
import '../models/transaction.dart';
import '../models/user.dart';
import '../repositories/shared_preferences_repository.dart';
import '../repositories/offline_repository.dart';

class TransactionRepository {
  final ApiHandler _apiServices = ApiHandler();
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
      //sendRequest(Method, Url, Body)
      final response = await _apiServices.sendRequest(MethodType.get, (ApiConfig.fetchTransactions + "?accountNumber=" + accountNumber), {});

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
    await Future.delayed(const Duration(seconds: 1));

    // Send data to API for transaction processing
    final sendThisData = Transaction(
      id:0,
      accountNumber: accountNumber,
      amount: amount.toString(),
      description: 'Transfer to $recipientName',
      recipientName: recipientName,
      transactionDate: DateTime.now().toString().split(' ')[0],
      transactionId: 0,
      transactionType: 'Sent',
      userId: "",
    );

    // Fake API used here; update to real API structure for integration.
    final response = await _apiServices.sendRequest(MethodType.post, (ApiConfig.fetchTransactions), sendThisData.toJson());

    // Simulating a successful response, you can modify this according to the real API
    // Here we create a transaction mock response
    final dynamic jsonData = jsonDecode(response.body);
    return Transaction(
      id: jsonData['id'],
      transactionId: 1,
      amount: jsonData['amount'].toString(),
      description: 'Transfer to $recipientName',
      transactionType: 'Sent',
      transactionDate: DateTime.now().toString().split(' ')[0],
      recipientName: jsonData['recipientName'],
      accountNumber: jsonData['accountNumber'],
      userId: "",
    );
  }
}
