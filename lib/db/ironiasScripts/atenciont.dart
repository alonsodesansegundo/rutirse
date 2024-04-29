// PREGUNTAS IRONIAS PARA EL GRUPO DE ATENCIÓN T.
import 'package:TresEnUno/db/obj/respuestaIronia.dart';
import 'package:sqflite/sqflite.dart';

import '../obj/situacionIronia.dart';

String pathIronias = 'assets/img/ironias/';

void insertIroniasInitialDataAtencionT(Database database) async {
  int grupoAtencionT = 1;

  int id_P1 = await insertSituacionIroniaInitialData(database,
      '¡Qué alegría, qué buen día!', pathIronias + 'sol.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 1, id_P1);
  insertRespuestaIronia(database, "Sí, es una ironía.", 0, id_P1);

  int id_P2 = await insertSituacionIroniaInitialData(
      database,
      '¡Qué alegría, qué buen día!',
      pathIronias + 'lluvia.png',
      grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 0, id_P2);
  insertRespuestaIronia(database, "Sí, es una ironía.", 1, id_P2);

  int id_P3 = await insertSituacionIroniaInitialData(database,
      '¡Qué frío hace hoy!', pathIronias + 'calor.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 0, id_P3);
  insertRespuestaIronia(database, "Sí, es una ironía.", 1, id_P3);

  int id_P4 = await insertSituacionIroniaInitialData(database,
      '¡Qué frío hace hoy!', pathIronias + 'frio.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 1, id_P4);
  insertRespuestaIronia(database, "Sí, es una ironía.", 0, id_P4);

  int id_P5 = await insertSituacionIroniaInitialData(database,
      '¡Qué calor hace hoy!', pathIronias + 'frio.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 0, id_P5);
  insertRespuestaIronia(database, "Sí, es una ironía.", 1, id_P5);

  int id_P6 = await insertSituacionIroniaInitialData(database,
      '¡Qué calor hace hoy!', pathIronias + 'calor.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 1, id_P6);
  insertRespuestaIronia(database, "Sí, es una ironía.", 0, id_P6);

  int id_P7 = await insertSituacionIroniaInitialData(
      database, '¡Qué mal día hace!', pathIronias + 'sol.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 0, id_P7);
  insertRespuestaIronia(database, "Sí, es una ironía.", 1, id_P7);

  int id_P8 = await insertSituacionIroniaInitialData(database,
      '¡Qué mal día hace!', pathIronias + 'lluvia.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 1, id_P8);
  insertRespuestaIronia(database, "Sí, es una ironía.", 0, id_P8);

  int id_P9 = await insertSituacionIroniaInitialData(database,
      '¡Qué lento va el caracol!', pathIronias + 'caracol.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 1, id_P9);
  insertRespuestaIronia(database, "Sí, es una ironía.", 0, id_P9);

  int id_P10 = await insertSituacionIroniaInitialData(
      database,
      '¡Qué rápido va el caracol!',
      pathIronias + 'caracol.png',
      grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 0, id_P10);
  insertRespuestaIronia(database, "Sí, es una ironía.", 1, id_P10);
}
