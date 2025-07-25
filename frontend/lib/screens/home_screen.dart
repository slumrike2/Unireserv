import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/lab_data.dart';
import '../models/lab_model.dart';
import '../widgets/schedule_table.dart';
import '../widgets/reservation_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentWeek = 0;
  List<SelectedSlot> _selectedSlots = [];
  Future<List<Laboratory>>? _labsFuture;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<List<Laboratory>> _getLabsFuture() {
    if (_labsFuture == null) {
      _labsFuture = LabData.fetchLaboratories();
    }
    return _labsFuture!;
  }

  Future<void> _logout() async {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _changeWeek(int direction) {
    setState(() {
      final newWeek = _currentWeek + direction;
      if (newWeek >= 0) {
        _currentWeek = newWeek;
      }
    });
  }

  void _toggleSlotSelection(SelectedSlot slot) {
    setState(() {
      final existingIndex = _selectedSlots.indexWhere(
        (s) =>
            s.salonId == slot.salonId &&
            s.fecha == slot.fecha &&
            s.hora == slot.hora,
      );

      if (existingIndex != -1) {
        _selectedSlots.removeAt(existingIndex);
      } else {
        _selectedSlots.add(slot);
      }
    });
  }

  void _clearSelections() {
    setState(() {
      _selectedSlots.clear();
    });
  }

  void _showReservationModal(List<Laboratory> labs) {
    showDialog(
      context: context,
      builder: (context) => ReservationModal(
        selectedSlots: _selectedSlots,
        labs: labs,
        onReserve: () {
          setState(() {
            _selectedSlots.clear();
          });
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString("userName");
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekStart =
        DateTime(2025, 1, 6).add(Duration(days: _currentWeek * 7));
    final weekEnd = weekStart.add(const Duration(days: 4));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                border: const Border(
                  bottom: BorderSide(color: Color(0xFF334155)),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Logo and title
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unireserv',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Horarios por Laboratorio',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Week navigator
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => _changeWeek(-1),
                              icon: const Icon(Icons.chevron_left,
                                  color: Colors.grey),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Semana ${weekStart.day} - ${weekEnd.day}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Enero 2025',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => _changeWeek(1),
                              icon: const Icon(Icons.chevron_right,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Logout button
                      OutlinedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Cerrar Sesión'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // User greeting
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _userName != null ? 'Bienvenido, $_userName!' : 'Cargando...',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Selection bar
            if (_selectedSlots.isNotEmpty)
              Container(
                color: const Color(0xFF1E293B).withOpacity(0.8),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      '${_selectedSlots.length} horarios seleccionados',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton.icon(
                      onPressed: _clearSelections,
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Limpiar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _getLabsFuture()
                          .then((labs) => _showReservationModal(labs)),
                      child: const Text('Reservar Selección'),
                    ),
                  ],
                ),
              ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: LabsContent(
                  labsFuture: _getLabsFuture(),
                  selectedSlots: _selectedSlots,
                  onSlotToggle: _toggleSlotSelection,
                  currentWeek: _currentWeek,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LabsContent extends StatefulWidget {
  final Future<List<Laboratory>> labsFuture;
  final List<SelectedSlot> selectedSlots;
  final Function(SelectedSlot) onSlotToggle;
  final int currentWeek;

  const LabsContent({
    required this.labsFuture,
    required this.selectedSlots,
    required this.onSlotToggle,
    required this.currentWeek,
    Key? key,
  }) : super(key: key);

  @override
  State<LabsContent> createState() => _LabsContentState();
}

class _LabsContentState extends State<LabsContent> {
  late final Future<List<Laboratory>> _cachedLabsFuture;

  @override
  void initState() {
    super.initState();
    _cachedLabsFuture = widget.labsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Laboratory>>(
      future: _cachedLabsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar laboratorios'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay laboratorios disponibles'));
        }

        final labs = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horarios de Laboratorios',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona los horarios disponibles para hacer tu reserva',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Legend
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                spacing: 24,
                runSpacing: 8,
                children: [
                  _buildLegendItem(Colors.red, 'Reserva Total'),
                  _buildLegendItem(
                      Colors.yellow, 'Reserva Parcial (Seleccionable)'),
                  _buildLegendItem(
                      Colors.green.withOpacity(0.3), 'Seleccionado',
                      border: Colors.green),
                  _buildLegendItem(Colors.transparent, 'Disponible',
                      border: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lab schedules
            ...labs.map((lab) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ScheduleTable(
                    lab: lab,
                    selectedSlots: widget.selectedSlots,
                    onSlotToggle: widget.onSlotToggle,
                    weekIndex: widget.currentWeek,
                  ),
                )),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem(Color color, String label, {Color? border}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: border != null ? Border.all(color: border, width: 2) : null,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
