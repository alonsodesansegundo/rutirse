// PREGUNTAS IRONIAS PARA EL GRUPO DE LA INFANCIA
import 'package:sqflite/sqflite.dart';

import '../obj/respuestaIronia.dart';
import '../obj/situacionIronia.dart';

String pathIronias = 'assets/img/ironias/';

void insertIroniasInitialDataInfancia(Database database) async {
  int grupoInfancia = 2;

  int id_P1 = await insertSituacionIroniaInitialData(
      database,
      '¡No te vayas a desabrigar que hace frío!',
      pathIronias + 'frio.png',
      grupoInfancia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente hace frío.", 1, id_P1);
  insertRespuestaIronia(
      database, "Es una ironía, realmente no hace frío.", 0, id_P1);

  int id_P2 = await insertSituacionIroniaInitialData(
      database,
      '¡No te vayas a desabrigar que hace frío!',
      pathIronias + 'calor.png',
      grupoInfancia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente hace frío.", 0, id_P2);
  insertRespuestaIronia(
      database, "Es una ironía, realmente no hace frío, hace calor.", 1, id_P2);

  int id_P3 = await insertSituacionIroniaInitialData(
      database,
      'Un padre entra a la habitación de su hija, la cual está estudiando. El padre dice: ¡Caray, cuanto estudiamos!',
      pathIronias + 'estudiar.png',
      grupoInfancia);
  insertRespuestaIronia(
      database,
      "No es una ironía, el padre realmente está soprendido de lo mucho que estudia su hija.",
      1,
      id_P3);
  insertRespuestaIronia(
      database,
      "Es una ironía, el padre realmente quiere decir que su hija debería de estar estudiando.",
      0,
      id_P3);

  int id_P4 = await insertSituacionIroniaInitialData(
      database,
      'Una madre entra a la habitación de su hijo, el cual está jugando. La madre dice: ¡Caray, cuanto estudiamos!',
      pathIronias + 'jugar.png',
      grupoInfancia);
  insertRespuestaIronia(
      database,
      "No es una ironía, la madre realmente está soprendida de lo mucho que estudia su hijo.",
      0,
      id_P4);
  insertRespuestaIronia(
      database,
      "Es una ironía, la madre realmente quiere decir que su hijo debería de estar estudiando.",
      1,
      id_P4);
}
