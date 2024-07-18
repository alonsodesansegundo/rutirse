// PREGUNTAS SENTIMIENTOS PARA EL GRUPO DE ADOLESCENCIA
import 'package:sqflite/sqflite.dart';

import '../obj/preguntaSentimiento.dart';
import '../obj/situacion.dart';

String pathSentimientos = 'assets/img/sentimientos/';
String pathPersonaje = 'assets/img/personajes/';

void insertPreguntaSentimientoInitialDataAdolescencia(Database database) async {
  int grupoAdolescencia = 3;

  int id_P1 = await insertPreguntaSituacionInitialData(
      database,
      'Jaime está contento después de acabar la carrera, ¿por qué?',
      pathPersonaje + 'corredor.png',
      grupoAdolescencia);

  insertSituacionInitialData(
      database, "", 1, pathSentimientos + "ganar.png", id_P1);

  insertSituacionInitialData(
      database, "", 0, pathSentimientos + "perder.png", id_P1);
  insertSituacionInitialData(
      database, "", 0, pathSentimientos + "perder.png", id_P1);
  insertSituacionInitialData(
      database, "", 0, pathSentimientos + "perder.png", id_P1);

  int id_P2 = await insertPreguntaSituacionInitialData(
      database,
      'Jaime está triste después de acabar la carrera, ¿por qué?',
      pathPersonaje + 'corredor.png',
      grupoAdolescencia);

  insertSituacionInitialData(
      database, "", 0, pathSentimientos + "ganar.png", id_P2);
  insertSituacionInitialData(
      database, "", 0, pathSentimientos + "ganar.png", id_P2);
  insertSituacionInitialData(
      database, "", 0, pathSentimientos + "ganar.png", id_P2);

  insertSituacionInitialData(
      database, "", 1, pathSentimientos + "perder.png", id_P2);
}
