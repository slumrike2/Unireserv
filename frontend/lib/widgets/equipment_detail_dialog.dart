import 'package:flutter/material.dart';
import '../models/lab_model.dart';

class EquipmentDetailDialog extends StatefulWidget {
  final Equipment equipment;
  final bool isAdmin;
  final Function(Equipment) onUpdate;

  const EquipmentDetailDialog({
    super.key,
    required this.equipment,
    required this.isAdmin,
    required this.onUpdate,
  });

  @override
  State<EquipmentDetailDialog> createState() => _EquipmentDetailDialogState();
}

class _EquipmentDetailDialogState extends State<EquipmentDetailDialog> {
  late TextEditingController _numEquipmentController;
  late TextEditingController _descriptionController;
  late String _selectedStatus;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _numEquipmentController =
        TextEditingController(text: widget.equipment.numEquipment);
    _descriptionController =
        TextEditingController(text: widget.equipment.description ?? '');
    _selectedStatus = widget.equipment.status;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
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
                  Icon(
                    _getEquipmentIcon(widget.equipment.description),
                    color: _getStatusColor(widget.equipment.status),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.equipment.numEquipment,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.equipment.description != null)
                          Text(
                            widget.equipment.description!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (widget.isAdmin)
                    IconButton(
                      onPressed: () => setState(() => _isEditing = !_isEditing),
                      icon: Icon(
                        _isEditing ? Icons.close : Icons.edit,
                        color: Colors.grey,
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
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.equipment.status)
                            .withOpacity(0.2),
                        border: Border.all(
                            color: _getStatusColor(widget.equipment.status)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(widget.equipment.status),
                            color: _getStatusColor(widget.equipment.status),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.equipment.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(widget.equipment.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_isEditing && widget.isAdmin) ...[
                      // Edit form
                      _buildEditField('Identificador', _numEquipmentController),
                      const SizedBox(height: 16),
                      _buildEditField('Descripción', _descriptionController),
                      const SizedBox(height: 16),
                      // Status dropdown
                      const Text(
                        'Estado',
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
                              value: 'available',
                              child: Text('Disponible',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'unavailable',
                              child: Text('No disponible',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'maintenance',
                              child: Text('Mantenimiento',
                                  style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ] else ...[
                      // View mode
                      _buildInfoRow('ID', widget.equipment.id.toString()),
                      _buildInfoRow(
                          'Identificador', widget.equipment.numEquipment),
                      if (widget.equipment.description != null)
                        _buildInfoRow(
                            'Descripción', widget.equipment.description!),
                      _buildInfoRow(
                          'Estado', _statusLabel(widget.equipment.status)),
                      _buildInfoRow(
                          'Creado', widget.equipment.createdAt.toString()),
                      _buildInfoRow(
                          'Actualizado', widget.equipment.updatedAt.toString()),
                    ],
                  ],
                ),
              ),
            ),

            // Footer
            if (_isEditing && widget.isAdmin)
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
                        onPressed: () => setState(() => _isEditing = false),
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
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Guardar Cambios'),
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

  Widget _buildEditField(String label, TextEditingController controller,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'unavailable':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'available':
        return Icons.check_circle;
      case 'unavailable':
        return Icons.cancel;
      case 'maintenance':
        return Icons.build;
      default:
        return Icons.help;
    }
  }

  IconData _getEquipmentIcon(String? description) {
    final desc = (description ?? '').toLowerCase();
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

  String _statusLabel(String status) {
    switch (status) {
      case 'available':
        return 'Disponible';
      case 'unavailable':
        return 'No disponible';
      case 'maintenance':
        return 'Mantenimiento';
      default:
        return status;
    }
  }

  void _saveChanges() {
    final updatedEquipment = Equipment(
      id: widget.equipment.id,
      laboratoryId: widget.equipment.laboratoryId,
      numEquipment: _numEquipmentController.text,
      status: _selectedStatus,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      createdAt: widget.equipment.createdAt,
      updatedAt: DateTime.now(),
    );

    widget.onUpdate(updatedEquipment);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Equipo actualizado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() => _isEditing = false);
  }

  @override
  void dispose() {
    _numEquipmentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
