import 'package:TresEnUno/db/obj/partida.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';

class PartidaSentimientos extends Partida {
  final int? id;
  final String fechaFin;
  final int duracionSegundos;
  final int aciertos;
  final int fallos;
  final int jugadorId;

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

// metodo para insertar una partida de sentimientos en la BBDD
Future<int> insertPartidaSentimientos(Partida partida) async {
  Database database = await initializeDB();

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

// Método para obtener las partidas de sentimientos de un jugador dado su userId
Future<List<Partida>> getPartidasSentimientosByUserId(int jugadorId) async {
  Database database = await initializeDB();

  List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT partida.*
    FROM partida
    INNER JOIN partidaSentimientos ON partida.id = partidaSentimientos.partidaId
    WHERE partida.jugadorId = ?
    ORDER BY partida.id DESC
  ''', [jugadorId]);

  // Mapear los resultados a objetos Partida
  List<Partida> partidas = [];
  for (Map<String, dynamic> row in result) {
    partidas.add(Partida.partidasFromMap(row));
  }

  return partidas;
}
