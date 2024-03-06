import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyCfBYbPnzrQwsgfgYsVVqz4Us28dF33f1w';
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  // si retornamos algo , es un error, si no , todo bien
  Future<String?> createUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Usuario registrado: ${userCredential.user?.email}');
      return null;
    } on FirebaseAuthException catch (e) {
      print('Error al registrar usuario: $e');
      // Puedes manejar diferentes errores según tus necesidades
      return e.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Usuario autenticado: ${userCredential.user?.email}');
      verificarAutenticacion();
      return null;
    } on FirebaseAuthException catch (e) {
      print('Error al iniciar sesión: $e');
      // Puedes manejar diferentes errores según tus necesidades
      return e.message;
    }
  }

  Future<String?> verificarAutenticacion() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;

    try {
      print('Verificando autenticación...');

      if (user != null) {
        print('TOKEN VALIDO $user');
        // Realiza acciones adicionales si es necesario
      } else {
        print(
            'Usuario no autenticado. Redirigiendo al inicio de sesión. $user');
        // Redirige a la pantalla de inicio de sesión o realiza acciones adicionales
        // según tus necesidades de manejo de autenticación.
      }
    } catch (e) {
      print('Error en verificarAutenticacion(): $e');
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
