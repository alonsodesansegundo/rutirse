import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../obj/PreguntaSentimientoPaginacion.dart';
import '../db.dart';
import '../sentimientosScripts/adolescencia.dart';
import '../sentimientosScripts/atenciont.dart';
import '../sentimientosScripts/infancia.dart';
import 'grupo.dart';

///Clase relativa a la tabla PreguntaSentimiento
class PreguntaSentimiento {
  final int? id;
  final String enunciado;
  final Uint8List? imagen;
  final int grupoId;
  final String fecha;
  final int byTerapeuta;

  ///Constructor de la clase PreguntaSentimiento
  PreguntaSentimiento(
      {this.id,
      required this.enunciado,
      this.imagen,
      required this.grupoId,
      required this.fecha,
      required this.byTerapeuta});

  ///Crea una instancia de PreguntaSentimiento a partir de un mapa de datos, dicho mapa debe contener:
  ///id, enunciado, imagen, grupoId, fecha y byTerapeuta
  PreguntaSentimiento.sentimientosFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        imagen = item["imagen"],
        grupoId = item["grupoId"],
        fecha = item["fecha"],
        byTerapeuta = item["byTerapeuta"];

  ///Convierte una instancia de PreguntaSentimientos a un mapa de datos
  Map<String, Object> sentimientosToMap() {
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

    return other is PreguntaSentimiento &&
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
    return 'PreguntaSentimiento {id: $id, enunciado: $enunciado,'
        ' imagen: $imagen, '
        'grupoId: $grupoId}, '
        'fecha: $fecha}, '
        'byTerapeuta: $byTerapeuta, ';
  }
}

///Método que nos permite obtener todas las preguntas de un grupo del juego Sentimientos
///<br><b>Parámetros</b><br>
///[grupoId] Identificador del grupo que queremos obtener las preguntas<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Lista de las preguntas del juego Sentimientos
Future<List<PreguntaSentimiento>> getPreguntasSentimiento(int grupoId,
    [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    final List<Map<String, dynamic>> preguntasMap = await database.query(
        'preguntaSentimiento',
        where: 'grupoId = ?',
        whereArgs: [grupoId]);
    return preguntasMap
        .map((map) => PreguntaSentimiento.sentimientosFromMap(map))
        .toList();
  } catch (e) {
    print("Error al obtener preguntas sentimientos: $e");
    return [];
  }
}

///Método que nos permite obtener las preguntas del juego Sentimientos de forma paginada. Usado para el
///punto de vista del terapeuta
///<br><b>Parámetros</b><br>
///[pageNumber] Página de la que queremos obtener los resultados. Comenzamos en la página 1<br>
///[pageSize] Cantidad de resultados que queremos obtener por página<br>
///[txtBuscar] Texto de la pregunta para filtrar la búsqueda<br>
///[grupo] Grupo para filtrar la búsqueda<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Resultado de la búsqueda con paginación
Future<PreguntaSentimientoPaginacion> getPreguntaSentimientoPaginacion(
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

    final List<Map<String, dynamic>> preguntasMap = await database.query(
      'preguntaSentimiento',
      where: whereClause.isEmpty ? null : whereClause,
      orderBy: 'id DESC',
      limit: pageSize,
      offset: offset,
    );
    final List<PreguntaSentimiento> preguntas = preguntasMap
        .map((map) => PreguntaSentimiento.sentimientosFromMap(map))
        .toList();

    // Comprobar si hay más preguntas disponibles
    final List<Map<String, dynamic>> totalSituacionesMap = await database.query(
        'preguntaSentimiento',
        where: whereClause.isEmpty ? null : whereClause);
    final bool hayMasPreguntas =
        (offset + pageSize) < totalSituacionesMap.length;

    return PreguntaSentimientoPaginacion(preguntas, hayMasPreguntas);
  } catch (e) {
    print("Error al obtener preguntas situaciones: $e");
    return PreguntaSentimientoPaginacion([], false);
  }
}

///Método que nos permite insertar una nueva pregunta al juego Sentimientos
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[enunciado] Enunciado de la pregunta<br>
///[imgPersonaje] Lista de enteros que es la imagen del personaje<br>
///[grupoId] Identificador del grupo al que va a pertenecer la pregunta
///<br><b>Salida</b><br>
///Identificador de la pregunta que ha sido añadida
Future<int> insertPreguntaSentimiento(Database database, String enunciado,
    List<int> imgPersonaje, int grupoId) async {
  int id = -1;
  await database.transaction((txn) async {
    if (imgPersonaje.isEmpty)
      id = await txn.rawInsert(
        "INSERT INTO preguntaSentimiento (enunciado, imagen, grupoId, byTerapeuta, fecha) VALUES (?, ?, ?, ?, ?)",
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
        "INSERT INTO preguntaSentimiento (enunciado, imagen, grupoId, byTerapeuta, fecha) VALUES (?, ?, ?, ?, ?)",
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

///Método que nos permite insertar las preguntas por defecto del juego Sentimientos
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[enunciado] Enunciado de la pregunta<br>
///[pathImg] Ruta en la que se encuentra la imagen del personaje<br>
///[grupoId] Identificador del grupo al que va a pertenecer la pregunta
///<br><b>Salida</b><br>
///Identificador de la pregunta que ha sido añadida
Future<int> insertPreguntaSentimientoInitialData(
    Database database, String enunciado, String pathImg, int grupoId) async {
  int id = -1;
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO preguntaSentimiento (enunciado, imagen, grupoId, fecha) VALUES (?, ?, ?, ?)",
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

///Método que nos permite eliminar una pregunta del juego Sentimientos a partir de su identificador
///<br><b>Parámetros</b><br>
///[preguntaSentimientoId] Identificador de la pregunta del juego Sentimientos que queremos eliminar<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
Future<void> removePreguntaSentimiento(int preguntaSentimientoId,
    [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    await database.delete(
      'preguntaSentimiento',
      where: 'id = ?',
      whereArgs: [preguntaSentimientoId],
    );
  } catch (e) {
    print('Error al eliminar la pregunta sentimiento: $e');
  }
}

///Método que nos permite actualizar una pregunta del juego Sentimientos
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecuta la actualización<br>
///[id] Identificador de la pregunta que queremos actualizar<br>
///[enunciado] Nuevo valor del enunciado<br>
///[imgPersonaje] Nueva lista de enteros que representa la imagen del personaje<br>
///[grupoId] Nuevo valor del grupo al que pertenece la pregunta
Future<void> updatePregunta(Database database, int id, String enunciado,
    List<int> imgPersonaje, int grupoId,
    [Database? db]) async {
  final Database database = db ?? await initializeDB();
  if (imgPersonaje.isEmpty)
    await database.update(
      'preguntaSentimiento',
      {
        'enunciado': enunciado,
        'imagen': null,
        'grupoId': grupoId,
        'fecha': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  else
    await database.update(
      'preguntaSentimiento',
      {
        'enunciado': enunciado,
        'imagen': imgPersonaje,
        'grupoId': grupoId,
        'fecha': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
      },
      where: 'id = ?',
      whereArgs: [id],
    );
}

///Método que se encarga de hacer la insercción de las preguntas del juego Sentimientos que están presentes inicialmente
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones
void insertSentimientos(Database database) {
  insertPreguntaSentimientoInitialDataAtencionT(database);
  insertPreguntaSentimientoInitialDataInfancia(database);
  insertPreguntaSentimientoInitialDataAdolescencia(database);
}
