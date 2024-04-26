import 'dart:async';

import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/src/pages/connection/no_internet.dart';
import 'package:app_inspections/src/pages/f1.dart';
import 'package:app_inspections/src/pages/inicio_indv.dart';
import 'package:app_inspections/src/pages/utils/check_internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InspeccionTienda extends StatefulWidget {
  final int initialTabIndex;
  final TabController? controller;

  const InspeccionTienda(
      {Key? key, required this.initialTabIndex, this.controller})
      : super(key: key);

  @override
  State<InspeccionTienda> createState() => _InspeccionTiendaState();
}

class _InspeccionTiendaState extends State<InspeccionTienda>
    with SingleTickerProviderStateMixin {
  //verificar la conexion a internet
  late final CheckInternetConnection _internetConnection;
  late StreamSubscription<ConnectionStatus> _connectionSubscription;
  ConnectionStatus _currentStatus = ConnectionStatus.online;
  //Map<String, dynamic>? tienda;
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _internetConnection = CheckInternetConnection();
    _connectionSubscription =
        _internetConnection.internetStatus().listen((status) {
      setState(() {
        _currentStatus = status;
      });
    });
    controller = TabController(
        length: 2, vsync: this, initialIndex: widget.initialTabIndex);

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _connectionSubscription.cancel();
    _internetConnection.close();
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    // Obtén los datos de la tienda desde los argumentos
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String nombreTienda = arguments['nombreTienda'];
    //print('ID de tienda en InspeccionTienda: ${arguments['idTienda']}');
    int idTi = arguments['idTienda'];

    //if (_currentStatus == ConnectionStatus.online) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40.0, color: Colors.white),
          onPressed: () {
            // Puedes agregar código para manejar el evento de retroceso aquí
            Navigator.pushReplacementNamed(context, 'inicioInsp');
          },
        ),
        backgroundColor: const Color.fromRGBO(6, 6, 68, 1),
        title: Text(
          nombreTienda,
          style: const TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: const Color.fromRGBO(169, 27, 96, 1),
          controller: controller,
          labelStyle: const TextStyle(fontSize: 20),
          unselectedLabelColor: Colors.white,
          unselectedLabelStyle: const TextStyle(fontSize: 20),
          tabs: const [
            Tab(
              child: SizedBox(
                // Especifica un ancho fijo para la pestaña "Inicio"
                width: 100,
                child: Row(
                  children: [
                    Text("Historial"),
                  ],
                ),
              ),
            ),
            Tab(
              child: SizedBox(
                // Especifica un ancho fijo para la pestaña "Registro"
                width: 100,
                child: Text("Registro"),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<PopupMenuEntry>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/inicio.png"),
                    ),
                    const SizedBox(
                        width: 10), // Espacio entre la imagen y el texto
                    Text(
                      ' ${authService.currentUser}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: const Text("Cerrar Sesión"),
                onTap: () {
                  authService.logout();
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Inicio(
              idTienda: idTi,
              nomTienda: nombreTienda), // Aquí pasas el argumento a Inicio
          F1Screen(idTienda: idTi),
        ],
      ),
    );
    /* } else {
      // Si no hay conexión a Internet, mostrar el widget de No Internet
      return const Scaffold(
        body: Center(
          child: NoInternet(), // Usar el widget NoInternetWidget
        ),
      );
    } */
  }
}
