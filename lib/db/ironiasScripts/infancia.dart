// PREGUNTAS IRONIAS PARA EL GRUPO DE LA INFANCIA
import 'package:sqflite/sqflite.dart';

import '../obj/respuestaIronia.dart';
import '../obj/situacionIronia.dart';

String pathIronias = 'assets/img/ironias/';

void insertIroniasInitialDataInfancia(Database database) async {
  int grupoInfancia = 2;

  int id_P1 = await insertSituacionIroniaInitialData(
      database,
      'Es un día de invierno, una madre ve que su hijo está a punto de salir de casa.'
      'La madre dice: "¡No te vayas a desabrigues que hace frío!"',
      pathIronias + 'frio.png',
      grupoInfancia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente hace frío.", 1, id_P1);
  insertRespuestaIronia(
      database, "Es una ironía, realmente no hace frío.", 0, id_P1);

  int id_P2 = await insertSituacionIroniaInitialData(
      database,
      'Es un día de verano, un padre ve a su hija que está a punto de salir de casa.'
      'El padre dice: "¡No te vayas a desabrigar que hace frío!"',
      pathIronias + 'calor.png',
      grupoInfancia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente hace frío.", 0, id_P2);
  insertRespuestaIronia(
      database, "Es una ironía, realmente no hace frío, hace calor.", 1, id_P2);

  int id_P3 = await insertSituacionIroniaInitialData(
      database,
      'Un padre entra a la habitación de su hija, la cual está estudiando. '
      'El padre dice: "¡Caray, cuánto estudiamos!"',
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
      'Una madre entra a la habitación de su hijo, el cual está jugando. '
      'La madre dice: "¡Caray, cuánto estudiamos!"',
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

  int id_P5 = await insertSituacionIroniaInitialData(
      database,
      'Un padre entra en la habitación de su hija y ve todo desordenado.'
      'El padre dice: ¡Qué desorden, dios mío!',
      pathIronias + 'desordenado.png',
      grupoInfancia);
  insertRespuestaIronia(
      database,
      "No es una ironía, la verdad es que la habitación está ordenada.",
      0,
      id_P5);
  insertRespuestaIronia(
      database,
      "No es una ironía, la verdad es que la habitación está desordenada.",
      1,
      id_P5);

  int id_P6 = await insertSituacionIroniaInitialData(
      database,
      'A una persona se le cae un jarrón, con la suerte de que el jarrón no se rompe. '
      'La persona al ver el jarrón intacto dice: "Uf, ¡qué buena suerte he tenido!"',
      pathIronias + 'jarron.png',
      grupoInfancia);
  insertRespuestaIronia(
      database, "No es una ironía, realmente ha tenido mala suerte.", 0, id_P6);
  insertRespuestaIronia(database,
      "No es una ironía, realmente ha tenido buena suerte.", 1, id_P6);

  int id_P7 = await insertSituacionIroniaInitialData(
      database,
      'A una persona se le cae un jarrón, con tan mala suerte que el jarrón se rompe. '
      'La persona al ver el jarrón roto dice: "Caray, ¡qué buena suerte la mía!"',
      pathIronias + 'jarronroto.png',
      grupoInfancia);
  insertRespuestaIronia(database,
      "No es una ironía, realmente ha tenido buena suerte.", 0, id_P7);
  insertRespuestaIronia(
      database, "Es una ironía, realmente ha tenido mala suerte.", 1, id_P7);

  int id_P8 = await insertSituacionIroniaInitialData(
      database,
      'Pepe ha visto una película de miedo por la tarde y ahora se encuentra en cama sin ser capaz de dormir.'
      'Pepe piensa: "No debí ver esa película de miedo".',
      pathIronias + 'despierto.png',
      grupoInfancia);
  insertRespuestaIronia(
      database,
      "No es una ironía, ver esa película de miedo no fue una buena idea.",
      1,
      id_P8);
  insertRespuestaIronia(database,
      "Es una ironía, ver esa película de miedo fue una buena idea.", 0, id_P8);

  int id_P9 = await insertSituacionIroniaInitialData(
      database,
      'María ha visto una película de miedo por la tarde y ahora se encuentra en cama sin ser capaz de dormir.'
      'María piensa: "¡Qué buena idea ver esa película de miedo!".',
      pathIronias + 'despierto.png',
      grupoInfancia);
  insertRespuestaIronia(
      database,
      "No es una ironía, ver esa película de miedo fue una buena idea.",
      0,
      id_P9);
  insertRespuestaIronia(
      database,
      "Es una ironía, ver esa película de miedo no fue una buena idea.",
      1,
      id_P9);

  int id_P10 = await insertSituacionIroniaInitialData(
      database,
      'Una madre entra en la habitación de su hijo y ve todo desordenado.'
      'La madre dice: ¡Qué ordenado está todo!',
      pathIronias + 'desordenado.png',
      grupoInfancia);
  insertRespuestaIronia(
      database,
      "No es una ironía, la verdad es que la habitación está ordenada.",
      0,
      id_P10);
  insertRespuestaIronia(
      database,
      "Es una ironía, la verdad es que la habitación está desordenada.",
      1,
      id_P10);
}
