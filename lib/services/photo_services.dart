import 'dart:io';

import 'package:app_inspections/services/db_offline.dart';
import 'package:app_inspections/services/db_online.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sqflite/sqflite.dart';

class FirebaseStorageService {
  static Future<String?> uploadImage(File image) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      firebase_storage.SettableMetadata metadata =
          firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
      );

      await ref.putFile(image, metadata);
      String downloadURL = await ref.getDownloadURL();

      print('Imagen cargada exitosamente. URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error al cargar la imagen: $e');
      return null;
    }
  }

  static Future<void> deleteImage(String imageUrl) async {
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
      print('Imagen eliminada de Firebase Storage.');
    } catch (e) {
      print('Error al eliminar la imagen: $e');
    }
  }
}

class LocalStorageService {
  // Función para eliminar una imagen de la base de datos local
  static Future<void> deleteImageFromDatabase(String imageUrl) async {
    final Database database = await DatabaseProvider.openDB();
    await database.delete('images', where: 'imagen = ?', whereArgs: [imageUrl]);
  }

  // Función para obtener todas las imágenes almacenadas localmente
  /* static Future<List<String>> getAllImagesFromDatabase() async {
    final Database database = await DatabaseProvider.openDB();
    final List<Map<String, dynamic>> maps = await database.query('images');
    return List.generate(maps.length, (i) => maps[i]['imagen']);
  } */

  static Future<List<Map<String, dynamic>>> getAllImagesFromDatabase() async {
    try {
      final Database database = await DatabaseProvider.openDB();
      final List<Map<String, dynamic>> maps = await database.query('images');
      return maps;
    } catch (e) {
      print('Error al obtener las imágenes de la base de datos local: $e');
      return [];
    }
  }
}

/* Future<void> syncImagesWithFirebaseStorage() async {
  //sincroniza las imágenes almacenadas localmente con Firebase Storage, eliminando las imágenes locales después de cargarlas correctamente en Firebase Storage.
  final List<String> localImageUrls =
      await LocalStorageService.getAllImagesFromDatabase();

  for (final imageUrl in localImageUrls) {
    // Verificar si hay conexión a Internet
    final bool isConnected = await hasInternetConnection();

    if (isConnected) {
      // Subir la imagen a Firebase Storage
      String? firebaseUrl =
          await FirebaseStorageService.uploadImage(File(imageUrl));

      if (firebaseUrl != null) {
        // Eliminar la imagen de la base de datos local después de una carga exitosa
        await LocalStorageService.deleteImageFromDatabase(imageUrl);

        // Imprimir el mensaje de confirmación
        print(
            'La imagen con URL: $imageUrl ha sido subida a Firebase Storage y eliminada de la base de datos local.');
      } else {
        print(
            'Hubo un error al subir la imagen con URL: $imageUrl a Firebase Storage.');
      }
    }
  }
} */

Future<void> syncImagesWithFirebaseAndPostgreSQL() async {
  try {
    // Obtener todas las imágenes locales
    final List<Map<String, dynamic>> localImages =
        await LocalStorageService.getAllImagesFromDatabase();

    for (final image in localImages) {
      final String imageUrl = image['imagen'];
      final String datoUnico = image['datoUnico'];
      final int idTienda = image['idTienda'];

      // Subir la imagen a Firebase Storage
      final bool isConnected = await hasInternetConnection();

      if (isConnected) {
        final String? firebaseUrl =
            await FirebaseStorageService.uploadImage(File(imageUrl));

        if (firebaseUrl != null) {
          // Insertar la URL de la imagen en la tabla de PostgreSQL
          await DatabaseHelper.insertarImagenes(
              firebaseUrl, datoUnico, idTienda);

          // Eliminar la imagen de la base de datos local después de la carga exitosa
          //await LocalStorageService.deleteImageFromDatabase(imageUrl);

          print(
              'Imagen subida a Firebase y URL insertada en PostgreSQL: $firebaseUrl');
        } else {
          print('Error al subir la imagen a Firebase Storage');
        }
      } else {
        print(
            'No hay conexión a internet. No se puede subir la imagen: $imageUrl');
      }
    }
  } catch (e) {
    print('Error durante la sincronización: $e');
  }
}

// Función para verificar la conexión a Internet
Future<bool> hasInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  // ignore: unrelated_type_equality_checks
  return connectivityResult == ConnectivityResult.mobile ||
      // ignore: unrelated_type_equality_checks
      connectivityResult == ConnectivityResult.wifi;
}
