import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:rutinas/obj/CartaAccion.dart';

import '../db/obj/accion.dart';
import '../db/obj/pregunta.dart';
import '../provider/MyProvider.dart';
import '../widgets/ExitDialog.dart';
import '../widgets/ImageTextButton.dart';
import '../widgets/PreguntaWidget.dart';
import 'home.dart';
import 'menu.dart';

Random random = Random(); // para generar numeros aleatorios

class Jugar extends StatefulWidget {
  @override
  _Jugar createState() => _Jugar();
}

class _Jugar extends State<Jugar> {
  FlutterTts flutterTts = FlutterTts();

  bool flag = false; // bandera para cargar las preguntas solo 1 vez

  List<Pregunta> preguntasList = []; // lista de preguntas

  List<CartaAccion> cartasAcciones = []; // acciones de la pregunta actual

  int indiceActual = -1; // índice de la pregunta actual

  late ExitDialog endGameDialog;

  Future<void> _speak(String texto) async {
    await flutterTts.setLanguage("es-ES"); // Establecer el idioma a español
    await flutterTts.speak(texto);
  }

  @override
  Widget build(BuildContext context) {
    // Variables necesarias para tamaños de fuentes, imagenes ...
    Size screenSize = MediaQuery.of(context).size;

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    double titleSize,
        textSize,
        espacioPadding,
        espacioAlto,
        imgHeight,
        personajeHeight,
        imgCartaHeight,
        imgVolverHeight,
        espacioCartas,
        ancho;

    int cartasFila; // numero de cartas por fila

    if (isHorizontal) {
      // si el dispositivo esta en horizontal
      cartasFila = 6;
      ancho = screenSize.width;
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.02;
      espacioAlto = screenSize.height * 0.04;
      imgHeight = screenSize.height / 7;
      personajeHeight = screenSize.height / 6;
      imgCartaHeight = screenSize.height / 4;
      imgVolverHeight = screenSize.height / 10;
      espacioCartas = screenSize.height * 0.02;
    } else {
      // si el dispositivo esta en vertical
      cartasFila = 3;
      ancho = screenSize.width;
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      espacioCartas = screenSize.height * 0.02;
      imgHeight = screenSize.height / 8;
      personajeHeight = screenSize.height / 7;
      imgCartaHeight = screenSize.height / 6;
      imgVolverHeight = imgHeight / 4;
    }

    // BOTONES DE LOS CUADROS DE DIALOGO
    // boton para seguir jugando
    ImageTextButton btnSeguirJugando = ImageTextButton(
      image: Image.asset('assets/img/botones/jugar.png', height: imgHeight),
      text: Text(
        'Seguir jugando',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    ImageTextButton btnSeguirJugandoCambiaPregunta = ImageTextButton(
      image: Image.asset('assets/img/botones/jugar.png', height: imgHeight),
      text: Text(
        'Seguir jugando',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        _cambiarPregunta();
      },
    );

    // boton para salir del juego
    ImageTextButton btnSalir = ImageTextButton(
      image: Image.asset('assets/img/botones/salir.png', height: imgHeight),
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
    );

    ImageTextButton btnMenu = ImageTextButton(
      image: Image.asset('assets/img/botones/salir.png', height: imgHeight),
      text: Text(
        'Ir al menú',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
        );
      },
    );

    // CUADROS DE DIALOGO
    // cuadro de dialogo para salir del juego o no
    ExitDialog exitDialog = ExitDialog(
        title: 'Aviso',
        titleSize: titleSize,
        content:
            "¿Estás seguro de que quieres salir del juego? Si lo haces, irás al menú principal.\n"
            "Puedes confirmar la salida o seguir disfrutando del juego.",
        contentSize: textSize,
        leftImageTextButton: btnSeguirJugando,
        rightImageTextButton: btnSalir,
        spaceRight: espacioPadding * 2);

    // cuadro de dialogo para cuando hay alguna respuesta incorrecta
    ExitDialog incorrectDialog = ExitDialog(
        title: '¡Oops!',
        titleSize: titleSize,
        content:
            "Hay algunas respuestas incorrectas, ¡pero sigue intentándolo!\n"
            "Te animamos a que lo intentes de nuevo y mejorar.\n"
            "¡Ánimo, tú puedes!\n\n"
            "PISTA: fíjate en los colores de las cartas...",
        contentSize: textSize,
        leftImageTextButton: btnSeguirJugando,
        rightImageTextButton: btnSalir,
        spaceRight: espacioPadding * 2,
        optionalImage:
            Image.asset('assets/img/medallas/bronce.png', height: imgHeight));

    // cuadro de dialogo para cuando todas las respuestas son correctas
    ExitDialog correctDialog = ExitDialog(
        title: '¡Fantástico!',
        titleSize: titleSize,
        content:
            "Lo has hecho excelente. Has ordenado todas las acciones de manera perfecta.\n"
            "¡Gran trabajo!",
        contentSize: textSize,
        leftImageTextButton: btnSeguirJugandoCambiaPregunta,
        rightImageTextButton: btnSalir,
        spaceRight: espacioPadding * 2,
        optionalImage:
            Image.asset('assets/img/medallas/oro.png', height: imgHeight));

    // cuadro de dialogo cuando hemos completado todas las preguntas del juego
    endGameDialog = ExitDialog(
        title: '¡Enhorabuena!',
        titleSize: titleSize,
        content:
            "¡Qué gran trabajo, bravo! Has superado todas las fases del juego.\n"
            "Espero que hayas disfrutado y aprendido con esta experiencia.\n"
            "¡Sigue trabajando para mejorar tu tiempo!",
        contentSize: textSize,
        leftImageTextButton: btnMenu,
        spaceRight: espacioPadding * 2,
        optionalImage:
            Image.asset('assets/img/medallas/trofeo.png', height: imgHeight));

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
                          fontSize: textSize,
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
                          imgHeight: personajeHeight,
                          personajePath:
                              preguntasList[indiceActual].personajePath,
                          rightSpace: espacioPadding,
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
                    childAspectRatio: (1 / 1.5),
                  ),
                  itemCount: cartasAcciones.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _cartaPulsada(cartasAcciones[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          color: cartasAcciones[index].backgroundColor,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              cartasAcciones[index].accion.imagenPath,
                              height: imgCartaHeight,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: cartasAcciones[index].backgroundColor,
                              ),
                              padding: EdgeInsets.all(espacioPadding / 3),
                              child: Text(
                                cartasAcciones[index].accion.texto,
                                style: TextStyle(
                                  fontFamily: 'ComicNeue',
                                  fontSize: textSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ImageTextButton(
                image: Image.asset('assets/img/botones/fin.png',
                    height: imgHeight),
                text: Text(
                  'Confirmar',
                  style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                      color: Colors.black),
                ),
                onPressed: () {
                  if (_comprobarRespuestas()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return correctDialog;
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return incorrectDialog;
                      },
                    );
                  }
                },
              ),
              SizedBox(height: espacioAlto),
            ],
          ),
        ),
      ),
    );
  }

  // metodo para cargar todas las preguntas
  Future<void> _cargarPreguntas() async {
    if (!flag) {
      flag = true;
      try {
        var myProvider = Provider.of<MyProvider>(context);
        // obtengo las preguntas del grupo correspondiente
        print("ID --> " + myProvider.grupo.id.toString());
        List<Pregunta> preguntas = await getPreguntas(myProvider.grupo.id);
        setState(() {
          preguntasList = preguntas; // actualizo la lista
          indiceActual =
              random.nextInt(preguntasList.length); // pregunta aleatoria
          _speak(preguntasList[indiceActual].enunciado);
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

  bool _comprobarRespuestas() {
    bool correcto = true;
    setState(() {
      for (int i = 0; i < cartasAcciones.length; i++) {
        cartasAcciones[i].selected = false;
        if (i != cartasAcciones[i].accion.orden) {
          correcto = false;
          cartasAcciones[i].backgroundColor = Colors.red;
        } else
          cartasAcciones[i].backgroundColor = Colors.green;
      }
    });
    return correcto;
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
          _speak(preguntasList[indiceActual].enunciado);
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
        return this.endGameDialog;
      },
    );
  }

  // metodo para calcular la altura del gridview
  double _calcularAltura(double ancho, int cartasFila, double espacioPadding,
      double espacioCartas, int filas) {
    double sol = 0;
    double aux = espacioPadding * 2;
    double aux2 = espacioCartas * (cartasFila - 1);
    double anchoTotal = ancho - aux - aux2;
    double anchoCarta = anchoTotal / cartasFila;
    double altoCarta = anchoCarta / (1 / 1.5);

    sol = altoCarta * filas + espacioCartas * 5;

    return sol;
  }

  // metodo para cuando pulso una carta, y de ser necesario, intercambiar
  void _cartaPulsada(CartaAccion cartasAccion) {
    cartasAccion.selected = !cartasAccion.selected;
    setState(() {
      // si la carta actualmente es pulsada
      if (cartasAccion.selected) {
        cartasAccion.backgroundColor = Colors.grey;
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

            cartasAcciones[pos].backgroundColor = Colors.transparent;
            cartasAcciones[i].backgroundColor = Colors.transparent;
            return;
          }
        }
      } else {
        cartasAccion.backgroundColor = Colors.transparent;
      }
    });
  }
}
