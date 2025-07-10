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
  late TextEditingController _nombreController;
  late TextEditingController _tipoController;
  late TextEditingController _observacionesController;
  late String _selectedStatus;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.equipment.nombre);
    _tipoController = TextEditingController(text: widget.equipment.tipo);
    _observacionesController =
        TextEditingController(text: widget.equipment.observaciones ?? '');
    _selectedStatus = widget.equipment.estado;
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
                    _getEquipmentIcon(widget.equipment.tipo),
                    color: _getStatusColor(widget.equipment.estado),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.equipment.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.equipment.tipo,
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
                        color: _getStatusColor(widget.equipment.estado)
                            .withOpacity(0.2),
                        border: Border.all(
                            color: _getStatusColor(widget.equipment.estado)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(widget.equipment.estado),
                            color: _getStatusColor(widget.equipment.estado),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.equipment.estado.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(widget.equipment.estado),
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
                      _buildEditField('Nombre del Equipo', _nombreController),
                      const SizedBox(height: 16),
                      _buildEditField('Tipo de Equipo', _tipoController),
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
                              value: 'disponible',
                              child: Text('Disponible',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'ocupado',
                              child: Text('Ocupado',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'dañado',
                              child: Text('Dañado',
                                  style: TextStyle(color: Colors.white))),
                        ],
                      ),

                      const SizedBox(height: 16),
                      _buildEditField('Observaciones', _observacionesController,
                          maxLines: 3),
                    ] else ...[
                      // View mode
                      _buildInfoRow('ID', widget.equipment.id.toString()),
                      _buildInfoRow('Nombre', widget.equipment.nombre),
                      _buildInfoRow('Tipo', widget.equipment.tipo),
                      _buildInfoRow('Estado', widget.equipment.estado),
                      _buildInfoRow('Último Mantenimiento',
                          widget.equipment.ultimoMantenimiento),
                      if (widget.equipment.observaciones?.isNotEmpty == true)
                        _buildInfoRow(
                            'Observaciones', widget.equipment.observaciones!),

                      // Operational status
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            widget.equipment.isOperational
                                ? Icons.check_circle
                                : Icons.error,
                            color: widget.equipment.isOperational
                                ? Colors.green
                                : Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.equipment.isOperational
                                ? 'Operacional'
                                : 'No Operacional',
                            style: TextStyle(
                              color: widget.equipment.isOperational
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
      case 'disponible':
        return Colors.green;
      case 'ocupado':
        return Colors.red;
      case 'dañado':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'disponible':
        return Icons.check_circle;
      case 'ocupado':
        return Icons.cancel;
      case 'dañado':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  IconData _getEquipmentIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'computadora':
      case 'proyector':
      case 'proyector 4k':
        return Icons.computer;
      case 'sistema audio':
      case 'micrófono':
        return Icons.volume_up;
      case 'router':
      case 'switch':
        return Icons.router;
      case 'osciloscopio':
      case 'multímetro':
      case 'fuente de poder':
      case 'generador':
        return Icons.electrical_services;
      case 'cámara':
        return Icons.videocam;
      case 'pantalla':
        return Icons.tv;
      default:
        return Icons.devices;
    }
  }

  void _saveChanges() {
    final updatedEquipment = Equipment(
      id: widget.equipment.id,
      nombre: _nombreController.text,
      tipo: _tipoController.text,
      estado: _selectedStatus,
      ultimoMantenimiento: widget.equipment.ultimoMantenimiento,
      observaciones: _observacionesController.text.isEmpty
          ? null
          : _observacionesController.text,
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
    _nombreController.dispose();
    _tipoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }
}
