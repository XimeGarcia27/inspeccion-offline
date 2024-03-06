import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class PhotoViewScreen extends StatelessWidget {
  PhotoViewScreen({required this.imageFile});

  File imageFile;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: FileImage(imageFile),
      ),
    );
  }

  static void pickImage(BuildContext context) {}
}
