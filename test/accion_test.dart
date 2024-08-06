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

  // Elimino la tabla grupo después de cada prueba
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
}
