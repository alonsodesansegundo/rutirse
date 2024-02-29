// PREGUNTAS RUTINAS PARA EL GRUPO DE ATENCIÓN T.
import 'package:sqflite/sqflite.dart';

import '../obj/accion.dart';
import '../obj/pregunta.dart';

String pathRutinas = 'assets/img/rutinas/';

void insertPreguntasAccionesAtencionT(Database database) async {
  int grupoAtencionT = 1;

  // LAVAR DIENTES
  int id_P1 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer Pepe para lavarse los dientes.',
      'cerdo.png',
      grupoAtencionT);
  insertAccion(database, "Echar pasta de dientes", 0,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
  insertAccion(database, "Cepillarse", 1,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
  insertAccion(database, "Lavar cepillo", 2,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);
  insertAccion(database, "Guardar cepillo", 3,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si tuviera pelo y quisiera peinarse.',
      'cerdo.png',
      grupoAtencionT);
  insertAccion(database, 'Coger el peine', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P2);
  insertAccion(database, 'Peinarse', 1,
      pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P2);
  insertAccion(database, 'Guardar el peine', 2,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P2);

  // LAVAR CARA
  int id_P3 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera lavarse la cara.',
      'cerdo.png',
      grupoAtencionT);

  insertAccion(database, 'Abrir grifo', 0,
      pathRutinas + "higiene/lavarCara/1.AbrirGrifo.png", id_P3);
  insertAccion(database, 'Lavar cara', 1,
      pathRutinas + "higiene/lavarCara/4.LavarCara.png", id_P3);
  insertAccion(database, 'Cerrar grifo', 2,
      pathRutinas + "higiene/lavarCara/3.CerrarGrifo.png", id_P3);
  insertAccion(database, 'Secarse', 3,
      pathRutinas + "higiene/lavarCara/7.Toalla.png", id_P3);

  // CALZARSE
  int id_P4 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera calzarse.',
      'cerdo.png',
      grupoAtencionT);
  insertAccion(database, 'Poner calcetines', 0,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P4);
  insertAccion(database, 'Poner calzado', 1,
      pathRutinas + "vestimenta/calzarse/2.PonerCalzado.png", id_P4);
  insertAccion(database, 'Atar cordones', 2,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P4);

  // PONER PARTE DE ARRIBA
  int id_P5 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera vestirse la parte de arriba.',
      'chico.png',
      grupoAtencionT);
  insertAccion(database, 'Poner camiseta', 0,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P5);
  insertAccion(database, 'Poner sudadera', 1,
      pathRutinas + "vestimenta/ponerParteArriba/4.PonerSudadera.png", id_P5);

  // QUITAR PARTE DE ARRIBA
  int id_P6 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera desvestirse la parte de arriba.',
      'chico.png',
      grupoAtencionT);
  insertAccion(database, 'Quitar sudadera', 0,
      pathRutinas + "vestimenta/ponerParteArriba/5.QuitarSudadera.png", id_P6);
  insertAccion(database, 'Quitar camiseta', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P6);

  // PONER PARTE DE ABAJO
  int id_P7 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que hay que hacer para ponernos la ropa de abajo.',
      'ambos.png',
      grupoAtencionT);
  insertAccion(database, 'Poner ropa interior', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/2.RopaPuesta.png", id_P7);
  insertAccion(database, 'Poner pantalón', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/4.SubirPantalon.png", id_P7);

  // QUITAR PARTE DE ABAJO
  int id_P8 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que hay que hacer para quitarnos la parte de abajo.',
      'chico.png',
      grupoAtencionT);
  insertAccion(database, 'Quitar pantalón', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/5.BajarPantalon.png", id_P8);
  insertAccion(database, 'Quitar ropa interior', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/6.BajarRopa.png", id_P8);

  // HACER COMPRA
  int id_P9 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestra amiga Paula cuando va a hacer la compra.',
      'chica.png',
      grupoAtencionT);
  insertAccion(database, 'Coger cesta o carro', 0,
      pathRutinas + "vidaSocial/hacerCompra/1.CogerCestaCarro.png", id_P9);
  insertAccion(database, 'Buscar productos', 1,
      pathRutinas + "vidaSocial/hacerCompra/3.BuscarProducto.png", id_P9);
  insertAccion(database, 'Guardar en la cesta', 2,
      pathRutinas + "vidaSocial/hacerCompra/8.GuardarComida.png", id_P9);
  insertAccion(database, 'Hacer cola', 3,
      pathRutinas + "vidaSocial/hacerCompra/4.HacerFila.png", id_P9);
  insertAccion(database, 'Pagar', 4,
      pathRutinas + "vidaSocial/hacerCompra/5.Pagar.png", id_P9);

  // IR AL PARQUE
  int id_P10 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para ir al parque.',
      'ambos.png',
      grupoAtencionT);
  insertAccion(database, 'Ir al parque', 0,
      pathRutinas + "vidaSocial/parque/2.Ir.png", id_P10);
  insertAccion(database, '¿Podemos jugar?', 1,
      pathRutinas + "vidaSocial/parque/3.Preguntar.png", id_P10);
  insertAccion(database, 'Jugar', 2,
      pathRutinas + "vidaSocial/parque/4.Jugar.png", id_P10);

  // MOCHILA PISCINA

  // MOCHILA COLE

  // IR AL BAÑO
}
