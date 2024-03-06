import 'dart:convert';

class Tiendas {
  Tiendas({
    required this.nombre,
    required this.direccion,
  });

  String nombre;
  String direccion;

  factory Tiendas.fromJson(String str) => Tiendas.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tiendas.fromMap(Map<String, dynamic> json) => Tiendas (
    nombre: json["nombre"],
    direccion: json["direccion"],
  );

  Map<String, dynamic> toMap() => {
    "nombre": nombre,
    "direccion": direccion,
  };
}