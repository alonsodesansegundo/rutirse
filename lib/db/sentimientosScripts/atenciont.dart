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
      database, "Ganó la carrera", 1, pathSentimientos + "ganar.png", id_P1);
  insertSituacionInitialData(
      database, "Perdió la carrera", 0, pathSentimientos + "perder.png", id_P1);

  int id_P2 = await insertPreguntaSituacionInitialData(
      database,
      'Jaime está triste después de acabar la carrera, ¿por qué?',
      pathPersonaje + 'corredor.png',
      grupoAtencionT);
  insertSituacionInitialData(
      database, "Ganó la carrera", 0, pathSentimientos + "ganar.png", id_P2);
  insertSituacionInitialData(
      database, "Perdió la carrera", 1, pathSentimientos + "perder.png", id_P2);

  int id_P3 = await insertPreguntaSituacionInitialData(
      database,
      'Hoy María está enfadada porque sus padres la van a llevar al...',
      pathPersonaje + 'enfadada.png',
      grupoAtencionT);
  insertSituacionInitialData(
      database, "Dentista", 1, pathSentimientos + "dentista.png", id_P3);
  insertSituacionInitialData(
      database, "Parque", 0, pathSentimientos + "parque.png", id_P3);

  int id_P4 = await insertPreguntaSituacionInitialData(
      database,
      'Hoy María está contenta porque sus padres la van a llevar al...',
      pathPersonaje + 'contenta.png',
      grupoAtencionT);
  insertSituacionInitialData(
      database, "Dentista", 0, pathSentimientos + "dentista.png", id_P4);
  insertSituacionInitialData(
      database, "Parque", 1, pathSentimientos + "parque.png", id_P4);

  int id_P5 = await insertPreguntaSituacionInitialData(
      database,
      'Jaime y Marisa hoy están muy contentos, por eso están...',
      pathPersonaje + 'ambos.png',
      grupoAtencionT);
  insertSituacionInitialData(
      database, "Abrazados", 1, pathSentimientos + "abrazo.png", id_P5);
  insertSituacionInitialData(
      database, "Discutiendo", 0, pathSentimientos + "discutir.png", id_P5);

  int id_P6 = await insertPreguntaSituacionInitialData(
      database,
      'Marisa y Jaime hoy están muy enfadados, por eso están...',
      pathPersonaje + 'enfadadosAmbos.png',
      grupoAtencionT);
  insertSituacionInitialData(
      database, "Abrazados", 0, pathSentimientos + "abrazo.png", id_P6);
  insertSituacionInitialData(
      database, "Discutiendo", 1, pathSentimientos + "discutir.png", id_P6);

  int id_P7 = await insertPreguntaSituacionInitialData(
      database,
      'Jesús se ha asustado al ver...',
      pathPersonaje + 'asustado.png',
      grupoAtencionT);
  insertSituacionInitialData(
      database, "Monstruo", 1, pathSentimientos + "monstruo.png", id_P7);
  insertSituacionInitialData(
      database, "Peluche", 0, pathSentimientos + "peluche.png", id_P7);

  int id_P8 = await insertPreguntaSituacionInitialData(
      database,
      'Celia se ha puesto contenta al ver...',
      pathPersonaje + 'contenta.png',
      grupoAtencionT);
  insertSituacionInitialData(
      database, "Monstruo", 0, pathSentimientos + "monstruo.png", id_P8);
  insertSituacionInitialData(
      database, "Peluche", 1, pathSentimientos + "peluche.png", id_P8);
}
