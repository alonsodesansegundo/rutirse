import 'package:Rutirse/db/obj/partida.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';

class PartidaRutinas extends Partida {
  final int? id;
  final String fechaFin;
  final int duracionSegundos;
  final int aciertos;
  final int fallos;
  final int jugadorId;

  PartidaRutinas({
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

  factory PartidaRutinas.partidasFromMap(Map<String, dynamic> item) {
    return PartidaRutinas(
      id: item["id"],
      fechaFin: item["fechaFin"],
      duracionSegundos: item["duracionSegundos"],
      aciertos: item["aciertos"],
      fallos: item["fallos"],
      jugadorId: item["jugadorId"],
    );
  }
}

// metodo para insertar una partida de rutinas en la BBDD
Future<int> insertPartidaRutinas(Partida partida, [Database? db]) async {
  final Database database = db ?? await initializeDB();

  // Insertar la partida en la tabla partida
  int partidaId = await database.insert("partida", partida.partidasToMap());

  // Crear un mapa para los datos específicos de rutinas
  Map<String, dynamic> rutinasData = {
    'partidaId': partidaId,
    // Agrega aquí los demás campos específicos de rutinas
  };

  // Insertar los datos de rutinas en la tabla rutinas
  int rutinasId = await database.insert("partidaRutinas", rutinasData);

  // Retornar el id de la partida insertada en la tabla partida
  return partidaId;
}

// Método para obtener las partidas de rutinas de un jugador dado su userId
Future<List<PartidaRutinas>> getPartidasRutinasByUserId(int jugadorId,
    [Database? db]) async {
  final Database database = db ?? await initializeDB();

  List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT partida.*
    FROM partida
    INNER JOIN partidaRutinas ON partida.id = partidaRutinas.partidaId
    WHERE partida.jugadorId = ?
    ORDER BY partida.id DESC
  ''', [jugadorId]);

  // Mapear los resultados a objetos Partida
  List<PartidaRutinas> partidas = [];
  for (Map<String, dynamic> row in result) {
    partidas.add(PartidaRutinas.partidasFromMap(row));
  }

  return partidas;
}
