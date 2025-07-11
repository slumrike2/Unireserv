import 'package:flutter/material.dart';
import '../models/lab_model.dart';
import '../data/lab_data.dart';

class ScheduleTable extends StatefulWidget {
  final Laboratory lab;
  final List<SelectedSlot> selectedSlots;
  final Function(SelectedSlot) onSlotToggle;
  final int weekIndex;

  const ScheduleTable({
    super.key,
    required this.lab,
    required this.selectedSlots,
    required this.onSlotToggle,
    required this.weekIndex,
  });

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  late final Future<List<dynamic>> _cachedDataFuture;
  late final Future<Map<String, Map<String, Reservation?>>>
      _cachedReservationsFuture;

  @override
  void initState() {
    super.initState();
    _cachedDataFuture = Future.wait([
      LabData.fetchHours(),
      LabData.fetchWeekDays(),
      LabData.fetchEquipmentForLab(widget.lab.id),
    ]);
    _cachedReservationsFuture = _fetchAllReservations();
  }

  Future<Map<String, Map<String, Reservation?>>> _fetchAllReservations() async {
    final weekDays = (await LabData.fetchWeekDays())
        .skip(widget.weekIndex * 5)
        .take(5)
        .toList();
    final hours = await LabData.fetchHours();

    final Map<String, Map<String, Reservation?>> reservations = {};

    for (final day in weekDays) {
      final date = day['fecha']!;
      reservations[date] = {};
      for (final hour in hours) {
        reservations[date]![hour] =
            await LabData.fetchReservationForLab(widget.lab.id, date, hour);
      }
    }

    return reservations;
  }

  bool _isSlotSelected(String fecha, String hora) {
    return widget.selectedSlots.any(
      (s) => s.salonId == widget.lab.id && s.fecha == fecha && s.hora == hora,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _cachedDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: \${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        final hours = snapshot.data![0] as List<String>;
        final allWeekDays = snapshot.data![1] as List<Map<String, String>>;
        final equipmentList = snapshot.data![2] as List<Equipment>;
        final weekDays =
            allWeekDays.skip(widget.weekIndex * 5).take(5).toList();
        final totalEquipos = equipmentList.length;

        return FutureBuilder<Map<String, Map<String, Reservation?>>>(
          future: _cachedReservationsFuture,
          builder: (context, reservationSnapshot) {
            if (reservationSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (reservationSnapshot.hasError) {
              return Center(
                  child: Text('Error: \${reservationSnapshot.error}'));
            } else if (!reservationSnapshot.hasData) {
              return const Center(child: Text('No reservation data available'));
            }

            final reservations = reservationSnapshot.data!;

            return Card(
              color: const Color(0xFF1E293B).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.lab.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 16,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.people,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${widget.lab.capacity} personas',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.computer,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$totalEquipos equipos',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.lab.location,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/equipment/${widget.lab.id}');
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            side: const BorderSide(color: Color(0xFFDC2626)),
                          ),
                          child: const Text('Ver Equipos'),
                        ),
                      ],
                    ),
                  ),

                  // Schedule table - Centered and larger
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width - 64,
                          ),
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              const Color(0xFF1E293B).withOpacity(0.5),
                            ),
                            headingRowHeight: 60, // Increased height
                            dataRowHeight: 80, // Increased height
                            columnSpacing: 20, // More spacing between columns
                            columns: [
                              const DataColumn(
                                label: SizedBox(
                                  width: 60,
                                  child: Text(
                                    'Hora',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              ...weekDays.map((day) => DataColumn(
                                    label: SizedBox(
                                      width: 140, // Fixed width for consistency
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            day['nombre']!,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${DateTime.parse(day['fecha']!).day}/01',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                            rows: hours.map((hour) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Container(
                                      width: 60,
                                      height: 70,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1E293B),
                                        border: Border(
                                          right: BorderSide(
                                              color: Color(0xFF334155)),
                                        ),
                                      ),
                                      child: Text(
                                        hour,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ...weekDays.map((day) {
                                    final isSelected =
                                        _isSlotSelected(day['fecha']!, hour);
                                    final reservation =
                                        reservations[day['fecha']!]![hour];
                                    final equiposDisponibles =
                                        reservation != null
                                            ? totalEquipos - reservation.equipos
                                            : totalEquipos;
                                    return DataCell(
                                      Container(
                                        width: 143, // +3 px
                                        height: 73, // +3 px
                                        margin: const EdgeInsets.all(4),
                                        child: _buildScheduleCell(
                                          reservation,
                                          isSelected,
                                          equiposDisponibles,
                                          day,
                                          hour,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildScheduleCell(
    Reservation? reservation,
    bool isSelected,
    int equiposDisponibles,
    Map<String, String> day,
    String hour,
  ) {
    if (reservation != null) {
      if (reservation.tipo == "total") {
        // Total reservation - not selectable
        return Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${reservation.equipos}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Text(
                'ocupados',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'COMPLETO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // Partial reservation - selectable
        return GestureDetector(
          onTap: () => widget.onSlotToggle(SelectedSlot(
            salonId: widget.lab.id,
            salonNombre: widget.lab.name,
            fecha: day['fecha']!,
            hora: hour,
            dia: day['nombre']!,
            equiposDisponibles: equiposDisponibles,
          )),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.yellow.shade700,
              border:
                  isSelected ? Border.all(color: Colors.green, width: 3) : null,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? Colors.green.withOpacity(0.3)
                      : Colors.yellow.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${reservation.equipos}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'ocupados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '$equiposDisponibles libres',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (isSelected)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'SELECCIONADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'PARCIAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    } else {
      // Available slot
      return GestureDetector(
        onTap: () => widget.onSlotToggle(SelectedSlot(
          salonId: widget.lab.id,
          salonNombre: widget.lab.name,
          fecha: day['fecha']!,
          hora: hour,
          dia: day['nombre']!,
          equiposDisponibles: equiposDisponibles,
        )),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 73,
            maxHeight: 73,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.green : Colors.grey.withOpacity(0.5),
              width: isSelected ? 3 : 1,
              style: BorderStyle.solid,
            ),
            color:
                isSelected ? Colors.green.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.add_circle_outline,
                color: isSelected ? Colors.green : Colors.grey,
                size: 20,
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  isSelected ? 'Seleccionado' : 'Disponible',
                  style: TextStyle(
                    color: isSelected ? Colors.green : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                child: Text(
                  '$equiposDisponibles equipos',
                  style: TextStyle(
                    color: isSelected ? Colors.green : Colors.grey,
                    fontSize: 8,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
