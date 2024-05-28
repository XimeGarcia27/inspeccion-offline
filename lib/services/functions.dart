import 'package:flutter/material.dart';

// Función para mostrar un diálogo de confirmación
Future<bool> mostrarDialogoConfirmacion(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar acción'),
            content: const Text('¿Está seguro de que desea guardar los datos?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ) ??
      false;
}

// Función para mostrar un diálogo de confirmación
Future<bool> mostrarDialogoConfirmacionEditar(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar acción'),
            content: const Text('¿Está seguro de que desea guardar los datos?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      ) ??
      false;
}
