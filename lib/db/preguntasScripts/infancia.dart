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
  insertAccion(database, "Coger el cepillo", 0,
      pathRutinas + "higiene/lavarDientes/1.LavarDientes.png", id_P1);
  insertAccion(database, "Coger pasta de dientes", 1,
      pathRutinas + "higiene/lavarDientes/6.LavarDientes.png", id_P1);
  insertAccion(database, "Echar la pasta de dientes", 2,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
  insertAccion(database, "Cepillarse", 3,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
  insertAccion(database, "Lavar el cepillo", 4,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);
  insertAccion(database, "Guardar el cepillo", 5,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer el león Simba para peinarse.',
      'león.png',
      grupoInfancia);
  insertAccion(database, 'Coger el peine', 0,
      pathRutinas + "higiene/peinarse/1.CogerPeine.png", id_P2);
  insertAccion(database, 'Peinarse', 1,
      pathRutinas + "higiene/peinarse/2.Peinarse.png", id_P2);
  insertAccion(database, 'Limpiar el peine', 2,
      pathRutinas + "higiene/peinarse/4.LimpiarPeine.png", id_P2);
  insertAccion(database, 'Guardar el peine', 3,
      pathRutinas + "higiene/peinarse/3.GuardarPeine.png", id_P2);

  // LAVAR CARA
  int id_P3 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer el mago Harry para lavarse la cara.',
      'mago.png',
      grupoInfancia);

  insertAccion(database, 'Abrir el grifo', 0,
      pathRutinas + "higiene/lavarCara/1.AbrirGrifo.png", id_P3);
  insertAccion(database, 'Mojar las manos', 1,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P3);
  insertAccion(database, 'Lavar la cara', 2,
      pathRutinas + "higiene/lavarCara/4.LavarCara.png", id_P3);
  insertAccion(database, 'Cerrar el grifo', 3,
      pathRutinas + "higiene/lavarCara/3.CerrarGrifo.png", id_P3);
  insertAccion(database, 'Secar la cara', 4,
      pathRutinas + "higiene/lavarCara/5.SecarCara.png", id_P3);
  insertAccion(database, 'Secar las manos', 5,
      pathRutinas + "higiene/lavarCara/6.SecarManos.png", id_P3);

  // CALZARSE
  int id_P4 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer la futbolista Alexia para calzarse.',
      'futbolista.png',
      grupoInfancia);
  insertAccion(database, 'Poner los calcetines', 0,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P4);
  insertAccion(database, 'Poner el calzado', 1,
      pathRutinas + "vestimenta/calzarse/2.PonerCalzado.png", id_P4);
  insertAccion(database, 'Atar los cordones', 2,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P4);

  // PONER PARTE DE ARRIBA
  int id_P5 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Jaime para vestirse la parte de arriba.',
      'chico.png',
      grupoInfancia);
  insertAccion(database, 'Coger la camiseta', 0,
      pathRutinas + "vestimenta/ponerParteArriba/1.CogerCamiseta.png", id_P5);
  insertAccion(database, 'Poner la camiseta', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P5);
  insertAccion(database, 'Coger la sudadera', 2,
      pathRutinas + "vestimenta/ponerParteArriba/3.CogerSudadera.png", id_P5);
  insertAccion(database, 'Poner la sudadera', 3,
      pathRutinas + "vestimenta/ponerParteArriba/4.PonerSudadera.png", id_P5);

  // QUITAR PARTE DE ARRIBA
  int id_P6 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Jaime para desvestirse la parte de arriba.',
      'chico.png',
      grupoInfancia);
  insertAccion(database, 'Quitar la sudadera', 0,
      pathRutinas + "vestimenta/ponerParteArriba/5.QuitarSudadera.png", id_P6);
  insertAccion(database, 'Quitar la camiseta', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P6);
  insertAccion(database, 'Guardar la ropa', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P6);

  // PONER PARTE DE ABAJO
  int id_P7 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que hay que hacer para poner la parte de abajo.',
      'ambos.png',
      grupoInfancia);
  insertAccion(database, 'Coger la ropa interior', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/1.CogerRopa.png", id_P7);
  insertAccion(database, 'Poner la ropa interior', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/2.RopaPuesta.png", id_P7);
  insertAccion(database, 'Coger el pantalón', 2,
      pathRutinas + "vestimenta/ponerParteAbajo/3.CogerPantalon.png", id_P7);
  insertAccion(database, 'Poner el pantalón', 3,
      pathRutinas + "vestimenta/ponerParteAbajo/4.SubirPantalon.png", id_P7);

  // QUITAR PARTE DE ABAJO
  int id_P8 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que hay que hacer para quitarnos la parte de abajo.',
      'ambos.png',
      grupoInfancia);
  insertAccion(database, 'Quitar el pantalón', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/5.BajarPantalon.png", id_P8);
  insertAccion(database, 'Quitar la ropa interior', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/6.BajarRopa.png", id_P8);
  insertAccion(database, 'Guardar la ropa', 2,
      pathRutinas + "vestimenta/ponerParteArriba/6.GuardarRopa.png", id_P8);

  // HACER COMPRA
  int id_P9 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Raúl cuando va a hacer la compra.',
      'chico.png',
      grupoInfancia);
  insertAccion(database, 'Hacer la lista de la compra', 0,
      pathRutinas + "vidaSocial/hacerCompra/2.HacerLista.png", id_P9);
  insertAccion(database, 'Ir al supermercado', 1,
      pathRutinas + "vidaSocial/hacerCompra/9.Supermercado.png", id_P9);
  insertAccion(database, 'Coger la cesta o carro', 2,
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
      'Por favor, pon en orden lo que tenemos que hacer si queremos ir al parque.',
      'ambos.png',
      grupoInfancia);

  insertAccion(database, 'Escoger juguete(s)', 0,
      pathRutinas + "vidaSocial/parque/1.Escoger.png", id_P10);
  insertAccion(database, 'Ir al parque', 1,
      pathRutinas + "vidaSocial/parque/2.Ir.png", id_P10);
  insertAccion(database, 'Decir hola', 2,
      pathRutinas + "vidaSocial/hacerCompra/6.Hola.png", id_P10);
  insertAccion(database, '¿Podemos jugar?', 3,
      pathRutinas + "vidaSocial/parque/3.Preguntar.png", id_P10);
  insertAccion(database, 'Jugar', 4,
      pathRutinas + "vidaSocial/parque/4.Jugar.png", id_P10);
  insertAccion(database, 'Decir adiós', 5,
      pathRutinas + "vidaSocial/hacerCompra/7.Adios.png", id_P10);

  // IR AL MÉDICO
  int id_P11 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para ir al médico.',
      'ambos.png',
      grupoInfancia);

  insertAccion(database, 'Ir al centro de salud', 0,
      pathRutinas + "vidaSocial/medico/5.Ir.png", id_P11);
  insertAccion(database, 'Saludar al llegar', 1,
      pathRutinas + "vidaSocial/medico/1.Saludar.png", id_P11);
  insertAccion(database, 'Buscar la consulta', 2,
      pathRutinas + "vidaSocial/medico/2.Buscar.png", id_P11);
  insertAccion(database, 'Esperar', 3,
      pathRutinas + "vidaSocial/medico/3.Esperar.png", id_P11);
  insertAccion(database, 'Hablar con el médico/a', 4,
      pathRutinas + "vidaSocial/medico/4.Consulta.png", id_P11);

  // MOCHILA COLE
  int id_P12 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer el mago Harry para preparar la mochila del cole.',
      'mago.png',
      grupoInfancia);
  insertAccion(database, 'Ver el horario', 0,
      pathRutinas + "vidaDiaria/mochilaCole/1.Horario.png", id_P12);
  insertAccion(database, 'Abrir la mochila', 1,
      pathRutinas + "vidaDiaria/mochilaCole/6.AbrirMochila.png", id_P12);
  insertAccion(database, 'Preparar libros', 2,
      pathRutinas + "vidaDiaria/mochilaCole/2.Libros.png", id_P12);
  insertAccion(database, 'Preparar libretas', 3,
      pathRutinas + "vidaDiaria/mochilaCole/3.Cuadernos.png", id_P12);
  insertAccion(database, 'Preparar estuche', 4,
      pathRutinas + "vidaDiaria/mochilaCole/4.Estuche.png", id_P12);
  insertAccion(database, 'Guardar todo', 5,
      pathRutinas + "vidaDiaria/mochilaCole/5.Mochila.png", id_P12);
  insertAccion(database, 'Cerrar la mochila', 6,
      pathRutinas + "vidaDiaria/mochilaCole/7.CerrarMochila.png", id_P12);

  // IR AL BAÑO (chico)
  int id_P13 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer Daniel para hacer sus necesidades (ir al baño).',
      'chico.png',
      grupoInfancia);

  insertAccion(database, 'Ir al baño', 0,
      pathRutinas + "vidaDiaria/irBaño/1.Baño.png", id_P13);
  insertAccion(database, 'Levantar la tapa', 1,
      pathRutinas + "vidaDiaria/irBaño/3.LevantarTapa.png", id_P13);
  insertAccion(database, 'Bajar el pantalón', 2,
      pathRutinas + "vidaDiaria/irBaño/6.BajarPantalon.png", id_P13);
  insertAccion(database, 'Bajar la ropa interior', 3,
      pathRutinas + "vidaDiaria/irBaño/10.BajarRopaO.png", id_P13);
  insertAccion(database, 'Hacer sus necesidades', 4,
      pathRutinas + "vidaDiaria/irBaño/12.Vater.png", id_P13);
  insertAccion(database, 'Limpiarse y tirar el papel', 5,
      pathRutinas + "vidaDiaria/irBaño/4.Papel.png", id_P13);
  insertAccion(database, 'Bajar la tapa', 6,
      pathRutinas + "vidaDiaria/irBaño/2.BajarTapa.png", id_P13);
  insertAccion(database, 'Tirar de la cisterna', 7,
      pathRutinas + "vidaDiaria/irBaño/9.TirarCisterna.png", id_P13);
  insertAccion(database, 'Subir la ropa interior', 8,
      pathRutinas + "vidaDiaria/irBaño/13.SubirRopaO.png", id_P13);
  insertAccion(database, 'Subir el pantalón', 9,
      pathRutinas + "vidaDiaria/irBaño/7.SubirPantalon.png", id_P13);
  insertAccion(database, 'Lavarse las manos', 10,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P13);

  int id_P14 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer Isabel para hacer sus necesidades (ir al baño).',
      'chica.png',
      grupoInfancia);

  insertAccion(database, 'Ir al baño', 0,
      pathRutinas + "vidaDiaria/irBaño/1.Baño.png", id_P14);
  insertAccion(database, 'Levantar la tapa', 1,
      pathRutinas + "vidaDiaria/irBaño/3.LevantarTapa.png", id_P14);
  insertAccion(database, 'Bajar el vestido', 2,
      pathRutinas + "vidaDiaria/irBaño/16.BajarVestido.png", id_P14);
  insertAccion(database, 'Bajar la ropa interior', 3,
      pathRutinas + "vidaDiaria/irBaño/11.BajarRopaA.png", id_P14);
  insertAccion(database, 'Hacer sus necesidades', 4,
      pathRutinas + "vidaDiaria/irBaño/12.Vater.png", id_P14);
  insertAccion(database, 'Limpiarse y tirar el papel', 5,
      pathRutinas + "vidaDiaria/irBaño/4.Papel.png", id_P14);
  insertAccion(database, 'Bajar la tapa', 6,
      pathRutinas + "vidaDiaria/irBaño/2.BajarTapa.png", id_P14);
  insertAccion(database, 'Tirar de la cisterna', 7,
      pathRutinas + "vidaDiaria/irBaño/9.TirarCisterna.png", id_P14);
  insertAccion(database, 'Subir la ropa interior', 8,
      pathRutinas + "vidaDiaria/irBaño/14.SubirRopaA.png", id_P14);
  insertAccion(database, 'Subir el vestido', 9,
      pathRutinas + "vidaDiaria/irBaño/15.SubirVestido.png", id_P14);
  insertAccion(database, 'Lavarse las manos', 10,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P14);

  // DESCALZARSE
  int id_P15 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer la futbolista Alexia para descalzarse.',
      'futbolista.png',
      grupoInfancia);
  insertAccion(database, 'Desatar los cordones', 0,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P15);
  insertAccion(database, 'Quitar el calzado', 1,
      pathRutinas + "vestimenta/calzarse/4.Descalzar.png", id_P15);
  insertAccion(database, 'Quitar los calcetines', 2,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P15);
  insertAccion(database, 'Poner las zapatillas', 3,
      pathRutinas + "vestimenta/calzarse/5.Zapatillas.png", id_P15);
}
