// lib/models/contratacion_model.dart
class ContratacionModel {
  final String clienteId;
  final String nombreCliente;    // Nuevo
  final String servicioId;
  final String nombreServicio;   // Nuevo
  final String descripcion;      // Nuevo
  final String proveedorId;
  final String nombreProveedor;  // Nuevo
  final double precio;           // Nuevo
  final String categoria;        // Nuevo
  final DateTime fechaContratacion;
  final String estado;

  ContratacionModel({
    required this.clienteId,
    required this.nombreCliente,
    required this.servicioId,
    required this.nombreServicio,
    required this.descripcion,
    required this.proveedorId,
    required this.nombreProveedor,
    required this.precio,
    required this.categoria,
    required this.fechaContratacion,
    this.estado = "pendiente",
  });

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'nombreCliente': nombreCliente,
      'servicioId': servicioId,
      'nombreServicio': nombreServicio,
      'descripcion': descripcion,
      'proveedorId': proveedorId,
      'nombreProveedor': nombreProveedor,
      'precio': precio,
      'categoria': categoria,
      'fechaContratacion': fechaContratacion,
      'estado': estado,
    };
  }
}