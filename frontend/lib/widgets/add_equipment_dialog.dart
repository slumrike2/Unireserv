import 'package:flutter/material.dart';
import '../models/lab_model.dart';

class AddEquipmentDialog extends StatefulWidget {
  final Function(Equipment) onAdd;

  const AddEquipmentDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddEquipmentDialog> createState() => _AddEquipmentDialogState();
}

class _AddEquipmentDialogState extends State<AddEquipmentDialog> {
  final _nombreController = TextEditingController();
  final _tipoController = TextEditingController();
  final _observacionesController = TextEditingController();
  String _selectedStatus = 'disponible';

  final List<String> _equipmentTypes = [
    'Computadora',
    'Proyector',
    'Proyector 4K',
    'Sistema Audio',
    'Micrófono',
    'Router',
    'Switch',
    'Osciloscopio',
    'Multímetro',
    'Fuente de Poder',
    'Generador',
    'Cámara',
    'Pantalla',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  const Icon(
                    Icons.add_circle,
                    color: Colors.green,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Agregar Nuevo Equipo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                    _buildField('Nombre del Equipo', _nombreController),
                    const SizedBox(height: 16),

                    // Type dropdown
                    const Text(
                      'Tipo de Equipo',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _tipoController.text.isEmpty
                          ? null
                          : _tipoController.text,
                      onChanged: (value) => _tipoController.text = value ?? '',
                      dropdownColor: const Color(0xFF374151),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Selecciona el tipo de equipo',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      items: _equipmentTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 16),

                    // Status dropdown
                    const Text(
                      'Estado Inicial',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      onChanged: (value) =>
                          setState(() => _selectedStatus = value!),
                      dropdownColor: const Color(0xFF374151),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'disponible',
                            child: Text('Disponible',
                                style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(
                            value: 'ocupado',
                            child: Text('Ocupado',
                                style: TextStyle(color: Colors.white))),
                        DropdownMenuItem(
                            value: 'dañado',
                            child: Text('En Mantenimiento',
                                style: TextStyle(color: Colors.white))),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildField('Observaciones', _observacionesController,
                        maxLines: 3),
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addEquipment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Agregar Equipo'),
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

  Widget _buildField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  String _mapStatus(String status) {
    switch (status) {
      case 'disponible':
        return 'available';
      case 'ocupado':
        return 'unavailable';
      case 'dañado':
        return 'maintenance';
      default:
        return 'available';
    }
  }

  void _addEquipment() {
    if (_nombreController.text.isEmpty || _tipoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos obligatorios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newEquipment = Equipment(
      id: DateTime.now().millisecondsSinceEpoch, // Simple ID generation
      laboratoryId: 0, // Set this to the correct lab id if available
      numEquipment: _nombreController.text,
      status: _mapStatus(_selectedStatus),
      description: _tipoController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onAdd(newEquipment);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Equipo agregado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }
}
