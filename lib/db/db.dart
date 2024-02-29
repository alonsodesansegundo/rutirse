import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      grupoId INTEGER,
      FOREIGN KEY (grupoId) REFERENCES grupo(id))""");
}

void createTableAccion(Database database) {
  database.execute("""
    CREATE TABLE accion (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      texto TEXT,
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
