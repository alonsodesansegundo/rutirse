import 'package:sqflite/sqflite.dart';

import '../db.dart';

void insertDefaultPassword(Database database) async {
  await database.transaction((txn) async {
    txn.rawInsert("INSERT INTO terapeuta (password,pista) VALUES ('','')");
  });
}

Future<String> getPassword([Database? db]) async {
  final Database database = db ?? await initializeDB();

  List<Map<String, dynamic>> result =
      await database.rawQuery('SELECT password FROM terapeuta');
  if (result.isNotEmpty) {
    return result.first['password'];
  } else {
    return '';
  }
}

Future<String> getPista([Database? db]) async {
  final Database database = db ?? await initializeDB();

  List<Map<String, dynamic>> result =
      await database.rawQuery('SELECT pista FROM terapeuta');
  if (result.isNotEmpty) {
    return result.first['pista'];
  } else {
    return '';
  }
}

Future<void> updatePassword(String newPassword, String newPista,
    [Database? db]) async {
  final Database database = db ?? await initializeDB();

  await database.rawUpdate(
      'UPDATE terapeuta SET password = ?, pista = ?', [newPassword, newPista]);
}
