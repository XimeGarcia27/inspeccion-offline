import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState { authenticated, unauthenticated }

class AuthService extends ChangeNotifier {
  AuthState _authState = AuthState.unauthenticated;
  AuthState get authState => _authState;

  String? _currentUser;
  String? get currentUser => _currentUser;

  final String _databaseHost =
      'ep-red-wood-a4nzhmfu-pooler.us-east-1.postgres.vercel-storage.com';
  final int _databasePort = 5432;
  final String _databaseName = 'verceldb';
  final String _username = 'default';
  final String _password = 'Iqkc7nFOlR6d';

  final storage = const FlutterSecureStorage();

  Future<PostgreSQLConnection> openConnection() async {
    try {
      final connection = PostgreSQLConnection(
        _databaseHost,
        _databasePort,
        _databaseName,
        username: _username,
        password: _password,
        useSSL: true,
      );

      await connection.open();
      if (kDebugMode) {
        print('BASE CONECTADA');
      }
      return connection;
    } catch (e) {
      if (kDebugMode) {
        print('Error al abrir la conexión: $e');
      }
      rethrow;
    }
  }

  Future<void> closeConnection() async {
    final connection = await openConnection();
    await connection.close();
    if (kDebugMode) {
      print('Conexión a PostgreSQL cerrada');
    }
  }

  // Método para establecer el nombre de usuario actual
  void setCurrentUser(String username) {
    _currentUser = username;
    notifyListeners(); // Notificar a los listeners que el estado ha cambiado
  }

  Future<String?> createUser(
      String name, String email, String contrasena) async {
    try {
      final connection = await openConnection();
      await connection.query(
          'INSERT INTO usuarios (nombre, email, password) VALUES (@name, @email, @contrasena)',
          substitutionValues: {
            'name': name,
            'email': email,
            'contrasena': contrasena
          });
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error al registrar usuario: $e');
      }
      return e.toString();
    }
  }

  Future<String?> login(String email, String contrasena) async {
    try {
      final connection = await openConnection();
      final result = await connection.query(
          'SELECT email FROM usuarios WHERE email = @email AND password = @contrasena',
          substitutionValues: {'email': email, 'contrasena': contrasena});
      if (result.isNotEmpty) {
        // Obtiene el nombre de usuario del resultado de la consulta
        final nombreUsuario = result[0][0] as String;

        // Establece el nombre de usuario en el servicio de autenticación
        setCurrentUser(nombreUsuario);
        _authState = AuthState.authenticated;
        notifyListeners();
        return null;
      } else {
        return 'Credenciales incorrectas';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al iniciar sesión: $e');
      }
      return e.toString();
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
    _authState = AuthState.unauthenticated;
    notifyListeners();
    if (kDebugMode) {
      print('Usuario desconectado');
    }
  }

  Future<String?> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
