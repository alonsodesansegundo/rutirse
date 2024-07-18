// PREGUNTAS SENTIMIENTOS PARA EL GRUPO DE ATENCIÓN T.
import 'package:sqflite/sqflite.dart';

import '../obj/preguntaSentimiento.dart';
import '../obj/situacion.dart';

String pathSentimientos = 'assets/img/sentimientos/';
String pathPersonaje = 'assets/img/personajes/';

void insertPreguntaSentimientoInitialDataAtencionT(Database database) async {
  int grupoAtencionT = 1;

  int id_P1 = await insertPreguntaSituacionInitialData(
      database,
      'Jaime está contento después de acabar la carrera, ¿por qué?',
      pathPersonaje + 'corredor.png',
      grupoAtencionT);

  insertSituacionInitialData(
      database, "Ganó", 1, pathSentimientos + "ganar.png", id_P1);

  insertSituacionInitialData(
      database, "Perdió", 0, pathSentimientos + "perder.png", id_P1);

  int id_P2 = await insertPreguntaSituacionInitialData(
      database,
      'Jaime está triste después de acabar la carrera, ¿por qué?',
      pathPersonaje + 'corredor.png',
      grupoAtencionT);

  insertSituacionInitialData(
      database, "Ganó", 0, pathSentimientos + "ganar.png", id_P2);

  insertSituacionInitialData(
      database, "Perdió", 1, pathSentimientos + "perder.png", id_P2);
}
