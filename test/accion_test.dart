import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/accion.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/situacionRutina.dart';
import 'package:flutter/services.dart';
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
    await database.delete('situacionRutina');
    await database.close();
  });

  // Test 1
  test('Test for check insertAccionInitialData (new) length', () async {
    int id_P1 = await insertSituacionRutinaInitialData(
        database, 'Enunciado rutina 1.', pathPersonaje + 'cerdo.png', 1);
    insertAccionInitialData(database, "Accion 0", 0,
        pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 1", 1,
        pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 2", 2,
        pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);

    final List<Map<String, dynamic>> result = await database.query('accion');
    expect(result.length, 3);
  });

  test('Test for check insertAccionInitialData (new) toString', () async {
    int id_P1 = await insertSituacionRutinaInitialData(
        database, 'Enunciado rutina 1.', pathPersonaje + 'cerdo.png', 1);
    insertAccionInitialData(database, "Accion 0", 0,
        pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 1", 1,
        pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 2", 2,
        pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);

    ByteData imageData = await rootBundle
        .load(pathRutinas + "higiene/lavarDientes/2.LavarDientes.png");
    List<int> bytes = imageData.buffer.asUint8List();

    Accion expectedAccion = new Accion(
        id: 1,
        texto: "Accion 0",
        orden: 0,
        situacionRutinaId: id_P1,
        imagen: Uint8List.fromList(bytes));

    final List<Map<String, dynamic>> accionesMap =
        await database.query('accion');
    List<Accion> acciones =
        accionesMap.map((map) => Accion.accionesFromMap(map)).toList();
    expect(acciones[0].toString(), expectedAccion.toString());
  });

  test('Test for check insertAccionInitialData (new) hashCode', () async {
    int id_P1 = await insertSituacionRutinaInitialData(
        database, 'Enunciado rutina 1.', pathPersonaje + 'cerdo.png', 1);
    insertAccionInitialData(database, "Accion 0", 0,
        pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 1", 1,
        pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 2", 2,
        pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);

    ByteData imageData = await rootBundle
        .load(pathRutinas + "higiene/lavarDientes/2.LavarDientes.png");
    List<int> bytes = imageData.buffer.asUint8List();

    Accion expectedAccion = new Accion(
        id: 1,
        texto: "Accion 0",
        orden: 0,
        situacionRutinaId: id_P1,
        imagen: Uint8List.fromList(bytes));

    final List<Map<String, dynamic>> accionesMap =
        await database.query('accion');
    List<Accion> acciones =
        accionesMap.map((map) => Accion.accionesFromMap(map)).toList();
    expect(acciones[0].hashCode, expectedAccion.hashCode);
  });

  test('Test for check insertAccionInitialData (new) equals', () async {
    int id_P1 = await insertSituacionRutinaInitialData(
        database, 'Enunciado rutina 1.', pathPersonaje + 'cerdo.png', 1);
    insertAccionInitialData(database, "Accion 0", 0,
        pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 1", 1,
        pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 2", 2,
        pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);

    ByteData imageData = await rootBundle
        .load(pathRutinas + "higiene/lavarDientes/2.LavarDientes.png");
    List<int> bytes = imageData.buffer.asUint8List();

    Accion expectedAccion = new Accion(
        id: 1,
        texto: "Accion 0",
        orden: 0,
        situacionRutinaId: id_P1,
        imagen: Uint8List.fromList(bytes));

    final List<Map<String, dynamic>> accionesMap =
        await database.query('accion');
    List<Accion> acciones =
        accionesMap.map((map) => Accion.accionesFromMap(map)).toList();
    expect(acciones[0], expectedAccion);
  });

  test('Test for check insertAccion (new) equals', () async {
    int id_P1 = await insertSituacionRutina(database, 'Enunciado rutina 1.',
        Uint8List.fromList([000, 000, 000]), 1);
    insertAccion(
        database, "Accion 0", 0, Uint8List.fromList([111, 111, 111]), id_P1);
    insertAccion(
        database, "Accion 1", 1, Uint8List.fromList([222, 222, 222]), id_P1);
    insertAccion(
        database, "Accion 2", 2, Uint8List.fromList([333, 333, 333]), id_P1);

    Accion expectedAccion = new Accion(
        id: 1,
        texto: "Accion 0",
        orden: 0,
        situacionRutinaId: id_P1,
        imagen: Uint8List.fromList(Uint8List.fromList([111, 111, 111])));

    final List<Map<String, dynamic>> accionesMap =
        await database.query('accion');
    List<Accion> acciones =
        accionesMap.map((map) => Accion.accionesFromMap(map)).toList();
    expect(acciones[0], expectedAccion);
  });

  test('Test for check getAcciones empty (with existent situacionRutina)',
      () async {
    int id_P1 = await insertSituacionRutinaInitialData(
        database, 'Enunciado rutina 1.', pathPersonaje + 'cerdo.png', 1);
    List<Accion> acciones = await getAcciones(id_P1, database);
    expect(acciones.length, 0);
  });

  test('Test for check getAcciones empty (without existent situacionRutina)',
      () async {
    List<Accion> acciones = await getAcciones(-1, database);
    expect(acciones.length, 0);
  });

  test('Test for check getAcciones (length)', () async {
    int id_P1 = await insertSituacionRutinaInitialData(
        database, 'Enunciado rutina 1.', pathPersonaje + 'cerdo.png', 1);
    insertAccionInitialData(database, "Accion 0", 0,
        pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 1", 1,
        pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 2", 2,
        pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);

    List<Accion> acciones = await getAcciones(id_P1, database);

    expect(acciones.length, 3);
  });

  test('Test for check getAcciones (obj)', () async {
    int id_P1 = await insertSituacionRutinaInitialData(
        database, 'Enunciado rutina 1.', pathPersonaje + 'cerdo.png', 1);
    insertAccionInitialData(database, "Accion 0", 0,
        pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 1", 1,
        pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 2", 2,
        pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);

    List<Accion> acciones = await getAcciones(id_P1, database);

    ByteData imageData = await rootBundle
        .load(pathRutinas + "higiene/lavarDientes/3.LavarDientes.png");
    List<int> bytes = imageData.buffer.asUint8List();
    Accion expectedAccion = new Accion(
        id: 2,
        texto: "Accion 1",
        orden: 1,
        situacionRutinaId: id_P1,
        imagen: Uint8List.fromList(bytes));
    expect(acciones[1], expectedAccion);
  });

  test('Test for check deleteAccion', () async {
    int id_P1 = await insertSituacionRutinaInitialData(
        database, 'Enunciado rutina 1.', pathPersonaje + 'cerdo.png', 1);
    insertAccionInitialData(database, "Accion 0", 0,
        pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 1", 1,
        pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
    insertAccionInitialData(database, "Accion 2", 2,
        pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);

    deleteAccion(database, 1);

    List<Accion> acciones = await getAcciones(id_P1, database);
    expect(acciones.length, 2);
  });

  test('Test for check accionesToMap', () async {
    int id_P1 = await insertSituacionRutina(database, 'Enunciado rutina 1.',
        Uint8List.fromList([111, 123, 321]), 1);
    insertAccion(
        database, "Accion 0", 0, Uint8List.fromList([111, 111, 111]), id_P1);
    insertAccion(
        database, "Accion 1", 1, Uint8List.fromList([222, 222, 222]), id_P1);
    insertAccion(
        database, "Accion 2", 2, Uint8List.fromList([333, 333, 333]), id_P1);

    List<Accion> acciones = await getAcciones(id_P1, database);
    Accion accionExpected = new Accion(
        id: 2,
        texto: "Accion 1",
        orden: 1,
        situacionRutinaId: id_P1,
        imagen: Uint8List.fromList([222, 222, 222]));

    expect(acciones[1].accionesToMap(), accionExpected.accionesToMap());
  });
}
