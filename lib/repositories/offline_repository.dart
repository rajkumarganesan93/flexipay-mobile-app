import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/transaction.dart';

class OfflineRepository {
  // Save wallet balance to SharedPreferences
  Future<void> storeBalanceInLocalStorage(String balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('balance', balance);
  }

  // Retrieve transactions from SharedPreferences
  Future<String> loadBalanceFromLocal() async {
    String walletBalance = "0.0";
    final prefs = await SharedPreferences.getInstance();
    final String? balance = prefs.getString('balance');
    if (balance != null) {
      return balance;
    }else{
      return walletBalance;
    }
  }

  // Save Transactions to SharedPreferences
  Future<void> storeTransactions(String _transactions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transactions', _transactions);
  }

  // Retrieve transactions from SharedPreferences
  Future<List<Transaction>> loadTransactionsFromLocal() async {
      List<Transaction> _transactions = [];
    final prefs = await SharedPreferences.getInstance();
    final String? jsonTransactions = prefs.getString('transactions');
    if (jsonTransactions != null) {
        final List<dynamic> jsonData = jsonDecode(jsonTransactions);
        return jsonData.map((item) => Transaction.fromJson(item)).toList();
    }else{
        return _transactions;
    }
  }
}
