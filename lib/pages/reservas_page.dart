import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import 'service_detail_page.dart';
import '../models/servicios_model.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  static const Color primaryBlue = Color(0xFF137FEC);
  static const Color darkBackground = Color(0xFF101922);
  static const Color darkInput = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String? userId = authService.currentUser?.uid;

    return Scaffold(
      backgroundColor: isDark ? darkBackground : const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: const Text("Mis Contrataciones", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? darkBackground : Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: userId == null 
        ? const Center(child: Text("Inicia sesión para ver tus reservas"))
        : StreamBuilder<QuerySnapshot>(
            // Mantenemos sin orderBy hasta que crees el índice en Firebase si lo deseas
            stream: FirebaseFirestore.instance
                .collection('servicios_contratados')
                .where('clienteId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error al cargar datos: ${snapshot.error}"));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: primaryBlue));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Aún no tienes servicios contratados.", 
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final doc = snapshot.data!.docs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final String estado = data['estado'] ?? 'pendiente';

                  return Container(
                    // CORRECCIÓN: EdgeInsets.only para evitar error de constructor constante
                    margin: const EdgeInsets.only(bottom: 15), 
                    decoration: BoxDecoration(
                      color: isDark ? darkInput : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      title: Text(
                        data['nombreServicio'] ?? 'Servicio',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Proveedor: ${data['nombreProveedor'] ?? 'Oficial'}"),
                          Text("Precio: Bs ${data['precio'] ?? '0'}", 
                            style: const TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          _buildStatusChip(estado),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: primaryBlue),
                      onTap: () => _verDetallesYGestionar(context, data, doc.id, estado),
                    ),
                  );
                },
              );
            },
          ),
    );
  }

  Widget _buildStatusChip(String estado) {
    // Lógica de colores según el estado guardado en Firebase
    Color colorBase;
    switch (estado) {
      case 'completado':
        colorBase = Colors.green;
        break;
      case 'calificado':
        colorBase = Colors.orange;
        break;
      default:
        colorBase = primaryBlue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colorBase.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado.toUpperCase(),
        style: TextStyle(
          color: colorBase,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _verDetallesYGestionar(BuildContext context, Map<String, dynamic> data, String docId, String estadoActual) {
    // Mapeamos los datos de la contratación al modelo de servicio
    final servicioTmp = ServiciosModel(
      id: data['servicioId'] ?? '',
      nombreTienda: data['nombreServicio'] ?? 'Sin nombre',
      imageUrl: "", // Puedes agregar un campo 'imagen' en servicios_contratados si lo deseas
      rating: 0.0, 
      reviews: 0,
      precioRango: "Bs ${data['precio']}",
      precioValor: (data['precio'] as num?)?.toDouble() ?? 0.0,
      descripcion: data['descripcion'] ?? 'Sin descripción',
      proveedorId: data['proveedorId'] ?? '',
      categoriaId: data['categoriaId'] ?? '',
    );

    // CORRECCIÓN: contratacionId ahora se pasa correctamente
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailPage(
          servicio: servicioTmp,
          estadoReserva: estadoActual,
          contratacionId: docId,
        ),
      ),
    );
  }
}