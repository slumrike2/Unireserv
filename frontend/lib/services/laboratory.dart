import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/lab_model.dart';

class LaboratoryService {
  /// Create a new laboratory
  Future<Map<String, dynamic>> createLaboratory(
      Map<String, dynamic> labData) async {
    final url = dotenv.env['LABORATORY_SERVICE_URL'];
    if (url == null) throw Exception('LABORATORY_SERVICE_URL not set in .env');

    final response = await http.post(
      Uri.parse('$url/laboratories'),
      body: json.encode(labData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create laboratory: ${response.statusCode}');
    }
  }

  /// Fetch all laboratories
  Future<List<Laboratory>> fetchLaboratories() async {
    final url = dotenv.env['LABORATORY_SERVICE_URL'];
    if (url == null) throw Exception('LABORATORY_SERVICE_URL not set in .env');

    final response = await http.get(Uri.parse('$url/laboratories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Laboratory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch laboratories');
    }
  }

  /// Fetch a specific laboratory by ID
  Future<Laboratory> fetchLaboratoryById(String labId) async {
    final url = dotenv.env['LABORATORY_SERVICE_URL'];
    if (url == null) throw Exception('LABORATORY_SERVICE_URL not set in .env');

    final response = await http.get(Uri.parse('$url/laboratories/$labId'));
    if (response.statusCode == 200) {
      return Laboratory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to fetch laboratory $labId: ${response.statusCode}');
    }
  }

  /// Update a laboratory
  Future<Map<String, dynamic>> updateLaboratory(
      String labId, Map<String, dynamic> labData) async {
    final url = dotenv.env['LABORATORY_SERVICE_URL'];
    if (url == null) throw Exception('LABORATORY_SERVICE_URL not set in .env');

    final response = await http.put(
      Uri.parse('$url/laboratories/$labId'),
      body: json.encode(labData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to update laboratory $labId: ${response.statusCode}');
    }
  }

  /// Delete a laboratory
  Future<void> deleteLaboratory(String labId) async {
    final url = dotenv.env['LABORATORY_SERVICE_URL'];
    if (url == null) throw Exception('LABORATORY_SERVICE_URL not set in .env');

    final response = await http.delete(Uri.parse('$url/laboratories/$labId'));
    if (response.statusCode != 204) {
      throw Exception(
          'Failed to delete laboratory $labId: ${response.statusCode}');
    }
  }
}
