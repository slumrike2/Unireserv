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

  factory Laboratory.fromJson(Map<String, dynamic> json) {
    return Laboratory(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
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

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      tipo: json['tipo'] ?? '',
      equipos: json['equipos'] ?? 0,
      duracion: json['duracion'] ?? 0,
    );
  }
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

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      laboratoryId: json['laboratory_id'],
      numEquipment: json['num_equipment'],
      status: json['status'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
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
