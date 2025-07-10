import 'package:flutter/material.dart';
import '../models/lab_model.dart';
import '../widgets/equipment_card.dart';
import '../widgets/equipment_detail_dialog.dart';
import '../data/lab_data.dart';

class AdminEquipmentScreen extends StatefulWidget {
  final int labId;
  const AdminEquipmentScreen({super.key, required this.labId});

  @override
  State<AdminEquipmentScreen> createState() => _AdminEquipmentScreenState();
}

class _AdminEquipmentScreenState extends State<AdminEquipmentScreen> {
  late Lab lab;
  List<Equipment> equipmentList = [];
  bool isLoading = true;
  bool isAdmin = true; // Aquí puedes poner la lógica real de admin

  @override
  void initState() {
    super.initState();
    // Simulación de carga de laboratorio y equipos
    lab = LabData.getLabs().firstWhere((l) => l.id == widget.labId);
    equipmentList = LabData.getEquipmentForLab(widget.labId);
    isLoading = false;
  }

  void _showEquipmentDetail(Equipment equipment) async {
    await showDialog(
      context: context,
      builder: (context) => EquipmentDetailDialog(
        equipment: equipment,
        isAdmin: isAdmin,
        onUpdate: (updatedEquipment) {
          setState(() {
            final idx =
                equipmentList.indexWhere((e) => e.id == updatedEquipment.id);
            if (idx != -1) {
              equipmentList[idx] = updatedEquipment;
            }
          });
        },
      ),
    );
  }

  void _showAddEquipmentDialog() async {
    final nombreController = TextEditingController();
    final tipoController = TextEditingController();
    String estado = 'disponible';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Nuevo Equipo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tipoController,
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: estado,
              onChanged: (v) => estado = v!,
              items: const [
                DropdownMenuItem(
                    value: 'disponible', child: Text('Disponible')),
                DropdownMenuItem(value: 'ocupado', child: Text('Ocupado')),
                DropdownMenuItem(value: 'dañado', child: Text('Dañado')),
              ],
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreController.text.isNotEmpty &&
                  tipoController.text.isNotEmpty) {
                setState(() {
                  equipmentList.add(Equipment(
                    id: DateTime.now().millisecondsSinceEpoch,
                    nombre: nombreController.text,
                    tipo: tipoController.text,
                    estado: estado,
                    ultimoMantenimiento: '',
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Administrar equipos - ${lab.nombre}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: equipmentList.length,
                itemBuilder: (context, idx) {
                  final equipment = equipmentList[idx];
                  return EquipmentCard(
                    equipment: equipment,
                    isAdmin: isAdmin,
                    onTap: () => _showEquipmentDetail(equipment),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEquipmentDialog,
        icon: const Icon(Icons.add),
        label: const Text('Agregar Equipo'),
      ),
    );
  }
}
