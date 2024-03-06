//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

class DatabaseHelper {
  static PostgreSQLConnection? connection;

  //DatabaseHelper._();//privado

  static Future<PostgreSQLConnection> openConnection() async {
    try {
      const databaseHost =
          'ep-red-wood-a4nzhmfu-pooler.us-east-1.postgres.vercel-storage.com';
      const databasePort = 5432;
      const databaseName = 'verceldb';
      const username = 'default';
      const password = 'Iqkc7nFOlR6d';

      final connection = PostgreSQLConnection(
        databaseHost,
        databasePort,
        databaseName,
        username: username,
        password: password,
        useSSL: true, // Habilita el uso de SSL
      );

      await connection.open();
      print('BASE CONECTADA');
      return connection;
    } catch (e) {
      print('Error al abrir la conexión: $e');

      throw e;
    }
  }

  static Future<List<Map<String, dynamic>>> mostrarTiendas() async {
    connection = await openConnection();
    try {
      print('Antes de la consulta');
      final results = await connection?.query('SELECT * FROM tiendas');
      print('despues de la consulta');
      print('Resultados de la consulta: $results');

      if (results != null) {
        final List<Map<String, dynamic>> mappedResults = results
            .map((row) => Map<String, dynamic>.from(row.toColumnMap()))
            .toList();
        return mappedResults;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al cargar datos desde Vercel: $e');
      return [];
    } finally {
      if (connection != null) {
        try {
          await connection?.query('DEALLOCATE ALL');
          await connection?.close();
        } catch (e) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  static Future<List<Map<String, dynamic>>> searchTiendas(String query) async {
    try {
      connection = await openConnection();
      final results = await connection?.query(
        'SELECT * FROM tiendas WHERE cod_tienda ILIKE @query OR nom_tienda ILIKE @query_nom',
        substitutionValues: {'query': '%$query%', 'query_nom': '%$query%'},
      );

      if (results != null) {
        return results
            .map((row) => Map<String, dynamic>.from(row.toColumnMap()))
            .toList();
      } else {
        print('Error al cargar datos desde Vercel en busqueda:');
        return [];
      }
    } catch (e) {
      print('Error al cargar datos desde Vercel en busqueda: $e');
      return [];
    } finally {
      if (connection != null) {
        try {
          await connection?.query('DEALLOCATE ALL');
          await connection?.close();
        } catch (e) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  static Future<List<Map<String, dynamic>>> mostrarProblemas(
      String query) async {
    connection = await openConnection();
    try {
      print('Antes de la consulta');
      final results = await connection?.query('SELECT * FROM problemas');
      print('despues de la consulta');
      print('Resultados de la consulta: $results');

      if (results != null) {
        final List<Map<String, dynamic>> mappedResults = results
            .map((row) => Map<String, dynamic>.from(row.toColumnMap()))
            .toList();
        return mappedResults;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al cargar datos desde Vercel: $e');
      return [];
    } finally {
      if (connection != null) {
        try {
          await connection?.query('DEALLOCATE ALL');
          await connection?.close();
        } catch (e) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  static Future<List<Map<String, dynamic>>> mostrarMateriales(
      String query) async {
    connection = await openConnection();
    try {
      print('Antes de la consulta');
      final results = await connection?.query('SELECT * FROM materiales');
      print('despues de la consulta');
      print('Resultados de la consulta: $results');

      if (results != null) {
        final List<Map<String, dynamic>> mappedResults = results
            .map((row) => Map<String, dynamic>.from(row.toColumnMap()))
            .toList();
        return mappedResults;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al cargar datos desde Vercel: $e');
      return [];
    } finally {
      if (connection != null) {
        try {
          await connection?.query('DEALLOCATE ALL');
          await connection?.close();
        } catch (e) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  static Future<List<Map<String, dynamic>>> mostrarObra(String query) async {
    connection = await openConnection();
    try {
      print('Antes de la consulta');
      final results = await connection?.query('SELECT * FROM obra');
      print('despues de la consulta');
      print('Resultados de la consulta: $results');

      if (results != null) {
        final List<Map<String, dynamic>> mappedResults = results
            .map((row) => Map<String, dynamic>.from(row.toColumnMap()))
            .toList();
        return mappedResults;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al cargar datos desde Vercel: $e');
      return [];
    } finally {
      if (connection != null) {
        try {
          await connection?.query('DEALLOCATE ALL');
          await connection?.close();
        } catch (e) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  static Future<void> insertarReporte(
      int id,
      String formato,
      String valorDepartamento,
      String valorUbicacion,
      int idProbl,
      String nomProbl,
      int idMat,
      String nomMat,
      String otro,
      int cantM,
      int idObra,
      String nomObr,
      String otroObr,
      int cantO,
      String foto,
      int idTiend) async {
    connection = await openConnection();
    try {
      // Validación de parámetros
      if (valorDepartamento.isEmpty ||
          valorUbicacion.isEmpty ||
          idProbl <= 0 ||
          idObra <= 0 ||
          idTiend <= 0) {
        throw ArgumentError(
            'Los parámetros no pueden estar vacíos o ser menores o iguales a cero.');
      }

      // Realizar la inserción en la base de datos utilizando una sentencia preparada
      await connection?.query(
        'INSERT INTO reporte (id_rep, formato, nom_dep, clave_ubi, id_probl, nom_probl, id_mat, nom_mat, otro, cant_mat, id_obr, nom_obr, otro_obr, cant_obr, foto, id_tienda)'
        'VALUES (@id, @formato, @valorDepartamento, @valorUbicacion, @idProbl, @nomProbl, @idMat, @nomMat, @otro, @cantM, @idObra, @nomObr, @otroObr, @cantO, @foto, @idTiend)',
        substitutionValues: {
          'id': id,
          'formato': formato,
          'valorDepartamento': valorDepartamento,
          'valorUbicacion': valorUbicacion,
          'idProbl': idProbl,
          'nomProbl': nomProbl,
          'idMat': idMat,
          'nomMat': nomMat,
          'otro': otro,
          'cantM': cantM,
          'idObra': idObra,
          'nomObr': nomObr,
          'otroObr': otroObr,
          'cantO': cantO,
          'foto': foto,
          'idTiend': idTiend,
        },
      );
      print("CONSULTA INSERTADA CORRECTAMENTE");
    } catch (e) {
      // Manejo de errores
      print('Error al insertar el reporte: $e');
      throw e; // Lanzar la excepción para que la maneje el código que llamó a esta función
    }
  }

  Future<List<Map<String, dynamic>>> mostrarReporte(int idtienda) async {
    print("ID TIENDA EN CONSULTA $idtienda");
    connection = await openConnection();
    try {
      print('Antes de la consulta');
      final results = await connection?.query(
          "SELECT * FROM reporte WHERE id_tienda = $idtienda ORDER BY insertion ASC");

      print('despues de la consulta');
      print('Resultados de la consulta: $results');

      if (results != null) {
        final List<Map<String, dynamic>> mappedResults = results
            .map((row) => Map<String, dynamic>.from(row.toColumnMap()))
            .toList();
        return mappedResults;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al cargar datos desde Vercel: $e');
      return [];
    } finally {
      if (connection != null) {
        try {
          await connection?.query('DEALLOCATE ALL');
          await connection?.close();
        } catch (e) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> mostrarReporteF1(int idtienda) async {
    print("ID TIENDA EN CONSULTA $idtienda");
    connection = await openConnection();
    try {
      print('Antes de la consulta');
      final results = await connection?.query(
          "SELECT * FROM reporte WHERE id_tienda = $idtienda AND formato = 'F1' ");

      print('despues de la consulta');
      print('Resultados de la consulta: $results');

      if (results != null) {
        final List<Map<String, dynamic>> mappedResults = results
            .map((row) => Map<String, dynamic>.from(row.toColumnMap()))
            .toList();
        return mappedResults;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al cargar datos desde Vercel: $e');
      return [];
    } finally {
      if (connection != null) {
        try {
          await connection?.query('DEALLOCATE ALL');
          await connection?.close();
        } catch (e) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> mostrarReporteF2(int idtienda) async {
    print("ID TIENDA EN CONSULTA $idtienda");
    connection = await openConnection();
    try {
      print('Antes de la consulta');
      final results = await connection?.query(
          "SELECT * FROM reporte WHERE id_tienda = $idtienda AND formato = 'F2' ");

      print('despues de la consulta');
      print('Resultados de la consulta: $results');

      if (results != null) {
        final List<Map<String, dynamic>> mappedResults = results
            .map((row) => Map<String, dynamic>.from(row.toColumnMap()))
            .toList();
        return mappedResults;
      } else {
        return [];
      }
    } catch (e) {
      print('Error al cargar datos desde Vercel: $e');
      return [];
    } finally {
      if (connection != null) {
        try {
          await connection?.query('DEALLOCATE ALL');
          await connection?.close();
        } catch (e) {
          print('Error al cerrar la conexión: $e');
        }
      }
    }
  }

  static Future<void> editarReporte(
    int idReporte,
    String valorDepartamento,
    String valorUbicacion,
    int idProbl,
    int idMat,
    int cantM,
    int idObra,
    int cantO,
    int idTiend,
  ) async {
    connection = await openConnection();
    try {
      // Validación de parámetros
      if (idReporte <= 0 ||
          valorDepartamento.isEmpty ||
          valorUbicacion.isEmpty ||
          idProbl <= 0 ||
          idMat <= 0 ||
          cantM <= 0 ||
          idObra <= 0 ||
          cantO <= 0 ||
          idTiend <= 0) {
        throw ArgumentError(
            'Los parámetros no pueden estar vacíos o ser menores o iguales a cero.');
      }

      // Realizar la actualización en la base de datos utilizando una sentencia preparada
      await connection?.query(
        'UPDATE reporte SET nom_dep = @valorDepartamento, clave_ubi = @valorUbicacion, '
        'id_probl = @idProbl, id_mat = @idMat, cant_mat = @cantM, id_obr = @idObra, '
        'cant_obr = @cantO, id_tienda = @idTiend WHERE id_rep = @idReporte',
        substitutionValues: {
          'idReporte': idReporte,
          'valorDepartamento': valorDepartamento,
          'valorUbicacion': valorUbicacion,
          'idProbl': idProbl,
          'idMat': idMat,
          'cantM': cantM,
          'idObra': idObra,
          'cantO': cantO,
          'idTiend': idTiend,
        },
      );
    } catch (e) {
      // Manejo de errores
      print('Error al editar el reporte: $e');
      throw e; // Lanzar la excepción para que la maneje el código que llamó a esta función
    }
  }

  Future<Map<String, dynamic>> obtenerDefectoPorId(int idDefecto) async {
    try {
      connection = await openConnection();

      // Realiza la consulta en tu tabla de problemas utilizando el ID proporcionado
      List<Map<String, Map<String, dynamic>>> resultados =
          await connection!.mappedResultsQuery(
        'SELECT * FROM problemas WHERE id_probl = @id',
        substitutionValues: {'id': idDefecto},
      );

      // Cierra la conexión después de realizar la consulta
      await connection?.close();

      // Si se encontraron resultados, retorna el primer resultado
      if (resultados.isNotEmpty) {
        return resultados.first.values.first;
      } else {
        // Si no se encontraron resultados, retorna un mapa vacío
        return {};
      }
    } catch (e) {
      // Manejo de errores, puedes imprimir el error o manejarlo de acuerdo a tus necesidades
      print('Error al obtener el defecto por ID: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> obtenerMaterialPorId(int idMaterial) async {
    try {
      connection = await openConnection();

      // Realiza la consulta en tu tabla de problemas utilizando el ID proporcionado
      List<Map<String, Map<String, dynamic>>> resultados =
          await connection!.mappedResultsQuery(
        'SELECT * FROM materiales WHERE id_mat = @id',
        substitutionValues: {'id': idMaterial},
      );

      // Cierra la conexión después de realizar la consulta
      await connection?.close();

      // Si se encontraron resultados, retorna el primer resultado
      if (resultados.isNotEmpty) {
        return resultados.first.values.first;
      } else {
        // Si no se encontraron resultados, retorna un mapa vacío
        return {};
      }
    } catch (e) {
      // Manejo de errores, puedes imprimir el error o manejarlo de acuerdo a tus necesidades
      print('Error al obtener el defecto por ID: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> obtenerObraPorId(int idObra) async {
    try {
      connection = await openConnection();

      // Realiza la consulta en tu tabla de problemas utilizando el ID proporcionado
      List<Map<String, Map<String, dynamic>>> resultados =
          await connection!.mappedResultsQuery(
        'SELECT * FROM obra WHERE id_obr = @id',
        substitutionValues: {'id': idObra},
      );

      // Cierra la conexión después de realizar la consulta
      await connection?.close();

      // Si se encontraron resultados, retorna el primer resultado
      if (resultados.isNotEmpty) {
        return resultados.first.values.first;
      } else {
        // Si no se encontraron resultados, retorna un mapa vacío
        return {};
      }
    } catch (e) {
      // Manejo de errores, puedes imprimir el error o manejarlo de acuerdo a tus necesidades
      print('Error al obtener el defecto por ID: $e');
      return {};
    }
  }
}
