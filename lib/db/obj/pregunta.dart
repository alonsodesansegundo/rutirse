import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';
import '../preguntasScripts/adolescencia.dart';
import '../preguntasScripts/atenciont.dart';
import '../preguntasScripts/infancia.dart';

class Pregunta {
  final int? id;
  final String enunciado;
  final Uint8List? personajeImg;
  final int grupoId;

  Pregunta(
      {this.id,
      required this.enunciado,
      this.personajeImg,
      required this.grupoId});

  Pregunta.preguntasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        personajeImg = item["personajeImg"],
        grupoId = item["grupoId"];

  Map<String, Object> preguntasToMap() {
    return {'enunciado': enunciado, 'grupoId': grupoId};
  }

  @override
  String toString() {
    return 'Pregunta {id: $id, enunciado: $enunciado,'
        ' personajeImg: $personajeImg, '
        'grupoId: $grupoId}';
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

Future<int> insertPregunta(Database database, String enunciado,
    List<int> imgPersonaje, int grupoId) async {
  int id = -1;
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO pregunta (enunciado, personajeImg, grupoId) VALUES (?, ?, ?)",
      [enunciado, imgPersonaje, grupoId],
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
      "INSERT INTO pregunta (enunciado, personajeImg, grupoId) VALUES (?, ?, ?)",
      [enunciado, bytes, grupoId],
    );
  });

  return id;
}

void insertPreguntas(Database database) {
  insertPreguntaInitialDataAtencionT(database);
  insertPreguntaInitialDataInfancia(database);
  insertPreguntaInitialDataAdolescencia(database);
}
