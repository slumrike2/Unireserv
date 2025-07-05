import 'package:flutter/material.dart';
import '../models/admin_models.dart';

class EquipmentTab extends StatelessWidget {
  final List<EquipmentStatus> equipmentStatus;

  const EquipmentTab({
    super.key,
    required this.equipmentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado de Equipos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: equipmentStatus.length,
              itemBuilder: (context, index) {
                final lab = equipmentStatus[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF374151).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF4B5563)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lab.laboratorio,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatColumn(
                              'Total',
                              lab.total.toString(),
                              Colors.white,
                            ),
                          ),
                          Expanded(
                            child: _buildStatColumn(
                              'Disponibles',
                              lab.disponibles.toString(),
                              Colors.green,
                            ),
                          ),
                          Expanded(
                            child: _buildStatColumn(
                              'Ocupados',
                              lab.ocupados.toString(),
                              Colors.yellow,
                            ),
                          ),
                          Expanded(
                            child: _buildStatColumn(
                              'Mantenimiento',
                              lab.danados.toString(),
                              Colors.red,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Action button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/admin/equipos/${index + 1}',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Gestionar'),
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
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
