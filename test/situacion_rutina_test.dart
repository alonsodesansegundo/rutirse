import 'dart:typed_data';

import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/situacionRutina.dart';
import 'package:Rutirse/obj/SituacionRutinaPaginacion.dart';
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

  // Elimino la tabla grupo después de cada prueba
  tearDown(() async {
    await database.delete('situacionRutina');
    await database.close();
  });

  // Test 1
  test('Test for check insert situacionRutina (new) length', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    final List<Map<String, dynamic>> result =
        await database.query('situacionRutina');
    expect(result.length, 1);
  });

  // Test 2
  test('Test for check insert situacionRutina (new) id', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    final List<Map<String, dynamic>> situacionesMap =
        await database.query('situacionRutina');
    List<SituacionRutina> situaciones = situacionesMap
        .map((map) => SituacionRutina.situacionesFromMap(map))
        .toList();
    expect(situaciones[0].id, 1);
  });

  // Test 2
  test('Test for check insert situacionRutina (new) equals', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);

    final List<Map<String, dynamic>> situacionesMap =
        await database.query('situacionRutina');
    List<SituacionRutina> situaciones = situacionesMap
        .map((map) => SituacionRutina.situacionesFromMap(map))
        .toList();
    SituacionRutina situacionRutinaExpected = new SituacionRutina(
        id: 1,
        enunciado: 'Enunciado pregunta rutinas 1',
        grupoId: 1,
        fecha: situaciones[0].fecha,
        byTerapeuta: 0,
        personajeImg: situaciones[0].personajeImg);
    expect(situaciones[0], situacionRutinaExpected);
  });

  // Test 3
  test('Test for check insert situacionRutina (new) hashCode', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);

    final List<Map<String, dynamic>> situacionesMap =
        await database.query('situacionRutina');
    List<SituacionRutina> situaciones = situacionesMap
        .map((map) => SituacionRutina.situacionesFromMap(map))
        .toList();
    SituacionRutina situacionRutinaExpected = new SituacionRutina(
        id: 1,
        enunciado: 'Enunciado pregunta rutinas 1',
        grupoId: 1,
        fecha: situaciones[0].fecha,
        byTerapeuta: 0,
        personajeImg: situaciones[0].personajeImg);
    expect(situaciones[0].hashCode, situacionRutinaExpected.hashCode);
  });

  // Test 4
  test('Test for check insert situacionRutina (new) toString', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);

    final List<Map<String, dynamic>> situacionesMap =
        await database.query('situacionRutina');
    List<SituacionRutina> situaciones = situacionesMap
        .map((map) => SituacionRutina.situacionesFromMap(map))
        .toList();
    SituacionRutina situacionRutinaExpected = new SituacionRutina(
        id: 1,
        enunciado: 'Enunciado pregunta rutinas 1',
        grupoId: 1,
        fecha: situaciones[0].fecha,
        byTerapeuta: 0,
        personajeImg: situaciones[0].personajeImg);
    expect(situaciones[0].toString(), situacionRutinaExpected.toString());
  });

  // Test 5
  test('Test for check getSituaciones empty', () async {
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);
    expect(situaciones.length, 0);
  });

  // Test 6
  test('Test for check getSituaciones with not existent group', () async {
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(-1, database);
    expect(situaciones.length, 0);
  });

  // Test 7
  test('Test for check getSituaciones with data', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 3', pathPersonaje + 'cerdo.png', 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);
    expect(situaciones.length, 3);
  });

  // Test 5
  test('Test for check getSituacionesPafinacion empty', () async {
    List<Grupo> grupos = await getGrupos(database);
    SituacionRutinaPaginacion situacionesPaginacion =
        await getSituacionRutinaPaginacion(1, 3, "", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 0);
  });

  test('Test for check getSituacionesPafinacion with not existent group',
      () async {
    Grupo grupo = new Grupo(id: -1, nombre: "Invented", edades: "Invented");
    SituacionRutinaPaginacion situacionesPaginacion =
        await getSituacionRutinaPaginacion(1, 3, "", grupo, database);
    expect(situacionesPaginacion.situaciones.length, 0);
  });

  // Test 7
  test('Test for check getSituaciones with data', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionRutinaPaginacion situacionesPaginacion =
        await getSituacionRutinaPaginacion(1, 3, "", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 3);
  });

  test('Test for check getSituaciones with more data than pageSize (bool)',
      () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionRutinaPaginacion situacionesPaginacion =
        await getSituacionRutinaPaginacion(1, 2, "", grupos[0], database);
    expect(situacionesPaginacion.hayMasSituaciones, true);
  });

  test(
      'Test for check getSituaciones with more data than pageSize (nextPageResults)',
      () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionRutinaPaginacion situacionesPaginacion =
        await getSituacionRutinaPaginacion(2, 2, "", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 1);
  });

  test('Test for check getSituaciones with used txtBuscar', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 2', pathPersonaje + 'cerdo.png', 1);
    int id_P3 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionRutinaPaginacion situacionesPaginacion =
        await getSituacionRutinaPaginacion(
            1, 5, "rutinas 2", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 1);
  });

  test('Test for check getSituaciones with used filter of group', () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 2', pathPersonaje + 'cerdo.png', 2);
    int id_P3 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 3', pathPersonaje + 'cerdo.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionRutinaPaginacion situacionesPaginacion =
        await getSituacionRutinaPaginacion(1, 5, "", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 2);
  });

  test('Test for check getSituaciones with used filter of group and txtBuscar',
      () async {
    int id_P1 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 1', pathPersonaje + 'cerdo.png', 1);
    int id_P2 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 2', pathPersonaje + 'cerdo.png', 2);
    int id_P3 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 3', pathPersonaje + 'cerdo.png', 1);
    int id_P4 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 3', pathPersonaje + 'cerdo.png', 3);
    int id_P5 = await insertSituacionRutinaInitialData(database,
        'Enunciado pregunta rutinas 2', pathPersonaje + 'cerdo.png', 3);
    List<Grupo> grupos = await getGrupos(database);
    SituacionRutinaPaginacion situacionesPaginacion =
        await getSituacionRutinaPaginacion(
            1, 5, "rutinas 3", grupos[2], database);
    expect(situacionesPaginacion.situaciones.length, 1);
  });

  test(
      'Test for check insertSituacionRutina without imgPersonaje length results',
      () async {
    insertSituacionRutina(database, "Enunciado pregunta", [], 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);
    expect(situaciones.length, 1);
  });

  test(
      'Test for check insertSituacionRutina without imgPersonaje type of data result',
      () async {
    insertSituacionRutina(database, "Enunciado pregunta", [], 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);
    expect(situaciones[0].personajeImg, null);
  });

  test('Test for check insertSituacionRutina without imgPersonaje length',
      () async {
    insertSituacionRutina(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);
    expect(situaciones.length, 1);
  });

  test(
      'Test for check insertSituacionRutina without imgPersonaje type of data result',
      () async {
    insertSituacionRutina(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);
    expect(situaciones[0].personajeImg, Uint8List.fromList([111, 123, 321]));
  });

  test('Test for check removeSituacionRutina with existent situacionRutinaId',
      () async {
    insertSituacionRutina(database, "Enunciado pregunta", [], 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);
    expect(situaciones.length, 1);
    removePreguntaRutinas(situaciones[0].id!, database);
    situaciones = await getSituacionesRutinas(1, database);
    expect(situaciones.length, 0);
  });

  test(
      'Test for check updateSituacionRutina with existent situacionRutinaId (personajeImg null to not null)',
      () async {
    insertSituacionRutina(database, "Enunciado pregunta", [], 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);

    updatePregunta(database, situaciones[0].id!, situaciones[0].enunciado,
        Uint8List.fromList([111, 123, 321]), situaciones[0].grupoId);
    situaciones = await getSituacionesRutinas(1, database);
    expect(situaciones[0].personajeImg, Uint8List.fromList([111, 123, 321]));
  });

  test(
      'Test for check updateSituacionRutina with existent situacionRutinaId (personajeImg not null to null)',
      () async {
    insertSituacionRutina(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);

    updatePregunta(database, situaciones[0].id!, situaciones[0].enunciado, [],
        situaciones[0].grupoId);
    situaciones = await getSituacionesRutinas(1, database);
    expect(situaciones[0].personajeImg, null);
  });

  // Test 1
  test('Test for check situacionesToMap', () async {
    insertSituacionRutina(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<SituacionRutina> situaciones =
        await getSituacionesRutinas(1, database);
    SituacionRutina situacionRutinaExpected = new SituacionRutina(
        id: 1,
        enunciado: "Enunciado pregunta",
        grupoId: 1,
        fecha: situaciones[0].fecha,
        byTerapeuta: 1,
        personajeImg: Uint8List.fromList([111, 123, 321]));
    expect(situaciones[0].situacionesToMap(),
        situacionRutinaExpected.situacionesToMap());
  });
}
