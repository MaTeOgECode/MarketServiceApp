import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String contratoId;
  final String id;
  final String clienteId;
  final String proveedorId;
  final String ultimoMensaje;
  final DateTime ultimoTimestamp;

  ChatModel({
    required this.contratoId,
    required this.id,
    required this.clienteId,
    required this.proveedorId,
    required this.ultimoMensaje,
    required this.ultimoTimestamp,
  });

  factory ChatModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      contratoId: data['contratoId'],
      id: doc.id,
      clienteId: data['clienteId'],
      proveedorId: data['proveedorId'],
      ultimoMensaje: data['ultimoMensaje'] ?? '',
      ultimoTimestamp:
          (data['ultimoTimestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
