import 'package:sqflite/sqflite.dart';

import '../../obj/JugadoresPaginacion.dart';
import '../db.dart';
import 'grupo.dart';

/**

 */
///Clase que nos permite obtener los datos de un jugador, así obtenemos el nombre del grupo
///en lugar de su identificador
class JugadorView {
  final int id;
  final String jugadorName;
  final String grupoName;

  ///Constructor de la clase JugadorView
  JugadorView(
      {required this.id, required this.jugadorName, required this.grupoName});

  ///Crea una instancia de JugadorView a partir de un mapa de datos, dicho mapa debe contener: id, jugadorName y grupoName
  JugadorView.jugadoresFromMap(Map<String, dynamic> item)
      : id = item["id"],
        jugadorName = item["jugadorName"],
        grupoName = item["grupoName"];

  ///Convierte una instancia de JugadorView a un mapa de datos
  Map<String, Object> jugadoresToMap() {
    return {'jugadorName': jugadorName, 'grupoName': grupoName};
  }

  ///Sobreescritura del método equals
  @override
  String toString() {
    return 'Jugador {id: $id, jugadorName: $jugadorName, grupoName: $grupoName}';
  }
}

///Método que nos permite obtener todos los JugadoresView con paginación
///<br><b>Parámetros</b><br>
///[pageNumber] Página de la que queremos obtener los resultados. Comenzamos en la página 1<br>
///[pageSize] Cantidad de resultados que queremos obtener por página<br>
///[txtNombre] Nombre del jugador para filtrar la búsqueda<br>
///[grupo] Grupo para filtrar la búsqueda
///<br><b>Salida</b><br>
///Resultado de la búsqueda con paginación
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
