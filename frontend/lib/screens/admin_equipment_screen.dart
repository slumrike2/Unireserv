import 'package:flutter/material.dart';

class AdminEquipmentScreen extends StatelessWidget {
  final int labId;
  const AdminEquipmentScreen({super.key, required this.labId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Equipos Lab $labId')),
      body: Center(child: Text('Administrar equipos para laboratorio $labId')),
    );
  }
}
