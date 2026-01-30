import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MarketServiceApp/pages/mensaje_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Mensajes")),
      body: _buildActiveChats(uid), // Aquí se muestran los chats ya iniciados
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF137FEC),
        icon: const Icon(Icons.add_comment, color: Colors.white),
        label: const Text("Nuevo Chat", style: TextStyle(color: Colors.white)),
        onPressed: () =>
            _showAllProviders(context), // Abre lista de TODOS los proveedores
      ),
    );
  }

  // 1. LISTA DE CHATS YA INICIADOS (Basado en Servicios_contratados)
  Widget _buildActiveChats(String uid) {
    return StreamBuilder<QuerySnapshot>(
      // Filtramos para ver solo los chats donde este usuario participa
      stream: FirebaseFirestore.instance
          .collection('chat')
          .where('participantes', arrayContains: uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(child: Text("Error: ${snapshot.error}"));
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No tienes chats recientes"));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            final String chatID = docs[i].id;
            final String nombre = data['nombreChat'] ?? 'Chat';
            final String ultimoMsg = data['ultimoMensaje'] ?? 'Ver mensajes...';

            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF137FEC),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                ultimoMsg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MensajePage(
                      contratoId: chatID,
                      nombreProveedor: nombre,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // 2. MODAL PARA HABLAR CON CUALQUIER PROVEEDOR
  void _showAllProviders(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          expand: false,
          builder: (_, controller) => Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Selecciona un Proveedor",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  // BUSCAMOS EN LA COLECCIÓN 'usuarios' FILTRANDO POR ROL
                  stream: FirebaseFirestore.instance
                      .collection('usuarios')
                      .where('rol', isEqualTo: 'proveedor')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const Center(child: CircularProgressIndicator());
                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      controller: controller,
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final data = docs[i].data() as Map<String, dynamic>;
                        final String nombre = data['nombre'] ?? 'Sin nombre';
                        final String provId =
                            docs[i].id; // Usamos su UID como ID de chat

                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Icon(Icons.store, color: Colors.white),
                          ),
                          title: Text(nombre),
                          subtitle: Text(
                            data['email'] ?? 'Proveedor disponible',
                          ),
                          onTap: () {
                            Navigator.pop(context); // Cierra el modal
                            _openChat(context, provId, nombre);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openChat(BuildContext context, String id, String? nombre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MensajePage(contratoId: id, nombreProveedor: nombre ?? 'Proveedor'),
      ),
    );
  }
}
