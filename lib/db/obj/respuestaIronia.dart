import 'package:sqflite/sqflite.dart';

import '../db.dart';

///Clase relativa a la tabla RespuestaIronia
class RespuestaIronia {
  final int id;
  String texto;
  final int correcta;
  final int situacionIroniaId;

  ///Constructor de la clase RespuestaIronia
  RespuestaIronia(
      {required this.id,
      required this.texto,
      required this.correcta,
      required this.situacionIroniaId});

  ///Crea una instancia de RespuestaIronia a partir de un mapa de datos, dicho mapa debe contener:
  ///id, texto, correcta y situacionIroniaId
  RespuestaIronia.respuestasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        texto = item["texto"],
        correcta = item["correcta"],
        situacionIroniaId = item["situacionIroniaId"];

  ///Convierte una instancia de RespuestaIronia a un mapa de datos
  Map<String, Object> respuestasToMap() {
    return {
      'id': id,
      'texto': texto,
      'correcta': correcta,
      'situacionIroniaId': situacionIroniaId
    };
  }

  ///Sobreescritura del método equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RespuestaIronia &&
        other.id == id &&
        other.texto == texto &&
        other.correcta == correcta &&
        other.situacionIroniaId == situacionIroniaId;
  }

  ///Sobreescritura del método hashCode
  @override
  int get hashCode =>
      id.hashCode ^
      texto.hashCode ^
      correcta.hashCode ^
      situacionIroniaId.hashCode;

  ///Sobreescritura del método toString
  @override
  String toString() {
    return 'Accion {id: $id, texto: $texto, correcta: $correcta, situacionIroniaId: $situacionIroniaId}';
  }
}

///Método que nos permite añadir una respuesta a una pregunta del juego Humor
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[texto] Texto de la respuesta<br>
///[correcta] Valor 1 si la respuesta es correcta, valor 0 si la respuesta es incorrecta<br>
///[situacionIroniaId] Identificador de la pregunta a la que pertenece la respuesta
Future<void> insertRespuestaIronia(Database database, String texto,
    int correcta, int situacionIroniaId) async {
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO respuestaIronia (texto, correcta, situacionIroniaId) VALUES (?, ?, ?)",
      [texto, correcta, situacionIroniaId],
    );
  });
}

///Método que nos permite obtener todas las respuestas de una pregunta del juego Humor
///<br><b>Parámetros</b><br>
///[situacionId] Identificador de la pregunta que queremos obtener las respuestas<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Una lista con las respuestas pertenecientes a la pregunta dada
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

///Método que nos permite eliminar las respuestas pertenecientes a una pregunta del juego Humor
///<br><b>Parámetros</b><br>
///[db] Objeto Database sobre la cual se ejecutan la operación de delete<br>
///[situacionIroniaId] Identificador de la pregunta de la que queremos eliminar las respuestas
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
