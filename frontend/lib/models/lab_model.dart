class Laboratory {
  final int id;
  final String name;
  final String location;
  final int capacity;
  final String openTime;
  final String closeTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Laboratory({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.openTime,
    required this.closeTime,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Reservation {
  final String tipo; // 'total' o 'parcial'
  final int equipos;
  final int duracion;

  Reservation({
    required this.tipo,
    required this.equipos,
    required this.duracion,
  });
}

class Equipment {
  final int id;
  final int laboratoryId;
  final String numEquipment;
  final String status; // 'available', 'unavailable', 'maintenance'
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Equipment({
    required this.id,
    required this.laboratoryId,
    required this.numEquipment,
    required this.status,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });
}

class SelectedSlot {
  final int salonId;
  final String salonNombre;
  final String fecha;
  final String hora;
  final String dia;
  final int equiposDisponibles;

  SelectedSlot({
    required this.salonId,
    required this.salonNombre,
    required this.fecha,
    required this.hora,
    required this.dia,
    required this.equiposDisponibles,
  });
}
