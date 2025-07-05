class AdminStats {
  final int reservasHoy;
  final int equiposActivos;
  final int ocupacion;
  final int mantenimiento;

  AdminStats({
    required this.reservasHoy,
    required this.equiposActivos,
    required this.ocupacion,
    required this.mantenimiento,
  });
}

class TodayReservation {
  final int id;
  final String cliente;
  final String laboratorio;
  final String hora;
  final int equipos;
  final String estado;

  TodayReservation({
    required this.id,
    required this.cliente,
    required this.laboratorio,
    required this.hora,
    required this.equipos,
    required this.estado,
  });
}

class EquipmentStatus {
  final String laboratorio;
  final int total;
  final int disponibles;
  final int ocupados;
  final int danados;

  EquipmentStatus({
    required this.laboratorio,
    required this.total,
    required this.disponibles,
    required this.ocupados,
    required this.danados,
  });
}

class WeeklyUsage {
  final String day;
  final int percentage;

  WeeklyUsage({
    required this.day,
    required this.percentage,
  });
}

class LabUsage {
  final String name;
  final int percentage;

  LabUsage({
    required this.name,
    required this.percentage,
  });
}
