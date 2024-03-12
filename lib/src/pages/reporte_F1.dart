import 'package:app_inspections/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

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
    print("DATOS DE REPORTEE $datos");

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
  final pdfWidgets.Font customFont = pdfWidgets.Font.ttf(
    await rootBundle.load('assets/fonts/OpenSans-Italic.ttf'),
  );
  final pdf = pdfWidgets.Document();

  // Carga la imagen de forma asíncrona
  final Uint8List imageData = await _loadImageData('assets/logoconexsa.png');

  pdf.addPage(
    pdfWidgets.Page(
      orientation: pdfWidgets.PageOrientation.landscape,
      build: (context) {
        return pdfWidgets.Stack(
          children: [
            pdfWidgets.Text(
              "Reporte de Contrastista",
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
                [
                  'Departamento',
                  'Ubicación',
                  'Problema',
                  'Material',
                  'Especifique (Otro)',
                  'Cantidad',
                  'Mano de Obra',
                  'Especifique (Otro)',
                  'Cantidad',
                  'URL FOTO'
                ],
                for (var row in data)
                  [
                    row['nom_dep'].toString(),
                    row['clave_ubi'].toString(),
                    pdfWidgets.Text(
                      row['nom_probl'].toString(),
                      style: pdfWidgets.TextStyle(
                        font: customFont, // Usa la fuente personalizada aquí
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                    ),
                    pdfWidgets.Text(
                      row['nom_mat'].toString(),
                      style: pdfWidgets.TextStyle(
                        font: customFont, // Usa la fuente personalizada aquí
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                    ),
                    row['otro'].toString(),
                    row['cant_mat'].toString(),
                    row['nom_obr'].toString(),
                    row['otro_obr'].toString(),
                    row['cant_obr'].toString(),
                    row['foto'].toString(),
                  ]
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
        );
      },
    ),
  );

  // Guarda el PDF en un archivo
  final Directory directory = await getApplicationDocumentsDirectory();
  final String filePath = '${directory.path}/reporteContratista.pdf';
  final File file = File(filePath);
  await file.writeAsBytes(await pdf.save());

  return file;
}

Future<Uint8List> _loadImageData(String imagePath) async {
  final ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
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
