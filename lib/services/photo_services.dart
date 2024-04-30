import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService {
  static Future<String?> uploadImage(File image) async {
    try {
      // Subir la imagen a Firebase Storage
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

  static Future<bool> isValidImageUrl(String imageUrl) async {
    try {
      firebase_storage.Reference storageRef =
          firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }
}
