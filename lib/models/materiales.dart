import 'package:app_inspections/services/db_offline.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

//modelo de las opciones de materiales para el formulario
class Materiales {
  int? id;
  String nombre;

  Materiales({
    required this.id,
    required this.nombre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_mat': id,
      'nom_mat': nombre,
    };
  }
}

//método para insertar las opciones de materiales en la bd local en la tabla materiales
void insertInitialDataM() async {
  getDatabasesPath().then((databasePath) async {
    join(databasePath, 'conexsa.db');

    final List<Materiales> materiales = [
      Materiales(id: null, nombre: 'Barra transversal galv 36” (cross bar)'),
      Materiales(id: null, nombre: 'Barra transversal galv 42” (cross bar)'),
      Materiales(id: null, nombre: 'Barra transversal galv 48” (cross bar)'),
      Materiales(
          id: null, nombre: 'Set versarack 96" beige (2 postes por set)'),
      Materiales(id: null, nombre: 'Tornillo grado 5, 7/16”x4” galv'),
      Materiales(id: null, nombre: 'Tornillo grado 5, 7/16”x2” galv'),
      Materiales(
          id: null, nombre: 'Tornillo grado 5, 1/4”x4 galv. (Ex Home Mart)'),
      Materiales(
          id: null, nombre: 'Tornillo grado 5, 1/4”x2 galv. (Ex Home Mart)'),
      Materiales(id: null, nombre: 'Columna seguridad galv. 1 5/8” x 156”'),
      Materiales(id: null, nombre: 'Bracket columna seguridad galv'),
      Materiales(id: null, nombre: 'Protector columna amarillo 12”'),
      Materiales(id: null, nombre: 'Separador rack galv 8”'),
      Materiales(id: null, nombre: 'Separador rack galv 6”'),
      Materiales(id: null, nombre: 'Separador tablo galvanizado”'),
      Materiales(id: null, nombre: 'Nivelador HD sísmico galv'),
      Materiales(id: null, nombre: 'Nivelador ARU sismico galv'),
      Materiales(id: null, nombre: 'Viga seguridad amarilla 51”'),
      Materiales(id: null, nombre: 'Viga seguridad amarilla 75”'),
      Materiales(id: null, nombre: 'Viga seguridad amarilla 87”'),
      Materiales(id: null, nombre: 'Viga seguridad amarilla 99”'),
      Materiales(id: null, nombre: 'Viga seguridad amarilla 108”'),
      Materiales(id: null, nombre: 'Viga beige 3.31”x48”'),
      Materiales(id: null, nombre: 'Viga beige 3.31”x51”'),
      Materiales(id: null, nombre: 'Viga beige 3.31”x75”'),
      Materiales(id: null, nombre: 'Viga beige 3.31”x87”'),
      Materiales(id: null, nombre: 'Viga beige 3.31”x99”'),
      Materiales(id: null, nombre: 'Viga beige 3.31”x102”'),
      Materiales(id: null, nombre: 'Viga beige 3.31”x108”'),
      Materiales(id: null, nombre: 'Viga beige 5.5”x75”'),
      Materiales(id: null, nombre: 'Viga beige 5.5”x87”'),
      Materiales(id: null, nombre: 'Viga beige 5.5”x99”'),
      Materiales(id: null, nombre: 'Viga beige 5.5”x108”'),
      Materiales(id: null, nombre: 'Viga beige 6”x126”'),
      Materiales(id: null, nombre: 'Viga beige 6”x156”'),
      Materiales(id: null, nombre: 'Viga galv 3.31”x48”'),
      Materiales(id: null, nombre: 'Viga galv 3.31”x51”'),
      Materiales(id: null, nombre: 'Viga galv 3.31”x75”'),
      Materiales(id: null, nombre: 'Viga galv 3.31”x87”'),
      Materiales(id: null, nombre: 'Viga galv 3.31”x99”'),
      Materiales(id: null, nombre: 'Viga galv 3.31”x102”'),
      Materiales(id: null, nombre: 'Viga galv 3.31”x108”'),
      Materiales(id: null, nombre: 'Viga galv 5.5”x75”'),
      Materiales(id: null, nombre: 'Viga galv 5.5”x87”'),
      Materiales(id: null, nombre: 'Viga galv 5.5”x99”'),
      Materiales(id: null, nombre: 'Viga galv 5.5”x108”'),
      Materiales(id: null, nombre: 'Viga galv 6”x126”'),
      Materiales(id: null, nombre: 'Viga galv 6”x156”'),
      Materiales(id: null, nombre: 'Viga naranja 3.31”x51”'),
      Materiales(id: null, nombre: 'Viga naranja 3.31”x75”'),
      Materiales(id: null, nombre: 'Viga naranja 3.31”x87”'),
      Materiales(id: null, nombre: 'Viga naranja 3.31”x99”'),
      Materiales(id: null, nombre: 'Viga naranja 3.31”x108”'),
      Materiales(id: null, nombre: 'Viga naranja 5.5”x75”'),
      Materiales(id: null, nombre: 'Viga naranja 5.5”x87”'),
      Materiales(id: null, nombre: 'Viga naranja 5.5”x99”'),
      Materiales(id: null, nombre: 'Viga naranja 5.5”x108”'),
      Materiales(id: null, nombre: 'Viga naranja 6”x126”'),
      Materiales(id: null, nombre: 'Viga naranja 6”x156”'),
      Materiales(id: null, nombre: 'Viga reforzada amarilla 6”x51”'),
      Materiales(id: null, nombre: 'Viga reforzada amarilla 6”x108”'),
      Materiales(id: null, nombre: 'Marco beige 24”x48”'),
      Materiales(id: null, nombre: 'Marco beige 24”x60”'),
      Materiales(id: null, nombre: 'Marco beige 24”x72”'),
      Materiales(id: null, nombre: 'Marco beige 24”x96”'),
      Materiales(id: null, nombre: 'Marco beige 36”x48”'),
      Materiales(id: null, nombre: 'Marco beige 36”x60”'),
      Materiales(id: null, nombre: 'Marco beige 36”x72”'),
      Materiales(id: null, nombre: 'Marco beige 36”x96”'),
      Materiales(id: null, nombre: 'Marco beige 42”x48”'),
      Materiales(id: null, nombre: 'Marco beige 42”x60”'),
      Materiales(id: null, nombre: 'Marco beige 42”x72”'),
      Materiales(id: null, nombre: 'Marco beige 42”x96”'),
      Materiales(id: null, nombre: 'Marco beige 48”x48”'),
      Materiales(id: null, nombre: 'Marco beige 48”x60”'),
      Materiales(id: null, nombre: 'Marco beige 48”x72”'),
      Materiales(id: null, nombre: 'Marco sísmico HD beige 24”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico HD beige 36”x168”'),
      Materiales(id: null, nombre: 'Marco sísmico HD beige 42”x168”'),
      Materiales(id: null, nombre: 'Marco sísmico HD beige 24”x192”'),
      Materiales(id: null, nombre: 'Marco sísmico HD beige 36”x192”'),
      Materiales(id: null, nombre: 'Marco sísmico HD beige 42”x192”'),
      Materiales(id: null, nombre: 'Marco sísmico HD_M beige 42”x192”'),
      Materiales(id: null, nombre: 'Marco sísmico HD beige 48”x192”'),
      Materiales(id: null, nombre: 'Marco sísmico HD_M beige 48”x192”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU beige 36”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU beige 42”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU_M beige 42”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU beige 48”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU_M beige 48”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU beige 60”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico GU beige 24”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico GU beige 36”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico GU beige 42”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico GU beige 48”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico VR beige 42”x144”'),
      Materiales(id: null, nombre: 'Marco galvizado 24”x48”'),
      Materiales(id: null, nombre: 'Marco galvizado 36”x48”'),
      Materiales(id: null, nombre: 'Marco galvizado 42”x48”'),
      Materiales(id: null, nombre: 'Marco galvizado 42”x72”'),
      Materiales(id: null, nombre: 'Marco galvizado 48”x48”'),
      Materiales(id: null, nombre: 'Marco galvizado 60”x48”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU galvanizado 36”x96”'),
      Materiales(id: null, nombre: 'Marco sísmico HD galvanizado 24”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU galvanizado 24”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU galvanizado 36”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU galvanizado 42”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU_M galvanizado 42”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU galvanizado 48”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU_M galvanizado 48”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico HD naranja 24”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico HD naranja 42”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU naranja 42”x144”'),
      Materiales(id: null, nombre: 'Marco sísmico ARU naranja 48”x144”'),
      Materiales(id: null, nombre: 'Rejilla 24”x35”'),
      Materiales(id: null, nombre: 'Rejilla 36”x35”'),
      Materiales(id: null, nombre: 'Rejilla 42”x35”'),
      Materiales(id: null, nombre: 'Rejilla 48”x35”'),
      Materiales(id: null, nombre: 'Rejilla 60”x35”'),
      Materiales(id: null, nombre: 'Rejilla 24”x48”'),
      Materiales(id: null, nombre: 'Rejilla 36”x48”'),
      Materiales(id: null, nombre: 'Rejilla 42”x48”'),
      Materiales(id: null, nombre: 'Rejilla 48”x48”'),
      Materiales(id: null, nombre: 'Rejilla 60”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 24”x35”'),
      Materiales(id: null, nombre: 'Rejilla galv 36”x35”'),
      Materiales(id: null, nombre: 'Rejilla galv 42”x35”'),
      Materiales(id: null, nombre: 'Rejilla galv 48”x35”'),
      Materiales(id: null, nombre: 'Rejilla galv 24”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 36”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 42”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 48”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 60”x48”'),
      Materiales(id: null, nombre: 'Rejilla reforzada amarilla 42”x35”'),
      Materiales(id: null, nombre: 'Rejilla reforzada amarilla 48"x35"'),
      Materiales(id: null, nombre: 'Rejilla reforzada amarilla 42”x48”'),
      Materiales(id: null, nombre: 'Rejilla reforzada amarilla 48”x48”'),
      Materiales(id: null, nombre: 'Madera 1a 2”x4”x8” estufado'),
      Materiales(id: null, nombre: 'Madera 1a 2”x4”x16” estufado'),
      Materiales(id: null, nombre: 'Madera 1a 2"x6"x16” estufado'),
      Materiales(id: null, nombre: 'Madera 1a 1"x8"x8” estufado'),
      Materiales(id: null, nombre: 'Tablón 2”x6”x20” 1/4” (24”)'),
      Materiales(id: null, nombre: 'Tablón 2”x6”x32” 1/4” (36”)'),
      Materiales(id: null, nombre: 'Tablón 2”x6”x38” 1/4” (42”)'),
      Materiales(id: null, nombre: 'Tablón 2”x6”x44” 1/4” (48”)'),
      Materiales(id: null, nombre: 'Tablón 2”x6”x56” 1/4” (60”)'),
      Materiales(id: null, nombre: 'Rejilla 24”x35”'),
      Materiales(id: null, nombre: 'Rejilla 36”x35”'),
      Materiales(id: null, nombre: 'Rejilla 42”x35”'),
      Materiales(id: null, nombre: 'Rejilla 48”x35”'),
      Materiales(id: null, nombre: 'Rejilla 60”x35”'),
      Materiales(id: null, nombre: 'Rejilla 24”x48”'),
      Materiales(id: null, nombre: 'Rejilla 36”x48”'),
      Materiales(id: null, nombre: 'Rejilla 42”x48”'),
      Materiales(id: null, nombre: 'Rejilla 48”x48”'),
      Materiales(id: null, nombre: 'Rejilla 60”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 24”x35”'),
      Materiales(id: null, nombre: 'Rejilla galv 36”x35”'),
      Materiales(id: null, nombre: 'Rejilla galv 42”x35”'),
      Materiales(id: null, nombre: 'Rejilla galv 48”x35”'),
      Materiales(id: null, nombre: 'Rejilla galv 24”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 36”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 42”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 48”x48”'),
      Materiales(id: null, nombre: 'Rejilla galv 60”x48”'),
      Materiales(id: null, nombre: 'Rejilla reforzada amarilla 42”x35”'),
      Materiales(id: null, nombre: 'Rejilla reforzada amarilla 48”x35”'),
      Materiales(id: null, nombre: 'Rejilla reforzada amarilla 42”x48”'),
      Materiales(id: null, nombre: 'Rejilla reforzada amarilla 48”x48”'),
      Materiales(id: null, nombre: 'Otro Fixture'),
      Materiales(id: null, nombre: ''), //id:173
    ];

    // Verificar si ya existen datos en la tabla materiales
    final List<Materiales> existingMateriales =
        await DatabaseProvider.showMateriales();
    // Insertar solo si la tabla materiales está vacía
    if (existingMateriales.isEmpty) {
      for (final material in materiales) {
        DatabaseProvider.insertMaterial(material);
      }
      print('Datos insertados correctamente.');
    } else {
      print(
          'Los datos de material ya existen en la base de datos. No se realizaron inserciones.');
    }
  });
}
