import 'package:flutter/material.dart';
import '../models/lab_model.dart';
import '../data/lab_data.dart';

class ReservationModal extends StatefulWidget {
  final List<SelectedSlot> selectedSlots;
  final List<Laboratory> labs;
  final VoidCallback onReserve;

  const ReservationModal({
    super.key,
    required this.selectedSlots,
    required this.labs,
    required this.onReserve,
  });

  @override
  State<ReservationModal> createState() => _ReservationModalState();
}

class _ReservationModalState extends State<ReservationModal> {
  final _clienteController = TextEditingController();
  final _observacionesController = TextEditingController();
  Map<String, List<int>> _selectedEquipment = {};

  @override
  void initState() {
    super.initState();
    // Initialize selected equipment for each slot
    for (var slot in widget.selectedSlots) {
      _selectedEquipment['${slot.salonId}_${slot.fecha}_${slot.hora}'] = [];
    }
  }

  void _toggleEquipmentSelection(String slotKey, int equipmentId) {
    setState(() {
      if (_selectedEquipment[slotKey]!.contains(equipmentId)) {
        _selectedEquipment[slotKey]!.remove(equipmentId);
      } else {
        _selectedEquipment[slotKey]!.add(equipmentId);
      }
    });
  }

  void _selectAllAvailable(String slotKey, List<Equipment> availableEquipment) {
    setState(() {
      _selectedEquipment[slotKey] =
          availableEquipment.map((e) => e.id).toList();
    });
  }

  Future<List<Equipment>> _fetchEquipmentForSlot(SelectedSlot slot) async {
    final allEquipment = await LabData.fetchEquipmentForLab(slot.salonId);
    final reservation = await LabData.fetchReservationForLab(
        slot.salonId, slot.fecha, slot.hora);
    if (reservation != null && reservation.tipo == "parcial") {
      // Simulate which equipment is occupied for partial reservations
      final occupiedCount = reservation.equipos;
      for (int i = 0; i < occupiedCount && i < allEquipment.length; i++) {
        allEquipment[i] = Equipment(
          id: allEquipment[i].id,
          laboratoryId: allEquipment[i].laboratoryId,
          numEquipment: allEquipment[i].numEquipment,
          status: 'unavailable',
          description: allEquipment[i].description,
          createdAt: allEquipment[i].createdAt,
          updatedAt: allEquipment[i].updatedAt,
        );
      }
    }
    return allEquipment;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF334155)),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Seleccionar Equipos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selected slots summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF374151).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Horarios Seleccionados',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              itemCount: widget.selectedSlots.length,
                              itemBuilder: (context, index) {
                                final slot = widget.selectedSlots[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFF4B5563)),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              slot.salonNombre,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              '${slot.dia} ${slot.hora}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${slot.equiposDisponibles} disponibles',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Client info
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _clienteController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Cliente/Responsable',
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: 'Nombre del responsable',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _observacionesController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Observaciones',
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: 'Detalles adicionales...',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Equipment selection for each slot
                    ...widget.selectedSlots.map((slot) {
                      final slotKey =
                          '${slot.salonId}_${slot.fecha}_${slot.hora}';
                      return FutureBuilder<List<Equipment>>(
                        future: _fetchEquipmentForSlot(slot),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error al cargar equipos'));
                          } else if (!snapshot.hasData) {
                            return const SizedBox();
                          }
                          final equipment = snapshot.data!;
                          final availableEquipment = equipment
                              .where((e) => e.status == 'available')
                              .toList();
                          final occupiedEquipment = equipment
                              .where((e) => e.status == 'unavailable')
                              .toList();
                          final damagedEquipment = equipment
                              .where((e) => e.status == 'maintenance')
                              .toList();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF4B5563)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Slot header
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${slot.salonNombre} - ${slot.dia} ${slot.hora}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _selectAllAvailable(
                                          slotKey, availableEquipment),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                      ),
                                      child: Text(
                                        'Reservar Todos (${availableEquipment.length})',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Equipment status summary
                                Row(
                                  children: [
                                    _buildStatusChip(
                                        'Disponibles',
                                        availableEquipment.length,
                                        Colors.green),
                                    const SizedBox(width: 8),
                                    _buildStatusChip('Ocupados',
                                        occupiedEquipment.length, Colors.red),
                                    const SizedBox(width: 8),
                                    _buildStatusChip('En Mantenimiento',
                                        damagedEquipment.length, Colors.yellow),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Equipment grid
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemCount: equipment.length,
                                  itemBuilder: (context, index) {
                                    final equip = equipment[index];
                                    final isSelected =
                                        _selectedEquipment[slotKey]
                                                ?.contains(equip.id) ??
                                            false;
                                    return _buildEquipmentCard(
                                        equip, isSelected, slotKey);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFF334155)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: const BorderSide(color: Color(0xFF4B5563)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _confirmReservation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Confirmar Reserva'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEquipmentCard(
      Equipment equipment, bool isSelected, String slotKey) {
    Color backgroundColor;
    Color borderColor;
    bool isClickable = false;

    switch (equipment.status) {
      case 'available':
        backgroundColor =
            isSelected ? Colors.green : Colors.green.withOpacity(0.2);
        borderColor = Colors.green;
        isClickable = true;
        break;
      case 'unavailable':
        backgroundColor = Colors.red.withOpacity(0.8);
        borderColor = Colors.red;
        break;
      case 'maintenance':
        backgroundColor = Colors.yellow.withOpacity(0.8);
        borderColor = Colors.yellow;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.3);
        borderColor = Colors.grey;
    }

    return GestureDetector(
      onTap: isClickable
          ? () => _toggleEquipmentSelection(slotKey, equipment.id)
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEquipmentIcon(equipment.description ?? ''),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              equipment.numEquipment,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              equipment.description ?? '',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              equipment.status.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 6,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 12,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getEquipmentIcon(String description) {
    final desc = description.toLowerCase();
    if (desc.contains('computadora')) return Icons.computer;
    if (desc.contains('proyector')) return Icons.tv;
    if (desc.contains('audio') || desc.contains('micrófono'))
      return Icons.volume_up;
    if (desc.contains('router') || desc.contains('switch')) return Icons.router;
    if (desc.contains('osciloscopio') ||
        desc.contains('multímetro') ||
        desc.contains('fuente') ||
        desc.contains('generador')) return Icons.electrical_services;
    if (desc.contains('cámara')) return Icons.videocam;
    if (desc.contains('pantalla')) return Icons.tv;
    return Icons.devices;
  }

  void _confirmReservation() {
    // Validate form
    if (_clienteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el nombre del responsable'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if at least one equipment is selected
    bool hasSelection =
        _selectedEquipment.values.any((list) => list.isNotEmpty);
    if (!hasSelection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un equipo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Process reservation
    print('Reserva confirmada:');
    print('Cliente: ${_clienteController.text}');
    print('Observaciones: ${_observacionesController.text}');
    print('Equipos seleccionados: $_selectedEquipment');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reserva confirmada exitosamente'),
        backgroundColor: Colors.green,
      ),
    );

    widget.onReserve();
  }

  @override
  void dispose() {
    _clienteController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }
}
