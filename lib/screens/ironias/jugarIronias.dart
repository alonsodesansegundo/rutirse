import 'dart:math';

import 'package:TresEnUno/db/obj/partidaIronias.dart';
import 'package:TresEnUno/db/obj/respuestaIronia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../db/obj/jugador.dart';
import '../../db/obj/situacionIronia.dart';
import '../../obj/CartaRespuestaIronia.dart';
import '../../provider/MyProvider.dart';
import '../../widgets/ExitDialog.dart';
import '../../widgets/ImageTextButton.dart';
import '../../widgets/PreguntaWidget.dart';
import '../common/menuJugador.dart';

Random random = Random(); // para generar numeros aleatorios

class JugarIronias extends StatefulWidget {
  @override
  _JugarIronias createState() => _JugarIronias();
}

class _JugarIronias extends State<JugarIronias> {
  late FlutterTts flutterTts; // para reproducir audio

  late bool flag, isSpeaking; // bandera para cargar las preguntas solo 1 vez

  late int indiceActual; // índice de la pregunta actual

  late List<SituacionIronia> situacionIroniaList; // lista de preguntas

  late List<CartaRespuestaIronia> respuestasActuales;

  late RespuestaIronia? respuestaSelected;

  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgWidth,
      personajeWidth,
      btnRespuestaWidth,
      espacioCartas,
      ancho,
      imgBtnWidth,
      imgVolverHeight;

  late ImageTextButton btnSeguirJugando,
      btnSeguirJugandoCambiaPregunta,
      btnConfirmar,
      btnSalir,
      btnMenu;

  late ExitDialog exitDialog,
      incorrectDialog,
      correctDialog,
      endGameDialog,
      notSelectedDialog;

  late int aciertos, fallos;

  late DateTime timeInicio, timeFin;

  late bool loadProvider, loadData;

  late Jugador jugadorActual;

  @override
  void initState() {
    super.initState();
    loadData = false;
    flutterTts = FlutterTts();
    timeInicio = DateTime.now();
    flag = false;
    situacionIroniaList = [];
    respuestasActuales = [];
    respuestaSelected = null;
    indiceActual = -1;
    aciertos = 0;
    fallos = 0;
    loadProvider = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!loadData) {
      loadData = true;
      _createVariablesSize();
      _createButtonsFromDialogs();
      _createDialogs();
    }
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
                        'Ironías',
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
              FutureBuilder<void>(
                future: _cargarPreguntas(),
                builder: (context, snapshot) {
                  if (situacionIroniaList.isEmpty) {
                    return Text("Cargando...");
                  } else {
                    return Column(
                      children: [
                        PreguntaWidget(
                          enunciado:
                              situacionIroniaList[indiceActual].enunciado,
                          isLoading: false,
                          subtextSize: textSize,
                          imgWidth: personajeWidth,
                          personajeImg:
                              situacionIroniaList[indiceActual].imagen,
                          rightSpace: espacioPadding,
                        ),
                        SizedBox(height: espacioAlto * 2),
                        Column(
                          children: respuestasActuales.map((respuesta) {
                            return Row(
                              children: [
                                Container(
                                  width: btnRespuestaWidth,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      respuesta.selected = !respuesta.selected;
                                      if (respuesta.selected) {
                                        for (int i = 0;
                                            i < respuestasActuales.length;
                                            i++) {
                                          respuestasActuales[i]
                                                  .backgroundColor =
                                              Colors.redAccent;
                                          if (respuesta !=
                                              respuestasActuales[i])
                                            respuestasActuales[i].selected =
                                                false;
                                        }
                                        setState(() {
                                          respuesta.backgroundColor =
                                              Colors.lightGreen;
                                          respuestaSelected =
                                              respuesta.respuesta;
                                        });
                                      } else {
                                        respuestaSelected = null;
                                        for (int i = 0;
                                            i < respuestasActuales.length;
                                            i++) {
                                          setState(() {
                                            respuestasActuales[i]
                                                .backgroundColor = Colors.blue;
                                          });
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: respuesta
                                          .backgroundColor, // Aquí establecemos el color de fondo gris
                                    ),
                                    child: Text(respuesta.respuesta.texto),
                                  ),
                                ),
                                SizedBox(width: espacioPadding / 2),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: espacioAlto * 2),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: espacioAlto),
              btnConfirmar
            ],
          ),
        ),
      ),
    );
  }

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    ancho = screenSize.width;
    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.height * 0.01;
    espacioCartas = screenSize.height * 0.02;
    personajeWidth = screenSize.width / 4;
    btnRespuestaWidth = (screenSize.width - espacioPadding * 2) / 1.5;
    imgWidth = screenSize.width / 4;
    imgBtnWidth = screenSize.width / 5;
    imgVolverHeight = screenSize.height / 32;
  }

  // metodo para crear los botones necesarios en los cuadros de dialogos
  void _createButtonsFromDialogs() {
    // boton para enviar la respuesta
    btnConfirmar = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/fin.png',
        width: imgWidth * 0.75,
      ),
      text: Text(
        'Confirmar',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            if (respuestaSelected != null && respuestaSelected!.correcta == 1) {
              aciertos++;
              if (situacionIroniaList.length != 1) {
                _speak('Fantástico');
                if (situacionIroniaList.isNotEmpty) {
                  // si hay preguntas
                  // Elimino la pregunta actual de la lista
                  situacionIroniaList.removeAt(indiceActual);
                  indiceActual = random.nextInt(situacionIroniaList.length);
                  _speak(situacionIroniaList[indiceActual].enunciado);
                  _cargarRespuestas();
                }
                return correctDialog;
              } else {
                _speak("¡Enhorabuena!");
                return this.endGameDialog;
              }
            }
            if (respuestaSelected != null && respuestaSelected!.correcta != 1) {
              fallos++;
              _speak('¡Oops!');
              return incorrectDialog;
            }
            _speak('Vaya...');
            return notSelectedDialog;
          },
        );
      },
    );

    // boton para seguir jugando
    btnSeguirJugando = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/jugar.png',
        width: imgBtnWidth,
      ),
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
      image: Image.asset(
        'assets/img/botones/jugar.png',
        width: imgBtnWidth,
      ),
      text: Text(
        'Seguir jugando',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        //_cambiarPregunta();
      },
    );

    // boton para salir del juego
    btnSalir = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/salir.png',
        width: imgBtnWidth,
      ),
      text: Text(
        'Salir',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        _stopSpeaking();
        saveProgreso();
        Navigator.pop(context);
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenuJugador(
                    juego: 'ironias',
                  )),
        );
      },
    );

    btnMenu = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/salir.png',
        width: imgBtnWidth,
      ),
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
          MaterialPageRoute(
              builder: (context) => MenuJugador(
                    juego: 'ironias',
                  )),
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
        rightImageTextButton: btnSalir);

    // cuadro de dialogo para cuando hay alguna respuesta incorrecta
    incorrectDialog = ExitDialog(
        title: '¡Oops!',
        titleSize: titleSize,
        content:
            "Vaya, parece que te has equivocado... ¡pero sigue intentándolo!\n"
            "Te animamos a que lo intentes de nuevo y mejorar.\n"
            "¡Ánimo, tú puedes!\n\n",
        contentSize: textSize,
        leftImageTextButton: btnSeguirJugando,
        rightImageTextButton: btnSalir,
        optionalImage: Image.asset(
          'assets/img/medallas/incorrecto.png',
          width: imgWidth,
        ));

    // cuadro de dialogo para cuando todas las respuestas son correctas
    correctDialog = ExitDialog(
        title: '¡Fantástico!',
        titleSize: titleSize,
        content: "¡Enhorabuena, lo has hecho excelente! "
            "\nHas sabido detectar perfectamente si se trataba o no de una ironía.\n"
            "¡Gran trabajo!",
        contentSize: textSize,
        leftImageTextButton: btnSeguirJugandoCambiaPregunta,
        rightImageTextButton: btnSalir,
        optionalImage: Image.asset(
          'assets/img/medallas/correcto.png',
          width: imgWidth,
        ));

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
      optionalImage: Image.asset(
        'assets/img/medallas/trofeo.png',
        width: imgWidth,
      ),
    );

    notSelectedDialog = ExitDialog(
        title: 'Vaya...',
        titleSize: titleSize,
        content:
            "Parece que te has olvidado de indicar una respuesta correcta.\n"
            "Recuerda que la respuesta que tengas seleccionada actualmente se pondrá de color verde.\n"
            "¡Te animamos a que lo revises y lo sigas intentando!",
        contentSize: textSize,
        leftImageTextButton: btnSeguirJugandoCambiaPregunta,
        rightImageTextButton: btnSalir);
  }

  // metodo para cargar todas las preguntas
  Future<void> _cargarPreguntas() async {
    if (!flag) {
      flag = true;
      try {
        var myProvider = Provider.of<MyProvider>(context);
        // obtengo las preguntas del grupo correspondiente
        List<SituacionIronia> situaciones =
            await getSituacionesIronias(myProvider.grupo.id);
        setState(() {
          situacionIroniaList = situaciones; // actualizo la lista
          indiceActual =
              random.nextInt(situacionIroniaList.length); // pregunta aleatoria
          _speak(situacionIroniaList[indiceActual].enunciado);
          _cargarRespuestas(); // cargo las acciones de la pregunta actual
        });
      } catch (e) {
        // no se debe de producir ningún error al ser una BBDD local
        print("Error al obtener la lista de preguntas de ironías: $e"); //
      }
    }
  }

  // método para cargar las respuestas de la pregunta actual
  Future<void> _cargarRespuestas() async {
    try {
      List<RespuestaIronia> respuestas =
          await getRespuestasIronia(situacionIroniaList[indiceActual].id ?? -1);
      setState(() {
        respuestas.shuffle(); // desordenar respuestas
        // creo las cartas respuesta
        respuestasActuales = respuestas.map((respuesta) {
          return CartaRespuestaIronia(respuesta: respuesta);
        }).toList();
      });
    } catch (e) {
      // no se debe de producir ningún error al ser una BBDD local
      print("Error al obtener la lista de respuestas: $e");
    }
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

    PartidaIronias partida = new PartidaIronias(
        fechaFin: formattedFechaFin,
        duracionSegundos: duracion.inSeconds,
        aciertos: aciertos,
        fallos: fallos,
        jugadorId: jugadorActual.id!);

    insertPartidaIronias(partida);
  }
}
