import 'package:flutter/material.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/offline_repository.dart';
import '../models/transaction.dart';
import 'connectivity_viewmodel.dart';

class TransactionViewModel extends ChangeNotifier {
  final TransactionRepository _repository;
  final OfflineRepository _offlineRepository = OfflineRepository();
  final ConnectivityViewModel _connectivityViewModel = ConnectivityViewModel();

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  TransactionViewModel(this._repository);

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      if (!_connectivityViewModel.isConnected) {
        _transactions = await _offlineRepository.loadTransactionsFromLocal();
        print("No internet connection");
      } else {
        _transactions = await _repository.fetchTransactions();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
