import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
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
  });

  // Elimino la tabla grupo después de cada prueba
  tearDown(() async {
    await database.delete('grupo');
    await database.close();
  });

  // Test 1
  test('Test for check gruposToMap', () async {
    insertGrupos(database);
    Grupo grupoExpected =
        new Grupo(id: 1, nombre: "Atención T.", edades: "4 - 7 años");
    List<Grupo> grupos = await getGrupos(database);
    expect(grupos[0].gruposToMap(), grupoExpected.gruposToMap());
  });

  // Test 2
  test('Test for check toString', () async {
    insertGrupos(database);
    Grupo grupoExpected =
        new Grupo(id: 1, nombre: "Atención T.", edades: "4 - 7 años");
    List<Grupo> grupos = await getGrupos(database);
    expect(grupos[0].toString(), grupoExpected.toString());
  });

  // Test 3
  test('Test for check insert groups', () async {
    insertGrupos(database);
    final List<Map<String, dynamic>> result = await database.query('grupo');
    expect(result.length, 3);
  });

  // Test 4
  test('Test for check getGrupos (length)', () async {
    insertGrupos(database);
    List<Grupo> grupos = await getGrupos(database);
    expect(grupos.length, 3);
  });

  // Test 5
  test('Test for check getGrupos (order element 0)', () async {
    Grupo grupoExpected =
        new Grupo(id: 1, nombre: "Atención T.", edades: "4 - 7 años");
    insertGrupos(database);
    List<Grupo> grupos = await getGrupos(database);
    expect(grupos[0], grupoExpected);
  });

  // Test
  test('Test for check getGrupos (order element 1)', () async {
    insertGrupos(database);
    Grupo grupoExpected =
        new Grupo(id: 2, nombre: "Infancia", edades: "8 - 11 años");
    List<Grupo> grupos = await getGrupos(database);
    expect(grupos[1], grupoExpected);
  });

  // Test
  test('Test for check getGrupos (order element 2)', () async {
    insertGrupos(database);
    Grupo grupoExpected =
        new Grupo(id: 3, nombre: "Adolescencia", edades: "12 - 17 años");
    List<Grupo> grupos = await getGrupos(database);
    expect(grupos[2], grupoExpected);
  });

  // Test
  test('Test for check hashCode', () async {
    insertGrupos(database);
    Grupo grupoExpected =
        new Grupo(id: 1, nombre: "Atención T.", edades: "4 - 7 años");
    List<Grupo> grupos = await getGrupos(database);
    expect(grupos[0].hashCode, grupoExpected.hashCode);
  });

  // Test
  test('Test for check getGrupos without insert of groups', () async {
    List<Grupo> grupos = await getGrupos(database);
    expect(grupos, []);
  });

  // Test
  test('Test for check getGrupoById with existent id', () async {
    insertGrupos(database);
    Grupo grupoExpected =
        new Grupo(id: 1, nombre: "Atención T.", edades: "4 - 7 años");
    Grupo grupo = await getGrupoById(1, database);
    expect(grupo, grupoExpected);
  });

  // Test
  test('Test for check getGrupoById with not existent id', () async {
    expect(getGrupoById(-1, database), throwsA(isA<Exception>()));
  });
}
