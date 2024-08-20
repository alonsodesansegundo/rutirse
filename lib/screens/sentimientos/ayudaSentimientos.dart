import 'package:flutter/material.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';

import '../../widgets/ExitDialog.dart';
import '../../widgets/ImageTextButton.dart';
import '../main.dart';

class AyudaSentimientos extends StatefulWidget {
  // string que nos indica si la pantalla de origen es 'home' o 'menu'
  // para dependiendo de eso, mostrar un cuadro de dialogo u otro (exitDialogFromHome o exitDialogFromMenu)
  final String origen;

  AyudaSentimientos({required this.origen});

  @override
  _AyudaSentimientosState createState() => _AyudaSentimientosState();
}

class _AyudaSentimientosState extends State<AyudaSentimientos> {
  // string que nos indica si la pantalla de origen es 'home' o 'menu'
  // para dependiendo de eso, mostrar un cuadro de dialogo u otro (exitDialogFromHome o exitDialogFromMenu)
  late String origen;

  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgWidth,
      imgBtnWidth,
      imgVolverHeight;

  late ImageTextButton btnSeguirAyuda,
      btnSalirAyudaFromHome,
      btnSalirFromMenu,
      btnJugar;

  late ExitDialog exitDialogFromHome,
      exitDialogFromMenu,
      helpCompletedDialogFromHome,
      helpCompletedDialogFromMenu;

  late bool loadData;

  @override
  void initState() {
    super.initState();
    loadData = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!loadData) {
      loadData = true;
      _createVariablesSize();
      _createButtonsFromDialogs();
      _createDialogs();
    }

    origen = widget.origen;

    return MaterialApp(
      home: Scaffold(
        body: DynMouseScroll(
          durationMS: myDurationMS,
          scrollSpeed: myScrollSpeed,
          animationCurve: Curves.easeOutQuart,
          builder: (context, controller, physics) => SingleChildScrollView(
            controller: controller,
            physics: physics,
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
                            'Sentimientos',
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: titleSize,
                            ),
                          ),
                          Text(
                            'Ayuda',
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: titleSize / 2,
                            ),
                          ),
                        ],
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
                              if (origen == 'home')
                                return exitDialogFromHome;
                              else
                                return exitDialogFromMenu;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: espacioAlto), // Espacio entre los textos
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Aquí descubrirás cómo jugar a \'Sentimientos\', '
                          'un juego que consiste en indicar las respuestas correctas (situaciones) '
                          'correspondientes a una pregunta (sentimiento o estado anímico). '
                          '\nAquí tienes un ejemplo:',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: espacioAlto),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Jaime está contento después de acabar la carrera, ¿por qué?',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/img/personajes/corredor.png',
                        width: imgWidth * 1.3,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/sentimientos/perder.png',
                              width: imgWidth,
                            ),
                            Text(
                              'Perdió la\ncarrera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: textSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: imgWidth),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/sentimientos/ganar.png',
                              width: imgWidth,
                            ),
                            Text(
                              'Ganó la\ncarrera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: textSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height: espacioAlto * 1.5), // Espacio entre los textos
                  Text(
                    'Una vez hemos leído la pregunta, seleccionamos o marcamos la respuesta(s) correcta(s). En el caso '
                    'de ser una pregunta de Atención Temprana solamente habrá una respuesta correcta, de ser otro grupo puede haber más de una.',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),

                  SizedBox(height: espacioAlto), // Espacio entre los textos
                  Text(
                    'En este caso seleccionamos la segunda carta, por lo que se pondrá de color gris.',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(height: espacioAlto), // Espacio entre los textos
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/sentimientos/perder.png',
                              width: imgWidth,
                            ),
                            Text(
                              'Perdió la\ncarrera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: textSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: imgWidth),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/sentimientos/ganar.png',
                              width: imgWidth,
                            ),
                            Text(
                              'Ganó la\ncarrera',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: textSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: espacioAlto / 2), // Espacio entre los textos
                  Text(
                    'Para confirmar nuestras respuestas debemos de pulsar el botón \'Confirmar\' que se encuentra en la parte de abajo.',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(height: espacioAlto),
                  Text(
                    'Esperamos que esta ayuda te haya sido de utilidad.\n¡Muchas gracias por tu atención!',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),
                  SizedBox(height: espacioAlto * 2),

                  ImageTextButton(
                    image: Image.asset('assets/img/botones/fin.png',
                        width: imgWidth * 0.75),
                    text: Text(
                      'Ayuda completada',
                      style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                          color: Colors.black),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          if (origen == 'home')
                            return helpCompletedDialogFromMenu;
                          else
                            return helpCompletedDialogFromHome;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.04;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.width * 0.03;
    imgWidth = screenSize.width / 5;
    imgBtnWidth = screenSize.width / 5;
    imgVolverHeight = screenSize.height / 32;
  }

  // metodo para crear los botones necesarios en los cuadros de dialogos
  void _createButtonsFromDialogs() {
    // boton para seguir en la pantalla de ayuda
    btnSeguirAyuda = ImageTextButton(
      image: Image.asset('assets/img/botones/ayuda.png', width: imgBtnWidth),
      text: Text(
        'Seguir en ayuda',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // boton para salir de la pantalla de ayuda desde la pantalla principal
    btnSalirAyudaFromHome = ImageTextButton(
      image: Image.asset('assets/img/botones/salir.png', height: imgBtnWidth),
      text: Text(
        'Salir',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // boton para salir de la pantalla de ayuda desde el menu
    btnSalirFromMenu = ImageTextButton(
      image: Image.asset('assets/img/botones/salir.png', width: imgBtnWidth),
      text: Text(
        'Salir',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // boton para volver a la pantalla principal (he acabado la ayuda)
    btnJugar = ImageTextButton(
      image: Image.asset('assets/img/botones/jugar.png', width: imgBtnWidth),
      text: Text(
        '¡Estoy listo!',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  // metodo para crear los cuadro de dialogos
  void _createDialogs() {
    // cuadrdo de dialogo para salir de la pantalla de ayuda desde la pantalla principal
    exitDialogFromHome = ExitDialog(
        title: 'Aviso',
        titleSize: titleSize,
        content:
            "¿Estás seguro de que quieres volver a la pantalla principal?\n"
            "Puedes confirmar la salida o seguir viendo la ayuda",
        contentSize: textSize,
        leftImageTextButton: btnSeguirAyuda,
        rightImageTextButton: btnSalirAyudaFromHome);

    // cuadro de dialogo para salir de la pantalla de ayuda desde el menu
    exitDialogFromMenu = ExitDialog(
        title: 'Aviso',
        titleSize: titleSize,
        content: "¿Estás seguro de que quieres volver al menú principal?\n"
            "Puedes confirmar la salida o seguir viendo la ayuda",
        contentSize: textSize,
        leftImageTextButton: btnSeguirAyuda,
        rightImageTextButton: btnSalirFromMenu);

    // cuadro de dialogo de he completado la ayuda desde la pantalla principal
    helpCompletedDialogFromHome = ExitDialog(
        title: '¡Genial!',
        titleSize: titleSize,
        content:
            "Si ya estás preparado para empezar a jugar, volverás al menú principal de \'Sentimientos\'.\n"
            "Si todavía no te sientes preparado, no te preocupes, puedes seguir viendo la explicación de cómo jugar.",
        contentSize: textSize,
        leftImageTextButton: btnSeguirAyuda,
        rightImageTextButton: btnSalirAyudaFromHome);

    // cuadro de dialogo de he completado la ayuda desde el menu
    helpCompletedDialogFromMenu = ExitDialog(
        title: '¡Genial!',
        titleSize: titleSize,
        content:
            "Si ya estás preparado para empezar a jugar, antes debes de indicarnos tu nombre y grupo.\n"
            "Si todavía no te sientes preparado, no te preocupes, puedes seguir viendo la explicación de cómo jugar.",
        contentSize: textSize,
        leftImageTextButton: btnJugar,
        rightImageTextButton: btnSeguirAyuda);
  }
}
