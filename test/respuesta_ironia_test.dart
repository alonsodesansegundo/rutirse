import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/respuestaIronia.dart';
import 'package:Rutirse/db/obj/situacionIronia.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

String pathIronias = 'assets/img/humor/';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  late Database database;

  // Inicializa la base de datos antes de cada prueba
  setUp(() async {
    database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    createTables(database);
    insertGrupos(database);
  });

  // Elimino la tabla situacionIronia después de cada prueba
  tearDown(() async {
    await database.delete('situacionIronia');
    await database.close();
  });

  // Test 1
  test('Test for check insertAccionInitialData (new) length', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);
    insertRespuestaIronia(database, "Respuesta correcta", 1, id_P1);

    final List<Map<String, dynamic>> result =
        await database.query('respuestaIronia');
    expect(result.length, 2);
  });

  test('Test for check insertRespuestaIronia (new) toString', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);
    insertRespuestaIronia(database, "Respuesta correcta", 1, id_P1);

    ByteData imageData = await rootBundle.load(pathIronias + 'vaca.png');
    List<int> bytes = imageData.buffer.asUint8List();

    RespuestaIronia expectedRespuestaIronia = new RespuestaIronia(
      id: 1,
      texto: "Respuesta incorrecta",
      correcta: 0,
      situacionIroniaId: id_P1,
    );

    final List<Map<String, dynamic>> accionesMap =
        await database.query('respuestaIronia');
    List<RespuestaIronia> respuestas = accionesMap
        .map((map) => RespuestaIronia.respuestasFromMap(map))
        .toList();
    expect(respuestas[0].toString(), expectedRespuestaIronia.toString());
  });

  test('Test for check insertRespuestaIronia (new) hashCode', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);
    insertRespuestaIronia(database, "Respuesta correcta", 1, id_P1);

    ByteData imageData = await rootBundle.load(pathIronias + 'vaca.png');
    List<int> bytes = imageData.buffer.asUint8List();

    RespuestaIronia expectedRespuestaIronia = new RespuestaIronia(
      id: 1,
      texto: "Respuesta incorrecta",
      correcta: 0,
      situacionIroniaId: id_P1,
    );

    final List<Map<String, dynamic>> accionesMap =
        await database.query('respuestaIronia');
    List<RespuestaIronia> respuestas = accionesMap
        .map((map) => RespuestaIronia.respuestasFromMap(map))
        .toList();
    expect(respuestas[0].hashCode, expectedRespuestaIronia.hashCode);
  });

  test('Test for check insertRespuestaIronia (new) equals', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);
    insertRespuestaIronia(database, "Respuesta correcta", 1, id_P1);

    RespuestaIronia expectedRespuestaIronia = new RespuestaIronia(
      id: 1,
      texto: "Respuesta incorrecta",
      correcta: 0,
      situacionIroniaId: id_P1,
    );

    final List<Map<String, dynamic>> accionesMap =
        await database.query('respuestaIronia');
    List<RespuestaIronia> respuestas = accionesMap
        .map((map) => RespuestaIronia.respuestasFromMap(map))
        .toList();
    expect(respuestas[0], expectedRespuestaIronia);
  });

  test('Test for check getAcciones empty (with existent situacionIronia)',
      () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    List<RespuestaIronia> respuestas =
        await getRespuestasIronia(id_P1, database);
    expect(respuestas.length, 0);
  });

  test('Test for check getAcciones empty (without existent situacionIronia)',
      () async {
    List<RespuestaIronia> respuestas = await getRespuestasIronia(-1, database);
    expect(respuestas.length, 0);
  });

  test('Test for check getRespuestasIronia (length)', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);
    insertRespuestaIronia(database, "Respuesta correcta", 1, id_P1);

    List<RespuestaIronia> respuestas =
        await getRespuestasIronia(id_P1, database);

    expect(respuestas.length, 2);
  });

  test('Test for check getRespuestasIronia (obj)', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);
    insertRespuestaIronia(database, "Respuesta correcta", 1, id_P1);

    List<RespuestaIronia> respuestas =
        await getRespuestasIronia(id_P1, database);

    RespuestaIronia expectedRespuestaIronia = new RespuestaIronia(
      id: 1,
      texto: "Respuesta incorrecta",
      correcta: 0,
      situacionIroniaId: id_P1,
    );
    expect(respuestas[0], expectedRespuestaIronia);
  });

  test('Test for check deleteRespuestasBySituacionIroniaId', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);
    insertRespuestaIronia(database, "Respuesta correcta", 1, id_P1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);

    deleteRespuestasBySituacionIroniaId(database, 1);

    List<RespuestaIronia> respuestas =
        await getRespuestasIronia(id_P1, database);
    expect(respuestas.length, 0);
  });

  test('Test for check accionesToMap', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta 1', pathIronias + 'vaca.png', 1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);
    insertRespuestaIronia(database, "Respuesta correcta", 1, id_P1);
    insertRespuestaIronia(database, "Respuesta incorrecta", 0, id_P1);

    List<RespuestaIronia> respuestas =
        await getRespuestasIronia(id_P1, database);
    RespuestaIronia expectedRespuestaIronia = new RespuestaIronia(
      id: 1,
      texto: "Respuesta incorrecta",
      correcta: 0,
      situacionIroniaId: id_P1,
    );

    expect(respuestas[0].respuestasToMap(),
        expectedRespuestaIronia.respuestasToMap());
  });
}
