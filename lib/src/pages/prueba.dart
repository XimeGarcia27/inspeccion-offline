import 'package:flutter/material.dart';

class FormPrincipal extends StatelessWidget {
  const FormPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FormReporte(),
    );
  }
}

class FormReporte extends StatefulWidget {
  const FormReporte({super.key});

  @override
  State<FormReporte> createState() => _FormReporteState();
}

class _FormReporteState extends State<FormReporte> {
  String selectedFormat = "F1";

  //controller de los campos
  final TextEditingController _departamentoController = TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Registro de Inspección',
                    style: Theme.of(context).textTheme.headlineMedium),
                DropdownButtonFormField(
                  value: selectedFormat,
                  onChanged: (newValue) {
                    setState(() {
                      selectedFormat = newValue!;
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
                      "Registra un defecto",
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 20,
                          ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      onPressed: () {},
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
                const Card(
                  //margin: EdgeInsets.all(1),
                  color: Color.fromARGB(255, 255, 255, 255),
                  shadowColor: Color.fromARGB(255, 193, 194, 194),
                  elevation: 14,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Defecto",
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Text('Mano de Obra'),
                        trailing: Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 10, 38, 129),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
