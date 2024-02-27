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

Future<void> insertJugador(Jugador jugador) async {
  Database database = await initializeDB();
  if (!await existeJugador(jugador, database)) {
    database.insert("jugador", jugador.jugadoresToMap());
    print("jugador añadido");
    return;
  }
  print("jugador repetido");
}

Future<bool> existeJugador(Jugador jugador, Database database) async {
  List<Map<String, dynamic>> result = await database.query(
    'jugador',
    where: 'nombre = ? AND grupoId = ?',
    whereArgs: [jugador.nombre, jugador.grupoId],
  );
  return result.isNotEmpty;
}
