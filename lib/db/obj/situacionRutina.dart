import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../obj/SituacionRutinaPaginacion.dart';
import '../db.dart';
import '../rutinasScripts/adolescencia.dart';
import '../rutinasScripts/atenciont.dart';
import '../rutinasScripts/infancia.dart';
import 'grupo.dart';

class SituacionRutina {
  final int? id;
  final String enunciado;
  final Uint8List? personajeImg;
  final int grupoId;
  final String fecha;
  final int byTerapeuta;

  SituacionRutina(
      {this.id,
      required this.enunciado,
      this.personajeImg,
      required this.grupoId,
      required this.fecha,
      required this.byTerapeuta});

  SituacionRutina.situacionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        personajeImg = item["personajeImg"],
        grupoId = item["grupoId"],
        fecha = item["fecha"],
        byTerapeuta = item["byTerapeuta"];

  Map<String, Object> situacionesToMap() {
    return {
      'enunciado': enunciado,
      'grupoId': grupoId,
      'fecha': fecha,
      'byTerapeuta': byTerapeuta
    };
  }

  @override
  String toString() {
    return 'SituacionRutina {id: $id, enunciado: $enunciado,'
        ' personajeImg: $personajeImg, '
        'grupoId: $grupoId}, '
        'fecha: $fecha}, '
        'byTerapeuta: $byTerapeuta, ';
  }
}

Future<List<SituacionRutina>> getSituacionesRutinas(int grupoId) async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> preguntasMap = await db
        .query('situacionRutina', where: 'grupoId = ?', whereArgs: [grupoId]);
    return preguntasMap
        .map((map) => SituacionRutina.situacionesFromMap(map))
        .toList();
  } catch (e) {
    print("Error al obtener situaciones: $e");
    return [];
  }
}

Future<SituacionRutinaPaginacion> getSituacionesRutinasCreatedByTerapeuta(
    int pageNumber, int pageSize, String txtBuscar, Grupo? grupo) async {
  try {
    final Database db = await initializeDB();
    int offset = (pageNumber - 1) * pageSize;
    String whereClause = 'byTerapeuta = 1';

    // Agregar condiciones de búsqueda por enunciado y grupo
    if (txtBuscar.isNotEmpty) {
      whereClause += " AND enunciado LIKE '%$txtBuscar%'";
    }
    if (grupo != null) {
      whereClause += " AND grupoId = ${grupo.id}";
    }

    final List<Map<String, dynamic>> situacionesMap = await db.query(
      'situacionRutina',
      where: whereClause,
      orderBy: 'id DESC',
      limit: pageSize,
      offset: offset,
    );
    final List<SituacionRutina> situaciones = situacionesMap
        .map((map) => SituacionRutina.situacionesFromMap(map))
        .toList();

    // Comprobar si hay más preguntas disponibles
    final List<Map<String, dynamic>> totalSituacionesMap =
        await db.query('situacionRutina', where: whereClause);
    final bool hayMasPreguntas =
        (offset + pageSize) < totalSituacionesMap.length;

    return SituacionRutinaPaginacion(situaciones, hayMasPreguntas);
  } catch (e) {
    print("Error al obtener situaciones: $e");
    return SituacionRutinaPaginacion([], false);
  }
}

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

Future<int> insertSituacionRutinaInitialDataTerapeutaTest(
    Database database, String enunciado, String pathImg, int grupoId) async {
  int id = -1;
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO situacionRutina (enunciado, personajeImg, grupoId, fecha,byTerapeuta) VALUES (?, ?, ?, ?, 1)",
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

Future<void> removePregunta(int situacionRutinaId) async {
  try {
    final Database db = await initializeDB();
    await db.delete(
      'situacionRutina',
      where: 'id = ?',
      whereArgs: [situacionRutinaId],
    );
    print('Situación rutina eliminada con éxito');
  } catch (e) {
    print('Error al eliminar la situación rutina: $e');
  }
}

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

void insertRutinas(Database database) {
  insertPreguntaRutinaInitialDataAtencionT(database);
  insertPreguntaRutinaInitialDataInfancia(database);
  insertPreguntaRutinaInitialDataAdolescencia(database);
}
