import 'package:app_inspections/models/mano_obra.dart';
import 'package:app_inspections/models/materiales.dart';
import 'package:app_inspections/models/problemas.dart';
import 'package:app_inspections/models/tiendas.dart';
import 'package:app_inspections/models/usuarios.dart';
import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/src/pages/f1.dart';
import 'package:app_inspections/src/pages/inicio_indv.dart';
import 'package:app_inspections/src/pages/prueba.dart';
import 'package:app_inspections/src/pages/screens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  runApp(const AppState());

  return;
}

class NotificationsServices {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static void init() {}
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

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
        "login": (_) => const LoginScreen(),
        "inicioInsp": (_) => const InicioInspeccion(),
        "inspectienda": (_) => const InspeccionTienda(initialTabIndex: 0),
        "f1": (_) => const F1Screen(idTienda: 1),
        "inicio": (_) =>
            const InicioScreen(idTienda: 1, initialTabIndex: 0, nomTienda: ''),
        "prueba": (_) => const PruebaExcel(idTienda: 1, nomTienda: ''),
      },
      scaffoldMessengerKey: NotificationsServices.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
    );
  }
}
