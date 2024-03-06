import 'dart:io';

import 'package:flutter/material.dart';


class ImageDisplayScreen extends StatelessWidget {
  final String imagePath;

  ImageDisplayScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagen Capturada'),
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}