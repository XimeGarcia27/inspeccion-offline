import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db.dart';
import 'package:app_inspections/src/pages/f1.dart';
import 'package:app_inspections/src/pages/fotos_prueba.dart';
import 'package:app_inspections/src/pages/inicio_indv.dart';
import 'package:app_inspections/src/pages/reporteGeneral.dart';
import 'package:app_inspections/src/pages/screens.dart';
import 'package:app_inspections/src/pages/users.dart';
import 'package:app_inspections/src/screens/home_foto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final dbHelper = DatabaseHelper();
  await AuthService().openConnection();
  runApp(AppState(dbHelper: dbHelper));
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
      initialRoute: "inicioInsp",
      routes: {
        "splash": (_) => const SplashScreen(),
        "registro": (_) => const RegistroScreen(),
        "login": (_) => const LoginScreen(),
        "inicioInsp": (_) => const InicioInspeccion(),
        "inspectienda": (_) => const InspeccionTienda(initialTabIndex: 0),
        "f1": (_) => const F1Screen(idTienda: 1),
        "reporte": (_) => const ReporteScreen(
              idTienda: 1,
            ),
        "inicio": (_) =>
            const InicioScreen(idTienda: 1, initialTabIndex: 0, nomTienda: ''),
        "home": (_) => HomeFoto(),
        "foto": (_) => FotosPrueba(),
        "user": (_) => const UserInsertion(),
      },
      scaffoldMessengerKey: NotificationsServices.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
    );
  }
}
