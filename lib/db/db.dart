import 'package:path/path.dart';
import 'package:rutinas/db/accion.dart';
import 'package:rutinas/db/pregunta.dart';
import 'package:sqflite/sqflite.dart';

import 'grupo.dart';
import 'jugador.dart';

String pathPersonajes = "assets/img/personajes/";
String pathAcciones = "assets/img/acciones/";

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

void insertPreguntas(Database database) {
  insertPreguntasAccionesAtencionT(database);
}

// PREGUNTAS RUTINAS PARA EL GRUPO DE ATENCIÓN T.
void insertPreguntasAccionesAtencionT(Database database) async {
  int grupoAtencionT = 1;

  // LAVAR DIENTES
  int id_P1 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer Pepe para lavarse los dientes.',
      'cerdo.png',
      grupoAtencionT);
  insertAccion(database, "Coger cepillo", 0, "1.LavarDientes.png", id_P1);
  insertAccion(
      database, "Echar pasta de dientes", 1, "2.LavarDientes.png", id_P1);
  insertAccion(database, "Cepillarse", 2, "3.LavarDientes.png", id_P1);
  insertAccion(database, "Lavar cepillo", 3, "4.LavarDientes.png", id_P1);
  insertAccion(database, "Guardar cepillo", 4, "5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si tuviera pelo y quisiera peinarse.',
      'cerdo.png',
      grupoAtencionT);
  insertAccion(database, 'Coger el peine', 0, '6.CogerPeine.png', id_P2);
  insertAccion(database, 'Peinarse', 1, '7.Peinarse.png', id_P2);
  insertAccion(database, 'Guardar el peine', 2, '8.GuardarPeine.png', id_P2);

  // LAVAR CARA
  int id_P3 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera lavarse la cara.',
      'cerdo.png',
      grupoAtencionT);

  insertAccion(database, 'Abrir grifo', 0, '9.AbrirGrifo.png', id_P3);
  insertAccion(database, 'Mojar manos', 1, '10.MojarManos.png', id_P3);
  insertAccion(database, 'Cerrar grifo', 2, '11.CerrarGrifo.png', id_P3);
  insertAccion(database, 'Lavar cara', 3, '12.LavarCara.png', id_P3);
  insertAccion(database, 'Secar cara', 4, '13.SecarCara.png', id_P3);
  insertAccion(database, 'Secar manos', 5, '14.SecarManos.png', id_P3);

  // CALZARSE
  int id_P4 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera calzarse.',
      'cerdo.png',
      grupoAtencionT);
  insertAccion(
      database, 'Poner calcetines', 0, '15.PonerCalcetines.png', id_P4);
  insertAccion(database, 'Poner calzado', 0, '16.PonerCalzado.png', id_P4);
  insertAccion(database, 'Atar cordones', 0, '17.AtarCalzado.png', id_P4);
}

// PREGUNTAS RUTINAS PARA EL GRUPO DE LA INFANCIA
void insertPreguntasAccionesInfancia(Database database) async {
  int grupoInfancia = 2;

  // LAVAR DIENTES
  int id_P1 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer la fontanera María para lavarse los dientes.',
      'fontanera.png',
      grupoInfancia);
  insertAccion(database, "Coger cepillo", 0, "1.LavarDientes.png", id_P1);
  insertAccion(
      database, "Echar pasta de dientes", 1, "2.LavarDientes.png", id_P1);
  insertAccion(database, "Cepillarse", 2, "3.LavarDientes.png", id_P1);
  insertAccion(database, "Lavar cepillo", 3, "4.LavarDientes.png", id_P1);
  insertAccion(database, "Guardar cepillo", 4, "5.LavarDientes.png", id_P1);
}

// PREGUNTAS RUTINAS PARA EL GRUPO DE ADOLESCENTES
void insertPreguntasAccionesAdolescencia(Database database) async {
  int grupoAdolescencia = 2;

  // LAVAR DIENTES
  int id_P1 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer la futbolista Aitana para lavarse los dientes.',
      'futbolista.png',
      grupoAdolescencia);
  insertAccion(database, "Coger cepillo", 0, "1.LavarDientes.png", id_P1);
  insertAccion(
      database, "Echar pasta de dientes", 1, "2.LavarDientes.png", id_P1);
  insertAccion(database, "Cepillarse", 2, "3.LavarDientes.png", id_P1);
  insertAccion(database, "Lavar cepillo", 3, "4.LavarDientes.png", id_P1);
  insertAccion(database, "Guardar cepillo", 4, "5.LavarDientes.png", id_P1);
}

Future<int> insertPregunta(Database database, String enunciado,
    String imgPersonaje, int grupoId) async {
  int id = -1;
  await database.transaction((txn) async {
    id = await txn.rawInsert(
      "INSERT INTO pregunta (enunciado, personajePath, grupoId) VALUES (?, ?, ?)",
      [enunciado, pathPersonajes + imgPersonaje, grupoId],
    );
  });

  return id;
}

Future<void> insertAccion(Database database, String texto, int orden,
    String imgAccion, int preguntaId) async {
  await database.transaction((txn) async {
    await txn.rawInsert(
      "INSERT INTO accion (texto, orden, imagenPath, preguntaId) VALUES (?, ?, ?, ?)",
      [texto, orden, pathAcciones + imgAccion, preguntaId],
    );
  });
}

Future<List<Pregunta>> getPreguntas(int grupoId) async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> preguntasMap =
        await db.query('pregunta', where: 'grupoId = ?', whereArgs: [grupoId]);
    return preguntasMap.map((map) => Pregunta.preguntasFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener preguntas: $e");
    return [];
  }
}

Future<List<Accion>> getAcciones(int preguntaId) async {
  try {
    final Database db = await initializeDB();
    final List<Map<String, dynamic>> accionesMap = await db
        .query('accion', where: 'preguntaId = ?', whereArgs: [preguntaId]);
    return accionesMap.map((map) => Accion.accionesFromMap(map)).toList();
  } catch (e) {
    print("Error al obtener acciones: $e");
    return [];
  }
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
