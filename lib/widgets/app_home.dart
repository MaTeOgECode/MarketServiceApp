import 'package:flutter/material.dart';
import '../models/categorias_model.dart';
import '../models/servicios_model.dart';
import '../services/categorias_services.dart';
import '../services/servicios_service.dart';
// Importa la nueva página que creamos anteriormente
import '../pages/service_detail_page.dart'; 

class AppWidgetHome {
  // Encabezado de sección (Categorías, Recomendados, etc.)
  static Widget buildSectionHeader(String title, VoidCallback onAction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title, 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          GestureDetector(
            onTap: onAction,
            child: const Text(
              "Ver todo", 
              style: TextStyle(color: Color(0xFF137FEC), fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }

  // Lista horizontal de categorías
  static Widget buildCategoriesList({
    required CategoriasService service,
    required String? selectedId,
    required Function(String) onCategorySelected,
  }) {
    return SizedBox(
      height: 100,
      child: StreamBuilder<List<CategoriasModel>>(
        stream: service.getCategorias(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final cat = snapshot.data![index];
              final isSelected = selectedId == cat.nombre; 
              
              return GestureDetector(
                onTap: () => onCategorySelected(cat.nombre),
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF137FEC) 
                              : const Color(0xFF137FEC).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.category, 
                          color: isSelected ? Colors.white : const Color(0xFF137FEC)
                        ), 
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat.nombre, 
                        style: TextStyle(
                          fontSize: 12, 
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF137FEC) : Colors.grey[700]
                        )
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Lista vertical de servicios filtrados
  static Widget buildServicesList({
    required ServiciosService service,
    required String? filterId,
    required bool isDark,
  }) {
    return StreamBuilder<List<ServiciosModel>>(
      stream: service.getServicios(categoriaNombre: filterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: Text("No hay servicios disponibles en esta categoría.")),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) => _serviceCard(context, snapshot.data![index], isDark),
        );
      },
    );
  }

  // Tarjeta individual de servicio con navegación a Detalles
  static Widget _serviceCard(BuildContext context, ServiciosModel serv, bool isDark) {
    return GestureDetector(
      onTap: () {
        // Al hacer clic en la tarjeta, vamos a la vista detallada
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailPage(servicio: serv),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey.withOpacity(0.2) : Colors.grey.shade200
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                serv.imageUrl, 
                width: 96, 
                height: 96, 
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 96, 
                  height: 96, 
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serv.nombreTienda, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black
                    )
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "${serv.rating} (${serv.reviews} reseñas)", 
                        style: const TextStyle(color: Colors.grey, fontSize: 12)
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        serv.precioRango, 
                        style: const TextStyle(
                          color: Color(0xFF137FEC), 
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        )
                      ),
                      // Botón que también lleva a detalles
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF137FEC), 
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: const Text(
                          "Reservar", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 12, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}