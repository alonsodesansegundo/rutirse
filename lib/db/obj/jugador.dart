import 'package:sqflite/sqflite.dart';

import '../db.dart';

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

// metodo para insertar un jugador en la BBDD
Future<Jugador> insertJugador(Jugador jugador) async {
  Database database = await initializeDB();
  Jugador sol;
  // si el jugador aun no existe en la base de datos
  if (!await existeJugador(jugador, database)) {
    int id = await database.insert("jugador", jugador.jugadoresToMap());
    sol = Jugador(id: id, nombre: jugador.nombre, grupoId: jugador.grupoId);
  } else {
    // el jugador ya existe en la base de datos
    List<Map<String, dynamic>> result = await database.query(
      'jugador',
      where: 'nombre = ? AND grupoId = ?',
      whereArgs: [jugador.nombre, jugador.grupoId],
    );
    sol = Jugador.jugadoresFromMap(result.first);
  }
  return sol;
}

// metodo para ver si un jugador (nombre y grupo) ya existe en la BBDD
Future<bool> existeJugador(Jugador jugador, Database database) async {
  List<Map<String, dynamic>> result = await database.query(
    'jugador',
    where: 'nombre = ? AND grupoId = ?',
    whereArgs: [jugador.nombre, jugador.grupoId],
  );
  return result.isNotEmpty;
}

Future<Jugador> insertJugadorDefault(Database database, Jugador jugador) async {
  Jugador sol = jugador;
  await database.transaction((txn) async {
    int id = await txn.rawInsert(
      "INSERT INTO jugador (nombre, grupoId) VALUES (?, ?)",
      [
        jugador.nombre,
        jugador.grupoId,
      ],
    );
    sol = Jugador(id: id, nombre: jugador.nombre, grupoId: jugador.grupoId);
  });
  return sol;
}
