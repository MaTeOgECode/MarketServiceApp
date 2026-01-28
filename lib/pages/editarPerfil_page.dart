import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nombreController = TextEditingController();
  final _ciController = TextEditingController();
  final _direccionController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    final data = doc.data()!;

    _nombreController.text = data['nombre'] ?? '';
    _ciController.text = data['ci'] ?? '';
    _direccionController.text = data['direccion'] ?? '';

    setState(() => loading = false);
  }

  Future<void> guardarCambios() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('usuarios').doc(uid).update({
      'nombre': _nombreController.text.trim(),
      'ci': _ciController.text.trim(),
      'direccion': _direccionController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Datos actualizados correctamente")),
    );

    Navigator.pop(context); // vuelve al perfil
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(title: const Text("Editar Perfil"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _input("Nombre", _nombreController, Icons.person),
            const SizedBox(height: 12),
            _input("CI", _ciController, Icons.badge),
            const SizedBox(height: 12),
            _input("Dirección", _direccionController, Icons.home),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: guardarCambios,
              child: const Text("Guardar Cambios"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
