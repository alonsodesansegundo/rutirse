// PREGUNTAS RUTINAS PARA EL GRUPO DE ADOLESCENTES
import 'package:sqflite/sqflite.dart';

import '../obj/accion.dart';
import '../obj/pregunta.dart';

String pathRutinas = 'assets/img/rutinas/';

void insertPreguntasAccionesAdolescencia(Database database) async {
  int grupoAdolescencia = 3;

  // LAVAR DIENTES
  int id_P1 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer la fontanera María para lavarse los dientes.',
      'fontanera.png',
      grupoAdolescencia);
  insertAccion(database, "", 0,
      pathRutinas + "higiene/lavarDientes/1.LavarDientes.png", id_P1);
  insertAccion(database, "", 1,
      pathRutinas + "higiene/lavarDientes/6.LavarDientes.png", id_P1);
  insertAccion(database, "", 2,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
  insertAccion(database, "", 3,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
  insertAccion(database, "", 4,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);
  insertAccion(database, "", 5,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si tuviera pelo y quisiera peinarse.',
      'fontanera.png',
      grupoAdolescencia);
  insertAccion(database, '', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P2);
  insertAccion(
      database, '', 1, pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P2);
  insertAccion(database, '', 2,
      pathRutinas + "higiene/peinarse/4.LimpiarPeine.png", id_P2);
  insertAccion(database, '', 3,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P2);

  // LAVAR CARA
  int id_P3 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera lavarse la cara.',
      'fontanera.png',
      grupoAdolescencia);

  insertAccion(database, '', 0,
      pathRutinas + "higiene/lavarCara/1.AbrirGrifo.png", id_P3);
  insertAccion(database, '', 1,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P3);
  insertAccion(database, '', 2,
      pathRutinas + "higiene/lavarCara/4.LavarCara.png", id_P3);
  insertAccion(database, '', 3,
      pathRutinas + "higiene/lavarCara/3.CerrarGrifo.png", id_P3);
  insertAccion(database, '', 4,
      pathRutinas + "higiene/lavarCara/5.SecarCara.png", id_P3);
  insertAccion(database, '', 5,
      pathRutinas + "higiene/lavarCara/6.SecarManos.png", id_P3);

  // CALZARSE
  int id_P4 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera calzarse.',
      'fontanera.png',
      grupoAdolescencia);
  insertAccion(database, '', 0,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P4);
  insertAccion(database, '', 1,
      pathRutinas + "vestimenta/calzarse/2.PonerCalzado.png", id_P4);
  insertAccion(database, '', 2,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P4);

  // PONER PARTE DE ARRIBA
  int id_P5 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera vestirse la parte de arriba.',
      'chico.png',
      grupoAdolescencia);
  insertAccion(database, '', 0,
      pathRutinas + "vestimenta/ponerParteArriba/1.CogerCamiseta.png", id_P5);
  insertAccion(database, '', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P5);
  insertAccion(database, '', 2,
      pathRutinas + "vestimenta/ponerParteArriba/3.CogerSudadera.png", id_P5);
  insertAccion(database, '', 3,
      pathRutinas + "vestimenta/ponerParteArriba/4.PonerSudadera.png", id_P5);

  // QUITAR PARTE DE ARRIBA
  int id_P6 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera desvestirse la parte de arriba.',
      'chico.png',
      grupoAdolescencia);
  insertAccion(database, '', 0,
      pathRutinas + "vestimenta/ponerParteArriba/5.QuitarSudadera.png", id_P6);
  insertAccion(database, '', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P6);
  insertAccion(database, '', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P6);

  // PONER PARTE DE ABAJO
  int id_P7 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que hay que hacer para poner la ropa interior.',
      'ambos.png',
      grupoAdolescencia);
  insertAccion(database, '', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/1.CogerRopa.png", id_P7);
  insertAccion(database, '', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/2.RopaPuesta.png", id_P7);
  insertAccion(database, '', 2,
      pathRutinas + "vestimenta/ponerParteAbajo/3.CogerPantalon.png", id_P7);
  insertAccion(database, '', 3,
      pathRutinas + "vestimenta/ponerParteAbajo/4.SubirPantalon.png", id_P7);

  // QUITAR PARTE DE ABAJO
  int id_P8 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que hay que hacer para quitarnos la parte de abajo.',
      'chico.png',
      grupoAdolescencia);
  insertAccion(database, '', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/5.BajarPantalon.png", id_P8);
  insertAccion(database, '', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/6.BajarRopa.png", id_P8);
  insertAccion(database, '', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P8);

  // HACER COMPRA
  int id_P9 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestra amiga Paula cuando va a hacer la compra.',
      'chica.png',
      grupoAdolescencia);
  insertAccion(database, '', 0,
      pathRutinas + "vidaSocial/hacerCompra/2.HacerLista.png", id_P9);
  insertAccion(database, '', 1,
      pathRutinas + "vidaSocial/hacerCompra/9.Supermercado.png", id_P9);
  insertAccion(database, '', 2,
      pathRutinas + "vidaSocial/hacerCompra/1.CogerCestaCarro.png", id_P9);
  insertAccion(database, '', 3,
      pathRutinas + "vidaSocial/hacerCompra/3.BuscarProducto.png", id_P9);
  insertAccion(database, '', 4,
      pathRutinas + "vidaSocial/hacerCompra/8.GuardarComida.png", id_P9);
  insertAccion(database, '', 5,
      pathRutinas + "vidaSocial/hacerCompra/4.HacerFila.png", id_P9);
  insertAccion(database, '', 6,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P9);
  insertAccion(database, '', 7,
      pathRutinas + "vidaSocial/hacerCompra/5.Pagar.png", id_P9);
  insertAccion(database, '', 8,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P9);

  // IR AL PARQUE
  int id_P10 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para ir al parque.',
      'ambos.png',
      grupoAdolescencia);

  insertAccion(
      database, '', 0, pathRutinas + "vidaSocial/parque/1.Escoger.png", id_P10);
  insertAccion(
      database, '', 1, pathRutinas + "vidaSocial/parque/2.Ir.png", id_P10);
  insertAccion(database, '', 2,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P10);
  insertAccion(database, '', 3,
      pathRutinas + "vidaSocial/parque/3.Preguntar.png", id_P10);
  insertAccion(
      database, '', 4, pathRutinas + "vidaSocial/parque/4.Jugar.png", id_P10);
  insertAccion(database, '', 5,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P10);

  // MOCHILA PISCINA

  // MOCHILA COLE

  // IR AL BAÑO
}
