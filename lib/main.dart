import 'package:app_inspections/models/mano_obra.dart';
import 'package:app_inspections/models/materiales.dart';
import 'package:app_inspections/models/problemas.dart';
import 'package:app_inspections/models/tiendas.dart';
import 'package:app_inspections/models/usuarios.dart';
import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db_online.dart';
import 'package:app_inspections/services/sincronizarBd.dart';
import 'package:app_inspections/services/subir_online.dart';
import 'package:app_inspections/src/pages/agregarDefectos.dart';
import 'package:app_inspections/src/pages/f1.dart';
import 'package:app_inspections/src/pages/inicio_indv.dart';
import 'package:app_inspections/src/pages/prueba.dart';
import 'package:app_inspections/src/pages/screens.dart';
import 'package:app_inspections/src/pages/users.dart';
import 'package:app_inspections/src/pages/utils/check_internet_connection.dart';
import 'package:app_inspections/src/screens/home_foto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final internetChecker = CheckInternetConnection();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //inicializa bd online
  DatabaseHelper dbHelper;

  // Llama a la función para insertar los datos iniciales de materiales
  insertInitialDataM();
  //llamar a la funcion para insertar datos iniciales de problemas
  insertInitialDataP();
  //llamar a la funcion para insertar datos iniciales de mano de obra
  insertInitialDataO();
  //llamar a la funcion para inserta r datos iniciales de tiendas
  insertInitialDataT();
  //llamar a la funcion para insertar datos iniciales de usuarios
  insertInitialDataUser();
  //llamar a la funcion para insertar datos del reporte cuando hay internet

  insertarReporteOnline();

  insertarImagenesOnline();

  dbHelper = DatabaseHelper();

  // Aquí puedes llamar a la función de transferencia de datos
  transferirDePostgreSQLASQLite().then((_) {
    runApp(AppState(
      dbHelper: dbHelper,
    ));
  }).catchError((error) {
    print('Error al transferir datos al instalar la aplicación: $error');
    // Continuar con la ejecución de la aplicación incluso si hay un error en la transferencia de datos
    runApp(AppState(
      dbHelper: dbHelper,
    ));
  });

  return;
}

class NotificationsServices {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static void init() {}
}

class AppState extends StatelessWidget {
  final DatabaseHelper dbHelper;

  const AppState({required this.dbHelper, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "login",
      routes: {
        "splash": (_) => const SplashScreen(),
        "registro": (_) => const RegistroScreen(),
        "login": (_) => const LoginScreen(),
        "inicioInsp": (_) => const InicioInspeccion(),
        "inspectienda": (_) => const InspeccionTienda(initialTabIndex: 0),
        "f1": (_) => const F1Screen(idTienda: 1),
        "inicio": (_) =>
            const InicioScreen(idTienda: 1, initialTabIndex: 0, nomTienda: ''),
        "home": (_) => const HomeFoto(),
        "user": (_) => const UserInsertion(),
        "prueba": (_) => const FormPrincipal(
              idTienda: 1,
            ),
        "defectos": (_) => Defectos(),
      },
      scaffoldMessengerKey: NotificationsServices.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
    );
  }
}
