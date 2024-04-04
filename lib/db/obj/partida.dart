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

// metodo para insertar una partida de rutinas en la BBDD
Future<int> insertPartidaRutinas(Partida partida) async {
  Database database = await initializeDB();

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
Future<List<Partida>> getPartidasRutinasByUserId(int jugadorId) async {
  Database database = await initializeDB();

  List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT partida.*
    FROM partida
    INNER JOIN partidaRutinas ON partida.id = partidaRutinas.partidaId
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

// metodo para insertar una partida de ironias en la BBDD
Future<int> insertPartidaIronias(Partida partida) async {
  Database database = await initializeDB();

  // Insertar la partida en la tabla partida
  int partidaId = await database.insert("partida", partida.partidasToMap());

  // Crear un mapa para los datos específicos de ironias
  Map<String, dynamic> rutinasData = {
    'partidaId': partidaId,
    // Agrega aquí los demás campos específicos de ironias
  };

  // Insertar los datos de ironias en la tabla ironias
  int ironiasId = await database.insert("partidaIronias", rutinasData);

  // Retornar el id de la partida insertada en la tabla partida
  return partidaId;
}

// Método para obtener las partidas de ironias de un jugador dado su userId
Future<List<Partida>> getPartidasIroniasByUserId(int jugadorId) async {
  Database database = await initializeDB();

  List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT partida.*
    FROM partida
    INNER JOIN partidaIronias ON partida.id = partidaIronias.partidaId
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

Future<void> deletePartidaById(int partidaId) async {
  Database database = await initializeDB();

  // Borrar la partida de la tabla partida
  await database.delete(
    'partida',
    where: 'id = ?',
    whereArgs: [partidaId],
  );
}
