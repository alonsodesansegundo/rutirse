import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/jugador.dart';
import 'package:Rutirse/db/obj/partidaSentimientos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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

  // Elimino la tabla partida después de cada prueba
  tearDown(() async {
    await database.delete('partida');
    await database.close();
  });

  // Test 1
  test('Test for check insertPartidaSentimientos (length)', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);

    jugador = await insertJugador(jugador, database);

    PartidaSentimientos partida = new PartidaSentimientos(
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 12,
        aciertos: 11,
        fallos: 11,
        jugadorId: jugador.id!);

    await insertPartidaSentimientos(partida, database);

    final List<Map<String, dynamic>> result =
        await database.query('partidaSentimientos');

    expect(result.length, 1);
  });

  test('Test for check insertPartidaSentimientos (toString)', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);

    jugador = await insertJugador(jugador, database);

    PartidaSentimientos partida = new PartidaSentimientos(
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 0,
        jugadorId: jugador.id!);

    int partidaId = await insertPartidaSentimientos(partida, database);

    PartidaSentimientos partidaExpected = new PartidaSentimientos(
        id: partidaId,
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 0,
        jugadorId: jugador.id!);

    final List<Map<String, dynamic>> partidasMap =
        await database.query('partida');
    List<PartidaSentimientos> partidas = partidasMap
        .map((map) => PartidaSentimientos.partidasFromMap(map))
        .toList();
    expect(partidas[0].toString(), partidaExpected.toString());
  });

  test('Test for check insertPartidaSentimientos (toString)', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);

    jugador = await insertJugador(jugador, database);

    PartidaSentimientos partida = new PartidaSentimientos(
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 0,
        jugadorId: jugador.id!);

    int partidaId = await insertPartidaSentimientos(partida, database);

    PartidaSentimientos partidaExpected = new PartidaSentimientos(
        id: partidaId,
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 0,
        jugadorId: jugador.id!);

    final List<Map<String, dynamic>> partidasMap =
        await database.query('partida');
    List<PartidaSentimientos> partidas = partidasMap
        .map((map) => PartidaSentimientos.partidasFromMap(map))
        .toList();
    expect(partidas[0].toString(), partidaExpected.toString());
  });

  test('Test for check getPartidasSentimientosByUserId (length)', () async {
    Jugador jugador1 = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    Jugador jugador2 = new Jugador(nombre: 'Jugador 2', grupoId: 3);

    jugador1 = await insertJugador(jugador1, database);
    jugador2 = await insertJugador(jugador2, database);

    PartidaSentimientos partida1 = new PartidaSentimientos(
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 5,
        jugadorId: jugador1.id!);

    PartidaSentimientos partida2 = new PartidaSentimientos(
        fechaFin: "09/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 5,
        fallos: 2,
        jugadorId: jugador2.id!);

    PartidaSentimientos partida3 = new PartidaSentimientos(
        fechaFin: "10/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 0,
        jugadorId: jugador1.id!);

    int partidaId_1 = await insertPartidaSentimientos(partida1, database);
    int partidaId_2 = await insertPartidaSentimientos(partida2, database);
    int partidaId_3 = await insertPartidaSentimientos(partida3, database);

    List<PartidaSentimientos> partidas =
        await getPartidasSentimientosByUserId(jugador1.id!, database);

    expect(partidas.length, 2);
  });

  test('Test for check getPartidasSentimientosByUserId (id partida 0)',
      () async {
    Jugador jugador1 = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    Jugador jugador2 = new Jugador(nombre: 'Jugador 2', grupoId: 3);

    jugador1 = await insertJugador(jugador1, database);
    jugador2 = await insertJugador(jugador2, database);

    PartidaSentimientos partida1 = new PartidaSentimientos(
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 5,
        jugadorId: jugador1.id!);

    PartidaSentimientos partida2 = new PartidaSentimientos(
        fechaFin: "09/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 5,
        fallos: 2,
        jugadorId: jugador2.id!);

    PartidaSentimientos partida3 = new PartidaSentimientos(
        fechaFin: "10/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 0,
        jugadorId: jugador1.id!);

    int partidaId_1 = await insertPartidaSentimientos(partida1, database);
    int partidaId_2 = await insertPartidaSentimientos(partida2, database);
    int partidaId_3 = await insertPartidaSentimientos(partida3, database);

    List<PartidaSentimientos> partidas =
        await getPartidasSentimientosByUserId(jugador1.id!, database);

    expect(partidas[0].id, partidaId_3);
  });

  test('Test for check getPartidasSentimientosByUserId (id partida 0)',
      () async {
    Jugador jugador1 = new Jugador(nombre: 'Jugador 1', grupoId: 1);
    Jugador jugador2 = new Jugador(nombre: 'Jugador 2', grupoId: 3);

    jugador1 = await insertJugador(jugador1, database);
    jugador2 = await insertJugador(jugador2, database);

    PartidaSentimientos partida1 = new PartidaSentimientos(
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 5,
        jugadorId: jugador1.id!);

    PartidaSentimientos partida2 = new PartidaSentimientos(
        fechaFin: "09/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 5,
        fallos: 2,
        jugadorId: jugador2.id!);

    PartidaSentimientos partida3 = new PartidaSentimientos(
        fechaFin: "10/08/2024 00:00:00",
        duracionSegundos: 120,
        aciertos: 10,
        fallos: 0,
        jugadorId: jugador1.id!);

    int partidaId_1 = await insertPartidaSentimientos(partida1, database);
    int partidaId_2 = await insertPartidaSentimientos(partida2, database);
    int partidaId_3 = await insertPartidaSentimientos(partida3, database);

    List<PartidaSentimientos> partidas =
        await getPartidasSentimientosByUserId(jugador1.id!, database);

    expect(partidas[1].id, partidaId_1);
  });
}
