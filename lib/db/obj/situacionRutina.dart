import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../obj/SituacionRutinaPaginacion.dart';
import '../db.dart';
import '../rutinasScripts/adolescencia.dart';
import '../rutinasScripts/atenciont.dart';
import '../rutinasScripts/infancia.dart';
import 'grupo.dart';

///Clase relativa a la tabla SituacionRutina
class SituacionRutina {
  final int? id;
  final String enunciado;
  final Uint8List? personajeImg;
  final int grupoId;
  final String fecha;
  final int byTerapeuta;

  ///Constructor de la clase SituacionRutina
  SituacionRutina(
      {this.id,
      required this.enunciado,
      this.personajeImg,
      required this.grupoId,
      required this.fecha,
      required this.byTerapeuta});

  ///Crea una instancia de SituacionRutina a partir de un mapa de datos, dicho mapa debe contener:
  ///id, enunciado, personajeImg, grupoId, fecha y byTerapeuta
  SituacionRutina.situacionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        personajeImg = item["personajeImg"],
        grupoId = item["grupoId"],
        fecha = item["fecha"],
        byTerapeuta = item["byTerapeuta"];

  ///Crea una instancia de SituacionIronia a partir de un mapa de datos, dicho mapa debe contener:
  ///id, enunciado, imagen, grupoId, fecha y byTerapeuta
  Map<String, Object> situacionesToMap() {
    return {
      'enunciado': enunciado,
      'grupoId': grupoId,
      'fecha': fecha,
      'byTerapeuta': byTerapeuta
    };
  }

  ///Sobreescritura del método equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SituacionRutina &&
        other.id == id &&
        other.enunciado == enunciado &&
        other.grupoId == grupoId &&
        other.fecha == fecha &&
        other.byTerapeuta == byTerapeuta;
  }

  ///Sobreescritura del método hashCode
  @override
  int get hashCode =>
      id.hashCode ^
      enunciado.hashCode ^
      grupoId.hashCode ^
      fecha.hashCode ^
      byTerapeuta.hashCode;

  ///Sobreescritura del método toString
  @override
  String toString() {
    return 'SituacionRutina {id: $id, enunciado: $enunciado,'
        ' personajeImg: $personajeImg, '
        'grupoId: $grupoId}, '
        'fecha: $fecha}, '
        'byTerapeuta: $byTerapeuta, ';
  }
}

///Método que nos permite obtener las preguntas del juego Rutinas
///<br><b>Parámetros</b><br>
///[grupoId] Identificador del grupo del que queremos obtener las preguntas<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Lista de preguntas del juego Rutinas pertenecientes al grupoId
Future<List<SituacionRutina>> getSituacionesRutinas(int grupoId,
    [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    final List<Map<String, dynamic>> preguntasMap = await database
        .query('situacionRutina', where: 'grupoId = ?', whereArgs: [grupoId]);
    return preguntasMap
        .map((map) => SituacionRutina.situacionesFromMap(map))
        .toList();
  } catch (e) {
    print("Error al obtener situaciones: $e");
    return [];
  }
}

///Método que nos permite obtener las preguntas del juego Rutinas de forma paginada. Usado para el
///punto de vista del terapeuta
///<br><b>Parámetros</b><br>
///[pageNumber] Página de la que queremos obtener los resultados. Comenzamos en la página 1<br>
///[pageSize] Cantidad de resultados que queremos obtener por página<br>
///[txtBuscar] Texto de la pregunta para filtrar la búsqueda<br>
///[grupo] Grupo para filtrar la búsqueda<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Resultado de la búsqueda con paginación
Future<SituacionRutinaPaginacion> getSituacionRutinaPaginacion(
    int pageNumber, int pageSize, String txtBuscar, Grupo? grupo,
    [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    int offset = (pageNumber - 1) * pageSize;
    String whereClause = '';

    // Agregar condiciones de búsqueda por enunciado y grupo
    if (txtBuscar.isNotEmpty) {
      whereClause += "enunciado LIKE '%$txtBuscar%'";
    }
    if (grupo != null) {
      whereClause +=
          (whereClause.isNotEmpty ? ' AND ' : '') + "grupoId = ${grupo.id}";
    }

    final List<Map<String, dynamic>> situacionesMap = await database.query(
      'situacionRutina',
      where: whereClause.isEmpty ? null : whereClause,
      orderBy: 'id DESC',
      limit: pageSize,
      offset: offset,
    );
    final List<SituacionRutina> situaciones = situacionesMap
        .map((map) => SituacionRutina.situacionesFromMap(map))
        .toList();

    // Comprobar si hay más preguntas disponibles
    final List<Map<String, dynamic>> totalSituacionesMap = await database.query(
        'situacionRutina',
        where: whereClause.isEmpty ? null : whereClause);
    final bool hayMasPreguntas =
        (offset + pageSize) < totalSituacionesMap.length;

    return SituacionRutinaPaginacion(situaciones, hayMasPreguntas);
  } catch (e) {
    print("Error al obtener situaciones: $e");
    return SituacionRutinaPaginacion([], false);
  }
}

///Método que nos permite insertar una nueva pregunta al juego Rutinas
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[enunciado] Enunciado de la pregunta<br>
///[imgPersonaje] Lista de enteros que es la imagen<br>
///[grupoId] Identificador del grupo al que va a pertenecer la pregunta
///<br><b>Salida</b><br>
///Identificador de la pregunta que se ha añadido
Future<int> insertSituacionRutina(Database database, String enunciado,
    List<int> imgPersonaje, int grupoId) async {
  int id = -1;
  await database.transaction((txn) async {
    if (imgPersonaje.isEmpty)
      id = await txn.rawInsert(
        "INSERT INTO situacionRutina (enunciado, personajeImg, grupoId, byTerapeuta, fecha) VALUES (?, ?, ?, ?, ?)",
        [
          enunciado,
          null,
          grupoId,
          1,
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
        ],
      );
    else
      id = await txn.rawInsert(
        "INSERT INTO situacionRutina (enunciado, personajeImg, grupoId, byTerapeuta, fecha) VALUES (?, ?, ?, ?, ?)",
        [
          enunciado,
          imgPersonaje,
          grupoId,
          1,
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
        ],
      );
  });

  return id;
}

///Método que nos permite insertar las preguntas por defecto del juego Rutinas
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[enunciado] Enunciado de la pregunta<br>
///[pathImg] Ruta en la que se encuentra la imagen<br>
///[grupoId] Identificador del grupo al que va a pertenecer la pregunta
///<br><b>Salida</b><br>
///Identificador de la pregunta que se ha añadido
Future<int> insertSituacionRutinaInitialData(
    Database database, String enunciado, String pathImg, int grupoId) async {
  int id = -1;
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO situacionRutina (enunciado, personajeImg, grupoId, fecha) VALUES (?, ?, ?, ?)",
      [
        enunciado,
        bytes,
        grupoId,
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
      ],
    );
  });

  return id;
}

///Método que nos permite eliminar una pregunta del juego Rutinas a partir de su identificador
///<br><b>Parámetros</b><br>
///[situacionRutinaId] Identificador de la pregunta del juego Rutinas que queremos eliminar<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
Future<void> removePreguntaRutinas(int situacionRutinaId,
    [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    await database.delete(
      'situacionRutina',
      where: 'id = ?',
      whereArgs: [situacionRutinaId],
    );
  } catch (e) {
    print('Error al eliminar la situación rutina: $e');
  }
}

///Método que nos permite actualizar una pregunta del juego Rutinas
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecuta la actualización<br>
///[id] Identificador de la pregunta que queremos actualizar<br>
///[enunciado] Nuevo valor del enunciado<br>
///[imgPersonaje] Nueva lista de enteros que representa la imagen<br>
///[grupoId] Nuevo valor del grupo al que pertenece la pregunta<br>
Future<void> updatePregunta(Database database, int id, String enunciado,
    List<int> imgPersonaje, int grupoId) async {
  if (imgPersonaje.isEmpty)
    await database.update(
      'situacionRutina',
      {
        'enunciado': enunciado,
        'personajeImg': null,
        'grupoId': grupoId,
        'fecha': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  else
    await database.update(
      'situacionRutina',
      {
        'enunciado': enunciado,
        'personajeImg': imgPersonaje,
        'grupoId': grupoId,
        'fecha': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
      },
      where: 'id = ?',
      whereArgs: [id],
    );
}

///Método que se encarga de hacer la insercción de las preguntas del juego Rutinas que están presentes inicialmente
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones
void insertRutinas(Database database) {
  insertPreguntaRutinaInitialDataAtencionT(database);
  //insertPreguntaRutinaInitialDataInfancia(database);
  insertPreguntaRutinaInitialDataAdolescencia(database);
}
