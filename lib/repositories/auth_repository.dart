import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config/api_config.dart';

class AuthRepository {
  Future<User?> login(String username, String password) async {
    // TODO: This is a temporary solution. User validation should be handled via the API.
    // Currently using fake APIs with GET method; will switch to POST for real APIs.
    // The code needs to be updated once the API validation is implemented and completed.

    final response = await http.get(Uri.parse(ApiConfig.getUsers));

    if (response.statusCode == 200) {
      List<dynamic> users = json.decode(response.body);
      final user = users.firstWhere(
        (user) => user['username'].toLowerCase() == username.toLowerCase(),
        orElse: () => null,
      );

      if (user != null) {
        return User(
          accountNumber: user['accountNumber'],
          firstName: user['firstName'],
          lastName: user['lastName'],
          token: "fake-token-${user['id']}",
          userId: user['userId'],
          username: user['username']
          );
      } else {
        throw Exception("Invalid username or password");
      }
    } else {
      throw Exception("Failed to fetch users");
    }
  }
}
