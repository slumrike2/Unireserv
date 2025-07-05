import '../models/lab_model.dart';

class LabData {
  static List<Lab> getLabs() {
    return [
      Lab(
        id: 1,
        nombre: "Laboratorio de Computación A",
        capacidad: 30,
        equipos: 25,
        ubicacion: "Piso 2 - Ala Norte",
        reservas: {
          "2025-01-06": {
            "10:00": Reservation(tipo: "total", equipos: 25, duracion: 2),
            "14:00": Reservation(tipo: "parcial", equipos: 12, duracion: 1),
          },
          "2025-01-07": {
            "08:00": Reservation(tipo: "total", equipos: 25, duracion: 3),
            "15:00": Reservation(tipo: "parcial", equipos: 8, duracion: 2),
          },
          "2025-01-08": {
            "09:00": Reservation(tipo: "parcial", equipos: 15, duracion: 2),
            "13:00": Reservation(tipo: "parcial", equipos: 6, duracion: 1),
            "16:00": Reservation(tipo: "total", equipos: 25, duracion: 2),
          },
          "2025-01-09": {
            "07:00": Reservation(tipo: "parcial", equipos: 4, duracion: 1),
            "11:00": Reservation(tipo: "total", equipos: 25, duracion: 3),
          },
          "2025-01-10": {
            "08:00": Reservation(tipo: "total", equipos: 25, duracion: 4),
            "15:00": Reservation(tipo: "parcial", equipos: 10, duracion: 3),
          },
        },
      ),
      Lab(
        id: 2,
        nombre: "Laboratorio de Electrónica",
        capacidad: 20,
        equipos: 15,
        ubicacion: "Piso 1 - Ala Sur",
        reservas: {
          "2025-01-06": {
            "09:00": Reservation(tipo: "total", equipos: 15, duracion: 2),
            "15:00": Reservation(tipo: "parcial", equipos: 8, duracion: 2),
          },
          "2025-01-07": {
            "07:00": Reservation(tipo: "parcial", equipos: 3, duracion: 1),
            "13:00": Reservation(tipo: "total", equipos: 15, duracion: 3),
          },
        },
      ),
      Lab(
        id: 3,
        nombre: "Sala de Conferencias Premium",
        capacidad: 50,
        equipos: 8,
        ubicacion: "Piso 3 - Centro",
        reservas: {
          "2025-01-06": {
            "11:00": Reservation(tipo: "total", equipos: 8, duracion: 2),
          },
          "2025-01-07": {
            "09:00": Reservation(tipo: "total", equipos: 8, duracion: 4),
            "16:00": Reservation(tipo: "parcial", equipos: 4, duracion: 2),
          },
        },
      ),
    ];
  }

  static List<Equipment> getEquipmentForLab(int labId) {
    switch (labId) {
      case 1:
        return [
          Equipment(id: 1, nombre: "PC-001", tipo: "Computadora", estado: "disponible", ultimoMantenimiento: "2024-12-15"),
          Equipment(id: 2, nombre: "PC-002", tipo: "Computadora", estado: "ocupado", ultimoMantenimiento: "2024-12-10"),
          Equipment(id: 3, nombre: "PC-003", tipo: "Computadora", estado: "disponible", ultimoMantenimiento: "2024-12-20"),
          Equipment(id: 4, nombre: "PC-004", tipo: "Computadora", estado: "dañado", ultimoMantenimiento: "2024-11-30"),
          Equipment(id: 5, nombre: "PC-005", tipo: "Computadora", estado: "disponible", ultimoMantenimiento: "2024-12-18"),
          Equipment(id: 11, nombre: "PROJ-001", tipo: "Proyector", estado: "disponible", ultimoMantenimiento: "2024-12-05"),
          Equipment(id: 12, nombre: "PROJ-002", tipo: "Proyector", estado: "dañado", ultimoMantenimiento: "2024-11-25"),
          Equipment(id: 13, nombre: "AUDIO-001", tipo: "Sistema Audio", estado: "disponible", ultimoMantenimiento: "2024-12-08"),
        ];
      case 2:
        return [
          Equipment(id: 16, nombre: "ELEC-001", tipo: "Osciloscopio", estado: "disponible", ultimoMantenimiento: "2024-12-10"),
          Equipment(id: 17, nombre: "ELEC-002", tipo: "Osciloscopio", estado: "ocupado", ultimoMantenimiento: "2024-12-15"),
          Equipment(id: 18, nombre: "ELEC-003", tipo: "Multímetro", estado: "disponible", ultimoMantenimiento: "2024-12-20"),
          Equipment(id: 19, nombre: "ELEC-004", tipo: "Multímetro", estado: "dañado", ultimoMantenimiento: "2024-11-28"),
        ];
      case 3:
        return [
          Equipment(id: 24, nombre: "CONF-001", tipo: "Proyector 4K", estado: "disponible", ultimoMantenimiento: "2024-12-15"),
          Equipment(id: 25, nombre: "CONF-002", tipo: "Sistema Audio", estado: "disponible", ultimoMantenimiento: "2024-12-10"),
          Equipment(id: 26, nombre: "CONF-003", tipo: "Cámara", estado: "ocupado", ultimoMantenimiento: "2024-12-08"),
        ];
      default:
        return [];
    }
  }

  static List<String> getHours() {
    return [
      "07:00", "08:00", "09:00", "10:00", "11:00", "12:00",
      "13:00", "14:00", "15:00", "16:00", "17:00", "18:00"
    ];
  }

  static List<Map<String, String>> getWeekDays() {
    return [
      {"nombre": "Lun", "fecha": "2025-01-06"},
      {"nombre": "Mar", "fecha": "2025-01-07"},
      {"nombre": "Mié", "fecha": "2025-01-08"},
      {"nombre": "Jue", "fecha": "2025-01-09"},
      {"nombre": "Vie", "fecha": "2025-01-10"},
    ];
  }
}
