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

  Future<void> calificarServicio(String servicioId, double nuevaPuntuacion) async {
  DocumentReference servicioRef = _db.collection('servicios').doc(servicioId);

  return _db.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(servicioRef);

    if (!snapshot.exists) return;

    // Obtenemos valores actuales de tu DB
    double promedioActual = (snapshot['promedioEstrellas'] ?? 0.0).toDouble();
    int votosTotales = snapshot['totalVotos'] ?? 0;

    // Cálculo matemático del nuevo promedio
    int nuevoTotalVotos = votosTotales + 1;
    double nuevoPromedio = ((promedioActual * votosTotales) + nuevaPuntuacion) / nuevoTotalVotos;

    // Actualizamos el documento del servicio
    transaction.update(servicioRef, {
      'promedioEstrellas': nuevoPromedio,
      'totalVotos': nuevoTotalVotos,
    });
  });
}
}