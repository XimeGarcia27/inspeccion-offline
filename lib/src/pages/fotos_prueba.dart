import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FotosPrueba(),
    );
  }
}

class FotosPrueba extends StatefulWidget {
  FotosPrueba({Key? key}) : super(key: key);

  @override
  _FotosPruebaState createState() => _FotosPruebaState();
}

class _FotosPruebaState extends State<FotosPrueba> {
  late List<File> _images = [];

  Future<void> _captureAndUpload(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: _images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ImageViewScreen(image: _images[index]),
                    ));
                  },
                  onLongPress: () {
                    _deleteImage(index);
                  },
                  child: Image.file(_images[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _captureAndUpload(context),
        tooltip: 'Take Picture',
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  final File image;

  const ImageViewScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image')),
      body: Center(
        child: Image.file(image),
      ),
    );
  }
}
