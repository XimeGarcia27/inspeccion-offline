import 'package:app_inspections/models/reporte_model.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:app_inspections/services/db_online.dart';
import 'package:app_inspections/src/pages/utils/check_internet_connection.dart';

final internetChecker = CheckInternetConnection();

Future<void> insertarReporteOnline(
    // Parámetros del reporte
    ) async {
  try {
    // Verificar si hay conexión a Internets
    final connectionStatus = await internetChecker.internetStatus().first;
    if (connectionStatus == ConnectionStatus.online) {
      print("CONEXION ACTIVA");
      // Si hay conexión, obtener los reportes locales
      final List<Reporte> reportes =
          await DatabaseProvider.leerReportesDesdeSQLite();

      // Sincronizar los reportes locales con la base de datos remota
      await DatabaseHelper.sincronizarConPostgreSQL(reportes);
      print("SE INSERTO EL DATO EN POSTGRE $reportes");
    }
  } catch (e) {
    print("No se pudo insertar el reporte online");
  }
}
