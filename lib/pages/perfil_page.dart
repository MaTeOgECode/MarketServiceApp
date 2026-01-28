import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? userModel;
  bool loading = true;
  File? imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    userModel = UserModel.fromMap(doc.data()!);
    setState(() => loading = false);
  }

  Future<void> seleccionarImagen() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });

      await subirImagen();
    }
  }

  Future<void> subirImagen() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref('fotosPerfil/$uid.jpg');

    await ref.putFile(imageFile!);
    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('usuarios').doc(uid).update({
      'fotoUrl': url,
    });

    await cargarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Perfil"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: seleccionarImagen,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          userModel!.fotoUrl != null &&
                              userModel!.fotoUrl!.isNotEmpty
                          ? NetworkImage(userModel!.fotoUrl!)
                          : const NetworkImage(
                              "https://via.placeholder.com/150",
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userModel!.nombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        userModel!.email,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rol: ${userModel!.rol}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            /// STATS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      value: "0",
                      label: "Servicios Contratados",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(value: "0", label: "Reseñas Realizadas"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ACCOUNT SETTINGS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Configuración de Cuenta",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 8),

            _MenuItem(icon: Icons.person, text: "Editar Perfil"),
            _MenuItem(icon: Icons.map, text: "Dirección"),
            _MenuItem(icon: Icons.security, text: "Seguridad"),

            const SizedBox(height: 24),

            /// LOGOUT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: const Text("Cerrar Sesión"),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// STAT CARD
class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

/// MENU ITEM
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MenuItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(text),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
