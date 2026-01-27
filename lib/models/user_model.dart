class UserModel {
  final String nombre;
  final String ci;
  final String direccion;
  final String email;
  final String rol;

  UserModel({
    required this.nombre,
    required this.ci,
    required this.direccion,
    required this.email,
    required this.rol,
  });

  // Para enviar datos a Firebase
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'ci': ci,
      'direccion': direccion,
      'email': email,
      'rol': rol,
      'createdAt': DateTime.now(), // Corregido: 'createdAt'
    };
  }

  // NUEVO: Para recibir datos de Firebase (Indispensable para el error fromMap)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nombre: map['nombre'] ?? '',
      ci: map['ci'] ?? '',
      direccion: map['direccion'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] ?? 'Cliente',
    );
  }
}