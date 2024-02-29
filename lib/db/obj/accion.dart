import 'package:sqflite/sqflite.dart';

import '../db.dart';

class Accion {
  final int id;
  final String texto;
  final int orden;
  final String imagenPath;
  final int preguntaId;

  Accion(
      {required this.id,
      required this.texto,
      required this.orden,
      required this.imagenPath,
      required this.preguntaId});

  Accion.accionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        texto = item["texto"],
        orden = item["orden"],
        imagenPath = item["imagenPath"],
        preguntaId = item["preguntaId"];

  Map<String, Object> accionesToMap() {
    return {
      'id': id,
      'texto': texto,
      'orden': orden,
      'imagenPath': imagenPath,
      'preguntaId': preguntaId
    };
  }

  @override
  String toString() {
    return 'Accion {id: $id, texto: $texto, orden: $orden, imagenPath: $imagenPath, preguntaId: $preguntaId}';
  }
}

Future<void> insertAccion(Database database, String texto, int orden,
    String imgAccion, int preguntaId) async {
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO accion (texto, orden, imagenPath, preguntaId) VALUES (?, ?, ?, ?)",
      [texto, orden, imgAccion, preguntaId],
    );
  });
}

Future<List<Accion>> getAcciones(int preguntaId) async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> accionesMap = await db
        .query('accion', where: 'preguntaId = ?', whereArgs: [preguntaId]);
    return accionesMap.map((map) => Accion.accionesFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener acciones: $e");
    return [];
  }
}
