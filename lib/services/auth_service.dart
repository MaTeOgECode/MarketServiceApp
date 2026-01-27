import 'package:firebase_auth/firebase_auth.dart';
import 'package:miproyecto/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener el usuario actual de Firebase Auth
  User? get currentUser => _auth.currentUser;

  // INICIO DE SESIÓN
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Email no válido');
      } else if (e.code == 'wrong-password') {
        print('La contraseña es incorrecta');
      }
      return null;
    }
  }

  // REGISTRO DE USUARIO
  Future<User?> register({
    required String nombre,
    required String ci,
    required String direccion,
    required String email,
    required String password,
    String rol = 'Cliente',
  }) async {
    try {
      // 1. Crear el usuario en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      
      User? user = userCredential.user;

      if (user != null) {
        // 2. Crear el modelo de usuario con los datos extra
        UserModel userModel = UserModel(
          nombre: nombre,
          ci: ci,
          direccion: direccion,
          email: email,
          rol: rol,
        );

        // 3. Guardar en la colección 'usuarios' de Firestore usando el UID de Auth
        await _db.collection('usuarios').doc(user.uid).set(userModel.toMap());
      }
      
      return user;
    } catch (e) {
      print("Error en el registro: $e");
      return null;
    }
  }

  // OBTENER DATOS DEL USUARIO DESDE FIRESTORE
  // Este es el método que usaremos en el AppDrawer para mostrar el Nombre
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('usuarios').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error al obtener datos del usuario de Firestore: $e");
    }
    return null;
  }

  // CERRAR SESIÓN
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }
}