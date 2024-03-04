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
      'Por favor, pon en orden lo que tiene que hacer el cerdito Pepe para lavarse los dientes.',
      'cerdo.png',
      grupoAtencionT);
  insertAccion(database, "Echar la pasta de dientes", 0,
      pathRutinas + "higiene/lavarDientes/2.LavarDientes.png", id_P1);
  insertAccion(database, "Cepillarse", 1,
      pathRutinas + "higiene/lavarDientes/3.LavarDientes.png", id_P1);
  insertAccion(database, "Lavar el cepillo", 2,
      pathRutinas + "higiene/lavarDientes/4.LavarDientes.png", id_P1);
  insertAccion(database, "Guardar el cepillo", 3,
      pathRutinas + "higiene/lavarDientes/5.LavarDientes.png", id_P1);

  // PEINARSE
  int id_P2 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer el perro Winston para peinarse.',
      'perro.png',
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
      'Por favor, pon en orden lo que tiene que hacer la perra Layka para lavarse la cara.',
      'perro.png',
      grupoAtencionT);

  insertAccion(database, 'Abrir el grifo', 0,
      pathRutinas + "higiene/lavarCara/1.AbrirGrifo.png", id_P3);
  insertAccion(database, 'Lavar la cara', 1,
      pathRutinas + "higiene/lavarCara/4.LavarCara.png", id_P3);
  insertAccion(database, 'Cerrar el grifo', 2,
      pathRutinas + "higiene/lavarCara/3.CerrarGrifo.png", id_P3);
  insertAccion(database, 'Secarse', 3,
      pathRutinas + "higiene/lavarCara/7.Toalla.png", id_P3);

  // CALZARSE
  int id_P4 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer el piloto Fernando para calzarse.',
      'piloto.png',
      grupoAtencionT);
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
      grupoAtencionT);
  insertAccion(database, 'Poner la camiseta', 0,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P5);
  insertAccion(database, 'Poner la sudadera', 1,
      pathRutinas + "vestimenta/ponerParteArriba/4.PonerSudadera.png", id_P5);

  // QUITAR PARTE DE ARRIBA
  int id_P6 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Jaime para desvestirse la parte de arriba.',
      'chico.png',
      grupoAtencionT);
  insertAccion(database, 'Quitar la sudadera', 0,
      pathRutinas + "vestimenta/ponerParteArriba/5.QuitarSudadera.png", id_P6);
  insertAccion(database, 'Quitar la camiseta', 1,
      pathRutinas + "vestimenta/ponerParteArriba/2.PonerCamiseta.png", id_P6);

  // PONER PARTE DE ABAJO
  int id_P7 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para ponernos la ropa de abajo.',
      'ambos.png',
      grupoAtencionT);
  insertAccion(database, 'Ponernos la ropa interior', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/2.RopaPuesta.png", id_P7);
  insertAccion(database, 'Ponernos el pantalón', 1,
      pathRutinas + "vestimenta/ponerParteAbajo/4.SubirPantalon.png", id_P7);

  // QUITAR PARTE DE ABAJO
  int id_P8 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para quitarnos la parte de abajo.',
      'ambos.png',
      grupoAtencionT);
  insertAccion(database, 'Quitarnos el pantalón', 0,
      pathRutinas + "vestimenta/ponerParteAbajo/5.BajarPantalon.png", id_P8);
  insertAccion(database, 'Quitarnos la ropa interior', 1,
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
      'Por favor, pon en orden lo que tenemos que hacer si queremos ir al parque.',
      'ambos.png',
      grupoAtencionT);
  insertAccion(database, 'Ir al parque', 0,
      pathRutinas + "vidaSocial/parque/2.Ir.png", id_P10);
  insertAccion(database, '¿Podemos jugar?', 1,
      pathRutinas + "vidaSocial/parque/3.Preguntar.png", id_P10);
  insertAccion(database, 'Jugar', 2,
      pathRutinas + "vidaSocial/parque/4.Jugar.png", id_P10);

  // IR AL MÉDICO
  int id_P11 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tenemos que hacer para ir al médico.',
      'chico.png',
      grupoAtencionT);
  insertAccion(database, 'Saludar al llegar', 0,
      pathRutinas + "vidaSocial/medico/1.Saludar.png", id_P11);
  insertAccion(database, 'Buscar la consulta', 1,
      pathRutinas + "vidaSocial/medico/2.Buscar.png", id_P11);
  insertAccion(database, 'Esperar', 2,
      pathRutinas + "vidaSocial/medico/3.Esperar.png", id_P11);

  // MOCHILA COLE
  int id_P12 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer la cerdita Pepa para preparar la mochila del cole.',
      'cerdo.png',
      grupoAtencionT);
  insertAccion(database, 'Ver el horario', 0,
      pathRutinas + "vidaDiaria/mochilaCole/1.Horario.png", id_P12);
  insertAccion(database, 'Preparar libros', 1,
      pathRutinas + "vidaDiaria/mochilaCole/2.Libros.png", id_P12);
  insertAccion(database, 'Preparar libretas', 2,
      pathRutinas + "vidaDiaria/mochilaCole/3.Cuadernos.png", id_P12);
  insertAccion(database, 'Preparar estuche', 3,
      pathRutinas + "vidaDiaria/mochilaCole/4.Estuche.png", id_P12);
  insertAccion(database, 'Guardar todo', 4,
      pathRutinas + "vidaDiaria/mochilaCole/5.Mochila.png", id_P12);

  // IR AL BAÑO (chico)
  int id_P13 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestro amigo Saúl para hacer sus necesidades (ir al baño).',
      'chico.png',
      grupoAtencionT);
  insertAccion(database, 'Bajar el pantalón', 0,
      pathRutinas + "vidaDiaria/irBaño/6.BajarPantalon.png", id_P13);
  insertAccion(database, 'Bajar la ropa interior', 1,
      pathRutinas + "vidaDiaria/irBaño/10.BajarRopaO.png", id_P13);
  insertAccion(database, 'Hacer sus necesidades', 2,
      pathRutinas + "vidaDiaria/irBaño/12.Vater.png", id_P13);
  insertAccion(database, 'Limpiarse y tirar el papel', 3,
      pathRutinas + "vidaDiaria/irBaño/4.Papel.png", id_P13);
  insertAccion(database, 'Tirar de la cisterna', 4,
      pathRutinas + "vidaDiaria/irBaño/9.TirarCisterna.png", id_P13);
  insertAccion(database, 'Subir la ropa interior', 5,
      pathRutinas + "vidaDiaria/irBaño/13.SubirRopaO.png", id_P13);
  insertAccion(database, 'Subir el pantalón', 6,
      pathRutinas + "vidaDiaria/irBaño/7.SubirPantalon.png", id_P13);
  insertAccion(database, 'Lavarse las manos', 7,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P13);

  // IR AL BAÑO (chica)
  int id_P14 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer nuestra amiga Cristina para hacer sus necesidades (ir al baño).',
      'chica.png',
      grupoAtencionT);
  insertAccion(database, 'Bajar el vestido', 0,
      pathRutinas + "vidaDiaria/irBaño/16.BajarVestido.png", id_P14);
  insertAccion(database, 'Bajar ropa interior', 1,
      pathRutinas + "vidaDiaria/irBaño/11.BajarRopaA.png", id_P14);
  insertAccion(database, 'Hacer sus necesidades', 2,
      pathRutinas + "vidaDiaria/irBaño/12.Vater.png", id_P14);
  insertAccion(database, 'Limpiarse y tirar el papel', 3,
      pathRutinas + "vidaDiaria/irBaño/4.Papel.png", id_P14);
  insertAccion(database, 'Tirar de la cisterna', 4,
      pathRutinas + "vidaDiaria/irBaño/9.TirarCisterna.png", id_P14);
  insertAccion(database, 'Subir la ropa interior', 5,
      pathRutinas + "vidaDiaria/irBaño/14.SubirRopaA.png", id_P14);
  insertAccion(database, 'Subir el vestido', 6,
      pathRutinas + "vidaDiaria/irBaño/15.SubirVestido.png", id_P14);
  insertAccion(database, 'Lavarse las manos', 7,
      pathRutinas + "higiene/lavarCara/2.MojarManos.png", id_P14);

  int id_P15 = await insertPregunta(
      database,
      'Por favor, pon en orden lo que tiene que hacer el piloto Fernando para descalzarse.',
      'piloto.png',
      grupoAtencionT);
  insertAccion(database, 'Desatar los cordones', 0,
      pathRutinas + "vestimenta/calzarse/3.AtarCalzado.png", id_P15);
  insertAccion(database, 'Quitar el calzado', 1,
      pathRutinas + "vestimenta/calzarse/4.Descalzar.png", id_P15);
  insertAccion(database, 'Quitar los calcetines', 2,
      pathRutinas + "vestimenta/calzarse/1.PonerCalcetines.png", id_P15);
}
