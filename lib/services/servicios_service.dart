import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/servicios_model.dart';

class ServiciosService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Cambiamos el parámetro para recibir el nombre o el ID según lo que guardes en la DB
  Stream<List<ServiciosModel>> getServicios({String? categoriaNombre}) {
    Query query = _db.collection('servicios');
    
    if (categoriaNombre != null) {
      // Usamos el campo 'categoria' que es el que tienes en tu DB de servicios
      query = query.where('categoria', isEqualTo: categoriaNombre);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ServiciosModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}