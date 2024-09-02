import 'package:sqflite/sqflite.dart';

import '../db.dart';

///Clase relativa a la tabla Jugador
class Jugador {
  int? id; // campo id opcional
  final String nombre;
  final int grupoId;

  ///Constructor de la clase Jugador
  Jugador({this.id, required this.nombre, required this.grupoId});

  ///Crea una instancia de Jugador a partir de un mapa de datos, dicho mapa debe contener: id, nombre y grupoId
  Jugador.jugadoresFromMap(Map<String, dynamic> item)
      : id = item["id"],
        nombre = item["nombre"],
        grupoId = item["grupoId"];

  ///Convierte una instancia de Jugador a un mapa de datos
  Map<String, Object> jugadoresToMap() {
    // no incluir id aquí ya que se generará automáticamente
    return {'nombre': nombre, 'grupoId': grupoId};
  }

  ///Sobreescritura del método equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Jugador &&
        other.id == id &&
        other.nombre == nombre &&
        other.grupoId == grupoId;
  }

  ///Sobreescritura del método hashCode
  @override
  int get hashCode => id.hashCode ^ nombre.hashCode ^ grupoId.hashCode;

  ///Sobreescritura del método toString
  @override
  String toString() {
    return 'Jugador {id: $id, nombre: $nombre, grupoId: $grupoId}';
  }
}

///Método que nos permite insertar un nuevo jugador
///<br><b>Parámetros</b><br>
///[jugador] Jugador que queremos insertar en la base de datos<br>
///[database] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Objeto Jugador que resulta de haber realizado la insercción
Future<Jugador> insertJugador(Jugador jugador, [Database? db]) async {
  final Database database = db ?? await initializeDB();
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

///Método que nos permite conocer si un jugador (nombre y grupo) ya está presente en la base de datos
///<br><b>Parámetros</b><br>
///[jugador] Jugador que queremos consultar si está presente en la base de datos<br>
///[database] Objeto Database sobre la cual se ejecuta la consulta
///<br><b>Salida</b><br>
///Booleano que nos indica si el jugador existe [true] o no [false]
Future<bool> existeJugador(Jugador jugador, Database database) async {
  List<Map<String, dynamic>> result = await database.query(
    'jugador',
    where: 'nombre = ? AND grupoId = ?',
    whereArgs: [jugador.nombre, jugador.grupoId],
  );
  return result.isNotEmpty;
}

///Método que nos permite eliminar a un jugador a través de su identificador
///<br><b>Parámetros</b><br>
///[playerId] Identificador del jugador que queremos eliminar de la base de datos<br>
///[database] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
Future<void> deletePlayer(int playerId, [Database? db]) async {
  final Database database = db ?? await initializeDB();

  int rowsAffected =
      await database.rawDelete('DELETE FROM jugador WHERE id = ?', [playerId]);

  if (rowsAffected == 0) {
    throw Exception(
        'No se encontró ningún jugador con el ID especificado: $playerId');
  }
}
