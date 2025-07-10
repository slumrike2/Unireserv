import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/admin_data.dart';

import '../widgets/admin_stats_card.dart';
import '../widgets/reservations_tab.dart';
import '../widgets/equipment_tab.dart';
import '../widgets/reports_tab.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool("isAuthenticated") ?? false;
    final userType = prefs.getString("userType");

    if (!isAuthenticated || userType != "admin") {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      setState(() {
        _isAuthenticated = true;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("userType");
    await prefs.remove("isAuthenticated");
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFDC2626)),
        ),
      );
    }

    final adminStats = AdminData.getAdminStats();
    final todayReservations = AdminData.getTodayReservations();
    final equipmentStatus = AdminData.getEquipmentStatus();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
              Color(0xFF0F172A),
            ],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.5),
                border: const Border(
                  bottom: BorderSide(color: Color(0xFF334155)),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Logo and title
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panel de Administración',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Gestión de laboratorios y reservas',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Logout button
                      OutlinedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Cerrar Sesión'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Color(0xFF334155)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Stats Cards
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        AdminStatsCard(
                          title: 'Reservas Hoy',
                          value: adminStats.reservasHoy.toString(),
                          icon: Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        AdminStatsCard(
                          title: 'Equipos Activos',
                          value: adminStats.equiposActivos.toString(),
                          icon: Icons.computer,
                          color: Colors.green,
                        ),
                        AdminStatsCard(
                          title: 'Ocupación',
                          value: '${adminStats.ocupacion}%',
                          icon: Icons.bar_chart,
                          color: Colors.yellow,
                        ),
                        AdminStatsCard(
                          title: 'Mantenimiento',
                          value: adminStats.mantenimiento.toString(),
                          icon: Icons.warning,
                          color: Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Column(
                        children: [
                          // Tab bar
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E293B),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: const Color(0xFFDC2626),
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey,
                              tabs: const [
                                Tab(text: 'Reservas'),
                                Tab(text: 'Equipos'),
                                Tab(text: 'Reportes'),
                              ],
                            ),
                          ),

                          // Tab content
                          SizedBox(
                            height: 600,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                ReservationsTab(reservations: todayReservations),
                                EquipmentTab(equipmentStatus: equipmentStatus),
                                const ReportsTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
