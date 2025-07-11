import 'dart:async';

import '../models/User_model.dart';

final List<User> users = [
  User(
    id: 1,
    name: 'John Doe',
    email: 'john.doe@example.com',
    password: 'hashed_password_1',
    rol: 'teacher',
    career: 'Computer Science',
    department: 'Engineering',
    passwordSalt: 'salt_1',
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    lastLogin: DateTime.now().subtract(const Duration(days: 1)),
  ),
  User(
    id: 2,
    name: 'Jane Smith',
    email: 'jane.smith@example.com',
    password: 'hashed_password_2',
    rol: 'student',
    career: 'Mathematics',
    department: 'Science',
    passwordSalt: 'salt_2',
    createdAt: DateTime.now().subtract(const Duration(days: 200)),
    lastLogin: DateTime.now().subtract(const Duration(days: 2)),
  ),
  User(
    id: 3,
    name: 'Jesus',
    email: '1',
    password: '1',
    rol: 'student',
    career: 'Mathematics',
    department: 'Science',
    passwordSalt: 'salt_2',
    createdAt: DateTime.now().subtract(const Duration(days: 200)),
    lastLogin: DateTime.now().subtract(const Duration(days: 2)),
  ),
  User(
    id: 3,
    name: 'Jesus',
    email: '123',
    password: '123',
    rol: 'admin',
    career: 'Mathematics',
    department: 'Science',
    passwordSalt: 'salt_2',
    createdAt: DateTime.now().subtract(const Duration(days: 200)),
    lastLogin: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

Future<bool> verifyUser(String email, String password) async {
  // Simulate a network request delay
  await Future.delayed(const Duration(seconds: 2));

  // Check if the user exists and the password matches

  User? user;
  try {
    user = users.firstWhere(
      (user) => user.email == email && user.password == password,
    );
  } catch (e) {
    user = null;
  }

  return user != null;
}

Future<User?> getUserByEmail(String email) async {
  // Simulate a network request delay
  await Future.delayed(const Duration(seconds: 1));

  // Find the user by email
  try {
    return users.firstWhere((user) => user.email == email);
  } catch (e) {
    return null; // User not found
  }
}

Future<String?> getRoleByEmail(String email) async {
  await Future.delayed(const Duration(seconds: 1));
  try {
    final user = users.firstWhere((user) => user.email == email);
    return user.rol;
  } catch (e) {
    return null;
  }
}
