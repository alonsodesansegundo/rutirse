import 'package:flutter/material.dart';

import '../../widgets/ExitDialog.dart';
import '../../widgets/ImageTextButton.dart';

class AyudaHumor extends StatefulWidget {
  // string que nos indica si la pantalla de origen es 'home' o 'menu'
  // para dependiendo de eso, mostrar un cuadro de dialogo u otro (exitDialogFromHome o exitDialogFromMenu)
  final String origen;

  AyudaHumor({required this.origen});

  @override
  _AyudaHumorState createState() => _AyudaHumorState();
}

class _AyudaHumorState extends State<AyudaHumor> {
  // string que nos indica si la pantalla de origen es 'home' o 'menu'
  // para dependiendo de eso, mostrar un cuadro de dialogo u otro (exitDialogFromHome o exitDialogFromMenu)
  late String origen;

  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgWidth,
      imgBtnWidth,
      imgVolverHeight,
      btnRespuestaWidth,
      gameTextSize,
      espacioAltoAux;

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
        body: SingleChildScrollView(
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
                          'Humor',
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
                        'Aquí descubrirás cómo jugar a \'Humor\', '
                        'un juego que consiste en indicar si una frase en una situación dada se trata de una ironía o no. '
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
                        '¡Qué alegría, que buen día!',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/img/humor/sol.png',
                      width: imgWidth * 1.3,
                    ),
                  ],
                ),
                Container(
                  width: btnRespuestaWidth,
                  child: ElevatedButton(
                    onPressed: () {},

                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ), // Esto desactiva el botón
                    child: Text(
                      'No, no es una ironía.',
                      style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: gameTextSize,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: espacioAlto),
                Container(
                  width: btnRespuestaWidth,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Text(
                      'Sí, es una ironía.',
                      style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: gameTextSize,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: espacioAlto / 2), // Espacio entre los textos
                Text(
                  'Debemos de pulsar la opción que creemos que es correcta.',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto / 2), // Espacio entre los textos
                Text(
                  'Por ejemplo, si creemos que la opción correcta es \'Sí, es una ironía.\' la pulsamos. '
                  'Una vez pulsada esta se pondrá en verde y las demás en rojo.',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(
                  height: espacioAlto * 2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '¡Qué alegría, que buen día!',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/img/humor/sol.png',
                      width: imgWidth * 1.3,
                    ),
                  ],
                ),
                Container(
                  width: btnRespuestaWidth,
                  child: ElevatedButton(
                    onPressed: () {},

                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    ), // Esto desactiva el botón
                    child: Text(
                      'No, no es una ironía.',
                      style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: gameTextSize,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: espacioAlto),
                Container(
                  width: btnRespuestaWidth,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightGreen,
                    ),
                    child: Text(
                      'Sí, es una ironía.',
                      style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: gameTextSize,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: espacioAlto / 2), // Espacio entre los textos
                Text(
                  'En este momento nuestra opción seleccionada es \'Sí, es una ironía.\'',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto / 2), // Espacio entre los textos
                Text(
                  'Para confirmar nuestra respuesta debemos de pulsar el botón \'Confirmar\' que se encuentra en la parte de abajo.',
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
    );
  }

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.04;
    gameTextSize = screenSize.width * 0.03;

    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.height * 0.03;
    espacioAltoAux = screenSize.height * 0.01;

    imgWidth = screenSize.width / 5;
    imgBtnWidth = screenSize.width / 5;
    imgVolverHeight = screenSize.height / 32;
    btnRespuestaWidth = (screenSize.width - espacioPadding * 2) / 1.5;
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
            "Si ya estás preparado para empezar a jugar, volverás al menú principal de \'Humor\'.\n"
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
