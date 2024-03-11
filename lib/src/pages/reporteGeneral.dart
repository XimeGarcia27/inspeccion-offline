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

  @override
  void initState() {
    super.initState();
    _futureReporte = _cargarReporte(widget.idTienda);
  }

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return await databaseHelper.mostrarReporte(widget.idTienda);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureReporte,
      builder: (context, snapshotReporte) {
        if (snapshotReporte.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshotReporte.hasError) {
          return Center(child: Text('Error: ${snapshotReporte.error}'));
        } else {
          List<Map<String, dynamic>> datos = snapshotReporte.data!;
          calcularCantidadesTotales(datos); // Calcular las cantidades totales
          setState(() {});
          List<DataRow> rows = [];
          cantidadesTotales.forEach((nombreMaterial, cantidadTotal) {
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
