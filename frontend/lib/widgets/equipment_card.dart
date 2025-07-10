import 'package:flutter/material.dart';
import '../models/lab_model.dart';

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  final bool isAdmin;
  final VoidCallback onTap;
  final Function(String)? onQuickAction;

  const EquipmentCard({
    super.key,
    required this.equipment,
    required this.isAdmin,
    required this.onTap,
    this.onQuickAction,
  });

  Color get _backgroundColor {
    switch (equipment.status) {
      case 'available':
        return Colors.green;
      case 'unavailable':
        return Colors.red.withOpacity(0.8);
      case 'maintenance':
        return Colors.orange.withOpacity(0.8);
      default:
        return Colors.grey;
    }
  }

  Color get _borderColor {
    switch (equipment.status) {
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

  IconData get _equipmentIcon {
    final desc = (equipment.description ?? '').toLowerCase();
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

  IconData get _statusIcon {
    switch (equipment.status) {
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

  String get _statusLabel {
    switch (equipment.status) {
      case 'available':
        return 'Disponible';
      case 'unavailable':
        return 'No disponible';
      case 'maintenance':
        return 'Mantenimiento';
      default:
        return equipment.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: _borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _borderColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Equipment icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF374151),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _equipmentIcon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Equipment identifier
                    Text(
                      equipment.numEquipment,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Equipment description
                    if (equipment.description != null)
                      Text(
                        equipment.description!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    const SizedBox(height: 8),

                    // Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _statusIcon,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _statusLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick actions for admin
            if (isAdmin && onQuickAction != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _buildQuickActions(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildQuickActions() {
    List<Widget> actions = [];
    switch (equipment.status) {
      case 'available':
        actions.addAll([
          _buildQuickActionButton(
            Icons.build,
            'maintenance',
            Colors.orange,
          ),
          _buildQuickActionButton(
            Icons.block,
            'occupy',
            Colors.red,
          ),
        ]);
        break;
      case 'unavailable':
        actions.add(
          _buildQuickActionButton(
            Icons.check,
            'free',
            Colors.green,
          ),
        );
        break;
      case 'maintenance':
        actions.add(
          _buildQuickActionButton(
            Icons.build_circle,
            'repair',
            Colors.green,
          ),
        );
        break;
    }
    return actions;
  }

  Widget _buildQuickActionButton(IconData icon, String action, Color color) {
    return GestureDetector(
      onTap: () => onQuickAction?.call(action),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: color,
          size: 16,
        ),
      ),
    );
  }
}
