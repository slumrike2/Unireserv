import '../models/lab_model.dart';

class LabData {
  /// Returns a Reservation for a given lab, date, and hour, or null if none exists.
  static Reservation? getReservationForLab(
      int labId, String fecha, String hora) {
    // Datos de prueba para 2 semanas (2025-01-06 a 2025-01-17)
    // Semana 1: 2025-01-06 (Lun) a 2025-01-10 (Vie)
    // Semana 2: 2025-01-13 (Lun) a 2025-01-17 (Vie)
    // Ejemplo: algunos slots reservados total/parcial para lab 1 y lab 2
    if (labId == 1 && fecha == "2025-01-07" && hora == "09:00") {
      return Reservation(tipo: "total", equipos: 3, duracion: 1);
    }
    if (labId == 1 && fecha == "2025-01-07" && hora == "10:00") {
      return Reservation(tipo: "parcial", equipos: 1, duracion: 1);
    }
    if (labId == 1 && fecha == "2025-01-14" && hora == "11:00") {
      return Reservation(tipo: "total", equipos: 4, duracion: 1);
    }
    if (labId == 2 && fecha == "2025-01-08" && hora == "08:00") {
      return Reservation(tipo: "parcial", equipos: 1, duracion: 1);
    }
    if (labId == 2 && fecha == "2025-01-15" && hora == "10:00") {
      return Reservation(tipo: "total", equipos: 2, duracion: 1);
    }
    // Puedes agregar más casos de prueba aquí
    return null;
  }

  static List<Laboratory> getLaboratories() {
    return [
      Laboratory(
        id: 1,
        name: "Laboratorio de Computación A",
        location: "Piso 2 - Ala Norte",
        capacity: 30,
        openTime: "07:00",
        closeTime: "18:00",
        isActive: true,
        createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
        updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
      ),
      Laboratory(
        id: 2,
        name: "Laboratorio de Electrónica",
        location: "Piso 1 - Ala Sur",
        capacity: 20,
        openTime: "08:00",
        closeTime: "17:00",
        isActive: true,
        createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
        updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
      ),
      Laboratory(
        id: 3,
        name: "Sala de Conferencias Premium",
        location: "Piso 3 - Centro",
        capacity: 50,
        openTime: "09:00",
        closeTime: "20:00",
        isActive: true,
        createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
        updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
      ),
    ];
  }

  static List<Equipment> getEquipmentForLab(int laboratoryId) {
    switch (laboratoryId) {
      case 1:
        return [
          Equipment(
            id: 1,
            laboratoryId: 1,
            numEquipment: "PC-001",
            status: "available",
            description: "Computadora de escritorio",
            createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
            updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
          ),
          Equipment(
            id: 2,
            laboratoryId: 1,
            numEquipment: "PC-002",
            status: "unavailable",
            description: "Computadora de escritorio",
            createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
            updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
          ),
          Equipment(
            id: 3,
            laboratoryId: 1,
            numEquipment: "PC-003",
            status: "available",
            description: "Computadora de escritorio",
            createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
            updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
          ),
          Equipment(
            id: 4,
            laboratoryId: 1,
            numEquipment: "PC-004",
            status: "maintenance",
            description: "Computadora de escritorio",
            createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
            updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
          ),
        ];
      case 2:
        return [
          Equipment(
            id: 5,
            laboratoryId: 2,
            numEquipment: "ELEC-001",
            status: "available",
            description: "Osciloscopio",
            createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
            updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
          ),
          Equipment(
            id: 6,
            laboratoryId: 2,
            numEquipment: "ELEC-002",
            status: "unavailable",
            description: "Osciloscopio",
            createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
            updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
          ),
        ];
      case 3:
        return [
          Equipment(
            id: 7,
            laboratoryId: 3,
            numEquipment: "CONF-001",
            status: "available",
            description: "Proyector 4K",
            createdAt: DateTime.parse("2025-01-01T08:00:00Z"),
            updatedAt: DateTime.parse("2025-01-01T08:00:00Z"),
          ),
        ];
      default:
        return [];
    }
  }

  static List<String> getHours() {
    return [
      "07:00",
      "08:00",
      "09:00",
      "10:00",
      "11:00",
      "12:00",
      "13:00",
      "14:00",
      "15:00",
      "16:00",
      "17:00",
      "18:00"
    ];
  }

  static List<Map<String, String>> getWeekDays() {
    // Devuelve 2 semanas (Lun-Vie)
    return [
      // Semana 1
      {"nombre": "Lun", "fecha": "2025-01-06"},
      {"nombre": "Mar", "fecha": "2025-01-07"},
      {"nombre": "Mié", "fecha": "2025-01-08"},
      {"nombre": "Jue", "fecha": "2025-01-09"},
      {"nombre": "Vie", "fecha": "2025-01-10"},
      // Semana 2
      {"nombre": "Lun", "fecha": "2025-01-13"},
      {"nombre": "Mar", "fecha": "2025-01-14"},
      {"nombre": "Mié", "fecha": "2025-01-15"},
      {"nombre": "Jue", "fecha": "2025-01-16"},
      {"nombre": "Vie", "fecha": "2025-01-17"},
    ];
  }

  /// Simula un fetch asíncrono para obtener una reserva
  static Future<Reservation?> fetchReservationForLab(
      int labId, String fecha, String hora) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return getReservationForLab(labId, fecha, hora);
  }

  /// Simula un fetch asíncrono para obtener laboratorios
  static Future<List<Laboratory>> fetchLaboratories() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return getLaboratories();
  }

  /// Simula un fetch asíncrono para obtener equipos de un laboratorio
  static Future<List<Equipment>> fetchEquipmentForLab(int laboratoryId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return getEquipmentForLab(laboratoryId);
  }

  /// Simula un fetch asíncrono para obtener los días de la semana
  static Future<List<Map<String, String>>> fetchWeekDays() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return getWeekDays();
  }

  /// Simula un fetch asíncrono para obtener las horas
  static Future<List<String>> fetchHours() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return getHours();
  }
}
