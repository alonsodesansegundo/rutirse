import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'obj/grupo.dart';
import 'obj/preguntaSentimiento.dart';
import 'obj/situacionIronia.dart';
import 'obj/situacionRutina.dart';
import 'obj/terapeuta.dart';

///Método que inicializa la base de datos sqflite
///<br><b>Salida</b><br>
///El objeto Database que se ha creado
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
      insertSentimientos(database);
    },
    onUpgrade: _onUpgrade, // Manejo de actualización de la base de datos
    version: 2, // Cambiar la versión a 2
  );
}

/// Método que maneja la actualización de la base de datos
Future<void> _onUpgrade(Database database, int oldVersion, int newVersion) async {
  print("old version --> "+oldVersion.toString());
  // Si la versión anterior es la primera
  if (oldVersion < 2) {
    // Lógica para eliminar la columna 'edades' de la tabla 'grupo'
    await database.execute('''
      CREATE TABLE nuevo_grupo (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        nombre TEXT NOT NULL
      )
    ''');

    // Copiar datos de la tabla original a la nueva tabla, excluyendo 'edades'
    await database.execute('''
      INSERT INTO nuevo_grupo (nombre) VALUES ('Fácil')
    ''');
    await database.execute('''
      INSERT INTO nuevo_grupo (nombre) VALUES ('Medio')
    ''');
    await database.execute('''
      INSERT INTO nuevo_grupo (nombre) VALUES ('Difícil')
    ''');


    // Eliminar la tabla original
    await database.execute('DROP TABLE grupo');

    // Renombrar la nueva tabla
    await database.execute('ALTER TABLE nuevo_grupo RENAME TO grupo');
  }
}

///Método para crear la tabla grupo
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
void createTableGrupo(Database database) {
  database.execute(
    """CREATE TABLE grupo (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          nombre TEXT NOT NULL)""",
  );
}

///Método para crear la tabla jugador
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
void createTableJugador(Database database) {
  database.execute("""
    CREATE TABLE jugador (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      nombre TEXT NOT NULL,
      grupoId INTEGER,
      FOREIGN KEY (grupoId) REFERENCES grupo(id))""");
}

///Método para crear la tabla partida
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
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

///Método para crear la tabla situacionRutina
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
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

///Método para crear la tabla accion
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
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

///Método para crear la tabla situacionIronia
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
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

///Método para crear la tabla respuestaIronia
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
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

///Método para crear la tabla preguntaSentimiento
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
void createTablePreguntaSentimiento(Database database) {
  database.execute("""
    CREATE TABLE preguntaSentimiento (
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

///Método para crear la tabla situacion
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
void createTableSituacion(Database database) {
  database.execute("""
    CREATE TABLE situacion (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      texto TEXT,
      correcta INTEGER NOT NULL,
      imagen BLOB NOT NULL,
      preguntaSentimientoId INTEGER NOT NULL,
      FOREIGN KEY (preguntaSentimientoId) REFERENCES preguntaSentimiento(id)
      ON DELETE CASCADE 
    )""");
}

///Método para crear la tabla terapeuta
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crea la tabla
void createTableTerapeuta(Database database) {
  database.execute("""
    CREATE TABLE terapeuta (
      password TEXT NOT NULL,
      pista TEXT NOT NULL
    )""");
}

///Método que recoge todas las creaciones de tablas
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se crean la tablas
void createTables(Database database) {
  createTableGrupo(database);
  createTableJugador(database);
  createTablePartida(database);
  createTableSituacionRutina(database);
  createTableAccion(database);
  createTableTerapeuta(database);
  createTableSituacionIronia(database);
  createTableRespuestaIronia(database);
  createTablePreguntaSentimiento(database);
  createTableSituacion(database);
}
