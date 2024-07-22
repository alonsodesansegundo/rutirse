import 'package:Rutirse/db/obj/partida.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';

class PartidaIronias extends Partida {
  final int? id;
  final String fechaFin;
  final int duracionSegundos;
  final int aciertos;
  final int fallos;
  final int jugadorId;

  PartidaIronias({
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

  factory PartidaIronias.partidasFromMap(Map<String, dynamic> item) {
    return PartidaIronias(
      id: item["id"],
      fechaFin: item["fechaFin"],
      duracionSegundos: item["duracionSegundos"],
      aciertos: item["aciertos"],
      fallos: item["fallos"],
      jugadorId: item["jugadorId"],
    );
  }
}

// método para insertar una partida de humor en la BBDD
Future<int> insertPartidaIronias(PartidaIronias partida) async {
  Database database = await initializeDB();

  // Insertar la partida en la tabla partida
  int partidaId = await database.insert("partida", partida.partidasToMap());

  // Crear un mapa para los datos específicos de humor
  Map<String, dynamic> rutinasData = {
    'partidaId': partidaId,
    // Agrega aquí los demás campos específicos de ironias
  };

  // Insertar los datos de humor en la tabla humor
  int ironiasId = await database.insert("partidaIronias", rutinasData);

  // Retornar el id de la partida insertada en la tabla partida
  return partidaId;
}

// Método para obtener las partidas de humor de un jugador dado su userId
Future<List<PartidaIronias>> getPartidasIroniasByUserId(int jugadorId) async {
  Database database = await initializeDB();

  List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT partida.*
    FROM partida
    INNER JOIN partidaIronias ON partida.id = partidaIronias.partidaId
    WHERE partida.jugadorId = ?
    ORDER BY partida.id DESC
  ''', [jugadorId]);

  // Mapear los resultados a objetos Partida
  List<PartidaIronias> partidas = [];
  for (Map<String, dynamic> row in result) {
    partidas.add(PartidaIronias.partidasFromMap(row));
  }

  return partidas;
}
