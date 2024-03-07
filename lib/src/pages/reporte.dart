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
    return databaseHelper.mostrarReporte(widget.idTienda);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _futureReporte,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> datos = snapshot.data!;
            return DataTable2.DataTable2(
              dividerThickness: 5,
              dataRowHeight: 50,
              headingRowHeight: 100,
              columnSpacing: 5,
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Formato')),
                DataColumn(label: Text('Departamento')),
                DataColumn(label: Text('Ubicación')),
                DataColumn(label: Text('Problema')),
                DataColumn(label: Text('Material')),
                DataColumn(label: Text('Especifique (Otro)')),
                DataColumn(label: Text('Cantidad')),
                DataColumn(label: Text('Mano de Obra')),
                DataColumn(label: Text('Especifique (Otro)')),
                DataColumn(label: Text('Cantidad')),
                DataColumn(label: Text('URL FOTO')),
              ],
              rows: datos.map((dato) {
                return DataRow(
                  cells: [
                    DataCell(Text('${dato['id_rep']}')),
                    DataCell(Text('${dato['formato']}')),
                    DataCell(Text('${dato['nom_dep']}')),
                    DataCell(Text('${dato['clave_ubi']}')),
                    DataCell(
                      SizedBox(
                        width: 400,
                        child: Text(
                          '${dato['nom_probl']}',
                          softWrap: true,
                        ),
                      ),
                    ),
                    DataCell(Text('${dato['nom_mat']}')),
                    DataCell(Text('${dato['otro']}')),
                    DataCell(Text('${dato['cant_mat']}')),
                    DataCell(Text('${dato['nom_obr']}')),
                    DataCell(Text('${dato['otro_obr']}')),
                    DataCell(Text('${dato['cant_obr']}')),
                    DataCell(Text('${dato['foto']}')),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
