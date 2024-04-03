import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'obj/accion.dart';
import 'obj/grupo.dart';
import 'obj/jugador.dart';
import 'obj/partida.dart';
import 'obj/pregunta.dart';
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
      insertPreguntas(database);

      // INSERCCIONES DE RUTINAS POR TERAPEUTA PARA PRUEBAS
      //insertDataTerapeutaTest();
      //insertDefaultJugadoresPartidasTest();
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
      FOREIGN KEY (jugadorId) REFERENCES jugador(id))""");
}

void createTablePregunta(Database database) {
  database.execute("""
    CREATE TABLE pregunta (
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
      preguntaId INTEGER NOT NULL,
      FOREIGN KEY (preguntaId) REFERENCES pregunta(id)
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
  createTablePregunta(database);
  createTableAccion(database);
  createTableTerapeuta(database);
}

Future<void> addRutina(Pregunta pregunta, List<Accion> acciones) async {
  Database database = await initializeDB();
  await database.insert("pregunta", pregunta.preguntasToMap());
  for (int i = 0; i < acciones.length; i++)
    await database.insert("accion", acciones[i].accionesToMap());
}

Future<void> insertDataTerapeutaTest() async {
  Database database = await initializeDB();
  int grupoAtencionT = 1;
  int grupoInfancia = 2;
  int grupoAdolescencia = 3;

  String pathRutinas = 'assets/img/rutinas/';
  String pathPersonaje = 'assets/img/personajes/';

  // LAVAR DIENTES
  int id_P1 = await insertPreguntaInitialDataTerapeutaTest(
      database,
      'Por favor, pon en orden lo que tiene que hacer el bailador Adrián para lavarse los dientes.',
      pathPersonaje + 'bailador.png',
      grupoAdolescencia);
  insertAccionInitialDataTerapeutaTest(database, "", 0,
      pathRutinas + "higiene/lavarDientes/1.LavarDientes.png", id_P1);
  insertAccionInitialDataTerapeutaTest(database, "", 1,
      pathRutinas + "higiene/lavarDientes/6.LavarDientes.png", id_P1);
  insertAccionInitialDataTerapeutaTest(database, "", 2,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
  insertAccionInitialDataTerapeutaTest(database, "", 3,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
  insertAccionInitialDataTerapeutaTest(database, "", 4,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);
  insertAccionInitialDataTerapeutaTest(database, "", 5,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P1);

  int id_P2 = await insertPreguntaInitialDataTerapeutaTest(
      database,
      'Por favor, pon en orden lo que tiene que hacer la fontanera María para lavarse los dientes.',
      pathPersonaje + 'fontanera.png',
      grupoAtencionT);
  insertAccionInitialDataTerapeutaTest(database, "Coger el cepillo", 0,
      pathRutinas + "higiene/lavarDientes/1.LavarDientes.png", id_P2);
  insertAccionInitialDataTerapeutaTest(database, "Coger pasta de dientes", 1,
      pathRutinas + "higiene/lavarDientes/6.LavarDientes.png", id_P2);
  insertAccionInitialDataTerapeutaTest(database, "Echar la pasta de dientes", 2,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P2);
  insertAccionInitialDataTerapeutaTest(database, "Cepillarse", 3,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P2);
  insertAccionInitialDataTerapeutaTest(database, "Lavar el cepillo", 4,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P2);
  insertAccionInitialDataTerapeutaTest(database, "Guardar el cepillo", 5,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P2);

  int id_P3 = await insertPreguntaInitialDataTerapeutaTest(
      database,
      'Por favor, pon en orden lo que tiene que hacer la fontanera María para lavarse los dientes.',
      pathPersonaje + 'fontanera.png',
      grupoInfancia);
  insertAccionInitialDataTerapeutaTest(database, "Coger el cepillo", 0,
      pathRutinas + "higiene/lavarDientes/1.LavarDientes.png", id_P3);
  insertAccionInitialDataTerapeutaTest(database, "Coger pasta de dientes", 1,
      pathRutinas + "higiene/lavarDientes/6.LavarDientes.png", id_P3);
  insertAccionInitialDataTerapeutaTest(database, "Echar la pasta de dientes", 2,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P3);
  insertAccionInitialDataTerapeutaTest(database, "Cepillarse", 3,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P3);
  insertAccionInitialDataTerapeutaTest(database, "Lavar el cepillo", 4,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P3);
  insertAccionInitialDataTerapeutaTest(database, "Guardar el cepillo", 5,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P3);

  // PEINARSE
  int id_P4 = await insertPreguntaInitialDataTerapeutaTest(
      database,
      'Por favor, pon en orden lo que tiene que hacer el león Simba para peinarse.',
      pathPersonaje + 'león.png',
      grupoInfancia);
  insertAccionInitialDataTerapeutaTest(database, 'Coger el peine', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P4);
  insertAccionInitialDataTerapeutaTest(database, 'Peinarse', 1,
      pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P4);
  insertAccionInitialDataTerapeutaTest(database, 'Limpiar el peine', 2,
      pathRutinas + "higiene/peinarse/4.LimpiarPeine.png", id_P4);
  insertAccionInitialDataTerapeutaTest(database, 'Guardar el peine', 3,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P4);

  // PEINARSE
  int id_P5 = await insertPreguntaInitialDataTerapeutaTest(
      database,
      'Por favor, pon en orden lo que tiene que hacer el león Simba para peinarse.',
      pathPersonaje + 'león.png',
      grupoAdolescencia);
  insertAccionInitialDataTerapeutaTest(database, '', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P5);
  insertAccionInitialDataTerapeutaTest(
      database, '', 1, pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P5);
  insertAccionInitialDataTerapeutaTest(database, '', 2,
      pathRutinas + "higiene/peinarse/4.LimpiarPeine.png", id_P5);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P5);

  // PEINARSE
  int id_P6 = await insertPreguntaInitialDataTerapeutaTest(
      database,
      'Por favor, pon en orden lo que tiene que hacer el león Simba para peinarse.',
      pathPersonaje + 'león.png',
      grupoAtencionT);
  insertAccionInitialDataTerapeutaTest(database, 'Coger el peine', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P6);
  insertAccionInitialDataTerapeutaTest(database, 'Peinarse', 1,
      pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P6);
  insertAccionInitialDataTerapeutaTest(database, 'Limpiar el peine', 2,
      pathRutinas + "higiene/peinarse/4.LimpiarPeine.png", id_P6);
  insertAccionInitialDataTerapeutaTest(database, 'Guardar el peine', 3,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P6);
}

Future<void> insertDefaultJugadoresPartidasTest() async {
  Database database = await initializeDB();
  print("Hola 3");

  Jugador j1 = new Jugador(nombre: "Jugador 1", grupoId: 1);
  Jugador j2 = new Jugador(nombre: "Jugador 2", grupoId: 2);
  Jugador j3 = new Jugador(nombre: "Jugador 3", grupoId: 3);
  print("Hola 4");

  j1 = await insertJugadorDefault(database, j1);
  print("Hola 5");

  j2 = await insertJugadorDefault(database, j2);
  print("Hola 6");
  j3 = await insertJugadorDefault(database, j3);

  Partida p1 = new Partida(
      fechaFin: "10/01/2024",
      duracionSegundos: 180,
      aciertos: 5,
      fallos: 5,
      jugadorId: j1.id!);

  insertPartidaDefault(database, p1);

  Partida p2 = new Partida(
      fechaFin: "11/01/2024",
      duracionSegundos: 190,
      aciertos: 7,
      fallos: 3,
      jugadorId: j2.id!);

  insertPartidaDefault(database, p2);

  Partida p3 = new Partida(
      fechaFin: "12/01/2024",
      duracionSegundos: 200,
      aciertos: 4,
      fallos: 6,
      jugadorId: j3.id!);

  insertPartidaDefault(database, p3);

  Partida p4 = new Partida(
      fechaFin: "10/02/2024",
      duracionSegundos: 243,
      aciertos: 8,
      fallos: 2,
      jugadorId: j1.id!);

  insertPartidaDefault(database, p4);

  Partida p5 = new Partida(
      fechaFin: "11/02/2024",
      duracionSegundos: 222,
      aciertos: 10,
      fallos: 3,
      jugadorId: j2.id!);

  insertPartidaDefault(database, p5);

  Partida p6 = new Partida(
      fechaFin: "12/02/2024",
      duracionSegundos: 233,
      aciertos: 6,
      fallos: 3,
      jugadorId: j3.id!);

  insertPartidaDefault(database, p6);

  Partida p7 = new Partida(
      fechaFin: "10/03/2024",
      duracionSegundos: 223,
      aciertos: 10,
      fallos: 2,
      jugadorId: j1.id!);

  insertPartidaDefault(database, p7);

  Partida p8 = new Partida(
      fechaFin: "11/03/2024",
      duracionSegundos: 232,
      aciertos: 12,
      fallos: 1,
      jugadorId: j2.id!);

  insertPartidaDefault(database, p8);

  Partida p9 = new Partida(
      fechaFin: "12/02/2024",
      duracionSegundos: 303,
      aciertos: 10,
      fallos: 0,
      jugadorId: j3.id!);

  insertPartidaDefault(database, p9);
}
