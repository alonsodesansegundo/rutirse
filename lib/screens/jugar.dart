import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutinas/db/db.dart';
import 'package:rutinas/obj/CartaAccion.dart';

import '../db/accion.dart';
import '../db/pregunta.dart';
import '../provider/MyProvider.dart';
import '../widgets/ExitDialog.dart';
import '../widgets/ImageTextButton.dart';
import '../widgets/PreguntaWidget.dart';
import 'home.dart';

Random random = Random(); // para generar numeros aleatorios

class Jugar extends StatefulWidget {
  @override
  _Jugar createState() => _Jugar();
}

class _Jugar extends State<Jugar> {
  bool flag = false;

  List<Pregunta> preguntasList = []; // lista de preguntas
  List<CartaAccion> cartasAcciones = []; // acciones de la pregunta actual

  int indiceActual = -1; // índice de la pregunta actual

  // metodo para cargar todas las preguntas
  Future<void> _cargarPreguntas() async {
    if (!flag) {
      flag = true;
      try {
        var myProvider = Provider.of<MyProvider>(context);
        // obtengo las preguntas del grupo correspondiente
        List<Pregunta> preguntas = await getPreguntas(myProvider.grupo.id);
        setState(() {
          preguntasList = preguntas; // actualizo la lista
          indiceActual =
              random.nextInt(preguntasList.length); // pregunta aleatoria
          _cargarAcciones(); // cargo las acciones de la pregunta actual
        });
      } catch (e) {
        // no se debe de producir ningún error al ser una BBDD local
        print("Error al obtener la lista de preguntas: $e"); //
      }
    }
  }

  // método para cargar las acciones de la pregunta actual
  Future<void> _cargarAcciones() async {
    try {
      // obtengo las acciones de la pregunta actual
      List<Accion> acciones = await getAcciones(preguntasList[indiceActual].id);
      setState(() {
        acciones.shuffle(); // desordenar acciones
        // creo las cartas
        cartasAcciones = acciones.map((accion) {
          return CartaAccion(
            accion: accion,
          );
        }).toList();
      });
    } catch (e) {
      // no se debe de producir ningún error al ser una BBDD local
      print("Error al obtener la lista de acciones: $e");
    }
  }

  // método para cambiar la pregunta actual
  void _cambiarPregunta() {
    setState(() {
      if (preguntasList.isNotEmpty) {
        // si hay preguntas
        if (preguntasList.length == 1) {
          // es la ultima
          _mostrarDialogoFinPreguntas();
        } else {
          // Elimino la pregunta actual de la lista
          preguntasList.removeAt(indiceActual);
          indiceActual = random.nextInt(preguntasList.length);
          _cargarAcciones();
        }
      }
    });
  }

  // método para mostrar un cuadro de dialogo cuando hemos completado la ultima pregunta
  Future<void> _mostrarDialogoFinPreguntas() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Enhorabuena!"),
          content: Text(
              "Has completado todas las fases del juego. ¡Sigue trabajando para mejorar tu tiempo!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    int cartasFila;

    double titleSize,
        textSize,
        subtextSize,
        espacioPadding,
        espacioAlto,
        imgHeight,
        imgWidth,
        personajeWidth,
        imgVolverHeight,
        espacioCartas,
        ancho;

    if (isHorizontal) {
      cartasFila = 6;
      ancho = screenSize.width;
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      subtextSize = screenSize.width * 0.010;
      espacioPadding = screenSize.height * 0.02;
      espacioAlto = screenSize.height * 0.04;
      imgHeight = screenSize.height / 3;
      imgWidth = screenSize.width / 3;
      personajeWidth = screenSize.width / 8;
      imgVolverHeight = screenSize.height / 10;
      espacioCartas = screenSize.height * 0.02;
    } else {
      cartasFila = 3;
      ancho = screenSize.width;
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      subtextSize = screenSize.width * 0.025;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      espacioCartas = screenSize.height * 0.02;
      imgHeight = screenSize.height / 8;
      imgWidth = screenSize.width / 5;
      personajeWidth = screenSize.width / 4;
      imgVolverHeight = imgHeight / 4;
    }

    ExitDialog exitDialog = ExitDialog(
      title: Text(
        'Aviso',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: titleSize,
        ),
      ),
      content: Text(
        "¿Estás seguro de que quieres salir del juego? Si lo haces, irás al menú principal.\n"
        "Puedes confirmar la salida o seguir disfrutando del juego.",
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      leftImageTextButton: ImageTextButton(
        image: Image.asset('assets/img/botones/jugar.png',
            width: imgWidth, height: imgHeight),
        text: Text(
          'Seguir jugando',
          style: TextStyle(
              fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      rightImageTextButton: ImageTextButton(
        image: Image.asset('assets/img/botones/salir.png',
            width: imgWidth, height: imgHeight),
        text: Text(
          'Salir',
          style: TextStyle(
              fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
      ),
      spaceRight: espacioPadding * 2,
    );

    return Scaffold(
      body: SingleChildScrollView(
        physics:
            AlwaysScrollableScrollPhysics(), // Habilita el scroll vertical siempre
        child: Padding(
          padding: EdgeInsets.all(espacioPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rutinas',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: titleSize,
                    ),
                  ),
                  ImageTextButton(
                    image: Image.asset('assets/img/botones/volver.png',
                        height: imgVolverHeight),
                    text: Text(
                      'Volver',
                      style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: subtextSize,
                          color: Colors.black),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return exitDialog;
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: espacioAlto),
              FutureBuilder<void>(
                future: _cargarPreguntas(),
                builder: (context, snapshot) {
                  if (preguntasList.isEmpty) {
                    return Text("Cargando...");
                  } else {
                    return Column(
                      children: [
                        PreguntaWidget(
                          enunciado: preguntasList[indiceActual].enunciado,
                          isLoading: false,
                          subtextSize: textSize,
                          imgWidth: personajeWidth * 1.3,
                          personajeName: 'cerdo',
                        ),
                      ],
                    );
                  }
                },
              ),
              //mostrar cada una de las CartaAccion de la lista cartaAcciones
              SizedBox(
                height: _calcularAltura(ancho, cartasFila, espacioPadding,
                    espacioCartas, (cartasAcciones.length / cartasFila).ceil()),
                child: GridView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Deshabilita el scroll vertical
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cartasFila,
                    crossAxisSpacing: espacioCartas,
                    mainAxisSpacing: espacioCartas,
                  ),
                  itemCount: cartasAcciones.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        cartaPulsada(cartasAcciones[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                          color: cartasAcciones[index].selected
                              ? Colors.grey
                              : Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                cartasAcciones[index].accion.imagenPath,
                                height: imgHeight * 0.5,
                              ),
                              Container(
                                padding: EdgeInsets.all(espacioPadding / 3),
                                child: Text(
                                  cartasAcciones[index].accion.texto,
                                  style: TextStyle(
                                    fontFamily: 'ComicNeue',
                                    fontSize: subtextSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _cambiarPregunta,
                child: Text('Cambiar Pregunta'),
              ),
              SizedBox(height: espacioAlto),
            ],
          ),
        ),
      ),
    );
  }

  double _calcularAltura(double ancho, int cartasFila, double espacioPadding,
      double espacioCartas, int filas) {
    double espacios = (cartasFila - 1) * espacioCartas;
    double espacios2 = espacioPadding * 2;
    double aux = ancho - (espacios + espacios2);
    aux = aux / cartasFila;
    aux = aux + espacioPadding * 2;
    aux = aux * filas;
    return aux;
  }

  void cartaPulsada(CartaAccion cartasAccion) {
    cartasAccion.selected = !cartasAccion.selected;
    setState(() {
      // si la carta actualmente es pulsada
      if (cartasAccion.selected) {
        // miro si hay otra que haya sido pulsada
        for (int i = 0; i < cartasAcciones.length; i++) {
          // si ha sido pulsada y no es la misma que he pulsado ahora
          if (cartasAcciones[i].selected && cartasAcciones[i] != cartasAccion) {
            // hago el intercambio
            // las marco como deseleccionadas
            cartasAcciones[i].selected = false;
            cartasAccion.selected = false;

            //hago el intercambio
            CartaAccion copia = cartasAccion;
            int pos = cartasAcciones.indexOf(cartasAccion);
            cartasAcciones[pos] = cartasAcciones[i];
            cartasAcciones[i] = copia;
            return;
          }
        }
      }
    });
  }
}
