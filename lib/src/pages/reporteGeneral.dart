import 'dart:io';
import 'dart:math';
import 'package:app_inspections/services/db.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

class ReporteScreen extends StatelessWidget {
  final int idTienda;

  const ReporteScreen({Key? key, required this.idTienda}) : super(key: key);

  Future<List<Map<String, dynamic>>> _cargarReporte(int idTienda) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    return await databaseHelper.mostrarCantidades(idTienda);
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
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () {
              _descargarPDF(context);
            },
          ),
        ],
      ),
      body: ReporteWidget(idTienda: idTienda),
    );
  }
}

class ReporteWidget extends StatefulWidget {
  final int idTienda;

  const ReporteWidget({Key? key, required this.idTienda}) : super(key: key);

  get pdfWidgets => null;

  @override
  State<ReporteWidget> createState() => _ReporteWidgetState();
}

Future<File> generatePDF(List<Map<String, dynamic>> data) async {
  // Carga la fuente personalizada
  final pdfWidgets.Font customFont = pdfWidgets.Font.ttf(
    await rootBundle.load('assets/fonts/OpenSans-Italic.ttf'),
  );
  final pdf = pdfWidgets.Document();

  // Carga la imagen de forma asíncrona
  final Uint8List imageData = await _loadImageData('assets/logoconexsa.png');

  // Añade la página al PDF
  pdf.addPage(
    pdfWidgets.Page(
      build: (context) {
        // Crea un widget que contiene todos los elementos del PDF
        return pdfWidgets.Container(
          padding: const pdfWidgets.EdgeInsets.all(40),
          child: pdfWidgets.Stack(
            children: [
              /* pdfWidgets.Positioned(
                right: 0,
                top: 0,
                child: pdfWidgets.Container(
                  margin: const pdfWidgets.EdgeInsets.all(5),
                  child: pdfWidgets.Image(pdfWidgets.MemoryImage(imageData)),
                  width: 100, // Ancho de la imagen
                ),
              ), */
              // Agrega el contenido del PDF
              pdfWidgets.Column(
                crossAxisAlignment: pdfWidgets.CrossAxisAlignment.center,
                children: [
                  // Agrega un título al PDF
                  pdfWidgets.Text(
                    'Reporte de Materiales',
                    style: pdfWidgets.TextStyle(
                      font: customFont,
                      fontSize: 20,
                      fontWeight: pdfWidgets.FontWeight.bold,
                      color: PdfColors.blueGrey500, // Cambia el color del texto
                    ),
                  ),
                  pdfWidgets.SizedBox(height: 30),
                  // Agrega una tabla con los datos
                  // ignore: deprecated_member_use
                  pdfWidgets.Table.fromTextArray(
                    context: context,
                    data: [
                      ['Material', 'Cantidad Total'],
                      for (var row in data)
                        [
                          pdfWidgets.Text(
                            row['nom_mat'].toString(),
                            style: pdfWidgets.TextStyle(
                              font:
                                  customFont, // Usa la fuente personalizada aquí
                              fontSize: 12,
                              color: PdfColors.black,
                            ),
                          ),
                          row['cantidad_total'].toString(),
                        ],
                    ],
                    border: null, // Elimina el borde de la tabla
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
                      color: PdfColors
                          .grey200, // Cambia el color de fondo del encabezado
                    ),
                  ),
                  pdfWidgets.Positioned.fill(
                    child: pdfWidgets.Center(
                      // Rota la imagen en sentido contrario a las agujas del reloj
                      child: pdfWidgets.Opacity(
                        opacity: 0.1, // Establece la opacidad de la imagen

                        child: pdfWidgets.Image(
                          pdfWidgets.MemoryImage(imageData),
                          width: 300, // Ancho deseado de la imagen
                          height: 300, // Alto deseado de la imagen
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

Future<Uint8List> _loadImageData(String imagePath) async {
  final ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
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
    return await databaseHelper.mostrarCantidades(widget.idTienda);
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
                DataColumn(label: Text('Material')),
                DataColumn(label: Text('Cantidad Total')),
              ],
              rows: data.map((row) {
                return DataRow(
                  cells: [
                    DataCell(Text(row['nom_mat'].toString())),
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
