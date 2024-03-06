import 'package:flutter/material.dart';
import 'package:rutinas/widgets/ExitDialog.dart';
import 'package:rutinas/widgets/ImageTextButton.dart';

class Ayuda extends StatefulWidget {
  // string que nos indica si la pantalla de origen es 'home' o 'menu'
  // para dependiendo de eso, mostrar un cuadro de dialogo u otro (exitDialogFromHome o exitDialogFromMenu)
  final String origen;

  Ayuda({required this.origen});

  @override
  _AyudaState createState() => _AyudaState();
}

class _AyudaState extends State<Ayuda> {
  // string que nos indica si la pantalla de origen es 'home' o 'menu'
  // para dependiendo de eso, mostrar un cuadro de dialogo u otro (exitDialogFromHome o exitDialogFromMenu)
  late String origen;

  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      imgHeight = 0.0,
      imgWidth = 0.0,
      imgVolverHeight = 0.0;

  late ImageTextButton btnSeguirAyuda,
      btnSalirAyudaFromHome,
      btnSalirFromMenu,
      btnJugar;

  late ExitDialog exitDialogFromHome,
      exitDialogFromMenu,
      helpCompletedDialogFromHome,
      helpCompletedDialogFromMenu;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    origen = widget.origen;
    _updateVariablesSize();
    _createButtonsFromDialogs();
    _createDialogs();

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
                    Text(
                      'Ayuda',
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
                        'Aquí descubrirás como jugar a \'Rutinas\', '
                        'juego que consiste en ordenar las acciones. '
                        '\nAquí tienes un ejemplo:',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Por favor, pon en orden lo que tiene que hacer Pepe para lavarse los dientes.',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/img/personajes/cerdo.png',
                      height: imgHeight * 1.3,
                      width: imgWidth * 1.3,
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto * 2), // Espacio entre los textos
                // AYUDA 1
                Row(
                  children: [
                    // Echar pasta de dientes
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/rutinas/higiene/lavarDientes/2.LavarDientes.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        Text(
                          'Echar pasta \nde dientes.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: imgWidth),
                    // Coger cepillo
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
                            'assets/img/rutinas/higiene/lavarDientes/1.LavarDientes.png',
                            height: imgHeight,
                            width: imgWidth,
                          ),
                          Text(
                            'Coger cepillo.',
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
                  'Para ordenar correctamente, comencemos pulsando en la acción \'Coger cepillo\'.',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto * 2), // Espacio entre los textos
                // AYUDA 2
                Row(
                  children: [
                    // Echar pasta de dientes
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
                            'assets/img/rutinas/higiene/lavarDientes/2.LavarDientes.png',
                            height: imgHeight,
                            width: imgWidth,
                          ),
                          Text(
                            'Echar pasta \nde dientes.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Coger cepillo
                    SizedBox(width: imgWidth),
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/rutinas/higiene/lavarDientes/1.LavarDientes.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        Text(
                          'Coger cepillo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto / 2), // Espacio entre los textos

                Text(
                  'Después de elegir la acción \'Coger cepillo\', '
                  'pulsamos en su posición correcta, '
                  'que en este caso es la acción \'Echar pasta de dientes\'.',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),

                SizedBox(height: espacioAlto * 2), // Espacio entre los textos
                Row(
                  children: [
                    // Echar pasta de dientes
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/rutinas/higiene/lavarDientes/2.LavarDientes.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        Text(
                          'Echar pasta \nde dientes.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: imgWidth),
                    //Coger cepillo
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/rutinas/higiene/lavarDientes/1.LavarDientes.png',
                          height: imgHeight,
                          width: imgWidth,
                        ),
                        Text(
                          'Coger cepillo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto / 2), // Espacio entre los textos
                Text(
                  'Ahora las acciones están en el orden correcto.'
                  '\n¡Muchas gracias por tu atención!',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto * 2),

                ImageTextButton(
                  image: Image.asset('assets/img/botones/fin.png',
                      width: imgWidth, height: imgHeight),
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
  void _updateVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal) {
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.04;
      imgHeight = screenSize.height / 5;
      imgWidth = screenSize.width / 5;
      imgVolverHeight = screenSize.height / 10;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.04;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.height / 10;
      imgWidth = screenSize.width / 5;
      imgVolverHeight = screenSize.height / 32;
    }
  }

  // metodo para crear los botones necesarios en los cuadros de dialogos
  void _createButtonsFromDialogs() {
    // boton para seguir en la pantalla de ayuda
    btnSeguirAyuda = ImageTextButton(
      image: Image.asset('assets/img/botones/ayuda.png', height: imgHeight),
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
      image: Image.asset('assets/img/botones/salir.png', height: imgHeight),
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
      image: Image.asset('assets/img/botones/salir.png', height: imgHeight),
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
      image: Image.asset('assets/img/botones/jugar.png', height: imgHeight),
      text: Text(
        '¡Estoy listo!',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
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
        rightImageTextButton: btnSalirAyudaFromHome,
        spaceRight: espacioPadding * 2);

    // cuadro de dialogo para salir de la pantalla de ayuda desde el menu
    exitDialogFromMenu = ExitDialog(
        title: 'Aviso',
        titleSize: titleSize,
        content: "¿Estás seguro de que quieres volver al menú principal?\n"
            "Puedes confirmar la salida o seguir viendo la ayuda",
        contentSize: textSize,
        leftImageTextButton: btnSeguirAyuda,
        rightImageTextButton: btnSalirFromMenu,
        spaceRight: espacioPadding * 2);

    // cuadro de dialogo de he completado la ayuda desde la pantalla principal
    helpCompletedDialogFromHome = ExitDialog(
        title: '¡Genial!',
        titleSize: titleSize,
        content:
            "Has acabado de ver la explicación de cómo jugar al juego 'Rutinas'.\n"
            "Si ya estás preparado para empezar a jugar, volverás al menú principal.\n"
            "Si todavía no te sientes preparado, no te preocupes, puedes seguir viendo la explicación de como jugar.",
        contentSize: textSize,
        leftImageTextButton: btnSeguirAyuda,
        rightImageTextButton: btnSalirAyudaFromHome,
        spaceRight: espacioPadding * 2);

    // cuadro de dialogo de he completado la ayuda desde el menu
    helpCompletedDialogFromMenu = ExitDialog(
        title: '¡Genial!',
        titleSize: titleSize,
        content:
            "Has acabado de ver la explicación de cómo jugar al juego 'Rutinas'.\n"
            "Si ya estás preparado para empezar a jugar, antes debes de indicarnos tu nombre y grupo.\n"
            "Si todavía no te sientes preparado, no te preocupes, puedes seguir viendo la explicación de como jugar.",
        contentSize: textSize,
        leftImageTextButton: btnJugar,
        rightImageTextButton: btnSeguirAyuda,
        spaceRight: espacioPadding * 2);
  }
}
