import 'dart:io';
import 'package:app_inspections/services/photo_services.dart';
import 'package:app_inspections/src/pages/agregarDefectos.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class FormPrincipal extends StatelessWidget {
  final int idTienda;

  const FormPrincipal({super.key, required this.idTienda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormReporte(idTienda: idTienda, context: context),
    );
  }
}

// ignore: must_be_immutable
class FormReporte extends StatefulWidget {
  final int idTienda;
  final BuildContext context;

  const FormReporte({super.key, required this.idTienda, required this.context});

  @override
  State<FormReporte> createState() =>
      // ignore: no_logic_in_create_state
      _FormReporteState(idTienda: idTienda, context: context);
}

class _FormReporteState extends State<FormReporte> {
  final int idTienda;
  List<XFile> images = [];
  int maxPhotos = 6;
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths =
      []; // Lista para almacenar las rutas de las imágenes
  String? _urlImagenSeleccionada = "";
  List<String?> imageUrls = []; //se almacenan todas las imagenes

  @override
  final BuildContext context;

  _FormReporteState({required this.idTienda, required this.context});

  void mostrarFotoEnGrande(XFile image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          // Establecer el color de fondo transparente
          child: Stack(
            children: [
              PhotoView(
                imageProvider: FileImage(File(image.path)),
                backgroundDecoration: const BoxDecoration(
                  color: Colors
                      .transparent, // Establece el color de fondo transparente
                ),
                loadingBuilder: (context, event) {
                  if (event == null || event.expectedTotalBytes == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: event.cumulativeBytesLoaded /
                          event.expectedTotalBytes!,
                    ),
                  );
                },
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child:
                        const Icon(Icons.cancel_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

//permitir al usuario ver la imagen en grande
  Widget buildThumbnailWithCancel(XFile image, int index) {
    return GestureDetector(
      onTap: () {
        mostrarFotoEnGrande(image);
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(.0),
            child: ClipRect(
              child: Align(
                alignment: Alignment.topLeft,
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Image.file(
                  File(image.path),
                  width: 100,
                  height: 70,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  images.removeAt(index); // Remueve la imagen de la lista
                });
                //eliminarImagenDeFirebase(image);
              },
              child: const Icon(Icons.cancel_rounded), // Ícono para cancelar
            ),
          ),
        ],
      ),
    );
  }

  void _guardarImagenEnBD(String? imageURL) {
    setState(() {
      // Asigna la URL de la imagen a una variable de estado para su uso en el formulario
      _urlImagenSeleccionada = imageURL;
    });
    print("URL D ELA IMAGEEEN $_urlImagenSeleccionada");
  }

  // Función para abrir la cámara y seleccionar imágenes
  Future<void> _getImage() async {
    if (images.length >= maxPhotos) {
      // Mostrar ventana emergente cuando se excede el límite de fotos
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Límite de fotos alcanzado'),
            content: Text('No puedes agregar más de $maxPhotos fotos.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar ventana emergente
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Salir del método si se alcanza el límite de fotos
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        images.add(image);
      });
      String? imageURL =
          await FirebaseStorageService.uploadImage(File(image.path));
      print("IURL DE LA IMAGEN $imageURL");
      _guardarImagenEnBD(imageURL);
      // Agrega la URL de la imagen a la lista de URLs
      imageUrls.add(imageURL);
    }
  }

  //controller de los campos
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  List<dynamic> listaDatos = [];

  void _guardar() {
    final datos =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    setState(() {
      listaDatos.add(datos);
    });
  }

  @override
  Widget build(BuildContext context) {
    final datos = ModalRoute.of(context)?.settings.arguments;
    print("DATOOOS $datos");

    // Verificar si hay datos disponibles
    bool datosDisponibles = datos != null && datos is Map<String, dynamic>;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Registro de Inspección',
                    style: Theme.of(context).textTheme.headlineMedium),
                TextFormField(
                  controller: _departamentoController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(labelText: 'Departamento'),
                  validator: (value) {
                    if (_departamentoController.text.isEmpty &&
                        _departamentoController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ubicacionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      const InputDecoration(labelText: 'Ubicación (Bahia)'),
                  validator: (value) {
                    if (_ubicacionController.text.isEmpty &&
                        _ubicacionController.text.isNotEmpty) {
                      return 'Este campo es oblicatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Agrega la información del defecto",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    FloatingActionButton(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const Defectos(); // Aquí creas una instancia de tu pantalla AgregarProblema
                          },
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        size: 35,
                        color: Color.fromARGB(255, 10, 38, 129),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                /*  */
                if (datosDisponibles)
                  Expanded(
                    child: ListView.builder(
                      itemCount: listaDatos.length,
                      itemBuilder: (context, index) {
                        final registro = listaDatos[index];
                        print("REGISTROS $registro");
                        return Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          shadowColor: const Color.fromARGB(255, 193, 194, 194),
                          elevation: 14,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Datos del Defecto:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Defecto: ${registro['nombreP']}'),
                                Text('Mano de Obra: ${registro['nombreM']}'),
                                // Agregar otros campos si es necesario
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Fotos",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return buildThumbnailWithCancel(images[index],
                          index); // Usa la función para construir miniaturas con botón de cancelar
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Aquí se llama a la función para tomar fotos
                          await _getImage();
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Tomar fotografía'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 70,
                ),
                ElevatedButton(
                  onPressed: () {
                    //guardarDatosConConfirmacion(context);
                    _guardar();
                  }, // Desactiva el botón si isGuardarHabilitado es falso
                  key: null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(
                      6,
                      6,
                      68,
                      1,
                    ),
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
