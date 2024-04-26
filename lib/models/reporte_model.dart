class Reporte {
  int idRep;
  String formato;
  String nomDep;
  String claveUbi;
  int idProbl;
  String nomProbl;
  int idMat;
  String nomMat;
  String otro;
  int cantMat;
  int idObr;
  String nomObr;
  String otroObr;
  int cantObr;
  String foto;
  String datoU;
  String nombUser;
  String lastUpdated;
  int idTienda;

  Reporte({
    required this.idRep,
    required this.formato,
    required this.nomDep,
    required this.claveUbi,
    required this.idProbl,
    required this.nomProbl,
    required this.idMat,
    required this.nomMat,
    required this.otro,
    required this.cantMat,
    required this.idObr,
    required this.nomObr,
    required this.otroObr,
    required this.cantObr,
    required this.foto,
    required this.datoU,
    required this.nombUser,
    required this.lastUpdated,
    required this.idTienda,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_rep': idRep,
      'formato': formato,
      'nom_dep': nomDep,
      'clave_ubi': claveUbi,
      'id_probl': idProbl,
      'nom_probl': nomProbl,
      'id_mat': idMat,
      'nom_mat': nomMat,
      'otro': otro,
      'cant_mat': cantMat,
      'id_obra': idObr,
      'nom_obr': nomObr,
      'otro_obr': otroObr,
      'cant_obr': cantObr,
      'foto': foto,
      'dato_unico': datoU,
      'nom_user': nombUser,
      'last_updated': lastUpdated,
      'id_tienda': idTienda,
    };
  }

  factory Reporte.fromMap(Map<String, dynamic> map) {
    return Reporte(
      idRep: map['id_rep'] ?? 0,
      formato: map['formato'] ?? "",
      nomDep: map['nom_dep'] ?? "",
      claveUbi: map['clave_ubi'] ?? "",
      idProbl: map['id_probl'] ?? 0,
      nomProbl: map['nom_probl'] ?? "",
      idMat: map['id_mat'] ?? 0,
      nomMat: map['nom_mat'] ?? "",
      otro: map['otro'] ?? "",
      cantMat: map['cant_mat'] ?? 0,
      idObr: map['id_obra'] ?? 0,
      nomObr: map['nom_obr'] ?? "",
      otroObr: map['otro_obr'] ?? "",
      cantObr: map['cant_obr'] ?? 0,
      foto: map['foto'] ?? "",
      datoU: map['dato_unico'] ?? "",
      nombUser: map['nom_user'] ?? "",
      lastUpdated: map['last_updated'] ?? "",
      idTienda: map['id_tienda'] ?? "",
    );
  }
}
