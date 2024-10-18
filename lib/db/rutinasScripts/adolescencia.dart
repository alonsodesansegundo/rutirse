// PREGUNTAS RUTINAS PARA EL GRUPO DE ADOLESCENTES
import 'package:sqflite/sqflite.dart';

import '../obj/accion.dart';
import '../obj/situacionRutina.dart';

///Path correspondiente a donde se almacenan las imágenes de las preguntas del juego Rutinas
String pathRutinas = 'assets/img/rutinas/';

///Path correspondiente a donde se almacenan las imágenes de los personajes del juego Rutinas
String pathPersonaje = 'assets/img/personajes/';

///Método encargado de las insercciones de preguntas predeterminadas para el juego Rutinas del grupo Adolescencia
///<br><b>Parámetros</b><br>
///[database] Objeto Database sobre la cual se ejecutan las insercciones
void insertPreguntaRutinaInitialDataAdolescencia(Database database) async {
  int grupoAdolescencia = 2;

  // LAVAR DIENTES
  int id_P1 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer el bailador Adrián para lavarse los dientes.',
      pathPersonaje + 'bailador.png',
      grupoAdolescencia);
  insertAccionInitialData(database, "", 0,
      pathRutinas + "higiene/lavarDientes/1.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "", 1,
      pathRutinas + "higiene/lavarDientes/6.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "", 2,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "", 3,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "", 4,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "", 5,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer la bailarina Marina para peinarse.',
      pathPersonaje + 'bailarina.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P2);
  insertAccionInitialData(
      database, '', 1, pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P2);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "higiene/peinarse/4.LimpiarPeine.png", id_P2);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P2);

  // LAVAR CARA
  int id_P3 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer la abuela Carmen para lavarse la cara.',
      pathPersonaje + 'abuela.png',
      grupoAdolescencia);

  insertAccionInitialData(database, '', 0,
      pathRutinas + "higiene/lavarCara/1.AbrirGrifo.png", id_P3);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P3);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "higiene/lavarCara/4.LavarCara.png", id_P3);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "higiene/lavarCara/3.CerrarGrifo.png", id_P3);
  insertAccionInitialData(database, '', 4,
      pathRutinas + "higiene/lavarCara/5.SecarCara.png", id_P3);
  insertAccionInitialData(database, '', 5,
      pathRutinas + "higiene/lavarCara/6.SecarManos.png", id_P3);

  // CALZARSE
  int id_P4 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer el futbolista David para calzarse.',
      pathPersonaje + 'futbolista2.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P4);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vestimenta/calzarse/2.PonerCalzado.png", id_P4);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P4);

  // PONER PARTE DE ARRIBA
  int id_P5 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera vestirse la parte de arriba.',
      pathPersonaje + 'chico.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "vestimenta/ponerParteArriba/1.CogerCamiseta.png", id_P5);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P5);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vestimenta/ponerParteArriba/3.CogerSudadera.png", id_P5);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "vestimenta/ponerParteArriba/4.PonerSudadera.png", id_P5);

  // QUITAR PARTE DE ARRIBA
  int id_P6 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tendría que hacer nuestro amigo Jaime si quisiera desvestirse la parte de arriba.',
      pathPersonaje + 'chico.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "vestimenta/ponerParteArriba/5.QuitarSudadera.png", id_P6);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P6);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P6);

  // PONER PARTE DE ABAJO
  int id_P7 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que hay que hacer para poner la parte de abajo.',
      pathPersonaje + 'ambos.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/1.CogerRopa.png", id_P7);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/2.RopaPuesta.png", id_P7);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vestimenta/ponerParteAbajo/3.CogerPantalon.png", id_P7);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "vestimenta/ponerParteAbajo/4.SubirPantalon.png", id_P7);

  // QUITAR PARTE DE ABAJO
  int id_P8 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que hay que hacer para quitarnos la parte de abajo.',
      pathPersonaje + 'ambos.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/5.BajarPantalon.png", id_P8);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/6.BajarRopa.png", id_P8);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P8);

  // HACER COMPRA
  int id_P9 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestra amigo Raúl cuando va a hacer la compra.',
      pathPersonaje + 'chico.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "vidaSocial/hacerCompra/2.HacerLista.png", id_P9);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vidaSocial/hacerCompra/9.Supermercado.png", id_P9);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vidaSocial/hacerCompra/1.CogerCestaCarro.png", id_P9);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "vidaSocial/hacerCompra/3.BuscarProducto.png", id_P9);
  insertAccionInitialData(database, '', 4,
      pathRutinas + "vidaSocial/hacerCompra/8.GuardarComida.png", id_P9);
  insertAccionInitialData(database, '', 5,
      pathRutinas + "vidaSocial/hacerCompra/4.HacerFila.png", id_P9);
  insertAccionInitialData(database, '', 6,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P9);
  insertAccionInitialData(database, '', 7,
      pathRutinas + "vidaSocial/hacerCompra/5.Pagar.png", id_P9);
  insertAccionInitialData(database, '', 8,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P9);

  // IR AL PARQUE
  int id_P10 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tenemos que hacer si queremos ir al parque.',
      pathPersonaje + 'ambos.png',
      grupoAdolescencia);

  insertAccionInitialData(
      database, '', 0, pathRutinas + "vidaSocial/parque/1.Escoger.png", id_P10);
  insertAccionInitialData(
      database, '', 1, pathRutinas + "vidaSocial/parque/2.Ir.png", id_P10);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P10);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "vidaSocial/parque/3.Preguntar.png", id_P10);
  insertAccionInitialData(
      database, '', 4, pathRutinas + "vidaSocial/parque/4.Jugar.png", id_P10);
  insertAccionInitialData(database, '', 5,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P10);

  // IR AL MÉDICO
  int id_P11 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para ir al médico.',
      pathPersonaje + 'ambos.png',
      grupoAdolescencia);

  insertAccionInitialData(
      database, '', 0, pathRutinas + "vidaSocial/medico/5.Ir.png", id_P11);
  insertAccionInitialData(
      database, '', 1, pathRutinas + "vidaSocial/medico/2.Buscar.png", id_P11);
  insertAccionInitialData(
      database, '', 2, pathRutinas + "vidaSocial/medico/1.Saludar.png", id_P11);
  insertAccionInitialData(
      database, '', 3, pathRutinas + "vidaSocial/medico/3.Esperar.png", id_P11);
  insertAccionInitialData(database, '', 4,
      pathRutinas + "vidaSocial/medico/4.Consulta.png", id_P11);

  // MOCHILA COLE
  int id_P12 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer el mago Harry para preparar la mochila del cole.',
      pathPersonaje + 'mago.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "vidaDiaria/mochilaCole/1.Horario.png", id_P12);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vidaDiaria/mochilaCole/6.AbrirMochila.png", id_P12);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vidaDiaria/mochilaCole/2.Libros.png", id_P12);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "vidaDiaria/mochilaCole/3.Cuadernos.png", id_P12);
  insertAccionInitialData(database, '', 4,
      pathRutinas + "vidaDiaria/mochilaCole/4.Estuche.png", id_P12);
  insertAccionInitialData(database, '', 5,
      pathRutinas + "vidaDiaria/mochilaCole/5.Mochila.png", id_P12);
  insertAccionInitialData(database, '', 6,
      pathRutinas + "vidaDiaria/mochilaCole/7.CerrarMochila.png", id_P12);

  // IR AL BAÑO (chico)
  int id_P13 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Pepe para hacer sus necesidades (ir al baño).',
      pathPersonaje + 'chico.png',
      grupoAdolescencia);

  insertAccionInitialData(
      database, '', 0, pathRutinas + "vidaDiaria/irBaño/1.Baño.png", id_P13);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vidaDiaria/irBaño/3.LevantarTapa.png", id_P13);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vidaDiaria/irBaño/6.BajarPantalon.png", id_P13);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "vidaDiaria/irBaño/10.BajarRopaO.png", id_P13);
  insertAccionInitialData(
      database, '', 4, pathRutinas + "vidaDiaria/irBaño/12.Vater.png", id_P13);
  insertAccionInitialData(
      database, '', 5, pathRutinas + "vidaDiaria/irBaño/4.Papel.png", id_P13);
  insertAccionInitialData(database, '', 6,
      pathRutinas + "vidaDiaria/irBaño/2.BajarTapa.png", id_P13);
  insertAccionInitialData(database, '', 7,
      pathRutinas + "vidaDiaria/irBaño/9.TirarCisterna.png", id_P13);
  insertAccionInitialData(database, '', 8,
      pathRutinas + "vidaDiaria/irBaño/13.SubirRopaO.png", id_P13);
  insertAccionInitialData(database, '', 9,
      pathRutinas + "vidaDiaria/irBaño/7.SubirPantalon.png", id_P13);
  insertAccionInitialData(database, '', 10,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P13);

  // IR AL BAÑO (chica)
  int id_P14 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestra amiga Iria para hacer sus necesidades (ir al baño).',
      pathPersonaje + 'chica.png',
      grupoAdolescencia);

  insertAccionInitialData(
      database, '', 0, pathRutinas + "vidaDiaria/irBaño/1.Baño.png", id_P14);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vidaDiaria/irBaño/3.LevantarTapa.png", id_P14);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vidaDiaria/irBaño/15.SubirVestido.png", id_P14);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "vidaDiaria/irBaño/11.BajarRopaA.png", id_P14);
  insertAccionInitialData(
      database, '', 4, pathRutinas + "vidaDiaria/irBaño/12.Vater.png", id_P14);
  insertAccionInitialData(
      database, '', 5, pathRutinas + "vidaDiaria/irBaño/4.Papel.png", id_P14);
  insertAccionInitialData(database, '', 6,
      pathRutinas + "vidaDiaria/irBaño/2.BajarTapa.png", id_P14);
  insertAccionInitialData(database, '', 7,
      pathRutinas + "vidaDiaria/irBaño/9.TirarCisterna.png", id_P14);
  insertAccionInitialData(database, '', 8,
      pathRutinas + "vidaDiaria/irBaño/14.SubirRopaA.png", id_P14);
  insertAccionInitialData(database, '', 9,
      pathRutinas + "vidaDiaria/irBaño/16.BajarVestido.png", id_P14);
  insertAccionInitialData(database, '', 10,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P14);

  // DESCALZARSE
  int id_P15 = await insertSituacionRutinaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer el futbolista David para descalzarse.',
      pathPersonaje + 'futbolista2.png',
      grupoAdolescencia);
  insertAccionInitialData(database, '', 0,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P15);
  insertAccionInitialData(database, '', 1,
      pathRutinas + "vestimenta/calzarse/4.Descalzar.png", id_P15);
  insertAccionInitialData(database, '', 2,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P15);
  insertAccionInitialData(database, '', 3,
      pathRutinas + "vestimenta/calzarse/5.Zapatillas.png", id_P15);
}
