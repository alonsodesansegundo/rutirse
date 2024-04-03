import 'package:sqflite/sqflite.dart';

import '../db.dart';

class Terapeuta {
  final String texto;

  Terapeuta({required this.texto});

  Terapeuta.terapeutasFromMap(Map<String, dynamic> item)
      : texto = item["texto"];

  Map<String, Object> terapeutasToMap() {
    return {'texto': texto};
  }

  @override
  String toString() {
    return 'Terapeuta {texto: $texto}';
  }
}

void insertDefaultPassword(Database database) async {
  await database.transaction((txn) async {
    txn.rawInsert("INSERT INTO terapeuta (password,pista) VALUES ('','')");
  });
}

Future<String> getPassword() async {
  final Database database = await initializeDB();

  List<Map<String, dynamic>> result =
      await database.rawQuery('SELECT password FROM terapeuta');
  if (result.isNotEmpty) {
    return result.first['password'];
  } else {
    return '';
  }
}

Future<String> getPista() async {
  final Database database = await initializeDB();

  List<Map<String, dynamic>> result =
      await database.rawQuery('SELECT pista FROM terapeuta');
  if (result.isNotEmpty) {
    return result.first['pista'];
  } else {
    return '';
  }
}

Future<void> updatePassword(String newPassword, String newPista) async {
  final Database database = await initializeDB();

  await database.rawUpdate(
      'UPDATE terapeuta SET password = ?, pista = ?', [newPassword, newPista]);
}
