// PREGUNTAS RUTINAS PARA EL GRUPO DE LA INFANCIA
import 'package:sqflite/sqflite.dart';

import '../obj/accion.dart';
import '../obj/pregunta.dart';

void insertPreguntasAccionesInfancia(Database database) async {
  int grupoInfancia = 2;

  // LAVAR DIENTES
  int id_P1 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer la fontanera María para lavarse los dientes.',
      'fontanera.png',
      grupoInfancia);
  insertAccion(database, "Coger cepillo", 0, "1.LavarDientes.png", id_P1);
  insertAccion(
      database, "Echar pasta de dientes", 1, "2.LavarDientes.png", id_P1);
  insertAccion(database, "Cepillarse", 2, "3.LavarDientes.png", id_P1);
  insertAccion(database, "Lavar cepillo", 3, "4.LavarDientes.png", id_P1);
  insertAccion(database, "Guardar cepillo", 4, "5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si tuviera pelo y quisiera peinarse.',
      'fontanera.png',
      grupoInfancia);
  insertAccion(database, 'Coger el peine', 0, '6.CogerPeine.png', id_P2);
  insertAccion(database, 'Peinarse', 1, '7.Peinarse.png', id_P2);
  insertAccion(database, 'Guardar el peine', 2, '8.GuardarPeine.png', id_P2);

  // LAVAR CARA
  int id_P3 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera lavarse la cara.',
      'fontanera.png',
      grupoInfancia);

  insertAccion(database, 'Abrir grifo', 0, '9.AbrirGrifo.png', id_P3);
  insertAccion(database, 'Mojar manos', 1, '10.MojarManos.png', id_P3);
  insertAccion(database, 'Cerrar grifo', 2, '11.CerrarGrifo.png', id_P3);
  insertAccion(database, 'Lavar cara', 3, '12.LavarCara.png', id_P3);
  insertAccion(database, 'Secar cara', 4, '13.SecarCara.png', id_P3);
  insertAccion(database, 'Secar manos', 5, '14.SecarManos.png', id_P3);

  // CALZARSE
  int id_P4 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera calzarse.',
      'fontanera.png',
      grupoInfancia);
  insertAccion(
      database, 'Poner calcetines', 0, '15.PonerCalcetines.png', id_P4);
  insertAccion(database, 'Poner calzado', 1, '16.PonerCalzado.png', id_P4);
  insertAccion(database, 'Atar cordones', 2, '17.AtarCalzado.png', id_P4);

  // PONER PARTE DE ARRIBA
  int id_P5 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera vestirse la parte de arriba.',
      'chico.png',
      grupoInfancia);
  insertAccion(database, 'Coger camiseta', 0, '18.CogerCamiseta.png', id_P5);
  insertAccion(database, 'Poner camiseta', 1, '19.PonerCamiseta.png', id_P5);
  insertAccion(database, 'Coger sudadera', 2, '20.CogerSudadera.png', id_P5);
  insertAccion(database, 'Poner sudadera', 3, '21.PonerSudadera.png', id_P5);

  int id_P6 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera desvestirse la parte de arriba.',
      'chico.png',
      grupoInfancia);
  insertAccion(database, 'Quitar sudadera', 0, '22.QuitarSudadera.png', id_P6);
  insertAccion(database, 'Quitar camiseta', 1, '19.PonerCamiseta.png', id_P6);

  // QUITAR PARTE DE ARRIBA

  // PONER PARTE DE ABAJO
}
