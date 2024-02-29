// PREGUNTAS RUTINAS PARA EL GRUPO DE LA INFANCIA
import 'package:sqflite/sqflite.dart';

import '../obj/accion.dart';
import '../obj/pregunta.dart';

String pathRutinas = 'assets/img/rutinas/';

void insertPreguntasAccionesInfancia(Database database) async {
  int grupoInfancia = 2;

  // LAVAR DIENTES
  int id_P1 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer la fontanera María para lavarse los dientes.',
      'fontanera.png',
      grupoInfancia);
  insertAccion(database, "Coger cepillo", 0,
      pathRutinas + "higiene/lavarDientes/1.LavarDientes.png", id_P1);
  insertAccion(database, "Coger pasta de dientes", 1,
      pathRutinas + "higiene/lavarDientes/6.LavarDientes.png", id_P1);
  insertAccion(database, "Echar pasta de dientes", 2,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
  insertAccion(database, "Cepillarse", 3,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
  insertAccion(database, "Lavar cepillo", 4,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);
  insertAccion(database, "Guardar cepillo", 5,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si tuviera pelo y quisiera peinarse.',
      'fontanera.png',
      grupoInfancia);
  insertAccion(database, 'Coger el peine', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P2);
  insertAccion(database, 'Peinarse', 1,
      pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P2);
  insertAccion(database, 'Limpiar peine', 2,
      pathRutinas + "higiene/peinarse/4.LimpiarPeine.png", id_P2);
  insertAccion(database, 'Guardar el peine', 3,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P2);

  // LAVAR CARA
  int id_P3 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera lavarse la cara.',
      'fontanera.png',
      grupoInfancia);

  insertAccion(database, 'Abrir grifo', 0,
      pathRutinas + "higiene/lavarCara/1.AbrirGrifo.png", id_P3);
  insertAccion(database, 'Mojar manos', 1,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P3);
  insertAccion(database, 'Lavar cara', 2,
      pathRutinas + "higiene/lavarCara/4.LavarCara.png", id_P3);
  insertAccion(database, 'Cerrar grifo', 3,
      pathRutinas + "higiene/lavarCara/3.CerrarGrifo.png", id_P3);
  insertAccion(database, 'Secar cara', 4,
      pathRutinas + "higiene/lavarCara/5.SecarCara.png", id_P3);
  insertAccion(database, 'Secar manos', 5,
      pathRutinas + "higiene/lavarCara/6.SecarManos.png", id_P3);

  // CALZARSE
  int id_P4 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer Pepe si quisiera calzarse.',
      'fontanera.png',
      grupoInfancia);
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
      grupoInfancia);
  insertAccion(database, 'Coger camiseta', 0,
      pathRutinas + "vestimenta/ponerParteArriba/1.CogerCamiseta.png", id_P5);
  insertAccion(database, 'Poner camiseta', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P5);
  insertAccion(database, 'Coger sudadera', 2,
      pathRutinas + "vestimenta/ponerParteArriba/3.CogerSudadera.png", id_P5);
  insertAccion(database, 'Poner sudadera', 3,
      pathRutinas + "vestimenta/ponerParteArriba/4.PonerSudadera.png", id_P5);

  // QUITAR PARTE DE ARRIBA
  int id_P6 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera desvestirse la parte de arriba.',
      'chico.png',
      grupoInfancia);
  insertAccion(database, 'Quitar sudadera', 0,
      pathRutinas + "vestimenta/ponerParteArriba/5.QuitarSudadera.png", id_P6);
  insertAccion(database, 'Quitar camiseta', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P6);
  insertAccion(database, 'Guardar ropa', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P6);

  // PONER PARTE DE ABAJO
  int id_P7 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que hay que hacer para poner la ropa interior.',
      'ambos.png',
      grupoInfancia);
  insertAccion(database, 'Coger ropa interior', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/1.CogerRopa.png", id_P7);
  insertAccion(database, 'Poner ropa interior', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/2.RopaPuesta.png", id_P7);
  insertAccion(database, 'Coger pantalón', 2,
      pathRutinas + "vestimenta/ponerParteAbajo/3.CogerPantalon.png", id_P7);
  insertAccion(database, 'Poner pantalón', 3,
      pathRutinas + "vestimenta/ponerParteAbajo/4.SubirPantalon.png", id_P7);

  // QUITAR PARTE DE ABAJO
  int id_P8 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que hay que hacer para quitarnos la parte de abajo.',
      'chico.png',
      grupoInfancia);
  insertAccion(database, 'Quitar pantalón', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/5.BajarPantalon.png", id_P8);
  insertAccion(database, 'Quitar ropa interior', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/6.BajarRopa.png", id_P8);
  insertAccion(database, 'Guardar ropa', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P8);

  // HACER COMPRA
  int id_P9 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestra amiga Paula cuando va a hacer la compra.',
      'chica.png',
      grupoInfancia);
  insertAccion(database, 'Hacer lista de la compra', 0,
      pathRutinas + "vidaSocial/hacerCompra/2.HacerLista.png", id_P9);
  insertAccion(database, 'Ir al supermercado', 1,
      pathRutinas + "vidaSocial/hacerCompra/9.Supermercado.png", id_P9);
  insertAccion(database, 'Coger cesta o carro', 2,
      pathRutinas + "vidaSocial/hacerCompra/1.CogerCestaCarro.png", id_P9);
  insertAccion(database, 'Buscar productos', 3,
      pathRutinas + "vidaSocial/hacerCompra/3.BuscarProducto.png", id_P9);
  insertAccion(database, 'Guardar en la cesta', 4,
      pathRutinas + "vidaSocial/hacerCompra/8.GuardarComida.png", id_P9);
  insertAccion(database, 'Hacer cola', 5,
      pathRutinas + "vidaSocial/hacerCompra/4.HacerFila.png", id_P9);
  insertAccion(database, 'Saludar al cajero/a', 6,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P9);
  insertAccion(database, 'Pagar', 7,
      pathRutinas + "vidaSocial/hacerCompra/5.Pagar.png", id_P9);
  insertAccion(database, 'Decir adiós al cajero/a', 8,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P9);

  // IR AL PARQUE
  int id_P10 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para ir al parque.',
      'ambos.png',
      grupoInfancia);

  insertAccion(database, 'Escoger juguete', 0,
      pathRutinas + "vidaSocial/parque/1.Escoger.png", id_P10);
  insertAccion(database, 'Ir al parque', 1,
      pathRutinas + "vidaSocial/parque/2.Ir.png", id_P10);
  insertAccion(database, 'Decir hola', 2,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P10);
  insertAccion(database, '¿Podemos jugar?', 3,
      pathRutinas + "vidaSocial/parque/3.Preguntar.png", id_P10);
  insertAccion(database, 'Jugar', 4,
      pathRutinas + "vidaSocial/parque/4.Jugar.png", id_P10);
  insertAccion(database, 'Decir adios', 5,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P10);

  // MOCHILA PISCINA

  // MOCHILA COLE

  // IR AL BAÑO
}
