import 'package:app_inspections/services/db_offline.dart';
import 'package:app_inspections/services/db_online.dart';
import 'package:sqflite/sqflite.dart';

/* Future<void> transferirDePostgreSQLASQLite() async {
  final connection = await DatabaseHelper.openConnection();

  final List<List<dynamic>> datos =
      await connection.query('SELECT * FROM reportes');

  Database database = await DatabaseProvider.openDB();

  for (final dato in datos) {
    // Inserta los datos en SQLite
    await database.rawInsert(
      'INSERT INTO reporte (id_rep, formato, nom_dep, clave_ubi, id_probl, nom_probl, id_mat, nom_mat, otro, cant_mat, id_obra, nom_obr, otro_obr, cant_obr, foto, dato_unico) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        dato[0],
        dato[1],
        dato[2],
        dato[3],
        dato[4],
        dato[5],
        dato[6],
        dato[7],
        dato[8],
        dato[9],
        dato[10],
        dato[11],
        dato[12],
        dato[13],
        dato[14],
        dato[15],
        dato[16],
        dato[17],
        dato[18],
        dato[19],
      ],
    );
  }

  await connection.close();
  await database.close();
}
 */
Future<void> transferirDePostgreSQLASQLite() async {
  try {
    final connection = await DatabaseHelper.openConnection();
    final List<List<dynamic>> datos =
        await connection.query('SELECT * FROM reportes');

    if (datos.isNotEmpty) {
      final Database database = await DatabaseProvider.openDB();

      for (final dato in datos) {
        print(dato[0]);
        print(dato[1]);
        print(dato[2]);
        print(dato[3]);
        print(dato[4]);
        print(dato[5]);
        print(dato[6]);
        print(dato[7]);
        print(dato[8]);
        print(dato[9]);
        print(dato[10]);

        print(dato[11]);
        print(dato[12]);
        print(dato[13]);
        print(dato[14]);
        print(dato[15]);
        print(dato[16]);
        print(dato[17]);
        print(dato[18]);
        print(dato[19]);
        print(dato[20]);
        // Inserta los datos en SQLite
        //id_rep, formato, nom_dep, clave_ubi, id_probl, nom_probl, id_mat, nom_mat, otro, cant_mat, id_obra, nom_obr, otro_obr, cant_obr, foto, dato_unico, dato_comp, insertion, nom_user, last_updated, id_tienda
        await database.rawInsert(
          'INSERT INTO reporte (id_rep, formato, nom_dep, clave_ubi, id_probl, nom_probl, id_mat, nom_mat, otro, cant_mat, id_obra, nom_obr, otro_obr, cant_obr, foto, dato_unico, dato_comp, insertion, nom_user, last_updated, id_tienda) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            dato[0],
            dato[1],
            dato[2],
            dato[3],
            dato[4],
            dato[5],
            dato[6],
            dato[7],
            dato[8],
            dato[9],
            dato[10],
            dato[11],
            dato[12],
            dato[13],
            dato[14],
            dato[15],
            dato[16],
            dato[17].toString(),
            dato[18],
            dato[19].toString(),
            dato[20],
          ],
        );
      }

      //await database.close();
    } else {
      print('No hay datos en PostgreSQL para transferir.');
    }
  } catch (e) {
    print('Error al transferir datos de PostgreSQL a SQLite: $e');
  }
}
