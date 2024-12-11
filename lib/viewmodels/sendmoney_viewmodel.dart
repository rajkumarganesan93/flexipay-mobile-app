import 'package:flutter/material.dart';
import '../repositories/transaction_repository.dart';
import '../models/transaction.dart';

class SendMoneyViewModel extends ChangeNotifier {
  final TransactionRepository _repository;
  String recipientName = '';
  String accountNumber = '';
  String amount = '';
  String? errorMessage;
  bool isLoading = false;
  String? transactionResponse;
  Transaction _transaction;

 SendMoneyViewModel(this._repository): _transaction = Transaction(
   amount: '',
   description: '',
      transactionType: '',
      transactionDate: '',
      recipientName: '',
      accountNumber: '',
      userId: '',
 );

Transaction get transactions => _transaction;

  // Method to update recipient name
  void updateRecipientName(String value) {
    recipientName = value;
    notifyListeners();
  }

  // Method to update account number
  void updateAccountNumber(String value) {
    accountNumber = value;
    notifyListeners();
  }

  // Method to update amount
  void updateAmount(String value) {
    amount = value;
    notifyListeners();
  }

  // Method to handle sending money
  Future<void> sendMoney() async {
    isLoading = true;
    notifyListeners();

    try {
      // Simulating an API call (you can replace this with actual API call)
      await Future.delayed(Duration(seconds: 2));
      _transaction = await _repository.sendMoney(500, recipientName, accountNumber);

      // Mock API Response
      transactionResponse = '''
        Transaction completed successfully.
        Amount: \$${amount}
        Recipient: ${recipientName}
        Account Number: ${accountNumber}
      ''';

      errorMessage = null;  // Clear any previous error message
    } catch (error) {
      errorMessage = 'Failed to send money: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
