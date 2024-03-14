// PREGUNTAS RUTINAS PARA EL GRUPO DE LA INFANCIA
import 'package:sqflite/sqflite.dart';

import '../obj/accion.dart';
import '../obj/pregunta.dart';

String pathRutinas = 'assets/img/rutinas/';
String pathPersonaje = 'assets/img/personajes/';

void insertPreguntaInitialDataInfancia(Database database) async {
  int grupoInfancia = 2;

  // LAVAR DIENTES
  int id_P1 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer la fontanera María para lavarse los dientes.',
      pathPersonaje + 'fontanera.png',
      grupoInfancia);
  insertAccionInitialData(database, "Coger el cepillo", 0,
      pathRutinas + "higiene/lavarDientes/1.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "Coger pasta de dientes", 1,
      pathRutinas + "higiene/lavarDientes/6.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "Echar la pasta de dientes", 2,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "Cepillarse", 3,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "Lavar el cepillo", 4,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);
  insertAccionInitialData(database, "Guardar el cepillo", 5,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer el león Simba para peinarse.',
      pathPersonaje + 'león.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Coger el peine', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P2);
  insertAccionInitialData(database, 'Peinarse', 1,
      pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P2);
  insertAccionInitialData(database, 'Limpiar el peine', 2,
      pathRutinas + "higiene/peinarse/4.LimpiarPeine.png", id_P2);
  insertAccionInitialData(database, 'Guardar el peine', 3,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P2);

  // LAVAR CARA
  int id_P3 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer el mago Harry para lavarse la cara.',
      pathPersonaje + 'mago.png',
      grupoInfancia);

  insertAccionInitialData(database, 'Abrir el grifo', 0,
      pathRutinas + "higiene/lavarCara/1.AbrirGrifo.png", id_P3);
  insertAccionInitialData(database, 'Mojar las manos', 1,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P3);
  insertAccionInitialData(database, 'Lavar la cara', 2,
      pathRutinas + "higiene/lavarCara/4.LavarCara.png", id_P3);
  insertAccionInitialData(database, 'Cerrar el grifo', 3,
      pathRutinas + "higiene/lavarCara/3.CerrarGrifo.png", id_P3);
  insertAccionInitialData(database, 'Secar la cara', 4,
      pathRutinas + "higiene/lavarCara/5.SecarCara.png", id_P3);
  insertAccionInitialData(database, 'Secar las manos', 5,
      pathRutinas + "higiene/lavarCara/6.SecarManos.png", id_P3);

  // CALZARSE
  int id_P4 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer la futbolista Alexia para calzarse.',
      pathPersonaje + 'futbolista.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Poner los calcetines', 0,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P4);
  insertAccionInitialData(database, 'Poner el calzado', 1,
      pathRutinas + "vestimenta/calzarse/2.PonerCalzado.png", id_P4);
  insertAccionInitialData(database, 'Atar los cordones', 2,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P4);

  // PONER PARTE DE ARRIBA
  int id_P5 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Jaime para vestirse la parte de arriba.',
      pathPersonaje + 'chico.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Coger la camiseta', 0,
      pathRutinas + "vestimenta/ponerParteArriba/1.CogerCamiseta.png", id_P5);
  insertAccionInitialData(database, 'Poner la camiseta', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P5);
  insertAccionInitialData(database, 'Coger la sudadera', 2,
      pathRutinas + "vestimenta/ponerParteArriba/3.CogerSudadera.png", id_P5);
  insertAccionInitialData(database, 'Poner la sudadera', 3,
      pathRutinas + "vestimenta/ponerParteArriba/4.PonerSudadera.png", id_P5);

  // QUITAR PARTE DE ARRIBA
  int id_P6 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Jaime para desvestirse la parte de arriba.',
      pathPersonaje + 'chico.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Quitar la sudadera', 0,
      pathRutinas + "vestimenta/ponerParteArriba/5.QuitarSudadera.png", id_P6);
  insertAccionInitialData(database, 'Quitar la camiseta', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P6);
  insertAccionInitialData(database, 'Guardar la ropa', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P6);

  // PONER PARTE DE ABAJO
  int id_P7 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que hay que hacer para poner la parte de abajo.',
      pathPersonaje + 'ambos.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Coger la ropa interior', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/1.CogerRopa.png", id_P7);
  insertAccionInitialData(database, 'Poner la ropa interior', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/2.RopaPuesta.png", id_P7);
  insertAccionInitialData(database, 'Coger el pantalón', 2,
      pathRutinas + "vestimenta/ponerParteAbajo/3.CogerPantalon.png", id_P7);
  insertAccionInitialData(database, 'Poner el pantalón', 3,
      pathRutinas + "vestimenta/ponerParteAbajo/4.SubirPantalon.png", id_P7);

  // QUITAR PARTE DE ABAJO
  int id_P8 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que hay que hacer para quitarnos la parte de abajo.',
      pathPersonaje + 'ambos.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Quitar el pantalón', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/5.BajarPantalon.png", id_P8);
  insertAccionInitialData(database, 'Quitar la ropa interior', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/6.BajarRopa.png", id_P8);
  insertAccionInitialData(database, 'Guardar la ropa', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P8);

  // HACER COMPRA
  int id_P9 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Raúl cuando va a hacer la compra.',
      pathPersonaje + 'chico.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Hacer la lista de la compra', 0,
      pathRutinas + "vidaSocial/hacerCompra/2.HacerLista.png", id_P9);
  insertAccionInitialData(database, 'Ir al supermercado', 1,
      pathRutinas + "vidaSocial/hacerCompra/9.Supermercado.png", id_P9);
  insertAccionInitialData(database, 'Coger la cesta o carro', 2,
      pathRutinas + "vidaSocial/hacerCompra/1.CogerCestaCarro.png", id_P9);
  insertAccionInitialData(database, 'Buscar productos', 3,
      pathRutinas + "vidaSocial/hacerCompra/3.BuscarProducto.png", id_P9);
  insertAccionInitialData(database, 'Guardar en la cesta', 4,
      pathRutinas + "vidaSocial/hacerCompra/8.GuardarComida.png", id_P9);
  insertAccionInitialData(database, 'Hacer cola', 5,
      pathRutinas + "vidaSocial/hacerCompra/4.HacerFila.png", id_P9);
  insertAccionInitialData(database, 'Saludar al cajero/a', 6,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P9);
  insertAccionInitialData(database, 'Pagar', 7,
      pathRutinas + "vidaSocial/hacerCompra/5.Pagar.png", id_P9);
  insertAccionInitialData(database, 'Decir adiós al cajero/a', 8,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P9);

  // IR AL PARQUE
  int id_P10 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tenemos que hacer si queremos ir al parque.',
      pathPersonaje + 'ambos.png',
      grupoInfancia);

  insertAccionInitialData(database, 'Escoger juguete(s)', 0,
      pathRutinas + "vidaSocial/parque/1.Escoger.png", id_P10);
  insertAccionInitialData(database, 'Ir al parque', 1,
      pathRutinas + "vidaSocial/parque/2.Ir.png", id_P10);
  insertAccionInitialData(database, 'Decir hola', 2,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P10);
  insertAccionInitialData(database, '¿Podemos jugar?', 3,
      pathRutinas + "vidaSocial/parque/3.Preguntar.png", id_P10);
  insertAccionInitialData(database, 'Jugar', 4,
      pathRutinas + "vidaSocial/parque/4.Jugar.png", id_P10);
  insertAccionInitialData(database, 'Decir adiós', 5,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P10);

  // IR AL MÉDICO
  int id_P11 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para ir al médico.',
      pathPersonaje + 'ambos.png',
      grupoInfancia);

  insertAccionInitialData(database, 'Ir al centro de salud', 0,
      pathRutinas + "vidaSocial/medico/5.Ir.png", id_P11);
  insertAccionInitialData(database, 'Saludar al llegar', 1,
      pathRutinas + "vidaSocial/medico/1.Saludar.png", id_P11);
  insertAccionInitialData(database, 'Buscar la consulta', 2,
      pathRutinas + "vidaSocial/medico/2.Buscar.png", id_P11);
  insertAccionInitialData(database, 'Esperar', 3,
      pathRutinas + "vidaSocial/medico/3.Esperar.png", id_P11);
  insertAccionInitialData(database, 'Hablar con el médico/a', 4,
      pathRutinas + "vidaSocial/medico/4.Consulta.png", id_P11);

  // MOCHILA COLE
  int id_P12 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer el mago Harry para preparar la mochila del cole.',
      pathPersonaje + 'mago.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Ver el horario', 0,
      pathRutinas + "vidaDiaria/mochilaCole/1.Horario.png", id_P12);
  insertAccionInitialData(database, 'Abrir la mochila', 1,
      pathRutinas + "vidaDiaria/mochilaCole/6.AbrirMochila.png", id_P12);
  insertAccionInitialData(database, 'Preparar libros', 2,
      pathRutinas + "vidaDiaria/mochilaCole/2.Libros.png", id_P12);
  insertAccionInitialData(database, 'Preparar libretas', 3,
      pathRutinas + "vidaDiaria/mochilaCole/3.Cuadernos.png", id_P12);
  insertAccionInitialData(database, 'Preparar estuche', 4,
      pathRutinas + "vidaDiaria/mochilaCole/4.Estuche.png", id_P12);
  insertAccionInitialData(database, 'Guardar todo', 5,
      pathRutinas + "vidaDiaria/mochilaCole/5.Mochila.png", id_P12);
  insertAccionInitialData(database, 'Cerrar la mochila', 6,
      pathRutinas + "vidaDiaria/mochilaCole/7.CerrarMochila.png", id_P12);

  // IR AL BAÑO (chico)
  int id_P13 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer Daniel para hacer sus necesidades (ir al baño).',
      pathPersonaje + 'chico.png',
      grupoInfancia);

  insertAccionInitialData(database, 'Ir al baño', 0,
      pathRutinas + "vidaDiaria/irBaño/1.Baño.png", id_P13);
  insertAccionInitialData(database, 'Levantar la tapa', 1,
      pathRutinas + "vidaDiaria/irBaño/3.LevantarTapa.png", id_P13);
  insertAccionInitialData(database, 'Bajar el pantalón', 2,
      pathRutinas + "vidaDiaria/irBaño/6.BajarPantalon.png", id_P13);
  insertAccionInitialData(database, 'Bajar la ropa interior', 3,
      pathRutinas + "vidaDiaria/irBaño/10.BajarRopaO.png", id_P13);
  insertAccionInitialData(database, 'Hacer sus necesidades', 4,
      pathRutinas + "vidaDiaria/irBaño/12.Vater.png", id_P13);
  insertAccionInitialData(database, 'Limpiarse y tirar el papel', 5,
      pathRutinas + "vidaDiaria/irBaño/4.Papel.png", id_P13);
  insertAccionInitialData(database, 'Bajar la tapa', 6,
      pathRutinas + "vidaDiaria/irBaño/2.BajarTapa.png", id_P13);
  insertAccionInitialData(database, 'Tirar de la cisterna', 7,
      pathRutinas + "vidaDiaria/irBaño/9.TirarCisterna.png", id_P13);
  insertAccionInitialData(database, 'Subir la ropa interior', 8,
      pathRutinas + "vidaDiaria/irBaño/13.SubirRopaO.png", id_P13);
  insertAccionInitialData(database, 'Subir el pantalón', 9,
      pathRutinas + "vidaDiaria/irBaño/7.SubirPantalon.png", id_P13);
  insertAccionInitialData(database, 'Lavarse las manos', 10,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P13);

  int id_P14 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer Isabel para hacer sus necesidades (ir al baño).',
      pathPersonaje + 'chica.png',
      grupoInfancia);

  insertAccionInitialData(database, 'Ir al baño', 0,
      pathRutinas + "vidaDiaria/irBaño/1.Baño.png", id_P14);
  insertAccionInitialData(database, 'Levantar la tapa', 1,
      pathRutinas + "vidaDiaria/irBaño/3.LevantarTapa.png", id_P14);
  insertAccionInitialData(database, 'Bajar el vestido', 2,
      pathRutinas + "vidaDiaria/irBaño/16.BajarVestido.png", id_P14);
  insertAccionInitialData(database, 'Bajar la ropa interior', 3,
      pathRutinas + "vidaDiaria/irBaño/11.BajarRopaA.png", id_P14);
  insertAccionInitialData(database, 'Hacer sus necesidades', 4,
      pathRutinas + "vidaDiaria/irBaño/12.Vater.png", id_P14);
  insertAccionInitialData(database, 'Limpiarse y tirar el papel', 5,
      pathRutinas + "vidaDiaria/irBaño/4.Papel.png", id_P14);
  insertAccionInitialData(database, 'Bajar la tapa', 6,
      pathRutinas + "vidaDiaria/irBaño/2.BajarTapa.png", id_P14);
  insertAccionInitialData(database, 'Tirar de la cisterna', 7,
      pathRutinas + "vidaDiaria/irBaño/9.TirarCisterna.png", id_P14);
  insertAccionInitialData(database, 'Subir la ropa interior', 8,
      pathRutinas + "vidaDiaria/irBaño/14.SubirRopaA.png", id_P14);
  insertAccionInitialData(database, 'Subir el vestido', 9,
      pathRutinas + "vidaDiaria/irBaño/15.SubirVestido.png", id_P14);
  insertAccionInitialData(database, 'Lavarse las manos', 10,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P14);

  // DESCALZARSE
  int id_P15 = await insertPreguntaInitialData(
      database,
      'Por favor, pon en orden lo que tiene que hacer la futbolista Alexia para descalzarse.',
      pathPersonaje + 'futbolista.png',
      grupoInfancia);
  insertAccionInitialData(database, 'Desatar los cordones', 0,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P15);
  insertAccionInitialData(database, 'Quitar el calzado', 1,
      pathRutinas + "vestimenta/calzarse/4.Descalzar.png", id_P15);
  insertAccionInitialData(database, 'Quitar los calcetines', 2,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P15);
  insertAccionInitialData(database, 'Poner las zapatillas', 3,
      pathRutinas + "vestimenta/calzarse/5.Zapatillas.png", id_P15);
}
