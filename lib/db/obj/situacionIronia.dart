import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../obj/SituacionIroniaPaginacion.dart';
import '../db.dart';
import '../ironiasScripts/adolescencia.dart';
import '../ironiasScripts/atenciont.dart';
import '../ironiasScripts/infancia.dart';
import 'grupo.dart';

class SituacionIronia {
  final int? id;
  final String enunciado;
  final Uint8List? imagen;
  final int grupoId;
  final String fecha;
  final int byTerapeuta;

  SituacionIronia(
      {this.id,
      required this.enunciado,
      this.imagen,
      required this.grupoId,
      required this.fecha,
      required this.byTerapeuta});

  SituacionIronia.situacionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        imagen = item["imagen"],
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
    return 'SituacionIronia {id: $id, enunciado: $enunciado,'
        ' imagen: $imagen, '
        'grupoId: $grupoId}, '
        'fecha: $fecha}, '
        'byTerapeuta: $byTerapeuta, ';
  }
}

Future<List<SituacionIronia>> getSituacionesIronias(int grupoId) async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> preguntasMap = await db
        .query('situacionIronia', where: 'grupoId = ?', whereArgs: [grupoId]);
    return preguntasMap
        .map((map) => SituacionIronia.situacionesFromMap(map))
        .toList();
  } catch (e) {
    print("Error al obtener situaciones: $e");
    return [];
  }
}

Future<SituacionIroniaPaginacion> getSituacionIroniaPaginacion(
    int pageNumber, int pageSize, String txtBuscar, Grupo? grupo) async {
  try {
    final Database db = await initializeDB();
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

    final List<Map<String, dynamic>> situacionesMap = await db.query(
      'situacionIronia',
      where: whereClause.isEmpty ? null : whereClause,
      orderBy: 'id DESC',
      limit: pageSize,
      offset: offset,
    );
    final List<SituacionIronia> situaciones = situacionesMap
        .map((map) => SituacionIronia.situacionesFromMap(map))
        .toList();

    // Comprobar si hay más preguntas disponibles
    final List<Map<String, dynamic>> totalSituacionesMap = await db.query(
        'situacionIronia',
        where: whereClause.isEmpty ? null : whereClause);
    final bool hayMasPreguntas =
        (offset + pageSize) < totalSituacionesMap.length;

    return SituacionIroniaPaginacion(situaciones, hayMasPreguntas);
  } catch (e) {
    print("Error al obtener situaciones: $e");
    return SituacionIroniaPaginacion([], false);
  }
}

Future<int> insertSituacionIronia(
    Database database, String enunciado, List<int> imagen, int grupoId) async {
  int id = -1;
  await database.transaction((txn) async {
    if (imagen.isEmpty)
      id = await txn.rawInsert(
        "INSERT INTO situacionIronia (enunciado, imagen, grupoId, byTerapeuta, fecha) VALUES (?, ?, ?, ?, ?)",
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
        "INSERT INTO situacionIronia (enunciado, imagen, grupoId, byTerapeuta, fecha) VALUES (?, ?, ?, ?, ?)",
        [
          enunciado,
          imagen,
          grupoId,
          1,
          DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
        ],
      );
  });

  return id;
}

Future<int> insertSituacionIroniaInitialData(
    Database database, String enunciado, String pathImg, int grupoId) async {
  int id = -1;
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO situacionIronia (enunciado, imagen, grupoId, fecha) VALUES (?, ?, ?, ?)",
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

Future<void> removePreguntaIronia(int situacionIroniaId) async {
  try {
    final Database db = await initializeDB();
    await db.delete(
      'situacionIronia',
      where: 'id = ?',
      whereArgs: [situacionIroniaId],
    );
    print('Situación ironía eliminada con éxito');
  } catch (e) {
    print('Error al eliminar la situación ironía: $e');
  }
}

Future<int> updatePreguntaIronia(Database database, int id, String enunciado,
    List<int> imagen, int grupoId) async {
  return await database.update(
    'situacionIronia',
    {
      'enunciado': enunciado,
      'imagen': imagen,
      'grupoId': grupoId,
      'fecha': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())
    },
    where: 'id = ?',
    whereArgs: [id],
  );
}

void insertIronias(Database database) {
  insertIroniasInitialDataAtencionT(database);
  insertIroniasInitialDataInfancia(database);
  insertIroniasInitialDataAdolescencia(database);
}
