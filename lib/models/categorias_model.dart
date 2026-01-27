import 'package:flutter/material.dart';

class CategoriasModel {
  final String id;
  final String nombre;
  final String icono; // Guardamos el nombre del icono o código
  final String color; // Guardamos el color en formato Hex (ej: "0xFF137FEC")

  CategoriasModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.color,
  });

  factory CategoriasModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoriasModel(
      id: id,
      nombre: map['nombre'] ?? '',
      icono: map['icono'] ?? 'help_outline',
      color: map['color'] ?? '0xFF137FEC',
    );
  }
}