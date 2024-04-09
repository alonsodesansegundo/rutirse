import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'obj/accion.dart';
import 'obj/grupo.dart';
import 'obj/situacionIronia.dart';
import 'obj/situacionRutina.dart';
import 'obj/terapeuta.dart';

String pathPersonajes = "assets/img/personajes/";

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();

  return openDatabase(
    join(path, 'rutinas.db'),
    onCreate: (database, version) async {
      // creación de tablas
      createTables(database);

      // inserción de datos iniciales (grupos, preguntas...)
      insertDefaultPassword(database);
      insertGrupos(database);
      insertRutinas(database);
      insertIronias(database);
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
      fechaFin TEXT NOT NULL,
      duracionSegundos INTEGER NOT NULL,
      aciertos INTEGER NOT NULL,
      fallos INTEGER NOT NULL,
      jugadorId INTEGER,
      FOREIGN KEY (jugadorId) REFERENCES jugador(id)
    )""");

  database.execute("""
    CREATE TABLE partidaRutinas (
      partidaId INTEGER PRIMARY KEY,
      FOREIGN KEY (partidaId) REFERENCES partida(id) ON DELETE CASCADE
    )""");

  database.execute("""
    CREATE TABLE partidaSentimientos (
      partidaId INTEGER PRIMARY KEY,
      FOREIGN KEY (partidaId) REFERENCES partida(id) ON DELETE CASCADE
    )""");

  database.execute("""
    CREATE TABLE partidaIronias (
      partidaId INTEGER PRIMARY KEY,
      FOREIGN KEY (partidaId) REFERENCES partida(id) ON DELETE CASCADE
    )""");
}

void createTableSituacionRutina(Database database) {
  database.execute("""
    CREATE TABLE situacionRutina (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      enunciado TEXT NOT NULL,
      personajeImg BLOB,
      grupoId INTEGER NOT NULL,
      fecha TEXT NOT NULL,
      byTerapeuta INTEGER DEFAULT 0 NOT NULL,
      FOREIGN KEY (grupoId) REFERENCES grupo(id)
      ON DELETE CASCADE 
    )""");
}

void createTableAccion(Database database) {
  database.execute("""
    CREATE TABLE accion (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      texto TEXT,
      orden INTEGER NOT NULL,
      imagen BLOB NOT NULL,
      situacionRutinaId INTEGER NOT NULL,
      FOREIGN KEY (situacionRutinaId) REFERENCES situacionRutina(id)
      ON DELETE CASCADE 
    )""");
}

void createTableSituacionIronia(Database database) {
  database.execute("""
    CREATE TABLE situacionIronia (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      enunciado TEXT NOT NULL,
      imagen BLOB,
      grupoId INTEGER NOT NULL,
      fecha TEXT NOT NULL,
      byTerapeuta INTEGER DEFAULT 0 NOT NULL,
      FOREIGN KEY (grupoId) REFERENCES grupo(id)
      ON DELETE CASCADE 
    )""");
}

void createTableRespuestaIronia(Database database) {
  database.execute("""
    CREATE TABLE respuestaIronia (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      texto TEXT,
      correcta INTEGER NOT NULL,
      situacionIroniaId INTEGER NOT NULL,
      FOREIGN KEY (situacionIroniaId) REFERENCES situacionIronia(id)
      ON DELETE CASCADE 
    )""");
}

void createTableTerapeuta(Database database) {
  database.execute("""
    CREATE TABLE terapeuta (
      password TEXT NOT NULL,
      pista TEXT NOT NULL
    )""");
}

void createTables(Database database) {
  createTableGrupo(database);
  createTableJugador(database);
  createTablePartida(database);
  createTableSituacionRutina(database);
  createTableAccion(database);
  createTableTerapeuta(database);
  createTableSituacionIronia(database);
  createTableRespuestaIronia(database);
}

Future<void> addRutina(
    SituacionRutina situacionRutina, List<Accion> acciones) async {
  Database database = await initializeDB();
  await database.insert("situacionRutina", situacionRutina.situacionesToMap());
  for (int i = 0; i < acciones.length; i++)
    await database.insert("accion", acciones[i].accionesToMap());
}
