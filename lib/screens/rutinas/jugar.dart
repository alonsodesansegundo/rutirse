import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../db/obj/accion.dart';
import '../../db/obj/jugador.dart';
import '../../db/obj/partida.dart';
import '../../db/obj/pregunta.dart';
import '../../obj/CartaAccion.dart';
import '../../provider/MyProvider.dart';
import '../../widgets/ExitDialog.dart';
import '../../widgets/ImageTextButton.dart';
import '../../widgets/PreguntaWidget.dart';
import 'menu.dart';

Random random = Random(); // para generar numeros aleatorios

class Jugar extends StatefulWidget {
  @override
  _Jugar createState() => _Jugar();
}

class _Jugar extends State<Jugar> {
  late FlutterTts flutterTts; // para reproducir audio

  late bool flag, isSpeaking; // bandera para cargar las preguntas solo 1 vez

  late List<Pregunta> preguntasList; // lista de preguntas

  late List<CartaAccion> cartasAcciones; // acciones de la pregunta actual

  late int indiceActual; // índice de la pregunta actual

  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgHeight,
      personajeHeight,
      imgCartaHeight,
      imgVolverHeight,
      espacioCartas,
      ancho;

  late int cartasFila; // numero de cartas por fila

  late ImageTextButton btnSeguirJugando,
      btnSeguirJugandoCambiaPregunta,
      btnSalir,
      btnMenu;

  late ExitDialog exitDialog, incorrectDialog, correctDialog, endGameDialog;

  late int aciertos, fallos;

  late DateTime timeInicio, timeFin;

  late bool loadProvider;

  late Jugador jugadorActual;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    timeInicio = DateTime.now();
    flag = false;
    preguntasList = [];
    cartasAcciones = [];
    indiceActual = -1;
    aciertos = 0;
    fallos = 0;
    loadProvider = false;
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createButtonsFromDialogs();
    _createDialogs();
    if (!loadProvider) {
      var myProvider = Provider.of<MyProvider>(context);
      jugadorActual = myProvider.jugador;
      loadProvider = true;
    }

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Alinea los elementos a la izquierda
                    children: [
                      Text(
                        'Rutinas',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize,
                        ),
                      ),
                      Text(
                        'Juego',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize / 2,
                        ),
                      ),
                    ],
                  ),
                  ImageTextButton(
                    image: Image.asset('assets/img/botones/salir.png',
                        height: imgVolverHeight * 1.5),
                    text: Text(
                      'Salir',
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
                    childAspectRatio: (1 / 1.6),
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
                        if (preguntasList.length != 1) {
                          _speak('Fantástico');
                          return correctDialog;
                        } else {
                          _speak("¡Enhorabuena!");
                          return this.endGameDialog;
                        }
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        _speak('¡Oops!');
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

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _updateVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal) {
      cartasFila = 6;
      ancho = screenSize.width;
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.04;
      imgHeight = screenSize.height / 7;
      personajeHeight = screenSize.height / 6;
      imgCartaHeight = screenSize.height / 4;
      imgVolverHeight = screenSize.height / 10;
      espacioCartas = screenSize.height * 0.015;
    } else {
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
  }

  // metodo para crear los botones necesarios en los cuadros de dialogos
  void _createButtonsFromDialogs() {
    // boton para seguir jugando
    btnSeguirJugando = ImageTextButton(
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

    btnSeguirJugandoCambiaPregunta = ImageTextButton(
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
    btnSalir = ImageTextButton(
      image: Image.asset('assets/img/botones/salir.png', height: imgHeight),
      text: Text(
        'Salir',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        _stopSpeaking();
        saveProgreso();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
        );
      },
    );

    btnMenu = ImageTextButton(
      image: Image.asset('assets/img/botones/salir.png', height: imgHeight),
      text: Text(
        'Ir al menú',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        _stopSpeaking();
        saveProgreso();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Menu()),
        );
      },
    );
  }

  // metodo para crear los cuadros de dialogos
  void _createDialogs() {
    // cuadro de dialogo para salir del juego o no
    exitDialog = ExitDialog(
        title: 'Aviso',
        titleSize: titleSize,
        content:
            "¿Estás seguro de que quieres salir del juego? \nSi lo haces, irás al menú principal.\n"
            "Puedes confirmar la salida o seguir disfrutando del juego.",
        contentSize: textSize,
        leftImageTextButton: btnSeguirJugando,
        rightImageTextButton: btnSalir,
        spaceRight: espacioPadding * 2);

    // cuadro de dialogo para cuando hay alguna respuesta incorrecta
    incorrectDialog = ExitDialog(
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
        optionalImage: Image.asset('assets/img/medallas/incorrecto.png',
            height: imgHeight));

    // cuadro de dialogo para cuando todas las respuestas son correctas
    correctDialog = ExitDialog(
        title: '¡Fantástico!',
        titleSize: titleSize,
        content: "¡Enhorabuena, lo has hecho excelente! "
            "\nHas ordenado todas las acciones de manera perfecta.\n"
            "¡Gran trabajo!",
        contentSize: textSize,
        leftImageTextButton: btnSeguirJugandoCambiaPregunta,
        rightImageTextButton: btnSalir,
        spaceRight: espacioPadding * 2,
        optionalImage:
            Image.asset('assets/img/medallas/correcto.png', height: imgHeight));

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
  }

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

  // método para comprobar si el orden de las acciones es el correcto o no
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
    if (correcto)
      aciertos += 1;
    else
      fallos += 1;
    return correcto;
  }

  // método para cambiar la pregunta actual
  void _cambiarPregunta() {
    setState(() {
      if (preguntasList.isNotEmpty) {
        // si hay preguntas
        // Elimino la pregunta actual de la lista
        preguntasList.removeAt(indiceActual);
        indiceActual = random.nextInt(preguntasList.length);
        _speak(preguntasList[indiceActual].enunciado);
        _cargarAcciones();
      }
    });
  }

  // metodo para calcular la altura del gridview
  double _calcularAltura(double ancho, int cartasFila, double espacioPadding,
      double espacioCartas, int filas) {
    double sol = 0;
    double aux = espacioPadding * 2;
    double aux2 = espacioCartas * (cartasFila - 1);
    double anchoTotal = ancho - aux - aux2;
    double anchoCarta = anchoTotal / cartasFila;
    double altoCarta = anchoCarta / (1 / 1.6);

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

  // método para reproducir un texto por audio
  Future<void> _speak(String texto) async {
    await flutterTts.setLanguage("es-ES"); // Establecer el idioma a español
    await flutterTts.speak(texto);

    // Establecer el estado como reproduciendo
    setState(() {
      isSpeaking = true;
    });

    // Escuchar los cambios de estado para detectar la finalización de la reproducción
    flutterTts.setCompletionHandler(() {
      // Limpiar el estado cuando la reproducción ha terminado
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> _stopSpeaking() async {
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    }
  }

  // metodo para guardar el progreso o partida
  void saveProgreso() {
    timeFin = DateTime.now();
    Duration duracion = timeFin.difference(timeInicio);

    // Formatear la fecha en el formato deseado
    String formattedFechaFin =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(timeFin);

    Partida partida = new Partida(
        fechaFin: formattedFechaFin,
        duracionSegundos: duracion.inSeconds,
        aciertos: aciertos,
        fallos: fallos,
        jugadorId: jugadorActual.id!);

    insertPartida(partida);
  }
}
