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
    switch (equipment.estado) {
      case 'disponible':
        return Colors.green;
      case 'ocupado':
        return Colors.red.withOpacity(0.8);
      case 'dañado':
        return Colors.yellow.withOpacity(0.8);
      default:
        return Colors.grey;
    }
  }

  Color get _borderColor {
    switch (equipment.estado) {
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

  IconData get _equipmentIcon {
    switch (equipment.tipo.toLowerCase()) {
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

  IconData get _statusIcon {
    switch (equipment.estado) {
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

                    // Equipment name
                    Text(
                      equipment.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Equipment type
                    Text(
                      equipment.tipo,
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
                          equipment.estado.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    if (isAdmin) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Mant: ${equipment.ultimoMantenimiento}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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

    switch (equipment.estado) {
      case 'disponible':
        actions.addAll([
          _buildQuickActionButton(
            Icons.build,
            'maintenance',
            Colors.yellow,
          ),
          _buildQuickActionButton(
            Icons.block,
            'occupy',
            Colors.red,
          ),
        ]);
        break;
      case 'ocupado':
        actions.add(
          _buildQuickActionButton(
            Icons.check,
            'free',
            Colors.green,
          ),
        );
        break;
      case 'dañado':
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
