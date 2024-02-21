import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'grupos.dart';


Future<Database> initializeDB() async {
  String path = await getDatabasesPath();

  return openDatabase(
    join(path, 'rutinas.db'),
    onCreate: (database, version) async {
      createTableGrupos(database);
      insertGrupos(database);
    },
    version: 1,
  );
}

void createTableGrupos(Database database){
  database.execute(
    """CREATE TABLE grupo (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT NOT NULL,
          edades TEXT NOT NULL)""",
  );
}

//void createTable

void insertGrupos(Database database)  {
   database.execute("INSERT INTO grupo (name, edades) VALUES ('Atención T.','4 - 7 años')");
   database.execute("INSERT INTO grupo (name, edades) VALUES ('Infancia','7 - 11 años')");
   database.execute("INSERT INTO grupo (name, edades) VALUES ('Adolescencia','12 - 17 años')");
}

Future<List<Grupo>> getGrupos() async {
  final Database db = await initializeDB();
  final List<Map<String,dynamic>> gruposMap=await db.query('grupo');
  return List.generate(gruposMap.length,
          (i) => Grupo(
            id: gruposMap[i]['id'],
            name: gruposMap[i]['name'],
              edades: gruposMap[i]['edades']
      )
  );
}