import 'package:app_inspections/services/db.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ReporteF1Screen extends StatelessWidget {
  final int idTienda;

  ReporteF1Screen({Key? key, required this.idTienda}) : super(key: key);

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return databaseHelper.mostrarReporteF1(idTienda);
  }

  void _descargarPDF(BuildContext context) async {
    // Obtener los datos del informe
    List<Map<String, dynamic>> datos = await _cargarReporte(idTienda);

    // Generar el PDF
    File pdfFile = await generatePDF(datos);

    // Abrir el diálogo de compartir para compartir o guardar el PDF
    // ignore: deprecated_member_use
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
        title: const Text(
          "REPORTE",
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _descargarPDF(context);
            },
          ),
        ],
      ),
      body: ReporteF1Widget(idTienda: idTienda),
    );
  }

  void setState(Null Function() param0) {}
}

class ReporteF1Widget extends StatefulWidget {
  final int idTienda;

  const ReporteF1Widget({Key? key, required this.idTienda}) : super(key: key);

  @override
  State<ReporteF1Widget> createState() => _ReporteWidgetState();
}

Future<File> generatePDF(List<Map<String, dynamic>> data) async {
  final pdf = pdfWidgets.Document();

  pdf.addPage(
    pdfWidgets.Page(
      orientation: pdfWidgets.PageOrientation.landscape,
      build: (context) {
        // ignore: deprecated_member_use
        return pdfWidgets.Table.fromTextArray(
          data: data.map((row) {
            return [
              row['nom_dep'],
              row['clave_ubi'],
              row['nom_probl'],
              row['nom_mat'],
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
          cellStyle: const pdfWidgets.TextStyle(),
          headers: [
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
            0: const pdfWidgets.FlexColumnWidth(1), // Departamento
            1: const pdfWidgets.FlexColumnWidth(1), // Ubicación
            2: const pdfWidgets.FlexColumnWidth(3), // Problema
            3: const pdfWidgets.FlexColumnWidth(2), // Material
            4: const pdfWidgets.FlexColumnWidth(2), // Otro
            5: const pdfWidgets.FlexColumnWidth(1), // Cantidad
            6: const pdfWidgets.FlexColumnWidth(2), // Mano de Obra
            7: const pdfWidgets.FlexColumnWidth(2), // Otro
            8: const pdfWidgets.FlexColumnWidth(1), // Cantidad
            9: const pdfWidgets.FlexColumnWidth(2), // URL FOTO
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

class _ReporteWidgetState extends State<ReporteF1Widget> {
  late Future<List<Map<String, dynamic>>> _futureReporte;

  @override
  void initState() {
    super.initState();
    _futureReporte = _cargarReporte(widget.idTienda);
  }

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return databaseHelper.mostrarReporteF1(widget.idTienda);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FutureBuilder(
        future: _futureReporte,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> datos = snapshot.data!;
            return Column(children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                  // ignore: deprecated_member_use
                  dataRowHeight: 100,
                  columns: const [
                    DataColumn(
                        label: Center(
                      child: Text(
                        'Departamento',
                        softWrap: true,
                      ),
                    )),
                    DataColumn(
                        label: Text(
                      'Ubicación',
                      softWrap: true,
                    )),
                    DataColumn(
                      label: Text(
                        'Problema',
                        softWrap: true,
                      ),
                    ),
                    DataColumn(
                        label: Text(
                      'Material',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Especifique (Otro)',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Cantidad',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Mano de Obra',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Especifique (Otro)',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'Cantidad',
                      softWrap: true,
                    )),
                    DataColumn(
                        label: Text(
                      'URL FOTO',
                      softWrap: true,
                    )),
                  ],
                  rows: datos.map((dato) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text('${dato['nom_dep']}'),
                        ),
                        DataCell(
                          Text('${dato['clave_ubi']}'),
                        ),
                        DataCell(
                          Container(
                            width: (MediaQuery.of(context).size.width / 10) * 3,
                            padding: const EdgeInsets.all(3),
                            child: Center(child: Text('${dato['nom_probl']}')),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: (MediaQuery.of(context).size.width / 10) * 3,
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['nom_mat']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Center(child: Text('${dato['otro']}')),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['cant_mat']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['nom_obr']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['otro_obr']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['cant_obr']}'),
                          ),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.all(3),
                            child: Text('${dato['foto']}'),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ]);
          }
        },
      ),
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  final File image;

  const ImageViewScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image')),
      body: Center(
        child: Image.file(image),
      ),
    );
  }
}
