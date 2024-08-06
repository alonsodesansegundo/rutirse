import 'dart:typed_data';

import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/preguntaSentimiento.dart';
import 'package:Rutirse/obj/PreguntaSentimientoPaginacion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

String pathRutinas = 'assets/img/rutinas/';
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

  // Elimino la tabla situacionRutina después de cada prueba
  tearDown(() async {
    await database.delete('preguntaSentimiento');
    await database.close();
  });

  // Test 1
  test('Test for check insert preguntaSentimiento (new) length', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    final List<Map<String, dynamic>> result =
        await database.query('preguntaSentimiento');
    expect(result.length, 1);
  });

  test('Test for check insert preguntaSentimiento (new) id', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    final List<Map<String, dynamic>> preguntasMap =
        await database.query('preguntaSentimiento');
    List<PreguntaSentimiento> preguntas = preguntasMap
        .map((map) => PreguntaSentimiento.sentimientosFromMap(map))
        .toList();
    expect(preguntas[0].id, id_P1);
  });

  test('Test for check insert preguntaSentimiento (new) equals', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);

    final List<Map<String, dynamic>> preguntasMap =
        await database.query('preguntaSentimiento');
    List<PreguntaSentimiento> preguntas = preguntasMap
        .map((map) => PreguntaSentimiento.sentimientosFromMap(map))
        .toList();
    PreguntaSentimiento preguntaSentimientoExpected = new PreguntaSentimiento(
        id: 1,
        enunciado: 'Enunciado pregunta sentimiento 1',
        grupoId: 1,
        fecha: preguntas[0].fecha,
        byTerapeuta: 0,
        imagen: preguntas[0].imagen);
    expect(preguntas[0], preguntaSentimientoExpected);
  });

  test('Test for check insert preguntaSentimiento (new) hashCode', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);

    final List<Map<String, dynamic>> preguntasMap =
        await database.query('preguntaSentimiento');
    List<PreguntaSentimiento> preguntas = preguntasMap
        .map((map) => PreguntaSentimiento.sentimientosFromMap(map))
        .toList();
    PreguntaSentimiento preguntaSentimientoExpected = new PreguntaSentimiento(
        id: 1,
        enunciado: 'Enunciado pregunta sentimiento 1',
        grupoId: 1,
        fecha: preguntas[0].fecha,
        byTerapeuta: 0,
        imagen: preguntas[0].imagen);
    expect(preguntas[0].hashCode, preguntaSentimientoExpected.hashCode);
  });

  test('Test for check insert preguntaSentimiento (new) toString', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);

    final List<Map<String, dynamic>> preguntasMap =
        await database.query('preguntaSentimiento');
    List<PreguntaSentimiento> preguntas = preguntasMap
        .map((map) => PreguntaSentimiento.sentimientosFromMap(map))
        .toList();
    PreguntaSentimiento preguntaSentimientoExpected = new PreguntaSentimiento(
        id: 1,
        enunciado: 'Enunciado pregunta sentimiento 1',
        grupoId: 1,
        fecha: preguntas[0].fecha,
        byTerapeuta: 0,
        imagen: preguntas[0].imagen);
    expect(preguntas[0].toString(), preguntaSentimientoExpected.toString());
  });

  test('Test for check getPreguntasSentimiento empty', () async {
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);
    expect(preguntas.length, 0);
  });

  test('Test for check getPreguntasSentimiento with not existent group',
      () async {
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(-1, database);
    expect(preguntas.length, 0);
  });

  test('Test for check getPreguntasSentimiento with data', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 3', pathPersonaje + 'cerdo.png', 1);

    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);
    expect(preguntas.length, 3);
  });

  test('Test for check getPreguntaSentimientoPaginacion empty', () async {
    List<Grupo> grupos = await getGrupos(database);
    PreguntaSentimientoPaginacion preguntaSentimientoPaginacion =
        await getPreguntaSentimientoPaginacion(1, 3, "", grupos[0], database);
    expect(preguntaSentimientoPaginacion.preguntas.length, 0);
  });

  test(
      'Test for check getPreguntaSentimientoPaginacion with not existent group',
      () async {
    Grupo grupo = new Grupo(id: -1, nombre: "Invented", edades: "Invented");
    PreguntaSentimientoPaginacion preguntaSentimientoPaginacion =
        await getPreguntaSentimientoPaginacion(1, 3, "", grupo, database);
    expect(preguntaSentimientoPaginacion.preguntas.length, 0);
  });

  // Test 7
  test('Test for check getPreguntaSentimientoPaginacion with data', () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    PreguntaSentimientoPaginacion preguntaSentimientoPaginacion =
        await getPreguntaSentimientoPaginacion(1, 3, "", grupos[0], database);
    expect(preguntaSentimientoPaginacion.preguntas.length, 3);
  });

  test(
      'Test for check getPreguntaSentimientoPaginacion with more data than pageSize (bool)',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    PreguntaSentimientoPaginacion preguntaSentimientoPaginacion =
        await getPreguntaSentimientoPaginacion(1, 2, "", grupos[0], database);
    expect(preguntaSentimientoPaginacion.hayMasPreguntas, true);
  });

  test(
      'Test for check getPreguntaSentimientoPaginacion with more data than pageSize (nextPageResults)',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    PreguntaSentimientoPaginacion preguntaSentimientoPaginacion =
        await getPreguntaSentimientoPaginacion(2, 2, "", grupos[0], database);
    expect(preguntaSentimientoPaginacion.preguntas.length, 1);
  });

  test('Test for check getPreguntaSentimientoPaginacion with used txtBuscar',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    PreguntaSentimientoPaginacion preguntaSentimientoPaginacion =
        await getPreguntaSentimientoPaginacion(
            1, 5, "sentimiento 2", grupos[0], database);
    expect(preguntaSentimientoPaginacion.preguntas.length, 1);
  });

  test(
      'Test for check getPreguntaSentimientoPaginacion with used filter of group',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 2', pathPersonaje + 'cerdo.png', 2);
    int id_P3 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    PreguntaSentimientoPaginacion preguntaSentimientoPaginacion =
        await getPreguntaSentimientoPaginacion(1, 5, "", grupos[0], database);
    expect(preguntaSentimientoPaginacion.preguntas.length, 2);
  });

  test(
      'Test for check getPreguntaSentimientoPaginacion with used filter of group and txtBuscar',
      () async {
    int id_P1 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 2', pathPersonaje + 'cerdo.png', 2);
    int id_P3 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 3', pathPersonaje + 'cerdo.png', 1);
    int id_P4 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 3', pathPersonaje + 'cerdo.png', 3);
    int id_P5 = await insertPreguntaSentimientoInitialData(database,
        'Enunciado pregunta sentimiento 2', pathPersonaje + 'cerdo.png', 3);
    List<Grupo> grupos = await getGrupos(database);
    PreguntaSentimientoPaginacion preguntaSentimientoPaginacion =
        await getPreguntaSentimientoPaginacion(
            1, 5, "sentimiento 3", grupos[2], database);
    expect(preguntaSentimientoPaginacion.preguntas.length, 1);
  });

  test(
      'Test for check insertPreguntaSentimiento without imgPersonaje length results',
      () async {
    insertPreguntaSentimiento(database, "Enunciado pregunta", [], 1);
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);
    expect(preguntas.length, 1);
  });

  test(
      'Test for check insertPreguntaSentimiento without imagen type of data result',
      () async {
    insertPreguntaSentimiento(database, "Enunciado pregunta", [], 1);
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);
    expect(preguntas[0].imagen, null);
  });

  test('Test for check insertPreguntaSentimiento without imagen length',
      () async {
    insertPreguntaSentimiento(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);
    expect(preguntas.length, 1);
  });

  test(
      'Test for check insertPreguntaSentimiento without imagen type of data result',
      () async {
    insertPreguntaSentimiento(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);
    expect(preguntas[0].imagen, Uint8List.fromList([111, 123, 321]));
  });

  test(
      'Test for check removePreguntaSentimiento with existent preguntaSentimientoId',
      () async {
    insertPreguntaSentimiento(database, "Enunciado pregunta", [], 1);
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);
    removePreguntaSentimiento(preguntas[0].id!, database);
    preguntas = await getPreguntasSentimiento(1, database);
    expect(preguntas.length, 0);
  });

  test(
      'Test for check updatePregunta with existent situacionRutinaId (imagen null to not null)',
      () async {
    insertPreguntaSentimiento(database, "Enunciado pregunta", [], 1);
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);

    updatePregunta(database, preguntas[0].id!, preguntas[0].enunciado,
        Uint8List.fromList([111, 123, 321]), preguntas[0].grupoId, database);
    preguntas = await getPreguntasSentimiento(1, database);
    expect(preguntas[0].imagen, Uint8List.fromList([111, 123, 321]));
  });

  test(
      'Test for check updatePregunta with existent situacionRutinaId (imagen not null to null)',
      () async {
    insertPreguntaSentimiento(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);

    updatePregunta(database, preguntas[0].id!, preguntas[0].enunciado, [],
        preguntas[0].grupoId, database);
    preguntas = await getPreguntasSentimiento(1, database);
    expect(preguntas[0].imagen, null);
  });

  test('Test for check sentimientosToMap', () async {
    insertPreguntaSentimiento(database, "Enunciado pregunta sentimiento 1",
        Uint8List.fromList([111, 123, 321]), 1);
    List<PreguntaSentimiento> preguntas =
        await getPreguntasSentimiento(1, database);
    PreguntaSentimiento preguntaSentimientoExpected = new PreguntaSentimiento(
        id: 1,
        enunciado: 'Enunciado pregunta sentimiento 1',
        grupoId: 1,
        fecha: preguntas[0].fecha,
        byTerapeuta: 1,
        imagen: preguntas[0].imagen);
    expect(preguntas[0].sentimientosToMap(),
        preguntaSentimientoExpected.sentimientosToMap());
  });
}
