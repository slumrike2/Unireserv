import 'package:flutter/material.dart';

class EquipmentStats extends StatelessWidget {
  final int total;
  final int disponibles;
  final int ocupados;
  final int danados;

  const EquipmentStats({
    super.key,
    required this.total,
    required this.disponibles,
    required this.ocupados,
    required this.danados,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              total.toString(),
              Colors.white,
              Icons.devices,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Disponibles',
              disponibles.toString(),
              Colors.green,
              Icons.check_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Ocupados',
              ocupados.toString(),
              Colors.red,
              Icons.cancel,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Mantenimiento',
              danados.toString(),
              Colors.yellow,
              Icons.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                icon,
                color: color,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
