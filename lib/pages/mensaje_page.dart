import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MensajePage extends StatefulWidget {
  final String? contratoId;
  final String? nombreProveedor;

  const MensajePage({super.key, this.contratoId, this.nombreProveedor});

  @override
  State<MensajePage> createState() => _MensajePageState();
}

class _MensajePageState extends State<MensajePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String uid = user?.uid ?? '';

    // Variables de respaldo seguras
    final String idFinal = widget.contratoId ?? "sin_id";
    final String nombreFinal = widget.nombreProveedor ?? "Chat";

    // Debug para que veas en consola qué está pasando
    print("Chat abierto con ID: $idFinal");

    if (idFinal == "sin_id" || idFinal.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Chat")),
        body: const Center(child: Text("ID de chat no válido")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        title: Text(nombreFinal),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .doc(
                    idFinal,
                  ) // Aquí se usa el UID del proveedor o ID contrato
                  .collection('mensajes')
                  .orderBy('fecha', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // Si hay error, mostramos el error técnico real para debugear rápido
                if (snapshot.hasError) {
                  print("Error de Firestore: ${snapshot.error}");
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No hay mensajes. ¡Escribe algo para empezar!"),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final String texto = data['texto'] ?? '';
                    final bool isMe = data['emisorId'] == uid;

                    return _BubbleChat(text: texto, isMe: isMe);
                  },
                );
              },
            ),
          ),
          _buildInputArea(uid, idFinal),
        ],
      ),
    );
  }

  Widget _buildInputArea(String uid, String idSeguro) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Escribe un mensaje...",
                  filled: true,
                  fillColor: const Color(0xFFF6F7F8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: const Color(0xFF137FEC),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => _enviarMensaje(uid, idSeguro),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _enviarMensaje(String uid, String idSeguro) async {
    if (_controller.text.trim().isEmpty) return;
    final textoParaEnviar = _controller.text.trim();
    _controller.clear();

    try {
      // 1. "Activamos" el documento principal para que aparezca en las listas
      await FirebaseFirestore.instance.collection('chat').doc(idSeguro).set({
        'ultimoMensaje': textoParaEnviar,
        'fecha': FieldValue.serverTimestamp(),
        'participantes': [uid, idSeguro], // Cliente y Proveedor
        'nombreChat': widget.nombreProveedor ?? 'Proveedor',
      }, SetOptions(merge: true)); // merge: true evita borrar lo que ya existe

      // 2. Guardamos el mensaje en la subcolección como siempre
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(idSeguro)
          .collection('mensajes')
          .add({
            'texto': textoParaEnviar,
            'emisorId': uid,
            'fecha': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print("Error al enviar: $e");
    }
  }
}

class _BubbleChat extends StatelessWidget {
  final String text;
  final bool isMe;

  const _BubbleChat({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF137FEC) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          border: isMe ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
