import 'package:flutter/material.dart';
import '../services/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRole = 'Profesor'; // Default role
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _careerController = TextEditingController();
  final _departmentController = TextEditingController();
  bool _isLoading = false;
  String _error = '';
  final AuthService _authService = AuthService();

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final name = _nameController.text;
    final email = _emailController.text;
    final role = _selectedRole == 'Alumno' ? 'student' : 'teacher';
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final career = _careerController.text;
    final department = _departmentController.text;

    if (password != confirmPassword) {
      setState(() {
        _error = "Las contraseñas no coinciden";
        _isLoading = false;
      });
      return;
    }

    final userData = {
      'name': name,
      'email': email,
      'password': password,
      'rol': role,
      'career': career.isNotEmpty ? career : null,
      'department': department.isNotEmpty ? department : null,
    };

    try {
      final result = await _authService.registerUser(userData);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Registro de Usuario',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Completa los campos para registrarte',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form
                    Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Ingresa tu nombre',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Ingresa tu correo',
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          items: const [
                            DropdownMenuItem(
                              value: 'Profesor',
                              child: Text('Profesor'),
                            ),
                            DropdownMenuItem(
                              value: 'Alumno',
                              child: Text('Alumno'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Rol',
                            prefixIcon: Icon(Icons.work),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Ingresa tu contraseña',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            prefixIcon: Icon(Icons.lock),
                            hintText: 'Confirma tu contraseña',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _careerController,
                          decoration: const InputDecoration(
                            labelText: 'Carrera',
                            prefixIcon: Icon(Icons.school),
                            hintText: 'Ingresa tu carrera',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _departmentController,
                          decoration: const InputDecoration(
                            labelText: 'Departamento',
                            prefixIcon: Icon(Icons.apartment),
                            hintText: 'Ingresa tu departamento',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Error message
                        if (_error.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error,
                                    color: Colors.red, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  _error,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),

                        // Register button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Registrarse'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Switch to login
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        '¿Ya tienes una cuenta? Inicia sesión',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _careerController.dispose();
    _departmentController.dispose();
    super.dispose();
  }
}
