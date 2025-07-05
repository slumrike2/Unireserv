import '../models/admin_models.dart';

class AdminData {
  static AdminStats getAdminStats() {
    return AdminStats(
      reservasHoy: 4,
      equiposActivos: 38,
      ocupacion: 15,
      mantenimiento: 3,
    );
  }

  static List<TodayReservation> getTodayReservations() {
    return [
      TodayReservation(
        id: 1,
        cliente: "Juan Pérez",
        laboratorio: "Lab. Computación A",
        hora: "10:00-12:00",
        equipos: 15,
        estado: "activa",
      ),
      TodayReservation(
        id: 2,
        cliente: "María García",
        laboratorio: "Lab. Electrónica",
        hora: "14:00-16:00",
        equipos: 8,
        estado: "activa",
      ),
      TodayReservation(
        id: 3,
        cliente: "Carlos López",
        laboratorio: "Sala Conferencias",
        hora: "09:00-11:00",
        equipos: 6,
        estado: "completada",
      ),
      TodayReservation(
        id: 4,
        cliente: "Ana Martínez",
        laboratorio: "Lab. Computación A",
        hora: "15:00-17:00",
        equipos: 12,
        estado: "pendiente",
      ),
    ];
  }

  static List<EquipmentStatus> getEquipmentStatus() {
    return [
      EquipmentStatus(
        laboratorio: "Lab. Computación A",
        total: 25,
        disponibles: 18,
        ocupados: 5,
        danados: 2,
      ),
      EquipmentStatus(
        laboratorio: "Lab. Electrónica",
        total: 15,
        disponibles: 12,
        ocupados: 2,
        danados: 1,
      ),
      EquipmentStatus(
        laboratorio: "Sala Conferencias",
        total: 8,
        disponibles: 8,
        ocupados: 0,
        danados: 0,
      ),
    ];
  }

  static List<WeeklyUsage> getWeeklyUsage() {
    return [
      WeeklyUsage(day: "Lunes", percentage: 85),
      WeeklyUsage(day: "Martes", percentage: 92),
      WeeklyUsage(day: "Miércoles", percentage: 78),
      WeeklyUsage(day: "Jueves", percentage: 88),
      WeeklyUsage(day: "Viernes", percentage: 95),
    ];
  }

  static List<LabUsage> getLabUsage() {
    return [
      LabUsage(name: "Lab. Computación A", percentage: 45),
      LabUsage(name: "Lab. Electrónica", percentage: 35),
      LabUsage(name: "Sala Conferencias", percentage: 20),
    ];
  }
}
