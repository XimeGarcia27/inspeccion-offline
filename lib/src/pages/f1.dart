import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:app_inspections/services/functions.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class F1Screen extends StatelessWidget {
  final int idTienda;

  const F1Screen({
    super.key,
    required this.idTienda,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyForm(
        idTienda: idTienda,
        context: context,
      ),
    );
  }
}

// ignore: must_be_immutable
class MyForm extends StatefulWidget {
  final int idTienda;
  final BuildContext context;

  MyForm({super.key, required this.idTienda, required this.context});

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _MyFormState createState() =>
      // ignore: no_logic_in_create_state
      _MyFormState(idTienda: idTienda, context: context);

  List<XFile> images = [];
}

class _MyFormState extends State<MyForm> {
  final int idTienda;
  @override
  final BuildContext context;
  //bool _isButtonDisabled = true;
  List<Map<String, dynamic>> datosIngresados = [];

  //campos de la base de datos
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _idproblController = TextEditingController();
  final TextEditingController _idmatController = TextEditingController();
  final TextEditingController _cantmatController = TextEditingController();
  final TextEditingController _idobraController = TextEditingController();
  final TextEditingController _cantobraController = TextEditingController();
  final TextEditingController _otroMPController = TextEditingController();
  final TextEditingController _otroObraController = TextEditingController();

  int idTiend = 0;
  int idProbl = 0;
  int idMat = 0;
  int idObra = 0;
  String selectedFormato = "F1";
  bool isGuardarHabilitado = false;

  List<String> problemasEscritos = [];
  List<String> materialesEscritos = [];
  List<String> obrasEscritas = [];

  _MyFormState({required this.idTienda, required this.context});

  final FocusNode _focusNodeProbl = FocusNode();
  final FocusNode _focusNodeMat = FocusNode();
  final FocusNode _focusNodeObr = FocusNode();
  final FocusNode _cantidadFocus = FocusNode();
  final FocusNode _focusOtO = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNodeProbl.addListener(() {
      if (!_focusNodeProbl.hasFocus) {
        setState(() {
          // Oculta la lista cuando el campo pierde el foco
          showListProblemas = false;
        });
      }
    });
    _focusNodeMat.addListener(() {
      if (!_focusNodeMat.hasFocus) {
        setState(() {
          // Oculta la lista cuando el campo pierde el foco
          showListMaterial = false;
        });
      }
    });
    _focusNodeObr.addListener(() {
      if (!_focusNodeObr.hasFocus) {
        setState(() {
          // Oculta la lista cuando el campo pierde el foco
          showListObra = false;
        });
      }
    });
  }

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

  void handleSelectionMaterial(
      String selectedOptionMaterial, int idMaterialSeleccionado) {
    setState(() {
      _textEditingControllerMaterial.text = selectedOptionMaterial;
      showListMaterial = false; // Ocultar la lista después de la selección
      isMaterialSelected = true;
      _idmatController.text = idMat.toString();
      idMat = idMaterialSeleccionado;
      //print('ID del material seleccionado: $idMat');
      //print('ID de tienda en F1Screen: $idTiend');
    });
  }

  void handleSelectionProblem(
      String selectedOptionProblem, int idProblemaSeleccionado) {
    setState(() {
      _textEditingControllerProblema.text = selectedOptionProblem;
      showListProblemas = false;
      isProblemSelected = true;
      _idproblController.text = idProbl.toString();
      idProbl = idProblemaSeleccionado;
      //print('ID del problema seleccionado: $selectedOptionProblem');
    });
  }

  void handleSelectionObra(String selectedOptionObra, int idObraSeleccionado) {
    setState(() {
      _textEditingControllerObra.text = selectedOptionObra;
      showListObra = false; // Ocultar la lista después de la selección
      isObraSelected = true;
      _idobraController.text = idObra.toString();
      idObra = idObraSeleccionado;
      //print('OBRAA SELECCIONADO: $idObra');
    });
  }

  /* void _checkIfButtonShouldBeEnabled() {
    final bool isDepartamento = _departamentoController.text.isNotEmpty;
    final bool isUbicacion = _ubicacionController.text.isNotEmpty;
    final bool isProblem = _textEditingControllerProblema.text.isNotEmpty;
    final bool isObra = _textEditingControllerObra.text.isNotEmpty;

    setState(() {
      _isButtonDisabled =
          !(isDepartamento && isUbicacion && isProblem && isObra);
    });
  } */
  //int lastGeneratedId = 0;
  // Función para generar un ID único que aumenta en uno cada vez
  String generateUniqueId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  // Función para guardar datos con confirmación
  void guardarDatosConConfirmacion(BuildContext context) async {
    bool confirmacion = await mostrarDialogoConfirmacion(context);
    if (confirmacion == true) {
      // Ejecutar la función _guardarDatos si el usuario acepta
      _guardarDatos();
    } else {
      // No hacer nada si el usuario cancela
    }
  }

  void _guardarDatos() {
    if (formKey.currentState!.validate()) {
      try {
        String valorDepartamento = _departamentoController.text;
        String valorUbicacion = _ubicacionController.text;
        String valorCanMate = _cantmatController.text;
        String valorCanObra = _cantobraController.text;
        String nomProbl = _textEditingControllerProblema.text;
        String nomMat = _textEditingControllerMaterial.text;
        String nomObra = _textEditingControllerObra.text;
        String otro = _otroMPController.text;
        String otroO = _otroObraController.text;
        int cantM = 0;
        int cantO = 0;
        String foto = "HJHFDVJDHVBJHFVB";
        String idUnico = generateUniqueId();

        for (var datos in datosIngresados) {
          // Usar un valor predeterminado si el valor es nulo
          valorDepartamento = datos['Departamento'] ?? '';
          valorUbicacion = datos['Ubicacion'] ?? '';
          idProbl = datos['ID_Problema'] ??
              0; // Usar un valor predeterminado si el valor es nulo
          nomProbl = datos['Problema'] ?? '';
          idMat = datos['ID_Material'] ?? 0;
          nomMat = datos['Material'] ?? '';
          otro = datos['Otro'] ?? 0;
          valorCanMate = datos['Cantidad_Material'] ?? 0;
          idObra = datos['ID_Obra'] ?? 0;
          nomObra = datos['Obra'] ?? '';
          otroO = datos['Otro_Obr'] ?? 0;
          valorCanObra = datos['Cantidad_Obra'] ?? 0;
          foto = datos['Foto'] ?? 0;

          if (valorCanMate.isNotEmpty || valorCanObra.isNotEmpty) {
            cantM = int.parse(valorCanMate);
            cantO = int.parse(valorCanObra);
          }

          print("DATOS DEL ARREGLO");
          print("ID UNICO $idUnico");
          print("FORMATO $selectedFormato");
          print("DEPARTAMENTO $valorDepartamento");
          print("UBICACION $valorUbicacion");
          print("ID PROBLEMA $idProbl");
          print("NOMBRE PROBLEMA $nomProbl");
          print("ID MATERIAL $idMat");
          print("NOMBRE MATERIAL $nomMat");
          print("OTRO MATERIAL $otro");
          print("CANTIDAD MATERIAL $cantM");
          print("ID OBRA $idObra");
          print("NOMBRE OBRA $nomObra");
          print("OTRO MANO DE OBRA $otroO");
          print("CANTIDAD MANO OBRA $cantO");
          print("FOTO $foto");
          print("ID TIENDA $idTiend");

          DatabaseHelper.insertarReporte(
            idUnico,
            selectedFormato,
            valorDepartamento,
            valorUbicacion,
            idProbl,
            nomProbl,
            idMat,
            nomMat,
            otro,
            cantM,
            idObra,
            nomObra,
            otroO,
            cantO,
            foto,
            idTiend,
          );
        }

        _save();
        datosIngresados.clear();
      } catch (e) {
        // Manejo de errores
        print('Error al insertar el reporte: $e');
        // Puedes mostrar un mensaje de error al usuario si lo deseas
      }
    }
  }

  // Método para eliminar un dato
  void eliminarDato(int index) {
    setState(() {
      datosIngresados.removeAt(index);
    });
  }

  void _preguardarDatos() {
    setState(() {
      isGuardarHabilitado = true;
    });
    if (formKey.currentState!.validate()) {
      // Obtener los datos ingresados por el usuario
      String valorDepartamento = _departamentoController.text;
      String valorUbicacion = _ubicacionController.text;
      String valorCanMate = _cantmatController.text;
      String valorCanObra = _cantobraController.text;
      String nomProbl = _textEditingControllerProblema.text;
      String nomMat = _textEditingControllerMaterial.text;
      String nomObra = _textEditingControllerObra.text;
      String otro = _otroMPController.text;
      String otroO = _otroObraController.text;
      String foto = "HJHFDVJDHVBJHFVB";

      // Agregar los datos a la lista
      datosIngresados.add({
        'Formato': selectedFormato,
        'Departamento': valorDepartamento,
        'Ubicacion': valorUbicacion,
        'ID_Problema': idProbl,
        'Problema': nomProbl,
        'ID_Material': idMat,
        'Material': nomMat,
        'Otro': otro,
        'Cantidad_Material': valorCanMate,
        'ID_Obra': idObra,
        'Obra': nomObra,
        'Otro_Obr': otroO,
        'Cantidad_Obra': valorCanObra,
        'Foto': foto,
      });

      // Limpiar los campos después de guardar los datos
      _save();
    }
  }

  void _save() {
    setState(() {
      _textEditingControllerMaterial.clear();
      isMaterialSelected = false;
      showListMaterial = false;
      _textEditingControllerProblema.clear();
      isProblemSelected = false;
      showListProblemas = false;
      _textEditingControllerObra.clear();
      isObraSelected = false;
      showListObra = false;
      _cantidadFocus.unfocus();
      _departamentoController.clear();
      _ubicacionController.clear();
      _cantmatController.clear();
      _cantobraController.clear();
      _otroMPController.clear();
      _otroObraController.clear();
      _focusNodeObr.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    idTiend = idTienda;
    List<Map<String, dynamic>> resultadosP = [];
    List<Map<String, dynamic>> resultadosM = [];
    List<Map<String, dynamic>> resultadosO = [];
    final authService = Provider.of<AuthService>(context, listen: false);
    String? nomUsuario = authService.currentUser;
    print("usuariooo $nomUsuario");

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Registro de Inspección',
                    style: Theme.of(context).textTheme.headlineMedium),
                DropdownButtonFormField(
                  value: selectedFormato,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFormato = newValue!;
                    });
                  },
                  items: <String>['F1', 'F2']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                      labelText:
                          'Selecciona el formato de tu defecto (F1 o F2)'),
                ),
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
                  focusNode: _focusNodeProbl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerProblema,
                  onChanged: (String value) async {
                    resultadosP = await DatabaseHelper.mostrarProblemas(value);
                    idProbl = 0;
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
                        // Establecer como null por defecto
                        if (showListProblemas) {
                          idProbl = opcion['id_probl'];
                        }
                        // Retorna el texto para mostrar en la lista
                        /* String textoProblema =
                            '${opcion['nom_probl']} ${opcion['formato']}'; */
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
                /* Row(
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
                ), */
                TextFormField(
                  focusNode: _focusNodeMat,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerMaterial,
                  onChanged: (String value) async {
                    resultadosM = await DatabaseHelper.mostrarMateriales(value);
                    idMat = 0;
                    setState(() {
                      showListMaterial = value.isNotEmpty;
                      // Utiliza la variable resultados directamente
                      filteredOptionsMaterial = resultadosM
                          .where((opcion) => opcion['nom_mat']
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .map((opcion) {
                        // Guarda el ID en la variable externa
                        if (showListMaterial) {
                          idMat = opcion['id_mat'];
                        }
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
                TextFormField(
                  controller: _otroMPController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration:
                      const InputDecoration(labelText: 'Especifique otro'),
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_otroMPController.text.isEmpty &&
                        _otroMPController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _cantmatController,
                  decoration:
                      const InputDecoration(labelText: 'Cantidad de Material'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    // Validar si el campo está vacío solo si el usuario ha interactuado con él
                    if (_cantmatController.text.isEmpty &&
                        _cantmatController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                /* Row(
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
                ), */

                /* ElevatedButton(
                  onPressed: () {
                    Navegar a la nueva pantalla al presionar el botón "Guardar"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FotosScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(6, 6, 68, 1),
                    onPrimary: Colors.white,
                  ),
                  child: Text('Guardar'),
                ),*/
                TextFormField(
                  focusNode: _focusNodeObr,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _textEditingControllerObra,
                  onChanged: (String value) async {
                    resultadosO = await DatabaseHelper.mostrarObra(value);
                    idObra = 0;
                    setState(() {
                      showListObra = value.isNotEmpty;
                      filteredOptionsObra = resultadosO
                          .where((opcion) => opcion['nom_obr']
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .map((opcion) {
                        // Guarda el ID en la variable externa
                        if (showListObra) {
                          idObra = opcion['id_obr'];
                        }
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
                TextFormField(
                  focusNode: _focusOtO,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _otroObraController,
                  decoration: const InputDecoration(
                      labelText: 'Especifique otro (Mano de Obra)'),
                  validator: (value) {
                    if (_otroObraController.text.isEmpty &&
                        _otroObraController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  focusNode: _cantidadFocus,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _cantobraController,
                  decoration: const InputDecoration(
                      labelText: 'Cantidad de Material para Mano de Obra'),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (_cantobraController.text.isEmpty &&
                        _cantobraController.text.isNotEmpty) {
                      return 'Este campo es obligatorio';
                    }
                    return null;
                  },
                ),

                /* Row(
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
                ), */

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centra los elementos horizontalmente
                  children: [
                    Flexible(
                      flex: 1,
                      child: ElevatedButton.icon(
                        onPressed: () => {},
                        icon: const Icon(Icons.camera),
                        label: const Text('Tomar fotografía'),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _preguardarDatos,
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
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16.0,
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Departamento')),
                      DataColumn(label: Text('Ubicación')),
                      DataColumn(label: Text('Problema')),
                      DataColumn(label: Text('Material')),
                      DataColumn(label: Text('Cantidad Material')),
                      DataColumn(label: Text('Mano de Obra')),
                      DataColumn(label: Text('Cantidad Mano de Obra')),
                      // Agregar una columna adicional para los botones de acción (editar, eliminar)
                      DataColumn(label: Text('Eliminar')),
                    ],
                    rows: datosIngresados.asMap().entries.map((entry) {
                      final index = entry.key;
                      final dato = entry.value;
                      return DataRow(cells: <DataCell>[
                        DataCell(
                          Center(
                            child: Text(
                              dato['Departamento'],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Ubicacion'],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Problema'],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Material'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Cantidad_Material'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Obra'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              dato['Cantidad_Obra'],
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Agregar botones de acción (Editar y Eliminar)
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  eliminarDato(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                  onPressed: isGuardarHabilitado
                      ? () {
                          guardarDatosConConfirmacion(context);
                        }
                      : null, // Desactiva el botón si isGuardarHabilitado es falso
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
                  child: const Text('Guardar todo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
