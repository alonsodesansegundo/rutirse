import 'package:sqflite/sqflite.dart';

import '../db.dart';

///Método que genera una contraseña por defecto, la cual es vacía
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecuta la insercción
void insertDefaultPassword(Database database) async {
  await database.transaction((txn) async {
    txn.rawInsert("INSERT INTO terapeuta (password,pista) VALUES ('','')");
  });
}

///Método que nos permite obtener la contraseña
///<br><b>Parámetros</b><br>
///[db] Objeto Database sobre la cual se ejecuta la consulta
///<br><b>Salida</b><br>
///Valor de la contraseña
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

///Método que nos permite obtener la pista para recordar la contraseña
///<br><b>Parámetros</b><br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
///<br><b>Salida</b><br>
///Valor de la pista
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

///Método que nos permite cambiar la contraseña
///<br><b>Parámetros</b><br>
///[newPassword] Valor de la nueva contraseña<br>
///[newPista] Valor de la nueva pista<br>
///[db] Parámetro opcional. Le pasamos un objeto Database en caso de estar probando dicho método
Future<void> updatePassword(String newPassword, String newPista,
    [Database? db]) async {
  final Database database = db ?? await initializeDB();

  await database.rawUpdate(
      'UPDATE terapeuta SET password = ?, pista = ?', [newPassword, newPista]);
}
