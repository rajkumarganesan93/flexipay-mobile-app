import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flexipay/viewmodels/sendmoney_viewmodel.dart';
import 'home_screen.dart';
import '../widgets/logout_button.dart';

class SendMoneyScreen extends StatelessWidget {
  SendMoneyScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController accountNumberController = TextEditingController();
    final TextEditingController recipientNameController = TextEditingController();

    final sendMoneyViewModel = Provider.of<SendMoneyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'),
        backgroundColor: Colors.green,
        actions: [
          LogoutButton()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Recipient Name TextField
            TextField(
              controller: recipientNameController,
              decoration: InputDecoration(
                labelText: 'Recipient Name',
              ),
            ),
            // Account Number TextField
            TextField(
              controller: accountNumberController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]+$')),
              ],
              decoration: InputDecoration(
                labelText: 'Account Number',
              ),
            ),
            // Amount TextField
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]+$')),
              ],
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendMoneyViewModel.isLoading
                  ? null
                  : () async {
                    final String amountText = amountController.text;
                    final String recipientText = recipientNameController.text;
                    final String accountNumberText = accountNumberController.text;
                if (recipientText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter Recipient Name")),
                  );
                }else if (accountNumberText.isEmpty || double.tryParse(accountNumberText) == null || double.parse(accountNumberText) <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid Account Number")),
                  );
                }else if (amountText.isEmpty || double.tryParse(amountText) == null || double.parse(amountText) <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid amount")),
                  );
                } 
                else {
                  sendMoneyViewModel.updateAmount(amountText);
                  sendMoneyViewModel.updateRecipientName(recipientText);
                  sendMoneyViewModel.updateAccountNumber(accountNumberText);
                  await sendMoneyViewModel.sendMoney();
                      // Show bottom sheet with success or error message
                      String message = sendMoneyViewModel.errorMessage ??
                          sendMoneyViewModel.transactionResponse ??
                          'No response from API';
                      _showBottomSheet(context, message);
                }
                      
                    },
              child: sendMoneyViewModel.isLoading
                  ? CircularProgressIndicator()
                  : Text('Send Money'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow bottom sheet to be scrollable
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Show an icon based on success or failure
              Icon(
                message.contains('Failed') ? Icons.error : Icons.check_circle,
                color: message.contains('Failed') ? Colors.red : Colors.green,
                size: 40,
              ),
              const SizedBox(height: 10),
              // Display the returned message or transaction details
              Text(
                message,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                  // Navigator.pop(context);
                },
                child: const Text('Go Home'),
              ),
            ],
          ),
        );
      },
    );
  }
}
