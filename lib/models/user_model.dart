class UserModel {
  final String nombre;
  final String ci;
  final String direccion;
  final String email;
  final String rol;
  final String? fotoUrl;

  UserModel({
    required this.nombre,
    required this.ci,
    required this.direccion,
    required this.email,
    required this.rol,
    this.fotoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'ci': ci,
      'direccion': direccion,
      'email': email,
      'rol': rol,
      'fotoUrl': fotoUrl,
      'createdAt': DateTime.now(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nombre: map['nombre'] ?? '',
      ci: map['ci'] ?? '',
      direccion: map['direccion'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] ?? 'Cliente',
      fotoUrl: map['fotoUrl'],
    );
  }
}
