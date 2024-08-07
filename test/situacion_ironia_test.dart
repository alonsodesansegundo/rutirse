import 'dart:typed_data';

import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/situacionIronia.dart';
import 'package:Rutirse/obj/SituacionIroniaPaginacion.dart';
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
  test('Test for check insert situacionIronia (new) length', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    final List<Map<String, dynamic>> result =
        await database.query('situacionIronia');
    expect(result.length, 1);
  });

  test('Test for check insert situacionIronia (new) id', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    final List<Map<String, dynamic>> situacionesMap =
        await database.query('situacionIronia');
    List<SituacionIronia> situaciones = situacionesMap
        .map((map) => SituacionIronia.situacionesFromMap(map))
        .toList();
    expect(situaciones[0].id, 1);
  });

  // Test 2
  test('Test for check insert situacionIronia (new) equals', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);

    final List<Map<String, dynamic>> situacionesMap =
        await database.query('situacionIronia');
    List<SituacionIronia> situaciones = situacionesMap
        .map((map) => SituacionIronia.situacionesFromMap(map))
        .toList();
    SituacionIronia situacionIroniaExpected = new SituacionIronia(
        id: 1,
        enunciado: 'Enunciado pregunta humor 1',
        grupoId: 1,
        fecha: situaciones[0].fecha,
        byTerapeuta: 0,
        imagen: situaciones[0].imagen);
    expect(situaciones[0], situacionIroniaExpected);
  });

  test('Test for check insert situacionIronia (new) hashCode', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);

    final List<Map<String, dynamic>> situacionesMap =
        await database.query('situacionIronia');
    List<SituacionIronia> situaciones = situacionesMap
        .map((map) => SituacionIronia.situacionesFromMap(map))
        .toList();
    SituacionIronia situacionIroniaExpected = new SituacionIronia(
        id: 1,
        enunciado: 'Enunciado pregunta humor 1',
        grupoId: 1,
        fecha: situaciones[0].fecha,
        byTerapeuta: 0,
        imagen: situaciones[0].imagen);
    expect(situaciones[0].hashCode, situacionIroniaExpected.hashCode);
  });

  test('Test for check insert situacionIronia (new) toString', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);

    final List<Map<String, dynamic>> situacionesMap =
        await database.query('situacionIronia');
    List<SituacionIronia> situaciones = situacionesMap
        .map((map) => SituacionIronia.situacionesFromMap(map))
        .toList();
    SituacionIronia situacionIroniaExpected = new SituacionIronia(
        id: 1,
        enunciado: 'Enunciado pregunta humor 1',
        grupoId: 1,
        fecha: situaciones[0].fecha,
        byTerapeuta: 0,
        imagen: situaciones[0].imagen);
    expect(situaciones[0].toString(), situacionIroniaExpected.toString());
  });

  test('Test for check getSituacionesIronias empty', () async {
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);
    expect(situaciones.length, 0);
  });

  test('Test for check getSituacionesIronias with not existent group',
      () async {
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(-1, database);
    expect(situaciones.length, 0);
  });

  // Test 7
  test('Test for check getSituacionesIronias with data', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    int id_P2 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 2', pathIronias + 'vaca.png', 1);
    int id_P3 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 3', pathIronias + 'vaca.png', 1);
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);
    expect(situaciones.length, 3);
  });

  // Test 5
  test('Test for check getSituacionIroniaPaginacion empty', () async {
    List<Grupo> grupos = await getGrupos(database);
    SituacionIroniaPaginacion situacionesPaginacion =
        await getSituacionIroniaPaginacion(1, 3, "", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 0);
  });

  test('Test for check getSituaciones with data', () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    int id_P2 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 2', pathIronias + 'vaca.png', 1);
    int id_P3 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 3', pathIronias + 'vaca.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionIroniaPaginacion situacionesPaginacion =
        await getSituacionIroniaPaginacion(1, 3, "", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 3);
  });

  test(
      'Test for check getSituacionIroniaPaginacion with more data than pageSize (bool)',
      () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    int id_P2 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 2', pathIronias + 'vaca.png', 1);
    int id_P3 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 3', pathIronias + 'vaca.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionIroniaPaginacion situacionesPaginacion =
        await getSituacionIroniaPaginacion(1, 2, "", grupos[0], database);
    expect(situacionesPaginacion.hayMasSituaciones, true);
  });

  test(
      'Test for check getSituacionIroniaPaginacion with more data than pageSize (nextPageResults)',
      () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    int id_P2 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 2', pathIronias + 'vaca.png', 1);
    int id_P3 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 3', pathIronias + 'vaca.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionIroniaPaginacion situacionesPaginacion =
        await getSituacionIroniaPaginacion(2, 2, "", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 1);
  });

  test('Test for check getSituacionIroniaPaginacion with used txtBuscar',
      () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    int id_P2 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 2', pathIronias + 'vaca.png', 1);
    int id_P3 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 3', pathIronias + 'vaca.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionIroniaPaginacion situacionesPaginacion =
        await getSituacionIroniaPaginacion(
            1, 5, "humor 2", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 1);
  });

  test('Test for check getSituacionIroniaPaginacion with used filter of group',
      () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    int id_P2 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 2', pathIronias + 'vaca.png', 2);
    int id_P3 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 3', pathIronias + 'vaca.png', 1);
    List<Grupo> grupos = await getGrupos(database);
    SituacionIroniaPaginacion situacionesPaginacion =
        await getSituacionIroniaPaginacion(1, 5, "", grupos[0], database);
    expect(situacionesPaginacion.situaciones.length, 2);
  });

  test(
      'Test for check getSituacionIroniaPaginacion with used filter of group and txtBuscar',
      () async {
    int id_P1 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 1', pathIronias + 'vaca.png', 1);
    int id_P2 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 2', pathIronias + 'vaca.png', 2);
    int id_P3 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 3', pathIronias + 'vaca.png', 1);
    int id_P4 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 3', pathIronias + 'vaca.png', 3);
    int id_P5 = await insertSituacionIroniaInitialData(
        database, 'Enunciado pregunta humor 2', pathIronias + 'vaca.png', 3);
    List<Grupo> grupos = await getGrupos(database);
    SituacionIroniaPaginacion situacionesPaginacion =
        await getSituacionIroniaPaginacion(
            1, 5, "humor 3", grupos[2], database);
    expect(situacionesPaginacion.situaciones.length, 1);
  });

  test('Test for check insertSituacionIronia without imagen length results',
      () async {
    insertSituacionIronia(database, "Enunciado pregunta", [], 1);
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);
    expect(situaciones.length, 1);
  });

  test(
      'Test for check insertSituacionIronia without imagen type of data result',
      () async {
    insertSituacionIronia(database, "Enunciado pregunta", [], 1);
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);
    expect(situaciones[0].imagen, null);
  });

  test('Test for check insertSituacionIronia without imgPersonaje length',
      () async {
    insertSituacionIronia(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);
    expect(situaciones.length, 1);
  });

  test(
      'Test for check insertSituacionIronia without imgPersonaje type of data result',
      () async {
    insertSituacionIronia(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);
    expect(situaciones[0].imagen, Uint8List.fromList([111, 123, 321]));
  });

  test('Test for check removePreguntaIronia with existent situacionRutinaId',
      () async {
    insertSituacionIronia(database, "Enunciado pregunta", [], 1);
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);
    expect(situaciones.length, 1);
    removePreguntaIronia(situaciones[0].id!, database);
    situaciones = await getSituacionesIronias(1, database);
    expect(situaciones.length, 0);
  });

  test('Test for check situacionesToMap', () async {
    insertSituacionIronia(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);
    SituacionIronia situacionRutinaExpected = new SituacionIronia(
        id: 1,
        enunciado: "Enunciado pregunta",
        grupoId: 1,
        fecha: situaciones[0].fecha,
        byTerapeuta: 1,
        imagen: Uint8List.fromList([111, 123, 321]));
    expect(situaciones[0].situacionesToMap(),
        situacionRutinaExpected.situacionesToMap());
  });

  test(
      'Test for check updatePreguntaIronia with existent situacionIroniaId (update image)',
      () async {
    insertSituacionIronia(
        database, "Enunciado pregunta", Uint8List.fromList([111, 123, 321]), 1);
    List<SituacionIronia> situaciones =
        await getSituacionesIronias(1, database);

    updatePreguntaIronia(database, situaciones[0].id!, situaciones[0].enunciado,
        Uint8List.fromList([321, 321, 321]), situaciones[0].grupoId);
    situaciones = await getSituacionesIronias(1, database);
    expect(situaciones[0].imagen, Uint8List.fromList([321, 321, 321]));
  });
}
