import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../db.dart';

///Clase relativa a la tabla accion
class Accion {
  final int id;
  final String texto;
  final int orden;
  final Uint8List? imagen;
  final int situacionRutinaId;

  ///Constructor de la clase Accion
  Accion(
      {required this.id,
      required this.texto,
      required this.orden,
      this.imagen,
      required this.situacionRutinaId});

  ///Crea una instancia de Accion a partir de un mapa de datos, dicho mapa debe contener:
  ///id, texto, orden, imagen y situacionRutinaId
  Accion.accionesFromMap(Map<String, dynamic> item)
      : id = item["id"],
        texto = item["texto"],
        orden = item["orden"],
        imagen = item["imagen"],
        situacionRutinaId = item["situacionRutinaId"];

  ///Convierte una instancia de Accion a un mapa de datos
  Map<String, Object> accionesToMap() {
    return {
      'id': id,
      'texto': texto,
      'orden': orden,
      'situacionRutinaId': situacionRutinaId
    };
  }

  ///Sobreescritura del método equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Accion &&
        other.id == id &&
        other.texto == texto &&
        other.orden == orden &&
        other.situacionRutinaId == situacionRutinaId;
  }

  ///Sobreescritura del método hashCode
  @override
  int get hashCode =>
      id.hashCode ^
      texto.hashCode ^
      orden.hashCode ^
      situacionRutinaId.hashCode;

  ///Sobreescritura del método toString
  @override
  String toString() {
    return 'Accion {id: $id, texto: $texto, orden: $orden, '
        'imagen: $imagen, situacionRutinaId: $situacionRutinaId}';
  }
}

/// Método que se engarga de realizar una insercción en la tabla accion
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[texto] Texto correspondiente a la accion<br>
///[orden] Posición correcta de la accion<br>
///[imgAccion] Array de enteros que es la imagen de la accion<br>
///[situacionRutinaId] Referencia a la pregunta rutina que pertenece dicha accion
Future<void> insertAccion(Database database, String texto, int orden,
    List<int> imgAccion, int situacionRutinaId) async {
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO accion (texto, orden, imagen, situacionRutinaId) VALUES (?, ?, ?, ?)",
      [texto, orden, imgAccion, situacionRutinaId],
    );
  });
}

/// Método que se engarga de realizar una insercción de los datos por defecto en la tabla accion
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[texto] Texto correspondiente a la accion<br>
///[orden] Posición correcta de la accion<br>
///[pathImg] Path que hace referencia a donde se encuentra la imagen de la accion<br>
///[situacionRutinaId] Referencia a la pregunta rutina que pertenece dicha accion
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

///Método que se encarga de obtener las acciones pertenecientes a una pregunta sobre rutinas
///<br><b>Parámetros</b><br>
///[situacionRutinaId] Identificador de la pregunta rutina sobre la que queremos obtener las acciones<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///La lista de acciones relativas a la pregunta que le pasamos por parametro
Future<List<Accion>> getAcciones(int situacionRutinaId, [Database? db]) async {
  try {
    final Database database = db ?? await initializeDB();
    final List<Map<String, dynamic>> accionesMap = await database.query(
        'accion',
        where: 'situacionRutinaId = ?',
        whereArgs: [situacionRutinaId]);
    return accionesMap.map((map) => Accion.accionesFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener acciones: $e");
    return [];
  }
}

///Método que elimina una fila de la tabla accion
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones<br>
///[accionId] Identificador de la fila de la tabla accion que queremos eliminar
void deleteAccion(Database database, int accionId) async {
  try {
    await database.delete(
      'accion',
      where: 'id = ?',
      whereArgs: [accionId],
    );
  } catch (e) {
    print('Error al borrar la instancia de accion: $e');
  }
}
