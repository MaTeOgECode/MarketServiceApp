import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String emisorId;
  final String texto;
  final DateTime timestamp;

  MessageModel({
    required this.emisorId,
    required this.texto,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      emisorId: map['emisorId'],
      texto: map['texto'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emisorId': emisorId,
      'texto': texto,
      'timestamp': timestamp,
      'leido': false,
    };
  }
}
