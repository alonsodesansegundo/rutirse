import 'package:sqflite/sqflite.dart';

import '../db.dart';

///Clase relativa a la tabla Partida
class Partida {
  final int? id;
  final String fechaFin;
  final int duracionSegundos;
  final int aciertos;
  final int fallos;
  final int jugadorId;

  ///Constructor de la clase Partida
  Partida(
      {this.id,
      required this.fechaFin,
      required this.duracionSegundos,
      required this.aciertos,
      required this.fallos,
      required this.jugadorId});

  ///Crea una instancia de Partida a partir de un mapa de datos, dicho mapa debe contener:
  ///id, fechaFin, duracionSegundos, aciertos, fallos y jugadorId
  Partida.partidasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        fechaFin = item["fechaFin"],
        duracionSegundos = item["duracionSegundos"],
        aciertos = item["aciertos"],
        fallos = item["fallos"],
        jugadorId = item["jugadorId"];

  ///Convierte una instancia de Partida a un mapa de datos
  Map<String, Object> partidasToMap() {
    return {
      'fechaFin': fechaFin,
      'duracionSegundos': duracionSegundos,
      'aciertos': aciertos,
      'fallos': fallos,
      'jugadorId': jugadorId
    };
  }

  ///Sobreescritura del método toString
  @override
  String toString() {
    return 'Partida {id: $id, fechaFin: $fechaFin, duracionSegundos: $duracionSegundos,'
        'aciertos: $aciertos, fallos: $fallos, jugadorId: $jugadorId}';
  }
}

///Método que nos permite eliminar una partida a partir de su identificador
///<br><b>Parámetros</b><br>
///[partidaId] Identificador de la partida que queremos eliminar<br>
///[database] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
Future<void> deletePartidaById(int partidaId, [Database? db]) async {
  final Database database = db ?? await initializeDB();

  // Borrar la partida de la tabla partida
  await database.delete(
    'partida',
    where: 'id = ?',
    whereArgs: [partidaId],
  );
}
