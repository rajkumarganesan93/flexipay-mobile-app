class Transaction {
  final String accountNumber;
  final String amount;
  final String description;
  final int id;
  final String recipientName;
  final String transactionDate;
  final int transactionId;
  final String transactionType;
  final String userId;

  Transaction({
    required this.accountNumber,
    required this.amount,
    required this.description,
    required this.id,
    required this.recipientName,
    required this.transactionDate,
    required this.transactionId,
    required this.transactionType,
    required this.userId
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      accountNumber: json['accountNumber'] ?? '',
      amount: json['amount'] ?? '',
      description: json['description'] ?? '',
      id: json['id'],
      recipientName: json['recipientName'] ?? '',
      transactionDate: json['transactionDate'] ?? '',
      transactionId: json['transactionId'],
      transactionType: json['transactionType'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'amount': amount,
      'description': description,
      'id': id,
      'recipientName': recipientName,
      'transactionDate': transactionDate,
      'transactionId': transactionId,
      'transactionType': transactionType,
      'userId': userId,
    };
}



}
