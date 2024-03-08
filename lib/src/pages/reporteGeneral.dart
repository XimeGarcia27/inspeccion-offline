import 'package:app_inspections/services/db.dart';
import 'package:data_table_2/data_table_2.dart' as DataTable2;
import 'package:flutter/material.dart';

class ReporteScreen extends StatelessWidget {
  final int idTienda;

  const ReporteScreen({Key? key, required this.idTienda}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "REPORTE",
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ReporteWidget(idTienda: idTienda),
    );
  }
}

class ReporteWidget extends StatefulWidget {
  final int idTienda;

  const ReporteWidget({Key? key, required this.idTienda}) : super(key: key);

  @override
  State<ReporteWidget> createState() => _ReporteWidgetState();
}

class _ReporteWidgetState extends State<ReporteWidget> {
  late Future<List<Map<String, dynamic>>> _futureReporte;
  Map<String, double> _cantidadesTotales =
      {}; // Mapa para almacenar las cantidades totales

  @override
  void initState() {
    super.initState();
    _futureReporte = _cargarReporte(widget.idTienda);
  }

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return await databaseHelper.mostrarReporte(widget.idTienda);
  }

  // Método para calcular las cantidades totales para cada material
  void _calcularCantidadesTotales(List<Map<String, dynamic>> datos) {
    // Reiniciar el mapa de cantidades totales
    _cantidadesTotales = {};

    // Iterar sobre los datos del reporte y actualizar las cantidades totales
    for (var dato in datos) {
      String nombreMaterial = dato['nom_mat'];
      String cantidadMaterialString = dato['cant_mat'];
      double cantidadMaterial = double.parse(cantidadMaterialString);

      _cantidadesTotales.update(
        nombreMaterial,
        (existingValue) => existingValue + cantidadMaterial,
        ifAbsent: () => cantidadMaterial,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureReporte,
      builder: (context, snapshotReporte) {
        if (snapshotReporte.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshotReporte.hasError) {
          return Center(child: Text('Error: ${snapshotReporte.error}'));
        } else {
          List<Map<String, dynamic>> datos = snapshotReporte.data!;
          _calcularCantidadesTotales(datos); // Calcular las cantidades totales

          List<DataRow> rows = [];
          _cantidadesTotales.forEach((nombreMaterial, cantidadTotal) {
            rows.add(
              DataRow(cells: [
                DataCell(Text(nombreMaterial)),
                DataCell(Text(cantidadTotal.toString())),
              ]),
            );
          });

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable2.DataTable2(
                dividerThickness: 5,
                dataRowHeight: 50,
                headingRowHeight: 100,
                columnSpacing: 5,
                columns: const [
                  DataColumn(label: Text('Material')),
                  DataColumn(label: Text('Cantidad Total')),
                ],
                rows: rows,
              ),
            ),
          );
        }
      },
    );
  }
}
