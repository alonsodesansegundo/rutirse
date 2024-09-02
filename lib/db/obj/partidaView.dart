import 'package:sqflite/sqflite.dart';

import '../../obj/PartidasPaginacion.dart';
import '../db.dart';
import 'grupo.dart';

///Clase que nos permite obtener los datos que queremos mostrar de una partida
class PartidaView {
  final int? id;
  final String fechaFin;
  final int duracionSegundos;
  final int aciertos;
  final int fallos;
  final String jugadorName;
  final String grupoName;

  ///Constructor de la clase PartidaView
  PartidaView(
      {this.id,
      required this.fechaFin,
      required this.duracionSegundos,
      required this.aciertos,
      required this.fallos,
      required this.jugadorName,
      required this.grupoName});

  ///Crea una instancia de PartidaView a partir de un mapa de datos, dicho mapa debe contener:
  ///id, fechaFin, duracionSegundos, aciertos, fallos, jugadorName y grupoName
  PartidaView.partidasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        fechaFin = item["fechaFin"],
        duracionSegundos = item["duracionSegundos"],
        aciertos = item["aciertos"],
        fallos = item["fallos"],
        jugadorName = item["jugadorName"],
        grupoName = item["grupoName"];

  /// Convierte una instancia de PartidaView a un mapa de datos
  Map<String, Object> partidasToMap() {
    return {
      'fechaFin': fechaFin,
      'duracionSegundos': duracionSegundos,
      'aciertos': aciertos,
      'fallos': fallos,
      'jugadorName': jugadorName,
      'grupoName': grupoName
    };
  }

  ///Sobreescritura del método toString
  @override
  String toString() {
    return 'Partida {id: $id, fechaFin: $fechaFin, duracionSegundos: $duracionSegundos,'
        'aciertos: $aciertos, fallos: $fallos, jugadorName: $jugadorName, grupoName: $grupoName}';
  }
}

///Método que nos permite obtener las partidas de forma paginada del juego que deseamos.
///Es para el punto de vista del terapeuta
///<br><b>Parámetros</b><br>
///[pageNumber] Página de la que queremos obtener los resultados. Comenzamos en la página 1<br>
///[pageSize] Cantidad de resultados que queremos obtener por página<br>
///[txtNombre] Nombre del jugador para filtrar la búsqueda<br>
///[grupo] Grupo para filtrar la búsqueda<br>
///[game] Juego sobre el que queremos obtener las partidas. Posibles valores: Ironias, Rutinas o Sentimientos
///<br><b>Salida</b><br>
///Lista de las partidas de forma paginada
Future<PartidasPaginacion> getAllPartidasView(int pageNumber, int pageSize,
    String txtNombre, Grupo? grupo, String game) async {
  try {
    final Database db = await initializeDB();
    int offset = (pageNumber - 1) * pageSize;
    String whereClause = '';

    if (txtNombre.isNotEmpty) {
      whereClause += " WHERE jugador.nombre LIKE '%$txtNombre%'";
    }
    if (grupo != null) {
      whereClause += (whereClause.isEmpty ? ' WHERE' : ' AND');
      whereClause += " grupo.id = ${grupo.id}";
    }

    final List<Map<String, dynamic>> partidasMap = await db.rawQuery('''
      SELECT partida.*, jugador.nombre AS jugadorName, grupo.nombre AS grupoName
      FROM partida
      JOIN partida''' +
        game +
        ''' ON partida.id = partida''' +
        game +
        '''.partidaId
      JOIN jugador ON partida.jugadorId = jugador.id
      JOIN grupo ON jugador.grupoId = grupo.id
      $whereClause
      ORDER BY fechaFin DESC
      LIMIT $pageSize OFFSET $offset
    ''');
    final List<PartidaView> partidas =
        partidasMap.map((map) => PartidaView.partidasFromMap(map)).toList();

    final List<Map<String, dynamic>> totalPartidasMap = await db.rawQuery('''
      SELECT COUNT(*) AS total
      FROM partida
      JOIN partidaRutinas ON partida.id = partidaRutinas.partidaId
      JOIN jugador ON partida.jugadorId = jugador.id
      JOIN grupo ON jugador.grupoId = grupo.id
      $whereClause
    ''');
    final int totalPartidas =
        totalPartidasMap.isNotEmpty ? totalPartidasMap[0]['total'] : 0;
    final bool hayMasPartidas = offset + pageSize < totalPartidas;

    return PartidasPaginacion(partidas, hayMasPartidas);
  } catch (e) {
    print("Error al obtener partidas: $e");
    return PartidasPaginacion([], false);
  }
}
