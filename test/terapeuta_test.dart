import 'package:Rutirse/db/db.dart';
import 'package:Rutirse/db/obj/grupo.dart';
import 'package:Rutirse/db/obj/terapeuta.dart';
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
    //insertDefaultPassword(database);
  });

  tearDown(() async {
    await database.close();
  });

  // Test 1
  test('Test for check insertDefaultPassword', () async {
    insertDefaultPassword(database);
    final List<Map<String, dynamic>> result = await database.query('terapeuta');
    expect(result.length, 1);
  });

  test('Test for check getPassword (default)', () async {
    insertDefaultPassword(database);
    String result = await getPassword(database);
    expect(result, '');
  });

  test('Test for check updatePassword (new)', () async {
    insertDefaultPassword(database);
    updatePassword("New password", "Pista new password", database);
    String result = await getPassword(database);
    expect(result, 'New password');
  });

  test('Test for check getPista (default)', () async {
    insertDefaultPassword(database);
    String result = await getPista(database);
    expect(result, '');
  });

  test('Test for check getPista (with update)', () async {
    insertDefaultPassword(database);
    updatePassword("New password", "Pista new password", database);
    String result = await getPista(database);
    expect(result, 'Pista new password');
  });
}
