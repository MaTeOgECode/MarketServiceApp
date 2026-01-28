import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRecord {
  final String id;
  final String categoria;
  final String clienteId;
  final String descripcion;
  final String estado;
  final DateTime fechaContratacion;
  final String nombreCliente;
  final String nombreProveedor;
  final String nombreServicio;
  final double precio;
  final String proveedorId;
  final String servicioId;

  ServiceRecord({
    required this.id,
    required this.categoria,
    required this.clienteId,
    required this.descripcion,
    required this.estado,
    required this.fechaContratacion,
    required this.nombreCliente,
    required this.nombreProveedor,
    required this.nombreServicio,
    required this.precio,
    required this.proveedorId,
    required this.servicioId,
  });

  // Esta es la "función" que transforma el documento de Firebase a un objeto de Dart
  factory ServiceRecord.fromFirestore(DocumentSnapshot doc) {
    // Si los datos son nulos, devolvemos un mapa vacío para evitar errores
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return ServiceRecord(
      id: doc.id,
      categoria: data['categoria'] ?? 'Sin categoría',
      clienteId: data['clienteId'] ?? '',
      descripcion: data['descripcion'] ?? '',
      estado: data['estado'] ?? 'Pending',
      // Manejo de fecha: Firebase usa Timestamp, Dart usa DateTime
      fechaContratacion: data['fechaContratacion'] != null
          ? (data['fechaContratacion'] as Timestamp).toDate()
          : DateTime.now(),
      nombreCliente: data['nombreCliente'] ?? 'Usuario',
      nombreProveedor: data['nombreProveedor'] ?? 'Proveedor',
      nombreServicio: data['nombreServicio'] ?? 'Servicio',
      // Convertimos a double por si Firebase lo guarda como int
      precio: (data['precio'] ?? 0).toDouble(),
      proveedorId: data['proveedorId'] ?? '',
      servicioId: data['servicioId'] ?? '',
    );
  }
}
