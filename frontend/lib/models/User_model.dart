class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final String rol; // 'admin', 'student', 'teacher'
  final String? career; // Nullable
  final String? department; // Nullable
  final String passwordSalt;
  final DateTime createdAt;
  final DateTime? lastLogin; // Nullable

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.rol,
    this.career,
    this.department,
    required this.passwordSalt,
    required this.createdAt,
    this.lastLogin,
  });

  @override
  String toString() {
    return 'User(id: $id, email: $email, rol: $rol)';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      rol: json['rol'],
      career: json['career'],
      department: json['department'],
      passwordSalt: json['password_salt'],
      createdAt: DateTime.parse(json['created_at']),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'rol': rol,
      'career': career,
      'department': department,
      'password_salt': passwordSalt,
      'created_at': createdAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}
