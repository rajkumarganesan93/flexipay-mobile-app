class Transaction {
  final String amount;
  final String description;
  final String transactionType;
  final String transactionDate;
  final String recipientName;
  final String accountNumber;
  final String userId;

  Transaction({
    required this.amount,
    required this.description,
    required this.transactionType,
    required this.transactionDate,
    required this.recipientName,
    required this.accountNumber,
    required this.userId
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'] ?? '',
      description: json['description'] ?? '',
      transactionType: json['transactionType'] ?? '',
      transactionDate: json['transactionDate'] ?? '',
      recipientName: json['recipientName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}
