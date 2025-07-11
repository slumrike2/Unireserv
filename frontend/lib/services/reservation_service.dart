import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/lab_model.dart';

class ReservationService {
  /// Create a new reservation
  Future<Map<String, dynamic>> createReservation(
      Map<String, dynamic> reservationData) async {
    final url = dotenv.env['RESERVATION_SERVICE_URL'];
    if (url == null) throw Exception('RESERVATION_SERVICE_URL not set in .env');
    final response = await http.post(
      Uri.parse('$url/reservations'),
      body: json.encode(reservationData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create reservation: ${response.statusCode}');
    }
  }

  /// Fetch all reservations (optionally by user, laboratory, or equipment)
  Future<List<Reservation>> fetchReservations(
      {int? userId, int? laboratoryId, int? computerId}) async {
    final url = dotenv.env['RESERVATION_SERVICE_URL'];
    if (url == null) throw Exception('RESERVATION_SERVICE_URL not set in .env');
    String endpoint = '$url/reservations?';
    if (userId != null) endpoint += 'user_id=$userId&';
    if (laboratoryId != null) endpoint += 'laboratory_id=$laboratoryId&';
    if (computerId != null) endpoint += 'computer_id=$computerId&';
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Reservation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch reservations');
    }
  }

  /// Fetch a specific reservation by ID
  Future<Reservation> fetchReservationById(int reservationId) async {
    final url = dotenv.env['RESERVATION_SERVICE_URL'];
    if (url == null) throw Exception('RESERVATION_SERVICE_URL not set in .env');
    final response =
        await http.get(Uri.parse('$url/reservations/$reservationId'));
    if (response.statusCode == 200) {
      return Reservation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to fetch reservation $reservationId: ${response.statusCode}');
    }
  }

  /// Update reservation status
  Future<Map<String, dynamic>> updateReservation(
      int reservationId, Map<String, dynamic> updateData) async {
    final url = dotenv.env['RESERVATION_SERVICE_URL'];
    if (url == null) throw Exception('RESERVATION_SERVICE_URL not set in .env');
    final response = await http.put(
      Uri.parse('$url/reservations/$reservationId'),
      body: json.encode(updateData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to update reservation $reservationId: ${response.statusCode}');
    }
  }

  /// Delete reservation
  Future<void> deleteReservation(int reservationId) async {
    final url = dotenv.env['RESERVATION_SERVICE_URL'];
    if (url == null) throw Exception('RESERVATION_SERVICE_URL not set in .env');
    final response =
        await http.delete(Uri.parse('$url/reservations/$reservationId'));
    if (response.statusCode != 204) {
      throw Exception(
          'Failed to delete reservation $reservationId: ${response.statusCode}');
    }
  }
}
