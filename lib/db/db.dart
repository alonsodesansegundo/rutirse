import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'grupo.dart';
import 'jugador.dart';

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();

  return openDatabase(
    join(path, 'rutinas.db'),
    onCreate: (database, version) async {
      createTables(database); // creación de tablas
      insertGrupos(
          database); // inserción de datos iniciales (grupos, preguntas...)
    },
    version: 1,
  );
}

void createTableGrupo(Database database) {
  database.execute(
    """CREATE TABLE grupo (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nombre TEXT NOT NULL,
          edades TEXT NOT NULL)""",
  );
}

void createTableJugador(Database database) {
  database.execute("""
    CREATE TABLE jugador (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      nombre TEXT NOT NULL,
      grupoId INTEGER,
      FOREIGN KEY (grupoId) REFERENCES grupo(id))""");
}

void createTablePartida(Database database) {
  database.execute("""
    CREATE TABLE partida (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      fechaInicio DATE NOT NULL,
      fechaFin DATE NOT NULL,
      aciertos INTEGER NOT NULL,
      fallos INTEGER NOT NULL,
      jugadorId INTEGER,
      FOREIGN KEY (jugadorId) REFERENCES jugador(id))""");
}

void createTablePregunta(Database database) {
  database.execute("""
    CREATE TABLE pregunta (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      enunciado TEXT NOT NULL,
      personajePath TEXT NOT NULL,
      partidaId INTEGER,
      grupoId INTEGER,
      FOREIGN KEY (partidaId) REFERENCES partida(id),
      FOREIGN KEY (grupoId) REFERENCES grupo(id))""");
}

void createTableAccion(Database database) {
  database.execute("""
    CREATE TABLE accion (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      texto TEXT NOT NULL,
      orden INTEGER NOT NULL,
      imagenPath TEXT NOT NULL,
      preguntaId INTEGER,
      FOREIGN KEY (preguntaId) REFERENCES pregunta(id))""");
}

void createTables(Database database) {
  createTableGrupo(database);
  createTableJugador(database);
  createTablePartida(database);
  createTablePregunta(database);
  createTableAccion(database);
}

void insertGrupos(Database database) async {
  await database.transaction((txn) async {
    txn.rawInsert(
        "INSERT INTO grupo (nombre, edades) VALUES ('Atención T.','4 - 7 años')");
    txn.rawInsert(
        "INSERT INTO grupo (nombre, edades) VALUES ('Infancia','7 - 11 años')");
    txn.rawInsert(
        "INSERT INTO grupo (nombre, edades) VALUES ('Adolescencia','12 - 17 años')");
  });
}

Future<List<Grupo>> getGrupos() async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> gruposMap = await db.query('grupo');
    return gruposMap.map((map) => Grupo.gruposFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener grupos: $e");
    return [];
  }
}

Future<void> insertJugador(Jugador jugador) async {
  Database database = await initializeDB();
  if (!await existeJugador(jugador, database)) {
    database.insert("jugador", jugador.jugadoresToMap());
    print("jugador añadido");
    return;
  }
  print("jugador repetido");
}

Future<bool> existeJugador(Jugador jugador, Database database) async {
  List<Map<String, dynamic>> result = await database.query(
    'jugador',
    where: 'nombre = ? AND grupoId = ?',
    whereArgs: [jugador.nombre, jugador.grupoId],
  );
  return result.isNotEmpty;
}
