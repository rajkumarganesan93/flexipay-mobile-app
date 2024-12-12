import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flexipay/viewmodels/transaction_viewmodel.dart';
import '../widgets/logout_button.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch transactions when screen is loaded
    _loadTransactions();
  }

  // Function to load transactions
  Future<void> _loadTransactions() async {
    await Provider.of<TransactionViewModel>(context, listen: false).fetchTransactions();
  }

  // Function to refresh transactions
  Future<void> _refreshTransactions() async {
    await _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          LogoutButton()
        ],
      ),
      body: Consumer<TransactionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          }

          final transactions = viewModel.transactions;

          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          return RefreshIndicator(
            onRefresh: _refreshTransactions,
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      '\$${transaction.amount}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction.transactionType == 'Received'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(transaction.description),
                        Text(
                          'Date: ${transaction.transactionDate}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Text(
                      transaction.transactionType,
                      style: TextStyle(
                        color: transaction.transactionType == 'Received'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
