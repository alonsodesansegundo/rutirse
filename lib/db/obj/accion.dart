import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';

class Accion {
  final int id;
  final String texto;
  final int orden;
  final Uint8List? imagen;
  final int situacionRutinaId;

  Accion(
      {required this.id,
      required this.texto,
      required this.orden,
      this.imagen,
      required this.situacionRutinaId});

  Accion.accionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        texto = item["texto"],
        orden = item["orden"],
        imagen = item["imagen"],
        situacionRutinaId = item["situacionRutinaId"];

  Map<String, Object> accionesToMap() {
    return {
      'id': id,
      'texto': texto,
      'orden': orden,
      'situacionRutinaId': situacionRutinaId
    };
  }

  @override
  String toString() {
    return 'Accion {id: $id, texto: $texto, orden: $orden, '
        'imagen: $imagen, situacionRutinaId: $situacionRutinaId}';
  }
}

Future<void> insertAccion(Database database, String texto, int orden,
    List<int> imgAccion, int situacionRutinaId) async {
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO accion (texto, orden, imagen, situacionRutinaId) VALUES (?, ?, ?, ?)",
      [texto, orden, imgAccion, situacionRutinaId],
    );
  });
}

Future<void> insertAccionInitialData(Database database, String texto, int orden,
    String pathImg, int situacionRutinaId) async {
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO accion (texto, orden, imagen, situacionRutinaId) VALUES (?, ?, ?, ?)",
      [texto, orden, bytes, situacionRutinaId],
    );
  });
}

Future<void> insertAccionInitialDataTerapeutaTest(Database database,
    String texto, int orden, String pathImg, int situacionRutinaId) async {
  ByteData imageData = await rootBundle.load(pathImg);
  List<int> bytes = imageData.buffer.asUint8List();
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO accion (texto, orden, imagen, situacionRutinaId) VALUES (?, ?, ?, ?)",
      [texto, orden, bytes, situacionRutinaId],
    );
  });
}

Future<List<Accion>> getAcciones(int situacionRutinaId) async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> accionesMap = await db.query('accion',
        where: 'situacionRutinaId = ?', whereArgs: [situacionRutinaId]);
    return accionesMap.map((map) => Accion.accionesFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener acciones: $e");
    return [];
  }
}

void deleteAccion(Database database, int accionId) async {
  try {
    await database.delete(
      'accion',
      where: 'id = ?',
      whereArgs: [accionId],
    );
    print('Instancia de accion con ID $accionId borrada correctamente.');
  } catch (e) {
    print('Error al borrar la instancia de accion: $e');
  }
}
