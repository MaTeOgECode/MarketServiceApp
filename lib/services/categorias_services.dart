import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/categorias_model.dart';

class CategoriasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener flujo de categorías en tiempo real
  Stream<List<CategoriasModel>> getCategorias() {
    return _db.collection('categorias').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return CategoriasModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}