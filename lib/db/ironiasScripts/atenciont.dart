// PREGUNTAS IRONIAS PARA EL GRUPO DE ATENCIÓN T.
import 'package:TresEnUno/db/obj/respuestaIronia.dart';
import 'package:sqflite/sqflite.dart';

import '../obj/situacionIronia.dart';

String pathIronias = 'assets/img/ironias/';

void insertIroniasInitialDataAtencionT(Database database) async {
  int grupoAtencionT = 1;

  int id_P1 = await insertSituacionIroniaInitialData(database,
      '¡Qué alegría, que buen día!', pathIronias + 'sol.png', grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 1, id_P1);
  insertRespuestaIronia(database, "Sí, es una ironía.", 0, id_P1);

  int id_P2 = await insertSituacionIroniaInitialData(
      database,
      '¡Qué alegría, que buen día!',
      pathIronias + 'lluvia.png',
      grupoAtencionT);
  insertRespuestaIronia(database, "No, no es una ironía.", 0, id_P2);
  insertRespuestaIronia(database, "Sí, es una ironía.", 1, id_P2);
}
