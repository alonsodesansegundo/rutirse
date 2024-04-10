// PREGUNTAS IRONIAS PARA EL GRUPO DE ADOLESCENTES
import 'package:sqflite/sqflite.dart';

import '../obj/respuestaIronia.dart';
import '../obj/situacionIronia.dart';

String pathIronias = 'assets/img/ironias/';

void insertIroniasInitialDataAdolescencia(Database database) async {
  int grupoAdolescencia = 3;

  int id_P1 = await insertSituacionIroniaInitialData(
      database,
      'Jaime ha quedado con su amigo Manuel, que siempre suele llegar tarde. Han quedado a las 17:00h y Manuel se presenta a las 17:15, '
      'en cuanto lo ve Jaime le dice: ¡Tú siempre tan puntual!',
      pathIronias + 'esperar.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente Manuel es puntual, siempre llega a la hora.",
      0,
      id_P1);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente Manuel no es puntual, siempre llega tarde.",
      0,
      id_P1);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente Manuel no es puntual, siempre llega tarde.",
      1,
      id_P1);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente Manuel es puntual, siempre llega a la hora.",
      0,
      id_P1);

  int id_P2 = await insertSituacionIroniaInitialData(
      database,
      'Jaime ha quedado con su amigo Manolo, que siempre suele llegar puntual. Han quedado a las 17:00h, Jaime llega a las 16:55 y Manolo '
      'ya estaba esperando por el. Jaime dice: ¡Tú siempre tan puntual! ',
      pathIronias + 'esperar.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente Manolo es puntual, siempre llega a la hora o incluso antes.",
      1,
      id_P2);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente Manuel no es puntual, siempre llega tarde.",
      0,
      id_P2);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente Manuel no es puntual, siempre llega tarde.",
      0,
      id_P2);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente Manuel es puntual, siempre llega a la hora o incluso antes.",
      0,
      id_P2);
}
