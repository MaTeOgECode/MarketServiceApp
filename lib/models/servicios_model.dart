class ServiciosModel {
  final String id;
  final String proveedorId;
  final String nombreTienda; 
  final String categoriaId;
  final double rating;    // Mapeado de 'promedioEstrellas'
  final int reviews;      // Mapeado de 'totalVotos'
  final String precioRango; 
  final double precioValor; 
  final String imageUrl;    
  final String descripcion; 
  final bool isVerified;

  ServiciosModel({
    required this.id,
    required this.proveedorId,
    required this.nombreTienda,
    required this.categoriaId,
    required this.rating,
    required this.reviews,
    required this.precioRango,
    required this.precioValor,
    required this.imageUrl,
    required this.descripcion,
    this.isVerified = false,
  });

  factory ServiciosModel.fromMap(Map<String, dynamic> map, String id) {
    // Extraemos el precio numérico directamente de la DB
    final double precioVenta = (map['precio'] ?? 0).toDouble();
    
    return ServiciosModel(
      id: id,
      // Mapeo de proveedorId desde la captura
      proveedorId: map['proveedorId'] ?? 'ID_NO_ENCONTRADO', 
      // Mapeo de nombre desde la captura
      nombreTienda: map['nombre'] ?? 'Sin nombre', 
      // Mapeo de categoria
      categoriaId: map['categoria'] ?? '', 
      // Ajuste a 'promedioEstrellas' según tu Firestore
      rating: (map['promedioEstrellas'] ?? 0.0).toDouble(),
      // Ajuste a 'totalVotos' según tu Firestore
      reviews: map['totalVotos'] ?? 0,
      precioRango: "Bs $precioVenta", 
      precioValor: precioVenta, 
      // Mapeo de imagen
      imageUrl: map['imagen'] ?? 'https://via.placeholder.com/150',
      // Mapeo de descripcion
      descripcion: map['descripcion'] ?? 'Sin descripción disponible', 
      // Mapeo de activo
      isVerified: map['activo'] ?? false,
    );
  }
}