import 'dart:async';

import 'package:app_inspections/services/db.dart';
import 'package:app_inspections/src/pages/add_mat.dart';
import 'package:app_inspections/src/pages/add_problem.dart';
import 'package:app_inspections/src/pages/mano_obra.dart';
import 'package:app_inspections/src/screens/home_foto.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarForm extends StatelessWidget {
  final int idTienda;
  final Map<String, dynamic> data;
  final String nombreTienda;
  const EditarForm(
      {super.key,
      required this.idTienda,
      required this.data,
      required this.nombreTienda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.white),
          onPressed: () {
            // Puedes agregar código para manejar el evento de retroceso aquí
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        title: Text(
          nombreTienda,
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: EditMyForm(
        idTienda: idTienda,
        context: context,
        data: data,
        nombreTienda: nombreTienda,
      ),
    );
  }
}

class EditMyForm extends StatefulWidget {
  final int idTienda;
  final BuildContext context;
  final Map<String, dynamic> data;
  final String nombreTienda;

  const EditMyForm(
      {super.key,
      required this.idTienda,
      required this.context,
      required this.data,
      required this.nombreTienda});

  @override
  State<EditMyForm> createState() =>
      // ignore: no_logic_in_create_state
      _EditMyFormState(idTienda: idTienda, context: context);
}

class _EditMyFormState extends State<EditMyForm> {
  final int idTienda;
  String idTien = '';
  String nombreTienda = '';
  final BuildContext context;
  bool _isLoading = true;

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _departamentoController.text = widget.data['nom_dep'];
    _ubicacionController.text = widget.data['clave_ubi'];
    idProbl = widget.data['id_probl'];
    idMat = widget.data['id_mat'];
    idObra = widget.data['id_obr'];
    _cantmatController.text = widget.data['cant_mat'].toString();
    _cantobraController.text = widget.data['cant_obr'].toString();
    _cargarDatosAsync();
  }

  //campos de la base de datos
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _cantmatController = TextEditingController();
  final TextEditingController _cantobraController = TextEditingController();

  int idTiend = 0;
  int idProbl = 0;
  int idMat = 0;
  int idObra = 0;
  int idReporte = 0;

  _EditMyFormState({required this.idTienda, required this.context});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths =
      []; // Lista para almacenar las rutas de las imágenes
  XFile? _image;

  final TextEditingController _textEditingControllerProblema =
      TextEditingController();
  bool showListProblemas = false;
  List<String> opcionesProblemas = [];
  List<String> filteredOptionsProblema = [];
  bool isProblemSelected = false;

  final TextEditingController _textEditingControllerMaterial =
      TextEditingController();
  bool showListMaterial = false;
  List<String> opcionesMaterial = [];
  List<String> filteredOptionsMaterial = [];
  bool isMaterialSelected = false;

  final TextEditingController _textEditingControllerObra =
      TextEditingController();
  bool showListObra = false;
  List<String> opcionesObra = [];
  List<String> filteredOptionsObra = [];
  bool isObraSelected = false;

  final FocusNode _cantidadFocus = FocusNode();

  // Función para abrir la cámara y seleccionar imágenes
  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      if (_image != null) {
        imagePaths.add(_image!.path); // Agregar la ruta de la imagen a la lista
      }
    });
  }

  void _checkIfButtonShouldBeEnabled() {
    final bool isDepartamento = _departamentoController.text.isNotEmpty;
    final bool isUbicacion = _ubicacionController.text.isNotEmpty;
    final bool isProblem = _textEditingControllerProblema.text.isNotEmpty;
    final bool isMat = _textEditingControllerMaterial.text.isNotEmpty;
    final bool isCantMat = _cantmatController.text.isNotEmpty;
    final bool isObra = _textEditingControllerObra.text.isNotEmpty;
    final bool isCantObra = _cantobraController.text.isNotEmpty;

    setState(() {
      _isButtonDisabled = !(isDepartamento &&
          isUbicacion &&
          isProblem &&
          isMat &&
          isCantMat &&
          isObra &&
          isCantObra);
    });
  }

  Future<void> editarDefecto() async {
    try {
      // Llama al método para obtener el defecto por su ID
      Map<String, dynamic> defecto =
          await DatabaseHelper().obtenerDefectoPorId(idProbl);
      if (defecto.isNotEmpty) {
        // Accede a los datos del defecto
        _textEditingControllerProblema.text = defecto['nom_probl'];

        // Usa los datos como necesites
      } else {
        // Manejo si no se encontró el defecto
        print("NO HAY DATOS");
      }
    } catch (error) {
      // Maneja cualquier error que ocurra durante la ejecución
      print('Error en editarDefecto: $error');
    }
  }

  Future<void> editarMaterial() async {
    try {
      // Llama al método para obtener el defecto por su ID
      Map<String, dynamic> material =
          await DatabaseHelper().obtenerMaterialPorId(idMat);
      // Verifica si se encontró el defecto
      if (material.isNotEmpty) {
        // Accede a los datos del defecto
        _textEditingControllerMaterial.text = material['nom_mat'];

        // Usa los datos como necesites
      } else {
        // Manejo si no se encontró el defecto
        print("NO HAY DATOS");
      }
    } catch (error) {
      // Maneja cualquier error que ocurra durante la ejecución
      print('Error en editarDefecto: $error');
    }
  }

  Future<void> editarManoObra() async {
    try {
      // Llama al método para obtener el defecto por su ID
      Map<String, dynamic> obra =
          await DatabaseHelper().obtenerObraPorId(idObra);
      // Verifica si se encontró el defecto
      if (obra.isNotEmpty) {
        // Accede a los datos del defecto
        _textEditingControllerObra.text = obra['nom_obr'];

        // Usa los datos como necesites
      } else {
        // Manejo si no se encontró el defecto
        print("NO HAY DATOS");
      }
    } catch (error) {
      // Maneja cualquier error que ocurra durante la ejecución
      print('Error en editarDefecto: $error');
    }
  }

  Future<void> _cargarDatosAsync() async {
    try {
      // Realiza las operaciones asíncronas para cargar los datos
      await editarDefecto();
      await editarMaterial();
      await editarManoObra();
      _checkIfButtonShouldBeEnabled();

      // Una vez que las operaciones están completas, actualiza el estado para ocultar el indicador de carga
      setState(() {
        _isLoading = true;
      });

      // Inicia un temporizador para ocultar el indicador de carga después de un tiempo determinado
      Timer(Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      // Manejo de errores
      Text('Error al cargar los datos: $e');
      // Aquí puedes mostrar un mensaje al usuario informándole sobre el error
    }
  }

  void handleSelectionMaterial(
      String selectedOptionMaterial, int idMaterialSeleccionado) {
    setState(() {
      _textEditingControllerMaterial.text = selectedOptionMaterial;
      showListMaterial = false; // Ocultar la lista después de la selección
      isMaterialSelected = true;
      //_idmatController.text = idMat.toString();
      idMat = idMaterialSeleccionado;
      print('ID del material seleccionado: $idMat');
      //print('ID de tienda en F1Screen: $idTiend');
    });
  }

  void handleSelectionProblem(
      String selectedOptionProblem, int idProblemaSeleccionado) {
    setState(() {
      _textEditingControllerProblema.text = selectedOptionProblem;
      showListProblemas = false;
      isProblemSelected = true;
      //_idproblController.text = idProbl.toString();
      idProbl = idProblemaSeleccionado;
      print('ID del problema seleccionado: $idProbl');
    });
  }

  void handleSelectionObra(String selectedOptionObra, int idObraSeleccionado) {
    setState(() {
      _textEditingControllerObra.text = selectedOptionObra;
      showListObra = false; // Ocultar la lista después de la selección
      isObraSelected = true;
      //_idobraController.text = idObra.toString();
      idObra = idObraSeleccionado;
      print('OBRAA SELECCIONADO: $idObra');
    });
  }

  void _editarDatos() {
    if (formKey.currentState!.validate()) {
      String valorDepartamento = _departamentoController.text;
      String valorUbicacion = _ubicacionController.text;
      String valorCanMate = _cantmatController.text;
      String valorCanObra = _cantobraController.text;

      int cantM = int.parse(valorCanMate);
      int cantO = int.parse(valorCanObra);
      idReporte = widget.data['id_rep'];

      print("DATOOOSS VALOR DEPART $valorDepartamento");
      print("DATOOOSS VALOR UBI $valorUbicacion");
      print("DATOOOSS ID PROB $idProbl");
      print("DATOOOSS ID MAT $idMat");
      print("DATOOOSS CANT M $cantM");
      print("DATOOOSS CANT O $cantO");
      print("DATOOOSS ID TIENDA $idTiend");
      try {
        DatabaseHelper.editarReporte(
          idReporte,
          valorDepartamento,
          valorUbicacion,
          idProbl,
          idMat,
          cantM,
          idObra,
          cantO,
          idTiend,
        );
        // Muestra una alerta de "Edición terminada"
        showDialog(
          context: context,
          builder: (BuildContext context) {
            nombreTienda = widget.nombreTienda;
            return AlertDialog(
              title: Text('Edición terminada'),
              content: Text('¡Los datos han sido editados con éxito!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra la alerta
                    Navigator.pushNamed(
                      context,
                      'inspectienda',
                      arguments: {
                        'idTienda': idTiend,
                        'nombreTienda': nombreTienda
                      },
                    );
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Manejo de errores
        Text('Error al insertar el reporte: $e');
        // Puedes mostrar un mensaje de error al usuario si lo deseas
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _buildLoadingIndicator() : _buildForm(context);
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildForm(BuildContext context) {
    idTiend = idTienda;
    List<Map<String, dynamic>> resultadosP = [];
    List<Map<String, dynamic>> resultadosM = [];
    List<Map<String, dynamic>> resultadosO = [];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Editar Inspección',
                    style: Theme.of(context).textTheme.headlineMedium),
                TextFormField(
                  controller: _departamentoController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (_departamentoController.text.isEmpty &&
                        _departamentoController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Departamento'),
                ),
                TextFormField(
                  controller: _ubicacionController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      const InputDecoration(labelText: 'Ubicación (Bahia)'),
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_ubicacionController.text.isEmpty &&
                        _ubicacionController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerProblema,
                  onChanged: (String value) async {
                    resultadosP = await DatabaseHelper.mostrarProblemas(value);
                    setState(() {
                      showListProblemas = value.isNotEmpty;
                      // Utiliza la variable resultados directamente
                      filteredOptionsProblema = resultadosP
                          .where((opcion) =>
                              opcion['cod_probl']
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              opcion['nom_probl']
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                          .map((opcion) {
                        // Guarda el ID en la variable externa
                        idProbl = opcion['id_probl'];
                        // Retorna el texto para mostrar en la lista
                        String textoProblema =
                            '${opcion['nom_probl']} ${opcion['formato']}';
                        return '$textoProblema|id:$idProbl';
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Escribe o selecciona un defecto',
                    suffixIcon: _textEditingControllerProblema.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _textEditingControllerProblema.clear();
                                isProblemSelected = false;
                                showListProblemas =
                                    true; // Muestra la lista nuevamente al eliminar la opción
                              });
                            },
                          )
                        : null,
                  ),
                  readOnly: isProblemSelected,
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_textEditingControllerProblema.text.isEmpty &&
                        _textEditingControllerProblema.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                if (showListProblemas)
                  Visibility(
                    visible:
                        showListProblemas && filteredOptionsProblema.isNotEmpty,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: filteredOptionsProblema.length,
                        itemBuilder: (context, index) {
                          // Divide el texto del problema y el ID del problema
                          List<String> partes =
                              filteredOptionsProblema[index].split('|id:');
                          String textoProblema = partes[0];
                          int idProblema = int.parse(partes[1]);
                          return ListTile(
                            title: Text(textoProblema),
                            onTap: () {
                              // Puedes acceder al ID del problema seleccionado aquí
                              int idProblemaSeleccionado = idProblema;
                              handleSelectionProblem(
                                  textoProblema, idProblemaSeleccionado);
                              showListProblemas = false;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AgregarProblema(); // Aquí creas una instancia de tu pantalla AgregarProblema
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar nuevo defecto'),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerMaterial,
                  onChanged: (String value) async {
                    resultadosM = await DatabaseHelper.mostrarMateriales(value);
                    setState(() {
                      showListMaterial = value.isNotEmpty;
                      // Utiliza la variable resultados directamente
                      filteredOptionsMaterial = resultadosM
                          .where((opcion) => opcion['nom_mat']
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .map((opcion) {
                        // Guarda el ID en la variable externa
                        idMat = opcion['id_mat'];
                        // Retorna el texto para mostrar en la lista
                        String textoMaterial =
                            '${opcion['nom_mat']} ${opcion['formato']}';
                        return '$textoMaterial|id:$idMat';
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Escribe o selecciona un material',
                    suffixIcon: _textEditingControllerMaterial.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _textEditingControllerMaterial.clear();
                                isMaterialSelected = false;
                                showListMaterial = true;
                              });
                            },
                          )
                        : null,
                  ),
                  readOnly: isMaterialSelected,
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_textEditingControllerMaterial.text.isEmpty &&
                        _textEditingControllerMaterial.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                if (showListMaterial)
                  Visibility(
                    visible:
                        showListMaterial && filteredOptionsMaterial.isNotEmpty,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: filteredOptionsMaterial.length,
                        itemBuilder: (context, index) {
                          // Divide el texto del problema y el ID del problema
                          List<String> partes =
                              filteredOptionsMaterial[index].split('|id:');
                          String textoMaterial = partes[0];
                          int idMaterial = int.parse(partes[1]);
                          return ListTile(
                            title: Text(textoMaterial),
                            onTap: () {
                              // Puedes acceder al ID del problema seleccionado aquí
                              int idMaterialSeleccionado = idMaterial;
                              handleSelectionMaterial(
                                  textoMaterial, idMaterialSeleccionado);
                              showListMaterial = false;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AddMaterial(); // Aquí creas una instancia de tu pantalla AgregarProblema
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar nuevo material'),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _cantmatController,
                  decoration:
                      const InputDecoration(labelText: 'Cantidad de Material'),
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_cantmatController.text.isEmpty &&
                        _cantmatController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centra los elementos horizontalmente
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return HomeFoto(); // Aquí creas una instancia de tu pantalla AgregarProblema
                            },
                          );
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Tomar fotografía'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerObra,
                  onChanged: (String value) async {
                    resultadosO = await DatabaseHelper.mostrarObra(value);
                    setState(() {
                      showListObra = value.isNotEmpty;
                      filteredOptionsObra = resultadosO
                          .where((opcion) => opcion['nom_obr']
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .map((opcion) {
                        // Guarda el ID en la variable externa
                        idObra = opcion['id_obr'];
                        // Retorna el texto para mostrar en la lista
                        String textoObra =
                            '${opcion['nom_obr']} ${opcion['formato']}';
                        return '$textoObra|id:$idObra';
                      }).toList();
                    });
                  },

                  //readOnly: true, no editar el texto
                  decoration: InputDecoration(
                    labelText: 'Escribe o selecciona un dato',
                    suffixIcon: _textEditingControllerObra.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _textEditingControllerObra.clear();
                                isObraSelected = false;
                                showListObra = true;
                              });
                            },
                          )
                        : null,
                  ),
                  readOnly: isObraSelected,
                  validator: (value) {
                    if (_textEditingControllerObra.text.isEmpty &&
                        _textEditingControllerObra.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                if (showListObra)
                  Visibility(
                    visible: showListObra && filteredOptionsObra.isNotEmpty,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: filteredOptionsObra.length,
                        itemBuilder: (context, index) {
                          // Divide el texto del problema y el ID del problema
                          List<String> partes =
                              filteredOptionsObra[index].split('|id:');
                          String textoObra = partes[0];
                          int idObra = int.parse(partes[1]);
                          return ListTile(
                            title: Text(textoObra),
                            onTap: () {
                              // Puedes acceder al ID del problema seleccionado aquí
                              int idObraSeleccionado = idObra;
                              handleSelectionObra(
                                  textoObra, idObraSeleccionado);
                              showListObra = false;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const ManoObra();
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                        label:
                            const Text('Agregar descripción de mano de obra'),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  focusNode: _cantidadFocus,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _cantobraController,
                  decoration: const InputDecoration(
                      labelText: 'Cantidad de Material para Mano de Obra'),
                  validator: (value) {
                    if (_cantobraController.text.isEmpty &&
                        _cantobraController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _isButtonDisabled ? null : _editarDatos,
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
                  child: const Text('Finalizar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
