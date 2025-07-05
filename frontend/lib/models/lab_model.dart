class Lab {
  final int id;
  final String nombre;
  final int capacidad;
  final int equipos;
  final String ubicacion;
  final Map<String, Map<String, Reservation>> reservas;

  Lab({
    required this.id,
    required this.nombre,
    required this.capacidad,
    required this.equipos,
    required this.ubicacion,
    required this.reservas,
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
  final String nombre;
  final String tipo;
  final String estado; // 'disponible', 'ocupado', 'dañado'
  final String ultimoMantenimiento;
  final String? observaciones;
  final bool isOperational;

  Equipment({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.estado,
    required this.ultimoMantenimiento,
    this.observaciones,
    bool? isOperational,
  }) : isOperational = isOperational ?? (estado == 'disponible' || estado == 'ocupado');
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
