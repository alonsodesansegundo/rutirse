import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/preguntaSentimiento.dart';
import 'package:Rutirse/db/obj/situacion.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

String pathSentimientos = 'assets/img/sentimientos/';
String pathPersonaje = 'assets/img/personajes/';

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

  // Elimino la tabla preguntaSentimiento después de cada prueba
  tearDown(() async {
    await database.delete('preguntaSentimiento');
    await database.close();
  });

  // Test 1
  test('Test for check insertPreguntaSentimientoInitialData (new) length',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado sentimiento 1.', pathPersonaje + 'corredor.png', 1);
    insertSituacionInitialData(
        database, "Situacion 0", 0, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 1", 1, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 2", 0, pathSentimientos + "ganar.png", id_P1);

    final List<Map<String, dynamic>> result = await database.query('situacion');
    expect(result.length, 3);
  });

  test('Test for check insertPreguntaSentimientoInitialData (new) toString',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado sentimiento 1.', pathPersonaje + 'corredor.png', 1);
    insertSituacionInitialData(
        database, "Situacion 0", 0, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 1", 1, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 2", 0, pathSentimientos + "ganar.png", id_P1);

    ByteData imageData = await rootBundle.load(pathSentimientos + "ganar.png");
    List<int> bytes = imageData.buffer.asUint8List();

    Situacion expectedAccion = new Situacion(
        id: 1,
        texto: "Situacion 0",
        preguntaSentimientoId: id_P1,
        imagen: Uint8List.fromList(bytes),
        correcta: 0);

    final List<Map<String, dynamic>> result = await database.query('situacion');
    List<Situacion> situaciones =
        result.map((map) => Situacion.situacionesFromMap(map)).toList();
    expect(situaciones[0].toString(), expectedAccion.toString());
  });

  test('Test for check insertPreguntaSentimientoInitialData (new) hashCode',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado sentimiento 1.', pathPersonaje + 'corredor.png', 1);
    insertSituacionInitialData(
        database, "Situacion 0", 0, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 1", 1, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 2", 0, pathSentimientos + "ganar.png", id_P1);

    ByteData imageData = await rootBundle.load(pathSentimientos + "ganar.png");
    List<int> bytes = imageData.buffer.asUint8List();

    Situacion expectedAccion = new Situacion(
        id: 1,
        texto: "Situacion 0",
        preguntaSentimientoId: id_P1,
        imagen: Uint8List.fromList(bytes),
        correcta: 0);

    final List<Map<String, dynamic>> result = await database.query('situacion');
    List<Situacion> situaciones =
        result.map((map) => Situacion.situacionesFromMap(map)).toList();
    expect(situaciones[0].hashCode, expectedAccion.hashCode);
  });

  test('Test for check insertPreguntaSentimientoInitialData (new) equals',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado sentimiento 1.', pathPersonaje + 'corredor.png', 1);
    insertSituacionInitialData(
        database, "Situacion 0", 0, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 1", 1, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 2", 0, pathSentimientos + "ganar.png", id_P1);

    ByteData imageData = await rootBundle.load(pathSentimientos + "ganar.png");
    List<int> bytes = imageData.buffer.asUint8List();

    Situacion expectedAccion = new Situacion(
        id: 1,
        texto: "Situacion 0",
        preguntaSentimientoId: id_P1,
        imagen: Uint8List.fromList(bytes),
        correcta: 0);

    final List<Map<String, dynamic>> result = await database.query('situacion');
    List<Situacion> situaciones =
        result.map((map) => Situacion.situacionesFromMap(map)).toList();
    expect(situaciones[0], expectedAccion);
  });

  test(
      'Test for check getSituaciones empty (with existent preguntaSentimiento)',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado sentimiento 1.', pathPersonaje + 'corredor.png', 1);
    List<Situacion> situaciones = await getSituaciones(id_P1, database);
    expect(situaciones.length, 0);
  });

  test(
      'Test for check getSituaciones empty (without existent preguntaSentimiento)',
      () async {
    List<Situacion> situaciones = await getSituaciones(-1, database);
    expect(situaciones.length, 0);
  });

  test('Test for check getSituaciones (length)', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado sentimiento 1.', pathPersonaje + 'corredor.png', 1);
    insertSituacionInitialData(
        database, "Situacion 0", 0, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 1", 1, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 2", 0, pathSentimientos + "ganar.png", id_P1);

    List<Situacion> situaciones = await getSituaciones(id_P1, database);

    expect(situaciones.length, 3);
  });

  test('Test for check getSituaciones (obj)', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado sentimiento 1.', pathPersonaje + 'corredor.png', 1);
    insertSituacionInitialData(
        database, "Situacion 0", 0, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 1", 1, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 2", 0, pathSentimientos + "ganar.png", id_P1);

    List<Situacion> situaciones = await getSituaciones(id_P1, database);

    ByteData imageData = await rootBundle.load(pathSentimientos + "ganar.png");
    List<int> bytes = imageData.buffer.asUint8List();
    Situacion expectedSituacion = new Situacion(
        id: 2,
        texto: "Situacion 1",
        imagen: Uint8List.fromList(bytes),
        correcta: 1,
        preguntaSentimientoId: id_P1);
    expect(situaciones[1], expectedSituacion);
  });

  test('Test for check deleteSituacion', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado sentimiento 1.', pathPersonaje + 'corredor.png', 1);
    insertSituacionInitialData(
        database, "Situacion 0", 0, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 1", 1, pathSentimientos + "ganar.png", id_P1);
    insertSituacionInitialData(
        database, "Situacion 2", 0, pathSentimientos + "ganar.png", id_P1);

    deleteSituacion(database, 1);

    List<Situacion> situaciones = await getSituaciones(id_P1, database);
    expect(situaciones.length, 2);
  });

  test('Test for check situacionesToMap', () async {
    int id_P1 = await insertPreguntaSentimiento(database,
        'Enunciado sentimiento 1.', Uint8List.fromList([111, 123, 321]), 1);
    insertSituacion(
        database, "Situacion 0", 0, Uint8List.fromList([111, 111, 111]), id_P1);
    insertSituacion(
        database, "Situacion 1", 1, Uint8List.fromList([222, 222, 222]), id_P1);
    insertSituacion(
        database, "Situacion 2", 0, Uint8List.fromList([333, 333, 333]), id_P1);

    List<Situacion> situaciones = await getSituaciones(id_P1, database);
    Situacion expectedSituacion = new Situacion(
        id: 2,
        texto: "Situacion 1",
        imagen: Uint8List.fromList([222, 222, 222]),
        correcta: 1,
        preguntaSentimientoId: id_P1);

    expect(situaciones[1].situacionesToMap(),
        expectedSituacion.situacionesToMap());
  });
}
