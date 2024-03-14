import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'obj/accion.dart';
import 'obj/grupo.dart';
import 'obj/pregunta.dart';

String pathPersonajes = "assets/img/personajes/";

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();

  return openDatabase(
    join(path, 'rutinas.db'),
    onCreate: (database, version) async {
      // creación de tablas
      createTables(database);

      // inserción de datos iniciales (grupos, preguntas...)
      insertGrupos(database);
      insertPreguntas(database);
    },
    version: 2,
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
      fechaFin TEXT NOT NULL,
      duracionSegundos INTEGER NOT NULL,
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
      personajeImg BLOB,
      grupoId INTEGER NOT NULL,
      FOREIGN KEY (grupoId) REFERENCES grupo(id))""");
}

void createTableAccion(Database database) {
  database.execute("""
    CREATE TABLE accion (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      texto TEXT,
      orden INTEGER NOT NULL,
      imagen BLOB,
      preguntaId INTEGER NOT NULL,
      FOREIGN KEY (preguntaId) REFERENCES pregunta(id))""");
}

void createTables(Database database) {
  createTableGrupo(database);
  createTableJugador(database);
  createTablePartida(database);
  createTablePregunta(database);
  createTableAccion(database);
}

Future<void> addRutina(Pregunta pregunta, List<Accion> acciones) async {
  Database database = await initializeDB();
  await database.insert("pregunta", pregunta.preguntasToMap());
  for (int i = 0; i < acciones.length; i++)
    await database.insert("accion", acciones[i].accionesToMap());
}
