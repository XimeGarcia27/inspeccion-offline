import 'dart:io';
import 'dart:typed_data';
import 'package:app_inspections/models/reporte_model.dart';
import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class PruebaExcel extends StatelessWidget {
  final int idTienda;
  final String nomTienda;

  const PruebaExcel(
      {super.key, required this.idTienda, required this.nomTienda});

  Future<List<Reporte>> _cargarReporte(int idTienda) async {
    return DatabaseProvider.mostrarReporteF1(idTienda);
  }

  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    String? user = authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Cierra el diálogo
          },
        ),
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        title: const Text(
          "REPORTE FORMATO 1",
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () async {},
          ),
        ],
      ),
      body: Prueba(idTienda: idTienda),
    );
  }

  void setState(Null Function() param0) {}
}

Future<Uint8List> _loadImageData(String imagePath) async {
  final ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
}

class Prueba extends StatefulWidget {
  final int idTienda;

  const Prueba({super.key, required this.idTienda});

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  String datounico = "";

  @override
  void initState() {
    super.initState();
  }

  Future<List<Reporte>> _cargarReporte(int idTienda) async {
    return DatabaseProvider.mostrarReporteF1(idTienda);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text("HOLA MUNDO"),
    );
  }
}
