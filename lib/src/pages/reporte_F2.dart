import 'package:app_inspections/services/db.dart';
import 'package:data_table_2/data_table_2.dart' as DataTable2;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReporteF2Screen extends StatelessWidget {
  final int idTienda;

  const ReporteF2Screen({Key? key, required this.idTienda}) : super(key: key);

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return databaseHelper.mostrarReporteF2(idTienda);
  }

  void _descargarPDF(BuildContext context) async {
    // Obtener los datos del informe
    List<Map<String, dynamic>> datos = await _cargarReporte(idTienda);

    // Generar el PDF
    File pdfFile = await generatePDF(datos);

    // Abrir el diálogo de compartir para compartir o guardar el PDF
    Share.shareFiles([pdfFile.path], text: 'Descarga tu reporte en PDF');
  }

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
        title: Text(
          "REPORTE",
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _descargarPDF(context);
            },
          ),
        ],
      ),
      body: ReporteF2Widget(idTienda: idTienda),
    );
  }
}

class ReporteF2Widget extends StatefulWidget {
  final int idTienda;

  const ReporteF2Widget({Key? key, required this.idTienda}) : super(key: key);

  @override
  State<ReporteF2Widget> createState() => _ReporteWidgetState();
}

Future<File> generatePDF(List<Map<String, dynamic>> data) async {
  final pdf = pdfWidgets.Document();

  pdf.addPage(
    pdfWidgets.Page(
      orientation: pdfWidgets.PageOrientation.landscape,
      build: (context) {
        return pdfWidgets.Table.fromTextArray(
          data: data.map((row) {
            String nomMa = row['nom_mat'].toString().replaceAll('"', '""');
            return [
              //row['id_rep'].toString(),
              row['formato'],
              row['nom_dep'],
              row['clave_ubi'],
              row['nom_probl'],
              nomMa,
              row['otro'],
              row['cant_mat'],
              row['nom_obr'],
              row['otro_obr'],
              row['cant_obr'],
              row['foto'],
            ];
          }).toList(),
          headerStyle: pdfWidgets.TextStyle(
            fontWeight: pdfWidgets.FontWeight.bold,
            color: PdfColors.black, // Color del texto del encabezado
          ),
          cellStyle: const pdfWidgets.TextStyle(
            background: pdfWidgets.BoxDecoration(
              color: PdfColors.black, // Verde brillante
            ),
          ),
          headers: [
            //'ID',
            'Formato',
            'Departamento',
            'Ubicación',
            'Problema',
            'Material',
            'Especifique (Otro)',
            'Cantidad',
            'Mano de Obra',
            'Especifique (Otro)',
            'Cantidad',
            'URL FOTO',
          ],
          columnWidths: {
            0: pdfWidgets.FlexColumnWidth(1), // Formato
            1: pdfWidgets.FlexColumnWidth(1), // Departamento
            2: pdfWidgets.FlexColumnWidth(1), // Ubicación
            3: pdfWidgets.FlexColumnWidth(3), // Problema
            4: pdfWidgets.FlexColumnWidth(2), // Material
            5: pdfWidgets.FlexColumnWidth(2), // Otro
            6: pdfWidgets.FlexColumnWidth(1), // Cantidad
            7: pdfWidgets.FlexColumnWidth(2), // Mano de Obra
            8: pdfWidgets.FlexColumnWidth(2), // Otro
            9: pdfWidgets.FlexColumnWidth(1), // Cantidad
            10: pdfWidgets.FlexColumnWidth(2), // URL FOTO
          },
        );
      },
    ),
  );
  // Guarda el PDF en un archivo
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/reporte.pdf';
  final File file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  return file;
}

class _ReporteWidgetState extends State<ReporteF2Widget> {
  late Future<List<Map<String, dynamic>>> _futureReporte;

  @override
  void initState() {
    super.initState();
    _futureReporte = _cargarReporte(widget.idTienda);
  }

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return databaseHelper.mostrarReporteF2(widget.idTienda);
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
                      Container(
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
