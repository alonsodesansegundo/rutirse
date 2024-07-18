import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';

class Situacion {
  final int id;
  final String texto;
  final int correcta;
  final Uint8List? imagen;
  final int preguntaSentimientoId;

  Situacion(
      {required this.id,
      required this.texto,
      required this.correcta,
      this.imagen,
      required this.preguntaSentimientoId});

  Situacion.situacionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        texto = item["texto"],
        correcta = item["correcta"],
        imagen = item["imagen"],
        preguntaSentimientoId = item["preguntaSentimientoId"];

  Map<String, Object> situacionesToMap() {
    return {
      'id': id,
      'texto': texto,
      'correcta': correcta,
      'preguntaSentimientoId': preguntaSentimientoId
    };
  }

  @override
  String toString() {
    return 'Situación {id: $id, texto: $texto, correcta: $correcta, '
        'imagen: $imagen, preguntaSentimientoId: $preguntaSentimientoId}';
  }
}

Future<void> insertSituacion(Database database, String texto, int correcta,
    List<int> imgSituacion, int preguntaSentimientoId) async {
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO situacion (texto, correcta, imagen, preguntaSentimientoId) VALUES (?, ?, ?, ?)",
      [texto, correcta, imgSituacion, preguntaSentimientoId],
    );
  });
}

Future<void> insertSituacionInitialData(Database database, String texto,
    int correcta, String pathImg, int preguntaSentimientoId) async {
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO situacion (texto, correcta, imagen, preguntaSentimientoId) VALUES (?, ?, ?, ?)",
      [texto, correcta, bytes, preguntaSentimientoId],
    );
  });
}

Future<List<Situacion>> getSituaciones(int preguntaSentimientoId) async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> situacionesMap = await db.query(
        'situacion',
        where: 'preguntaSentimientoId = ?',
        whereArgs: [preguntaSentimientoId]);
    return situacionesMap
        .map((map) => Situacion.situacionesFromMap(map))
        .toList();
  } catch (e) {
    print("Error al obtener situaciones: $e");
    return [];
  }
}

void deleteSituacion(Database database, int situacionId) async {
  try {
    await database.delete(
      'situacion',
      where: 'id = ?',
      whereArgs: [situacionId],
    );
    print('Instancia de situación con ID $situacionId borrada correctamente.');
  } catch (e) {
    print('Error al borrar la instancia de situación: $e');
  }
}
