import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/jugador.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  var databaseFactory = databaseFactoryFfi;
  late Database database;

  // Inicializa la base de datos antes de cada prueba
  setUp(() async {
    database = await databaseFactory.openDatabase(inMemoryDatabasePath);
    createTables(database);
    insertGrupos(database);
  });

  // Elimino la tabla jugador después de cada prueba
  tearDown(() async {
    await database.delete('jugador');
    await database.close();
  });

  // Test 1
  test('Test for check insert jugador (new) length', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);

    await insertJugador(jugador, database);

    final List<Map<String, dynamic>> result = await database.query('jugador');
    expect(result.length, 1);
  });

  // Test 2
  test('Test for check insert jugador (existent) length', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    await insertJugador(jugador, database);

    await insertJugador(jugador, database);

    final List<Map<String, dynamic>> result = await database.query('jugador');
    expect(result.length, 1);
  });

  // Test 3
  test('Test for check toString', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    Jugador jugadorExpected =
        new Jugador(id: 1, nombre: 'Jugador 1', grupoId: 1);

    await insertJugador(jugador, database);
    final List<Map<String, dynamic>> jugadoresMap =
        await database.query('jugador');
    List<Jugador> jugadores =
        jugadoresMap.map((map) => Jugador.jugadoresFromMap(map)).toList();
    expect(jugadores[0].toString(), jugadorExpected.toString());
  });

  // Test 4
  test('Test for check equals', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    Jugador jugadorExpected =
        new Jugador(id: 1, nombre: 'Jugador 1', grupoId: 1);

    await insertJugador(jugador, database);
    final List<Map<String, dynamic>> jugadoresMap =
        await database.query('jugador');
    List<Jugador> jugadores =
        jugadoresMap.map((map) => Jugador.jugadoresFromMap(map)).toList();
    expect(jugadores[0], jugadorExpected);
  });

  // Test 5
  test('Test for check hashCode', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    Jugador jugadorExpected =
        new Jugador(id: 1, nombre: 'Jugador 1', grupoId: 1);

    await insertJugador(jugador, database);
    final List<Map<String, dynamic>> jugadoresMap =
        await database.query('jugador');
    List<Jugador> jugadores =
        jugadoresMap.map((map) => Jugador.jugadoresFromMap(map)).toList();
    expect(jugadores[0].hashCode, jugadorExpected.hashCode);
  });

  // Test 6
  test('Test for check exiteJugador (true)', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    await insertJugador(jugador, database);

    bool result = await existeJugador(jugador, database);

    expect(result, true);
  });

  // Test 7
  test('Test for check exiteJugador (false)', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);

    bool result = await existeJugador(jugador, database);

    expect(result, false);
  });

  // Test 8
  test('Test for check deletePlayer (existent)', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    jugador = await insertJugador(jugador, database);

    await deletePlayer(jugador.id!, database);

    final List<Map<String, dynamic>> result = await database.query('jugador');
    expect(result.length, 0);
  });

  // Test 9
  test('Test for check deletePlayer (not existent)', () async {
    expect(deletePlayer(-1, database), throwsA(isA<Exception>()));
  });
}
