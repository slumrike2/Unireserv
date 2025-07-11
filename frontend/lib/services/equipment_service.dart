import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/lab_model.dart';

class EquipmentService {
  /// Create a new equipment
  Future<Map<String, dynamic>> createEquipment(
      Map<String, dynamic> equipmentData) async {
    final url = dotenv.env['EQUIPMENT_SERVICE_URL'];
    if (url == null) throw Exception('EQUIPMENT_SERVICE_URL not set in .env');

    final response = await http.post(
      Uri.parse('$url/equipments'),
      body: json.encode(equipmentData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create equipment: ${response.statusCode}');
    }
  }

  /// Fetch all equipments (optionally by laboratory)
  Future<List<Equipment>> fetchEquipments({int? laboratoryId}) async {
    final url = dotenv.env['EQUIPMENT_SERVICE_URL'];
    if (url == null) throw Exception('EQUIPMENT_SERVICE_URL not set in .env');
    String endpoint = '$url/equipments';
    if (laboratoryId != null) {
      endpoint += '?laboratory_id=$laboratoryId';
    }
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Equipment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch equipments');
    }
  }

  /// Fetch a specific equipment by ID
  Future<Equipment> fetchEquipmentById(int equipmentId) async {
    final url = dotenv.env['EQUIPMENT_SERVICE_URL'];
    if (url == null) throw Exception('EQUIPMENT_SERVICE_URL not set in .env');
    final response = await http.get(Uri.parse('$url/equipments/$equipmentId'));
    if (response.statusCode == 200) {
      return Equipment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to fetch equipment $equipmentId: ${response.statusCode}');
    }
  }

  /// Update equipment
  Future<Map<String, dynamic>> updateEquipment(
      int equipmentId, Map<String, dynamic> equipmentData) async {
    final url = dotenv.env['EQUIPMENT_SERVICE_URL'];
    if (url == null) throw Exception('EQUIPMENT_SERVICE_URL not set in .env');
    final response = await http.put(
      Uri.parse('$url/equipments/$equipmentId'),
      body: json.encode(equipmentData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to update equipment $equipmentId: ${response.statusCode}');
    }
  }

  /// Delete equipment
  Future<void> deleteEquipment(int equipmentId) async {
    final url = dotenv.env['EQUIPMENT_SERVICE_URL'];
    if (url == null) throw Exception('EQUIPMENT_SERVICE_URL not set in .env');
    final response =
        await http.delete(Uri.parse('$url/equipments/$equipmentId'));
    if (response.statusCode != 204) {
      throw Exception(
          'Failed to delete equipment $equipmentId: ${response.statusCode}');
    }
  }
}
