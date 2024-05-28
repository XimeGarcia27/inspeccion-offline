// ignore: file_names
import 'dart:io';
import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
// ignore: library_prefixes
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

class ReporteObra extends StatelessWidget {
  final int idTienda;
  final String nomTienda;

  const ReporteObra(
      {super.key, required this.idTienda, required this.nomTienda});

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    return DatabaseProvider.mostrarCantidadesObra(idTienda);
  }

  void _descargarPDF(BuildContext context, String? user) async {
    List<Map<String, dynamic>> datos = await _cargarReporte(idTienda);
    File pdfFile = await generatePDF(datos, nomTienda, user);
    // ignore: deprecated_member_use
    Share.shareFiles([pdfFile.path], text: 'Descarga tu reporte en PDF');
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    String? user = authService.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        title: const Text(
          "REPORTE DE MANO DE OBRA",
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              _descargarPDF(context, user);
            },
          ),
        ],
      ),
      body: ReporteManoObra(idTienda: idTienda),
    );
  }
}

class ReporteManoObra extends StatefulWidget {
  final int idTienda;

  const ReporteManoObra({super.key, required this.idTienda});

  @override
  State<ReporteManoObra> createState() => _ReporteManoObraState();
}

Future<File> generatePDF(
    List<Map<String, dynamic>> data, String nomTiend, String? user) async {
  final pdfWidgets.Font customFont = pdfWidgets.Font.ttf(
    await rootBundle.load('assets/fonts/OpenSans-Italic.ttf'),
  );
  final pdf = pdfWidgets.Document();
  final dateFormatter = DateFormat('yyyy-MM-dd');
  final formattedDate = dateFormatter.format(DateTime.now());
  final Uint8List imageData = await _loadImageData('assets/logoconexsa.png');
  final Uint8List backgroundImageData =
      await _loadImageData('assets/portada1.png');
  const int itemsPerPage = 20;
  final int totalPages = (data.length / itemsPerPage).ceil();

  pdf.addPage(
    pdfWidgets.Page(
      pageFormat: PdfPageFormat.a4.copyWith(
        marginLeft: 0,
        marginRight: -60,
        marginTop: 0,
        marginBottom: 0,
      ),
      build: (context) {
        return pdfWidgets.Stack(
          alignment: pdfWidgets.Alignment.center,
          children: [
            pdfWidgets.Positioned.fill(
              child: pdfWidgets.Image(
                pdfWidgets.MemoryImage(backgroundImageData),
                fit: pdfWidgets.BoxFit.cover,
              ),
            ),
            pdfWidgets.Center(
              child: pdfWidgets.Column(
                mainAxisAlignment: pdfWidgets.MainAxisAlignment.center,
                children: [
                  // Logo
                  pdfWidgets.Positioned(
                    right: 0,
                    top: 0,
                    child: pdfWidgets.Container(
                      margin: const pdfWidgets.EdgeInsets.all(5),
                      child:
                          pdfWidgets.Image(pdfWidgets.MemoryImage(imageData)),
                      width: 250,
                    ),
                  ),
                  pdfWidgets.SizedBox(height: 20),

                  pdfWidgets.Text(
                    'Reporte de Mano de Obra',
                    style: pdfWidgets.TextStyle(
                      font: customFont,
                      fontSize: 30,
                      fontWeight: pdfWidgets.FontWeight.bold,
                      color: PdfColors.blueGrey500,
                    ),
                  ),
                  pdfWidgets.Text(
                    'Fecha: $formattedDate',
                    style: pdfWidgets.TextStyle(
                      font: customFont,
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                  pdfWidgets.Text(
                    'Tienda: $nomTiend',
                    style: pdfWidgets.TextStyle(
                      font: customFont,
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                  pdfWidgets.Text(
                    'Nombre de Inspector: $user',
                    style: pdfWidgets.TextStyle(
                      font: customFont,
                      fontSize: 18,
                      color: PdfColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
    final int startIndex = pageIndex * itemsPerPage;
    final int endIndex = (startIndex + itemsPerPage < data.length)
        ? startIndex + itemsPerPage
        : data.length;
    final List<Map<String, dynamic>> pageData =
        data.sublist(startIndex, endIndex);
    pdf.addPage(
      pdfWidgets.MultiPage(
        build: (context) {
          List<pdfWidgets.Widget> widgets = [
            pdfWidgets.Container(
              padding: const pdfWidgets.EdgeInsets.all(40),
              child: pdfWidgets.Stack(
                children: [
                  pdfWidgets.Column(
                    crossAxisAlignment: pdfWidgets.CrossAxisAlignment.center,
                    children: [
                      pdfWidgets.Text(
                        'Reporte de Mano de Obra',
                        style: pdfWidgets.TextStyle(
                          font: customFont,
                          fontSize: 20,
                          fontWeight: pdfWidgets.FontWeight.bold,
                          color: PdfColors.blueGrey500,
                        ),
                      ),
                      pdfWidgets.SizedBox(height: 30),
                      // ignore: deprecated_member_use
                      pdfWidgets.Table.fromTextArray(
                        context: context,
                        data: [
                          ['Mano de Obra', 'Cantidad Total'],
                          for (var row in pageData)
                            [
                              pdfWidgets.Text(
                                row['nom_obr'].toString(),
                                style: pdfWidgets.TextStyle(
                                  font: customFont,
                                  fontSize: 12,
                                  color: PdfColors.black,
                                ),
                              ),
                              row['cantidad_total'].toString(),
                            ],
                        ],
                        border: pdfWidgets.TableBorder.all(
                          color: PdfColors.black,
                          width: 1,
                        ),
                        cellAlignment: pdfWidgets.Alignment.center,
                        cellStyle: const pdfWidgets.TextStyle(
                          fontSize: 12,
                          color: PdfColors.black,
                        ),
                        headerStyle: pdfWidgets.TextStyle(
                          fontWeight: pdfWidgets.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                        headerDecoration: const pdfWidgets.BoxDecoration(
                          color: PdfColors.lightBlue900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
          return widgets;
        },
      ),
    );
  }

  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/reporteManoDeObra.pdf';
  final File file = File(filePath);
  await file.writeAsBytes(await pdf.save());
  return file;
}

Future<Uint8List> _loadImageData(String imagePath) async {
  final ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
}

class _ReporteManoObraState extends State<ReporteManoObra> {
  late Future<List<Map<String, dynamic>>> _futureReporte;

  @override
  void initState() {
    super.initState();
    _futureReporte = _cargarReporte(widget.idTienda);
  }

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    return DatabaseProvider.mostrarCantidadesObra(idTienda);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureReporte,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>> data = snapshot.data!;
            return DataTable(
              columns: const [
                DataColumn(label: Text('Mano de Obra')),
                DataColumn(label: Text('Cantidad Total')),
              ],
              rows: data.map((row) {
                return DataRow(
                  cells: [
                    DataCell(Text(row['nom_obr'].toString())),
                    DataCell(Text(row['cantidad_total'].toString())),
                  ],
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}
