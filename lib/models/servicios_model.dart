class ServiciosModel {
  final String id;
  final String nombreTienda; 
  final String categoriaId;
  final double rating;
  final int reviews;
  final String precioRango; 
  final String imageUrl;    
  final bool isVerified;

  ServiciosModel({
    required this.id,
    required this.nombreTienda,
    required this.categoriaId,
    required this.rating,
    required this.reviews,
    required this.precioRango,
    required this.imageUrl,
    this.isVerified = false,
  });

  factory ServiciosModel.fromMap(Map<String, dynamic> map, String id) {
    // Obtenemos el precio y lo formateamos a Bs
    final double precioVenta = (map['precio'] ?? 0).toDouble();
    
    return ServiciosModel(
      id: id,
      nombreTienda: map['nombre'] ?? 'Sin nombre', 
      categoriaId: map['categoria'] ?? '', 
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviews: map['reviews'] ?? 0,
      // Cambio aquí: Formato en Bolivianos
      precioRango: "Bs $precioVenta", 
      imageUrl: map['imagen'] ?? 'https://via.placeholder.com/150',
      isVerified: map['activo'] ?? false,
    );
  }
}