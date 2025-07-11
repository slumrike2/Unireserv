import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['AUTH_SERVICE_URL']}/token'),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchUsers(String accessToken) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['AUTH_SERVICE_URL']}/users?skip=0&limit=100'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch users: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['AUTH_SERVICE_URL']}/register'),
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register user: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchCurrentUser(String accessToken) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['AUTH_SERVICE_URL']}/users/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch current user: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchSpecificUser(
      String accessToken, String userId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['AUTH_SERVICE_URL']}/users/$userId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user $userId: ${response.statusCode}');
    }
  }

  Future<bool> checkServiceStatus() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['AUTH_SERVICE_URL']}/'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['status'] == 'running';
    } else {
      throw Exception('Failed to check service status: ${response.statusCode}');
    }
  }
}
