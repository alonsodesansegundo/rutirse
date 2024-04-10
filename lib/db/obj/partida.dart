import 'package:sqflite/sqflite.dart';

import '../db.dart';

class Partida {
  final int? id;
  final String fechaFin;
  final int duracionSegundos;
  final int aciertos;
  final int fallos;
  final int jugadorId;

  Partida(
      {this.id,
      required this.fechaFin,
      required this.duracionSegundos,
      required this.aciertos,
      required this.fallos,
      required this.jugadorId});

  Partida.partidasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        fechaFin = item["fechaFin"],
        duracionSegundos = item["duracionSegundos"],
        aciertos = item["aciertos"],
        fallos = item["fallos"],
        jugadorId = item["jugadorId"];

  Map<String, Object> partidasToMap() {
    return {
      'fechaFin': fechaFin,
      'duracionSegundos': duracionSegundos,
      'aciertos': aciertos,
      'fallos': fallos,
      'jugadorId': jugadorId
    };
  }

  @override
  String toString() {
    return 'Partida {id: $id, fechaFin: $fechaFin, duracionSegundos: $duracionSegundos,'
        'aciertos: $aciertos, fallos: $fallos, jugadorId: $jugadorId}';
  }
}

Future<void> deletePartidaById(int partidaId) async {
  Database database = await initializeDB();

  // Borrar la partida de la tabla partida
  await database.delete(
    'partida',
    where: 'id = ?',
    whereArgs: [partidaId],
  );
}
