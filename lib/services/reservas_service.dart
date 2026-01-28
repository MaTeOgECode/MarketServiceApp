import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contratacion_model.dart';

class ReservasService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> crearContratacion(ContratacionModel contratacion) async {
    await _db.collection('servicios_contratados').add(contratacion.toMap());
  }
  Future<void> finalizarServicio(String contratacionId) async {
  return await _db.collection('servicios_contratados').doc(contratacionId).update({
    'estado': 'completado',
    'fechaFinalizado': DateTime.now(), //
  });
}
}