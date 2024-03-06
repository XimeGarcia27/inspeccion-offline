import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getTiendas() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = _auth.currentUser;
  List tiendas = [];

  try {
    // Verificar si el token existe y no está vacío
    if (user != null) {
      // Realizar la consulta a Firestore
      print('Antes de la consulta a Firestore $user');
      QuerySnapshot queryTiendas = await db.collection('tiendas').get();
      print('Después de la consulta a Firestore');

      // Procesar los resultados de la consulta
      tiendas = queryTiendas.docs.map((documento) => documento.data()).toList();
    } else {
      print('Usuario no autenticado. Token no encontrado.');
      // Puedes manejar la situación de no autenticado según tus necesidades
    }
  } catch (e) {
    print('Error al realizar la consulta: $e');
    // Manejar el error según tus necesidades
  }

  return tiendas;
}
