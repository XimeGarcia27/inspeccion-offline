import 'package:app_inspections/search/search_delegate.dart';
import 'package:app_inspections/services/auth_service.dart';
import 'package:app_inspections/services/db.dart';
import 'package:app_inspections/src/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InicioInspeccion extends StatelessWidget {
  const InicioInspeccion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color encabezado = const Color(0xFF060644);
    return Home(encabezado: encabezado);
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.encabezado,
  });

  final Color encabezado;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //List<Map<String, dynamic>> datos = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 174, 174, 174),
      appBar: AppBar(
        backgroundColor: widget.encabezado,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Inspecciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            //Icon(Icons.exit_to_app_rounded, size: 40, color: Colors.white),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined, color: Colors.white),
            onPressed: () {
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ],
        toolbarHeight: 110.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25.0, left: 8.0, right: 8.0),
        child: SizedBox(
          height: 1000,
          child: CardContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: TiendaSearchDelegate(),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: FutureBuilder(
                    future: DatabaseHelper.mostrarTiendas(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        //print(snapshot.data);
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Map<String, dynamic>> datos = snapshot.data!;
                        return ListView.builder(
                          itemCount: datos.length,
                          itemBuilder: (context, index) {
                            final dato = datos[index];
                            print("datos $dato");
                            int idTiendaSeleccionada = dato[
                                'id_tienda']; // Asumiendo que el id de la tienda está en 'id_tienda'
                            return ListTile(
                              title: Text(
                                  '${dato['cod_tienda']} ${dato['nom_tienda']}'),
                              onTap: () {
                                String nombreTiendaSeleccionada =
                                    '${dato['cod_tienda']} ${dato['nom_tienda']}';
                                Navigator.pushNamed(
                                  context,
                                  'inspectienda',
                                  arguments: {
                                    'nombreTienda': nombreTiendaSeleccionada,
                                    'idTienda': idTiendaSeleccionada,
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
