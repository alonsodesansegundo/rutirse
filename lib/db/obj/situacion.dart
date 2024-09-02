import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';

///Clase relativa a la tabla Situacion
class Situacion {
  final int id;
  final String texto;
  final int correcta;
  final Uint8List? imagen;
  final int preguntaSentimientoId;

  ///Constructor de la clase Situacion
  Situacion(
      {required this.id,
      required this.texto,
      required this.correcta,
      this.imagen,
      required this.preguntaSentimientoId});

  ///Crea una instancia de Situacion a partir de un mapa de datos, dicho mapa debe contener:
  ///id, texto, correcta, imagen y preguntaSentimientoId
  Situacion.situacionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        texto = item["texto"],
        correcta = item["correcta"],
        imagen = item["imagen"],
        preguntaSentimientoId = item["preguntaSentimientoId"];

  ///Convierte una instancia de Situacion a un mapa de datos
  Map<String, Object> situacionesToMap() {
    return {
      'id': id,
      'texto': texto,
      'correcta': correcta,
      'preguntaSentimientoId': preguntaSentimientoId
    };
  }

  ///Sobreescritura del método equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Situacion &&
        other.id == id &&
        other.texto == texto &&
        other.correcta == correcta &&
        other.preguntaSentimientoId == preguntaSentimientoId;
  }

  ///Sobreescritura del método hashCode
  @override
  int get hashCode =>
      id.hashCode ^
      texto.hashCode ^
      correcta.hashCode ^
      preguntaSentimientoId.hashCode;

  ///Sobreescritura del método toString
  @override
  String toString() {
    return 'Situación {id: $id, texto: $texto, correcta: $correcta, '
        'imagen: $imagen, preguntaSentimientoId: $preguntaSentimientoId}';
  }
}

///Método que nos permite insertar una respuesta del juego Sentimientos
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[texto] Texto de la respuesta<br>
///[correcta] Valor 1 si la respuesta es correcta, valor 0 si la respuesta es incorrecta<br>
///[imgSituacion] Lista de enteros que es la imagen de la respuesta<br>
///[preguntaSentimientoId] Identificador de la pregunta del juego Sentimientos a la que pertenece la respuesta
Future<void> insertSituacion(Database database, String texto, int correcta,
    List<int> imgSituacion, int preguntaSentimientoId) async {
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO situacion (texto, correcta, imagen, preguntaSentimientoId) VALUES (?, ?, ?, ?)",
      [texto, correcta, imgSituacion, preguntaSentimientoId],
    );
  });
}

///Método que nos permite insertar las respuestas a las preguntas que vienen por defecto en el juego Sentimientos
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[texto] Texto de la respuesta<br>
///[correcta] Valor 1 si la respuesta es correcta, valor 0 si la respuesta es incorrecta<br>
///[pathImg] Ruta en la que se encuentra la imagen de la respuesta<br>
///[preguntaSentimientoId] Identificador de la pregunta del juego Sentimientos a la que pertenece la respuesta
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

///Método que nos permite obtener las posibles respuestas de una pregunta del juego Sentimientos dada
///<br><b>Parámetros</b><br>
///[preguntaSentimientoId] Identificador de la pregunta que queremos obtener las respuestas<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Lista de todas las preguntas de sentimientos relativas al grupo indicado
Future<List<Situacion>> getSituaciones(int preguntaSentimientoId,
    [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    final List<Map<String, dynamic>> situacionesMap = await database.query(
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

///Método que nos permite eliminar una respuesta a partir de su identificador
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan la operación de delete<br>
///[situacionId] Identificador de la respuesta que queremos eliminar
void deleteSituacion(Database database, int situacionId) async {
  try {
    await database.delete(
      'situacion',
      where: 'id = ?',
      whereArgs: [situacionId],
    );
  } catch (e) {
    print('Error al borrar la instancia de situación: $e');
  }
}
