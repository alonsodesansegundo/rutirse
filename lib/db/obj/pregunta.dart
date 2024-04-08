import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../obj/PreguntasPaginacion.dart';
import '../db.dart';
import '../preguntasScripts/adolescencia.dart';
import '../preguntasScripts/atenciont.dart';
import '../preguntasScripts/infancia.dart';
import 'grupo.dart';

class Pregunta {
  final int? id;
  final String enunciado;
  final Uint8List? personajeImg;
  final int grupoId;
  final String fecha;
  final int byTerapeuta;

  Pregunta(
      {this.id,
      required this.enunciado,
      this.personajeImg,
      required this.grupoId,
      required this.fecha,
      required this.byTerapeuta});

  Pregunta.preguntasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        personajeImg = item["personajeImg"],
        grupoId = item["grupoId"],
        fecha = item["fecha"],
        byTerapeuta = item["byTerapeuta"];

  Map<String, Object> preguntasToMap() {
    return {
      'enunciado': enunciado,
      'grupoId': grupoId,
      'fecha': fecha,
      'byTerapeuta': byTerapeuta
    };
  }

  @override
  String toString() {
    return 'Pregunta {id: $id, enunciado: $enunciado,'
        ' personajeImg: $personajeImg, '
        'grupoId: $grupoId}, '
        'fecha: $fecha}, '
        'byTerapeuta: $byTerapeuta, ';
  }
}

Future<List<Pregunta>> getPreguntas(int grupoId) async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> preguntasMap =
        await db.query('pregunta', where: 'grupoId = ?', whereArgs: [grupoId]);
    return preguntasMap.map((map) => Pregunta.preguntasFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener preguntas: $e");
    return [];
  }
}

Future<PreguntasPaginacion> getPreguntasCreatedByTerapeuta(
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

    final List<Map<String, dynamic>> preguntasMap = await db.query(
      'pregunta',
      where: whereClause,
      orderBy: 'id DESC',
      limit: pageSize,
      offset: offset,
    );
    final List<Pregunta> preguntas =
        preguntasMap.map((map) => Pregunta.preguntasFromMap(map)).toList();

    // Comprobar si hay más preguntas disponibles
    final List<Map<String, dynamic>> totalPreguntasMap =
        await db.query('pregunta', where: whereClause);
    final bool hayMasPreguntas = (offset + pageSize) < totalPreguntasMap.length;

    return PreguntasPaginacion(preguntas, hayMasPreguntas);
  } catch (e) {
    print("Error al obtener preguntas: $e");
    return PreguntasPaginacion([], false);
  }
}

Future<int> insertPregunta(Database database, String enunciado,
    List<int> imgPersonaje, int grupoId) async {
  int id = -1;
  await database.transaction((txn) async {
    if (imgPersonaje.isEmpty)
      id = await txn.rawInsert(
        "INSERT INTO pregunta (enunciado, personajeImg, grupoId, byTerapeuta, fecha) VALUES (?, ?, ?, ?, ?)",
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
        "INSERT INTO pregunta (enunciado, personajeImg, grupoId, byTerapeuta, fecha) VALUES (?, ?, ?, ?, ?)",
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

Future<int> insertPreguntaInitialData(
    Database database, String enunciado, String pathImg, int grupoId) async {
  int id = -1;
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO pregunta (enunciado, personajeImg, grupoId, fecha) VALUES (?, ?, ?, ?)",
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

Future<int> insertPreguntaInitialDataTerapeutaTest(
    Database database, String enunciado, String pathImg, int grupoId) async {
  int id = -1;
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO pregunta (enunciado, personajeImg, grupoId, fecha,byTerapeuta) VALUES (?, ?, ?, ?, 1)",
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

Future<void> removePregunta(int preguntaId) async {
  try {
    final Database db = await initializeDB();
    await db.delete(
      'pregunta',
      where: 'id = ?',
      whereArgs: [preguntaId],
    );
    print('Pregunta eliminada con éxito');
  } catch (e) {
    print('Error al eliminar la pregunta: $e');
  }
}

Future<void> updatePregunta(Database database, int id, String enunciado,
    List<int> imgPersonaje, int grupoId) async {
  if (imgPersonaje.isEmpty)
    await database.update(
      'pregunta',
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
      'pregunta',
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

void insertPreguntas(Database database) {
  insertPreguntaInitialDataAtencionT(database);
  insertPreguntaInitialDataInfancia(database);
  insertPreguntaInitialDataAdolescencia(database);
}
