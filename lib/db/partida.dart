class Partida {
  final int id;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int aciertos;
  final int fallos;
  final int jugadorId;

  Partida(
      {required this.id,
      required this.fechaInicio,
      required this.fechaFin,
      required this.aciertos,
      required this.fallos,
      required this.jugadorId});

  Partida.partidasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        fechaInicio = item["fechaInicio"],
        fechaFin = item["fechaFin"],
        aciertos = item["aciertos"],
        fallos = item["fallos"],
        jugadorId = item["jugadorId"];

  Map<String, Object> partidasToMap() {
    return {
      'id': id,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      ''
          'aciertos': aciertos,
      'fallos': fallos,
      'jugadorId': jugadorId
    };
  }

  @override
  String toString() {
    return 'Partida {id: $id, fechaInicio: $fechaInicio, fechaFin: $fechaFin,'
        'aciertos: $aciertos, fallos: $fallos, jugadorId: $jugadorId}';
  }
}
