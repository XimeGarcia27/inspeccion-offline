import 'package:app_inspections/models/materiales.dart';
import 'package:app_inspections/models/tiendas.dart';
import 'package:app_inspections/services/db_offline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Listado extends StatelessWidget {
  const Listado({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Animales"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
        body: const Lista());
  }
}

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MiLista createState() => _MiLista();
}

class _MiLista extends State<Lista> {
  List<Tiendas> tiendas = [];

  @override
  void initState() {
    cargaAnimales();
    super.initState();
  }

  cargaAnimales() async {
    List<Tiendas> auxMaterial = await DatabaseProvider.showTiendas();

    setState(() {
      tiendas = auxMaterial;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tiendas.length,
        itemBuilder: (context, i) => Dismissible(
            key: Key(i.toString()),
            direction: DismissDirection.startToEnd,
            background: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(left: 5),
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete, color: Colors.white))),
            onDismissed: (direction) {
              //DB.delete(animales[i]);
            },
            child: ListTile(
                title: Text('${tiendas[i].codigo} ${tiendas[i].nombre}'),
                trailing: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/editar",
                          arguments: tiendas[i]);
                    },
                    child: const Icon(Icons.edit)))));
  }
}
