import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../obj/PreguntaSentimientoPaginacion.dart';
import '../db.dart';
import '../sentimientosScripts/adolescencia.dart';
import '../sentimientosScripts/atenciont.dart';
import '../sentimientosScripts/infancia.dart';
import 'grupo.dart';

class PreguntaSentimiento {
  final int? id;
  final String enunciado;
  final Uint8List? imagen;
  final int grupoId;
  final String fecha;
  final int byTerapeuta;

  PreguntaSentimiento(
      {this.id,
      required this.enunciado,
      this.imagen,
      required this.grupoId,
      required this.fecha,
      required this.byTerapeuta});

  PreguntaSentimiento.sentimientosFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        imagen = item["imagen"],
        grupoId = item["grupoId"],
        fecha = item["fecha"],
        byTerapeuta = item["byTerapeuta"];

  Map<String, Object> sentimientosToMap() {
    return {
      'enunciado': enunciado,
      'grupoId': grupoId,
      'fecha': fecha,
      'byTerapeuta': byTerapeuta
    };
  }

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

  @override
  int get hashCode =>
      id.hashCode ^
      enunciado.hashCode ^
      grupoId.hashCode ^
      fecha.hashCode ^
      byTerapeuta.hashCode;

  @override
  String toString() {
    return 'PreguntaSentimiento {id: $id, enunciado: $enunciado,'
        ' imagen: $imagen, '
        'grupoId: $grupoId}, '
        'fecha: $fecha}, '
        'byTerapeuta: $byTerapeuta, ';
  }
}

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

Future<void> removePreguntaSentimiento(int preguntaSentimientoId,
    [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    await database.delete(
      'preguntaSentimiento',
      where: 'id = ?',
      whereArgs: [preguntaSentimientoId],
    );
    print('Pregunta sentimiento eliminada con éxito');
  } catch (e) {
    print('Error al eliminar la pregunta sentimiento: $e');
  }
}

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

void insertSentimientos(Database database) {
  insertPreguntaSentimientoInitialDataAtencionT(database);
  insertPreguntaSentimientoInitialDataInfancia(database);
  insertPreguntaSentimientoInitialDataAdolescencia(database);
}
