import 'package:flutter/material.dart';

class AnimatedContainerExample extends StatefulWidget {
  @override
  _AnimatedContainerExampleState createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isPressed = !_isPressed;
            });
          },
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: _isPressed ? 200 : 100,
            height: 50,
            color: _isPressed ? Colors.blue : Colors.red,
            child: Center(child: Text('Presiona Aquí')),
          ),
        ),
      ),
    );
  }
}

/*
// Definimos un mapa para almacenar las sumas de las cantidades de cada material
Map<String, double> cantidadesTotales = {};

// Iteramos sobre los datos para calcular las sumas de las cantidades
datos.forEach((dato) {
  String nombreMaterial = dato['nom_mat'];
  double cantidadMaterial = dato['cant_mat'];
  
  // Verificamos si el material ya está en el mapa
  if (cantidadesTotales.containsKey(nombreMaterial)) {
    // Si ya existe, sumamos la cantidad
    cantidadesTotales[nombreMaterial] += cantidadMaterial;
  } else {
    // Si no existe, lo agregamos al mapa con su cantidad
    cantidadesTotales[nombreMaterial] = cantidadMaterial;
  }
});

// Ahora, puedes usar cantidadesTotales para mostrar las sumas en la tabla

return DataTable2.DataTable2(
  // Otras propiedades...
  columns: [
    // Otras columnas...
    DataColumn(label: Text('Total por Material')),
  ],
  rows: cantidadesTotales.entries.map((entry) {
    return DataRow(
      cells: [
        // Celdas de otras columnas...
        DataCell(Text(entry.key)), // Nombre del material
        DataCell(Text(entry.value.toString())), // Total de cantidad
      ],
    );
  }).toList(),
);









*/ 