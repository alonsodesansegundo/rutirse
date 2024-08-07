import 'package:sqflite/sqflite.dart';

import '../db.dart';

class RespuestaIronia {
  final int id;
  String texto;
  final int correcta;
  final int situacionIroniaId;

  RespuestaIronia(
      {required this.id,
      required this.texto,
      required this.correcta,
      required this.situacionIroniaId});

  RespuestaIronia.respuestasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        texto = item["texto"],
        correcta = item["correcta"],
        situacionIroniaId = item["situacionIroniaId"];

  Map<String, Object> respuestasToMap() {
    return {
      'id': id,
      'texto': texto,
      'correcta': correcta,
      'situacionIroniaId': situacionIroniaId
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RespuestaIronia &&
        other.id == id &&
        other.texto == texto &&
        other.correcta == correcta &&
        other.situacionIroniaId == situacionIroniaId;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      texto.hashCode ^
      correcta.hashCode ^
      situacionIroniaId.hashCode;

  @override
  String toString() {
    return 'Accion {id: $id, texto: $texto, correcta: $correcta, situacionIroniaId: $situacionIroniaId}';
  }
}

Future<void> insertRespuestaIronia(Database database, String texto,
    int correcta, int situacionIroniaId) async {
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO respuestaIronia (texto, correcta, situacionIroniaId) VALUES (?, ?, ?)",
      [texto, correcta, situacionIroniaId],
    );
  });
}

Future<List<RespuestaIronia>> getRespuestasIronia(int situacionId,
    [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    final List<Map<String, dynamic>> accionesMap = await database.query(
        'respuestaIronia',
        where: 'situacionIroniaId = ?',
        whereArgs: [situacionId]);
    return accionesMap
        .map((map) => RespuestaIronia.respuestasFromMap(map))
        .toList();
  } catch (e) {
    print("Error al obtener respuestas: $e");
    return [];
  }
}

Future<void> deleteRespuestasBySituacionIroniaId(
    Database db, int situacionIroniaId) async {
  try {
    await db.delete(
      'respuestaIronia',
      where: 'situacionIroniaId = ?',
      whereArgs: [situacionIroniaId],
    );
  } catch (e) {
    print("Error al eliminar respuestas: $e");
  }
}
