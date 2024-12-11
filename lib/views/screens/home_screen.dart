import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';  // Import the LoginScreen
import 'send_money_screen.dart'; // Import the SendMoneyScreen
import 'transactions_screen.dart'; // Import the TransactionsScreen
import '../../models/user.dart';
import '../../repositories/wallet_repository.dart';
import '../../repositories/offline_repository.dart';
import '../../repositories/transaction_repository.dart';
import '../../repositories/shared_preferences_repository.dart';
import '../widgets/logout_button.dart';
import 'package:flexipay/viewmodels/connectivity_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceVisible = false;
  String _walletBalance = "0.0";
  User? currentUserData;
  String firstName = "";
  final WalletRepository walletRepository = WalletRepository();
  final TransactionRepository transactionRepository = TransactionRepository();
  final OfflineRepository offlineRepository = OfflineRepository();
  final SharedPreferencesRepository currentUserDataRepository = SharedPreferencesRepository();

@override
  void initState() {
    super.initState();
    fetchWalletBalance();
    getCurrentUserData();
  }

// Function to fetch wallet balance from the repository
  Future<void> fetchWalletBalance() async {
    try {
      String balance = await walletRepository.fetchWalletBalance();
      getCurrentUserData();
      await transactionRepository.fetchTransactions();
      setState(() {
        _walletBalance = balance;
      });
    } catch (e) {
      setState(() {
        _walletBalance = "0.00";
      });
    }
  }

// Function to fetch wallet balance from the Local Storage
  Future<void> fetchWalletBalanceFromLocalStorage() async {
    try {
      String balance = await offlineRepository.loadBalanceFromLocal();
      getCurrentUserData();
      await transactionRepository.fetchTransactions();
      setState(() {
        _walletBalance = balance;
      });
    } catch (e) {
      setState(() {
        _walletBalance = "0.00";
      });
    }
  }

  // Function to fetch current user data from the Local Storage
  Future<void> getCurrentUserData() async {
    try {
      User? tempUserData = await currentUserDataRepository.getUserData();
      setState(() {
        currentUserData = tempUserData;
        if(tempUserData != null){
        firstName = tempUserData.firstName;
        }
      });
    } catch (e) {
      setState(() {
        currentUserData = null;
        firstName = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityViewModel = Provider.of<ConnectivityViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.green,
        actions: [
          // Logout button in AppBar
          LogoutButton()
        ],
      ),
      body: RefreshIndicator(
        onRefresh: !connectivityViewModel.isConnected ? fetchWalletBalanceFromLocalStorage : fetchWalletBalance,
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance Card
            Card(
              color: Colors.green,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, " + firstName,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Wallet Balance",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isBalanceVisible
                              ? "\$${_walletBalance}"
                              : "****", // Masked by default
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isBalanceVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isBalanceVisible = !_isBalanceVisible;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Send Money and Transactions Buttons
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to SendMoneyScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SendMoneyScreen()),
                      );
                    },
                    child: const Text("Send Money"),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to TransactionsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TransactionsScreen()),
                      );
                    },
                    child: const Text("Transactions"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      ),
    );
  }
}
