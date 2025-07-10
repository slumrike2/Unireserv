import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/lab_data.dart';
import '../models/lab_model.dart';
import '../widgets/add_equipment_dialog.dart';
import '../widgets/equipment_card.dart';
import '../widgets/equipment_detail_dialog.dart';
import '../widgets/equipment_stats.dart';

class EquipmentDetailScreen extends StatefulWidget {
  final int labId;

  const EquipmentDetailScreen({
    super.key,
    required this.labId,
  });

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
  bool _isAdmin = false;
  Laboratory? _lab;
  List<Equipment> _equipment = [];
  String _searchQuery = '';
  String _filterStatus = 'todos';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString("userType");

    setState(() {
      _isAdmin = userType == "admin";
      _lab =
          LabData.getLaboratories().firstWhere((lab) => lab.id == widget.labId);
      _equipment = LabData.getEquipmentForLab(widget.labId);
    });
  }

  List<Equipment> get _filteredEquipment {
    return _equipment.where((equipment) {
      final matchesSearch = equipment.numEquipment
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (equipment.description ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesFilter =
          _filterStatus == 'todos' || equipment.status == _filterStatus;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showEquipmentDetail(Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => EquipmentDetailDialog(
        equipment: equipment,
        isAdmin: _isAdmin,
        onUpdate: (updatedEquipment) {
          setState(() {
            final index = _equipment.indexWhere((e) => e.id == equipment.id);
            if (index != -1) {
              _equipment[index] = updatedEquipment;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_lab == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFDC2626)),
        ),
      );
    }

    final disponibles = _equipment.where((e) => e.status == 'available').length;
    final mantenimiento =
        _equipment.where((e) => e.status == 'maintenance').length;

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
                  child: Column(
                    children: [
                      // Top row with back button and title
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _lab!.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  _isAdmin
                                      ? 'Gestión de equipos'
                                      : 'Selecciona tus equipos',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_isAdmin)
                            ElevatedButton.icon(
                              onPressed: () => _showAddEquipmentDialog(),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Agregar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Stats badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatBadge(
                              '$disponibles Disponibles', Colors.green),
                          _buildStatBadge(
                              '$mantenimiento Mantenimiento', Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search and filter bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Buscar equipos...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Todos', 'todos'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Disponibles', 'available'),
                        const SizedBox(width: 8),
                        _buildFilterChip('No disponibles', 'unavailable'),
                        const SizedBox(width: 8),
                        _buildFilterChip('Mantenimiento', 'maintenance'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Equipment stats
            if (_isAdmin)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EquipmentStats(
                  total: _equipment.length,
                  disponibles: disponibles,
                  ocupados: 0,
                  danados: mantenimiento,
                ),
              ),

            // Equipment grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _filteredEquipment.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron equipos',
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _isAdmin ? 3 : 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: _filteredEquipment.length,
                        itemBuilder: (context, index) {
                          final equipment = _filteredEquipment[index];
                          return EquipmentCard(
                            equipment: equipment,
                            isAdmin: _isAdmin,
                            onTap: () => _showEquipmentDetail(equipment),
                            onQuickAction: _isAdmin
                                ? (action) =>
                                    _handleQuickAction(equipment, action)
                                : null,
                          );
                        },
                      ),
              ),
            ),

            // Legend
            Container(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildLegendItem(
                      Colors.green,
                      _isAdmin
                          ? 'Disponible'
                          : 'Disponible - Clic para reservar'),
                  _buildLegendItem(Colors.orange, 'Mantenimiento'),
                ],
              ),
            ),

            // Action buttons (for users)
            if (!_isAdmin)
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Color(0xFF334155)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cancelar'),
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

  Widget _buildStatBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      selectedColor: const Color(0xFFDC2626),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: const Color(0xFF374151),
      side: BorderSide(
        color: isSelected ? const Color(0xFFDC2626) : Colors.grey,
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _handleQuickAction(Equipment equipment, String action) {
    setState(() {
      final index = _equipment.indexWhere((e) => e.id == equipment.id);
      if (index != -1) {
        String newStatus = equipment.status;
        switch (action) {
          case 'repair':
            newStatus = 'available';
            break;
          case 'maintenance':
            newStatus = 'maintenance';
            break;
          case 'occupy':
            newStatus = 'unavailable';
            break;
          case 'free':
            newStatus = 'available';
            break;
          default:
            return;
        }

        _equipment[index] = Equipment(
          id: equipment.id,
          laboratoryId: equipment.laboratoryId,
          numEquipment: equipment.numEquipment,
          status: newStatus,
          description: equipment.description,
          createdAt: equipment.createdAt,
          updatedAt: DateTime.now(),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Estado del equipo ${equipment.numEquipment} actualizado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddEquipmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEquipmentDialog(
        onAdd: (newEquipment) {
          setState(() {
            _equipment.add(newEquipment);
          });
        },
      ),
    );
  }
}
