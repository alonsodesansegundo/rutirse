class Jugador {
  int? id; // campo id opcional
  final String nombre;
  final int grupoId;

  Jugador({this.id, required this.nombre, required this.grupoId});

  Jugador.jugadoresFromMap(Map<String, dynamic> item)
      : id = item["id"],
        nombre = item["nombre"],
        grupoId = item["grupoId"];

  Map<String, Object> jugadoresToMap() {
    // no incluir id aquí ya que se generará automáticamente
    return {'nombre': nombre, 'grupoId': grupoId};
  }

  @override
  String toString() {
    return 'Jugador {id: $id, nombre: $nombre, grupoId: $grupoId}';
  }
}
