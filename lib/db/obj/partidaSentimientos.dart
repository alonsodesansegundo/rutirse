import 'package:Rutirse/db/obj/partida.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';

///Clase relativa a la tabla PartidaSentimientos
class PartidaSentimientos extends Partida {
  final int? id;
  final String fechaFin;
  final int duracionSegundos;
  final int aciertos;
  final int fallos;
  final int jugadorId;

  ///Constructor de la clase PartidaSentimientos
  PartidaSentimientos({
    this.id,
    required this.fechaFin,
    required this.duracionSegundos,
    required this.aciertos,
    required this.fallos,
    required this.jugadorId,
  }) : super(
          fechaFin: fechaFin,
          duracionSegundos: duracionSegundos,
          aciertos: aciertos,
          fallos: fallos,
          jugadorId: jugadorId,
        );

  /// Crea una instancia de PartidaSentimientos a partir de un mapa de datos, dicho mapa debe contener:
  /// id, fechaFin, duracionSegundos, aciertos, fallos y jugadorId
  factory PartidaSentimientos.partidasFromMap(Map<String, dynamic> item) {
    return PartidaSentimientos(
      id: item["id"],
      fechaFin: item["fechaFin"],
      duracionSegundos: item["duracionSegundos"],
      aciertos: item["aciertos"],
      fallos: item["fallos"],
      jugadorId: item["jugadorId"],
    );
  }
}

///Método que nos permite insertar una partida del juego Sentimientos en la base de datos
///<br><b>Parámetros</b><br>
///[partida] Partida que queremos insertar en la base de datos<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Identificador de la partida que se ha insertado en la base de datos
Future<int> insertPartidaSentimientos(Partida partida, [Database? db]) async {
  final Database database = db ?? await initializeDB();

  // Insertar la partida en la tabla partida
  int partidaId = await database.insert("partida", partida.partidasToMap());

  // Crear un mapa para los datos específicos de sentimientos
  Map<String, dynamic> sentimientosData = {
    'partidaId': partidaId,
    // Agrega aquí los demás campos específicos de sentimientos
  };

  // Insertar los datos de sentimientos en la tabla sentimientos
  int sentimientosId =
      await database.insert("partidaSentimientos", sentimientosData);

  // Retornar el id de la partida insertada en la tabla partida
  return partidaId;
}

///Método que nos permite obtener todas las partidas de un jugador en el juego Sentimientos
///<br><b>Parámetros</b><br>
///[jugadorId] Identificador del jugador del que queremos obtener las partidas<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Lista de las partidas del jugador en el juego Sentimientos
Future<List<PartidaSentimientos>> getPartidasSentimientosByUserId(int jugadorId,
    [Database? db]) async {
  final Database database = db ?? await initializeDB();

  List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT partida.*
    FROM partida
    INNER JOIN partidaSentimientos ON partida.id = partidaSentimientos.partidaId
    WHERE partida.jugadorId = ?
    ORDER BY partida.id DESC
  ''', [jugadorId]);

  // Mapear los resultados a objetos Partida
  List<PartidaSentimientos> partidas = [];
  for (Map<String, dynamic> row in result) {
    partidas.add(PartidaSentimientos.partidasFromMap(row));
  }

  return partidas;
}
