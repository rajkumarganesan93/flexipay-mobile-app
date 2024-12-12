import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiHandler {

  static final ApiHandler _instance = ApiHandler._internal();
  final http.Client _client = http.Client();

  // Private constructor
  ApiHandler._internal();

  // Factory constructor to return the same instance
  factory ApiHandler() => _instance;


  var restHeader = {
    'Accept': 'application/json',
    'Content-type': 'application/json',
  };

  // Function to send HTTP requests (GET, POST, PUT, DELETE)
  Future<http.Response> sendRequest(MethodType methodType, String url, Map<String, dynamic> params) async {
    try {
      switch (methodType) {
        case MethodType.post:
          return await _client.post(
            Uri.parse(url),
            headers: restHeader,
            body: json.encode(params),
          );
        case MethodType.put:
          return await _client.put(
            Uri.parse(url),
            headers: restHeader,
            body: json.encode(params),
          );
        case MethodType.delete:
          return await _client.delete(
            Uri.parse(url),
            headers: restHeader,
            body: json.encode(params), // Optional body for DELETE requests
          );
        case MethodType.get:
        default:
          return await _client.get(
            Uri.parse(url),
            headers: restHeader,
          );
      }
    } catch (e) {
      throw Exception('Error during HTTP request: $e');
    }
  }
}



// Enum for HTTP methods
enum MethodType { post, get, put, delete }