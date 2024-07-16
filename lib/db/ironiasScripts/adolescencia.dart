// PREGUNTAS IRONIAS PARA EL GRUPO DE ADOLESCENTES
import 'package:sqflite/sqflite.dart';

import '../obj/respuestaIronia.dart';
import '../obj/situacionIronia.dart';

String pathIronias = 'assets/img/humor/';

void insertIroniasInitialDataAdolescencia(Database database) async {
  int grupoAdolescencia = 3;

  int id_P1 = await insertSituacionIroniaInitialData(
      database,
      'Jaime ha quedado con su amigo Manuel, que siempre suele llegar tarde. Han quedado a las 17:00h y Manuel se presenta a las 17:15h, '
      'en cuanto lo ve Jaime le dice: "¡Tú siempre tan puntual!"',
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
      'Jaime ha quedado con su amigo Manolo, que siempre suele llegar puntual. Han quedado a las 17:00h, Jaime llega a las 16:55h y Manolo '
      'ya estaba esperando por el. Jaime dice: "¡Tú siempre tan puntual!"',
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

  int id_P3 = await insertSituacionIroniaInitialData(
      database,
      'Pepe está de camino a la parada del autobús para ir al instituto, con tan mala suerte que lo pierde delante suya. '
      'Pepe dice: "¡Genial, qué manera tan buena de empezar el día"',
      pathIronias + 'perderautobus.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente es una mala manera de empezar el día.",
      0,
      id_P3);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente es una buena manera de empezar el día.",
      0,
      id_P3);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente es una buena manera de empezar el día.",
      0,
      id_P3);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente es una mala manera de empezar el día",
      1,
      id_P3);

  int id_P4 = await insertSituacionIroniaInitialData(
      database,
      'Pepe está de camino a la parada del autobús para ir al instituto, con tan mala suerte que lo pierde delante suya. '
      'Pepe dice: "¡Qué mala suerte! Lo he perdido por los pelos."',
      pathIronias + 'perderautobus.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente tuvo mala suerte.", 1, id_P4);
  insertRespuestaIronia(
      database, "No es una ironía, realmente tuvo buena suerte.", 0, id_P4);
  insertRespuestaIronia(
      database, "Es una ironía, realmente tuvo buena suerte.", 0, id_P4);
  insertRespuestaIronia(
      database, "Es una ironía, realmente tuvo mala suerte.", 0, id_P4);

  int id_P5 = await insertSituacionIroniaInitialData(
      database,
      'Un profesor está dando clase tranquilamente hasta que se encuentra a un alumno durmiendo. '
      'El profesor para de dar clase y dice: "¡Qué buen lugar y momento para echar una siesta, claro que sí!"',
      pathIronias + 'dormirclase.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente es un buen lugar y momento para echar una siesta.",
      0,
      id_P5);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente no es un buen lugar y momento para echar una siesta.",
      0,
      id_P5);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente es un buen lugar y momento para echar una siesta.",
      0,
      id_P5);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente no es un buen lugar y momento para echar una siesta.",
      1,
      id_P5);

  int id_P6 = await insertSituacionIroniaInitialData(
      database,
      'Una profesora está dando clase tranquilamente hasta que se encuentra a una alumna durmiendo. '
      'La profesora para de dar clase y dice: "Débeis de dormir en casa y no en clase".',
      pathIronias + 'dormirclase.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente los alumnos y alumnas deben de dormir en casa y no en clase.",
      1,
      id_P6);
  insertRespuestaIronia(
      database,
      "No es una ironía, realmente los alumnos y alumnas deben de dormir en clase y no en casa.",
      0,
      id_P6);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente los alumnos y alumnas deben de dormir en clase y no en casa.",
      0,
      id_P6);
  insertRespuestaIronia(
      database,
      "Es una ironía, realmente los alumnos y alumnas deben de dormir en casa y no en clase.",
      0,
      id_P6);

  int id_P7 = await insertSituacionIroniaInitialData(
      database,
      'Luisa y su amiga Carmen han ido a la bolera por la tarde. En su primer lanzamiento de la tarde Luisa'
      ' ha hecho un pleno. Carmen dice: ¡Wow, qué buen tiro!',
      pathIronias + 'bolos.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente ha sido un buen tiro.", 1, id_P7);
  insertRespuestaIronia(
      database, "No es una ironía, realmente ha sido un mal tiro", 0, id_P7);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha sido un buen tiro.", 0, id_P7);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha sido un mal tiro.", 0, id_P7);

  int id_P8 = await insertSituacionIroniaInitialData(
      database,
      'Juanjo y su amigo Martín han ido a la bolera por la tarde. En su primer lanzamiento de la tarde Martín'
      ' no ha tirado ni un solo bolo. Juanjo dice: ¡Caray, qué buen tiro!',
      pathIronias + 'bolos2.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente ha sido un buen tiro.", 0, id_P8);
  insertRespuestaIronia(
      database, "No es una ironía, realmente ha sido un mal tiro", 0, id_P8);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha sido un buen tiro.", 0, id_P8);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha sido un mal tiro.", 1, id_P8);

  int id_P9 = await insertSituacionIroniaInitialData(
      database,
      'Fran va caminando tranquilamente y sin darse cuenta pisa una cagada de perro que estaba en su camino. '
      'Fran dice: "¡Qué buena suerte la mía!',
      pathIronias + 'caca.png',
      grupoAdolescencia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente ha tenido mala suerte.", 0, id_P9);
  insertRespuestaIronia(
      database, "No es una ironía, realmente ha tenido buena suerte", 0, id_P9);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha tenido buena suerte.", 0, id_P9);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha tenido mala suerte.", 1, id_P9);

  int id_P10 = await insertSituacionIroniaInitialData(
      database,
      'Luisa va caminando tranquilamente y de repente se encuentra un billete de 10 euros. '
      'Luisa dice: "¡Qué buena suerte la mía!',
      pathIronias + 'caca.png',
      grupoAdolescencia);
  insertRespuestaIronia(database,
      "No es una ironía, realmente ha tenido mala suerte.", 0, id_P10);
  insertRespuestaIronia(database,
      "No es una ironía, realmente ha tenido buena suerte", 1, id_P10);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha tenido buena suerte.", 0, id_P10);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha tenido mala suerte.", 0, id_P10);
}
