class User {
  final String accountNumber;
  final String firstName;
  final String lastName;
  final String token;
  final int userId;
  final String username;

  User(
    {
      required this.accountNumber,
      required this.firstName,
      required this.lastName,
      required this.token,
      required this.userId,
      required this.username
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accountNumber: json['accountNumber'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      token: json['token'],
      userId: json['userId'],
      username: json['username'],
    );
  }
}
