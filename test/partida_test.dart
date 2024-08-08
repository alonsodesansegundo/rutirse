import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/jugador.dart';
import 'package:Rutirse/db/obj/partida.dart';
import 'package:Rutirse/db/obj/partidaIronias.dart';
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
  test('Test for check deletePartidaById (length)', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);

    jugador = await insertJugador(jugador, database);

    PartidaIronias partida = new PartidaIronias(
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 12,
        aciertos: 11,
        fallos: 11,
        jugadorId: jugador.id!);

    int partidaId = await insertPartidaIronias(partida, database);
    deletePartidaById(partidaId, database);

    final List<Map<String, dynamic>> partidasMap =
        await database.query('partida');
    List<Partida> partidas =
        partidasMap.map((map) => Partida.partidasFromMap(map)).toList();

    expect(partidas.length, 0);
  });

  test('Test for check deletePartidaById (length)', () async {
    Jugador jugador = new Jugador(nombre: 'Jugador 1', grupoId: 1);

    jugador = await insertJugador(jugador, database);

    PartidaIronias partida = new PartidaIronias(
        fechaFin: "08/08/2024 00:00:00",
        duracionSegundos: 12,
        aciertos: 11,
        fallos: 11,
        jugadorId: jugador.id!);

    int partidaId = await insertPartidaIronias(partida, database);

    final List<Map<String, dynamic>> partidasMap =
        await database.query('partida');
    List<Partida> partidas =
        partidasMap.map((map) => Partida.partidasFromMap(map)).toList();

    expect(partidas.length, 1);
  });
}
