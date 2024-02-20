import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'grupos.dart';


Future<Database> initializeDB() async {
  String path = await getDatabasesPath();

  return openDatabase(
    join(path, 'rutinas.db'),
    onCreate: (database, version) async {
      await database.execute(
        """CREATE TABLE grupos (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT NOT NULL,
          edades TEXT NOT NULL)""",
      );
      await insertGrupos(database);
    },
    version: 1,
  );
}

Future<void> insertGrupos(Database database) async {
  await database.execute("INSERT INTO grupos (name, edades) VALUES ('Atención T.','4 - 7 años')");
  await database.execute("INSERT INTO grupos (name, edades) VALUES ('Infancia','7 - 11 años')");
  await database.execute("INSERT INTO grupos (name, edades) VALUES ('Adolescencia','12 - 17 años')");

}

Future<List<Grupos>> getGrupos() async {
  final Database db = await initializeDB();
  final List<Map<String,dynamic>> gruposMap=await db.query('grupos');
  return List.generate(gruposMap.length,
          (i) => Grupos(
            id: gruposMap[i]['id'],
            name: gruposMap[i]['name'],
              edades: gruposMap[i]['edades']
      )
  );
}