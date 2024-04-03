import 'package:sqflite/sqflite.dart';

import '../../obj/JugadoresPaginacion.dart';
import '../db.dart';
import 'grupo.dart';

class JugadorView {
  final int id;
  final String jugadorName;
  final String grupoName;

  JugadorView(
      {required this.id, required this.jugadorName, required this.grupoName});

  JugadorView.jugadoresFromMap(Map<String, dynamic> item)
      : id = item["id"],
        jugadorName = item["jugadorName"],
        grupoName = item["grupoName"];

  Map<String, Object> jugadoresToMap() {
    return {'jugadorName': jugadorName, 'grupoName': grupoName};
  }

  @override
  String toString() {
    return 'Jugador {id: $id, jugadorName: $jugadorName, grupoName: $grupoName}';
  }
}

Future<JugadoresPaginacion> getAllJugadoresView(
    int pageNumber, int pageSize, String txtNombre, Grupo? grupo) async {
  try {
    final Database db = await initializeDB();
    int offset = (pageNumber - 1) * pageSize;
    String whereClause = '';

    // Agregar condiciones de búsqueda por nombre de jugador y nombre de grupo
    if (txtNombre.isNotEmpty) {
      whereClause += " WHERE jugador.nombre LIKE '%$txtNombre%'";
    }
    if (grupo != null) {
      whereClause += (whereClause.isEmpty ? ' WHERE' : ' AND');
      whereClause += " grupo.id = ${grupo.id}";
    }

    final List<Map<String, dynamic>> jugadoresMap = await db.rawQuery('''
      SELECT jugador.id as id, jugador.nombre AS jugadorName, grupo.nombre AS grupoName
      FROM jugador
      JOIN grupo ON jugador.grupoId = grupo.id
      $whereClause
      ORDER BY jugador.id 
      LIMIT $pageSize OFFSET $offset
    ''');

    final List<JugadorView> jugadores =
        jugadoresMap.map((map) => JugadorView.jugadoresFromMap(map)).toList();

    // Comprobar si hay más preguntas disponibles
    final List<Map<String, dynamic>> totalJugadoresMap = await db.rawQuery('''
      SELECT COUNT(*) AS total
      FROM jugador
      JOIN grupo ON jugador.grupoId = grupo.id
      $whereClause
    ''');
    final int totalJugadores =
        totalJugadoresMap.isNotEmpty ? totalJugadoresMap[0]['total'] : 0;
    final bool hayMasJugadores = offset + pageSize < totalJugadores;

    return JugadoresPaginacion(jugadores, hayMasJugadores);
  } catch (e) {
    print("Error al obtener preguntas: $e");
    return JugadoresPaginacion([], false);
  }
}
