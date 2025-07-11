import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/equipment_detail_screen.dart';
import 'screens/admin_equipment_screen.dart';
import 'screens/register_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const LabBookingApp());
}

class LabBookingApp extends StatelessWidget {
  const LabBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unireserv',
      theme: AppTheme.darkTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/admin': (context) => const AdminScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/equipment/') == true) {
          final id = int.parse(settings.name!.split('/')[2]);
          return MaterialPageRoute(
            builder: (context) => EquipmentDetailScreen(labId: id),
          );
        }
        if (settings.name?.startsWith('/admin/equipos/') == true) {
          final id = int.parse(settings.name!.split('/')[3]);
          return MaterialPageRoute(
            builder: (context) => AdminEquipmentScreen(labId: id),
          );
        }
        return null;
      },
    );
  }
}
