import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';

import '../db.dart';
import '../preguntasScripts/adolescencia.dart';
import '../preguntasScripts/atenciont.dart';
import '../preguntasScripts/infancia.dart';

class Pregunta {
  final int? id;
  final String enunciado;
  final String? personajePath;
  final Uint8List? personajeImg;
  final int grupoId;

  Pregunta(
      {this.id,
      required this.enunciado,
      this.personajePath,
      this.personajeImg,
      required this.grupoId});

  Pregunta.preguntasFromMap(Map<String, dynamic> item)
      : id = item["id"],
        enunciado = item["enunciado"],
        personajePath = item["personajePath"],
        personajeImg = item["personajeImg"],
        grupoId = item["grupoId"];

  Map<String, Object> preguntasToMap() {
    return {'enunciado': enunciado, 'grupoId': grupoId};
  }

  @override
  String toString() {
    return 'Pregunta {id: $id, enunciado: $enunciado, personajePath: $personajePath,'
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
    String imgPersonaje, int grupoId) async {
  int id = -1;
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO pregunta (enunciado, personajePath, grupoId) VALUES (?, ?, ?)",
      [enunciado, pathPersonajes + imgPersonaje, grupoId],
    );
  });

  return id;
}

void insertPreguntas(Database database) {
  insertPreguntasAccionesAtencionT(database);
  insertPreguntasAccionesInfancia(database);
  insertPreguntasAccionesAdolescencia(database);
}
