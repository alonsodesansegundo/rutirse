import 'package:flutter/material.dart';

import '../../widgets/ExitDialog.dart';
import '../../widgets/ImageTextButton.dart';
import '../humor/ayudaHumor.dart';
import '../humor/jugarHumor.dart';
import '../humor/userProgressHumor.dart';
import '../rutinas/ayudaRutinas.dart';
import '../rutinas/jugarRutinas.dart';
import '../rutinas/userProgressRutinas.dart';
import '../sentimientos/ayudaSentimientos.dart';
import '../sentimientos/jugarSentimientos.dart';
import '../sentimientos/userProgressSentimientos.dart';
import 'opciones.dart';

///Pantalla que le aparece a un jugador a modo de menú tras finalizar una partida, a través de ella puede: Jugar, Ver partidas, Opciones o Ayuda del juego actual
class MenuJugador extends StatefulWidget {
  ///Variable que nos indica cual es el juego actual, el valor debe ser: rutinas, humor o sentimientos. Dependiendo de este valor se mostrarán unos textos u otros
  ///y seremos redirigidos a las pantallas que correspondan
  final String juego;

  MenuJugador({required this.juego});

  @override
  MenuJugadorState createState() => MenuJugadorState();
}

/// Estado asociado a la pantalla [MenuJugador] que gestiona la lógica
/// y la interfaz de usuario de la pantalla
class MenuJugadorState extends State<MenuJugador> {
  late double titleSize,
      textSize,
      espacioPadding,
      espacioBotones,
      espacioAlto,
      imgVolverHeight,
      imgBtnWidth;

  late ExitDialog exitDialog;

  late ImageTextButton btnJugar,
      btnProgresos,
      btnOpciones,
      btnAyuda,
      btnSeguir,
      btnSalir;

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
      _createButtons();
      _createDialogs();
    }

    return Scaffold(
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
                      if (widget.juego == 'rutinas')
                        Text(
                          'Rutinas',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: titleSize,
                          ),
                        ),
                      if (widget.juego == 'humor')
                        Text(
                          'Humor',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: titleSize,
                          ),
                        ),
                      if (widget.juego == 'sentimientos')
                        Text(
                          'Sentimientos',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: titleSize,
                          ),
                        ),
                      Text(
                        'Menú',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize / 2,
                        ),
                      ),
                    ],
                  ),
                  ImageTextButton(
                    image: Image.asset(
                      'assets/img/botones/home.png',
                      height: imgVolverHeight,
                    ),
                    text: Text(
                      'Volver',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // cuadro de dialogo
                          return exitDialog;
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio entre los textos
              Row(
                children: [
                  if (widget.juego == 'rutinas')
                    Expanded(
                      child: Text(
                        'Aquí tienes diferentes opciones para el juego \'Rutinas\'.\n'
                        'Estas opciones son: jugar, ver tus progresos, ver y cambiar las opciones y ver la ayuda.',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),
                  if (widget.juego == 'humor')
                    Expanded(
                      child: Text(
                        'Aquí tienes diferentes opciones para el juego \'Humor\'.\n'
                        'Estas opciones son: jugar, ver tus progresos, ver y cambiar las opciones y ver la ayuda.',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),
                  if (widget.juego == 'sentimientos')
                    Expanded(
                      child: Text(
                        'Aquí tienes diferentes opciones para el juego \'Sentimientos\'.\n'
                        'Estas opciones son: jugar, ver tus progresos, ver y cambiar las opciones y ver la ayuda.',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      btnJugar,
                      SizedBox(height: espacioAlto * 2),
                      btnOpciones
                    ],
                  ),
                  SizedBox(
                    width: espacioBotones,
                  ),
                  Column(
                    children: [
                      btnProgresos,
                      SizedBox(height: espacioAlto * 2),
                      btnAyuda
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Método que se utiliza para darle valor a las variables relacionadas con tamaños de fuente, imágenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioBotones = screenSize.height * 0.09;
    espacioAlto = screenSize.width * 0.03;
    imgVolverHeight = screenSize.height / 32;
    imgBtnWidth = screenSize.width / 5;
  }

  ///Método encargado de inicializar los cuadros de dialogo que tendrá la pantalla
  void _createDialogs() {
    // CUADROS DE DIALOGO
    // cuadro de dialogo para cuando quiere jugar pero los datos son incompletos
    exitDialog = ExitDialog(
        title: 'Aviso',
        titleSize: titleSize,
        content:
            "¿Estás seguro de que deseas salir del menú del juego 'Rutinas'?\n"
            "De esta manera volverás a la pantalla principal de la aplicación.",
        contentSize: textSize,
        leftImageTextButton: btnSeguir,
        rightImageTextButton: btnSalir);
  }

  ///Método encargado de inicializar los botones que tendrá la pantalla
  void _createButtons() {
    // boton para dar la opcion de jugar
    btnJugar = ImageTextButton(
      image: Image.asset('assets/img/botones/jugar.png', width: imgBtnWidth),
      text: Text(
        'Jugar',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        if (widget.juego == 'rutinas')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JugarRutinas()),
          );
        if (widget.juego == 'humor')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JugarHumor()),
          );

        if (widget.juego == 'sentimientos')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JugarSentimientos()),
          );
      },
    );

    // boton para dar la opcion de ver progresos
    btnProgresos = ImageTextButton(
      image:
          Image.asset('assets/img/botones/progresos.png', width: imgBtnWidth),
      text: Text(
        'Ver mis progresos',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        if (widget.juego == 'rutinas')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserProgressRutinas()),
          );

        if (widget.juego == 'humor')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserProgressHumor()),
          );

        if (widget.juego == 'sentimientos')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserProgressSentimientos()),
          );
      },
    );

    // boton para dar la opcion de ir a opciones
    btnOpciones = ImageTextButton(
      image: Image.asset('assets/img/botones/opciones.png', width: imgBtnWidth),
      text: Text(
        'Opciones',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        if (widget.juego == 'rutinas')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Opciones(juego: 'rutinas')),
          );

        if (widget.juego == 'humor')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Opciones(juego: 'humor')),
          );
        if (widget.juego == 'sentimientos') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Opciones(juego: 'sentimientos')),
          );
        }
      },
    );

    // boton para dar la opcion de ir a ayuda
    btnAyuda = ImageTextButton(
      image: Image.asset('assets/img/botones/ayuda.png', width: imgBtnWidth),
      text: Text(
        'Ayuda',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        if (widget.juego == 'rutinas')
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AyudaRutinas(
                      origen: 'menu',
                    )),
          );
        if (widget.juego == 'humor') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AyudaHumor(
                      origen: 'menu',
                    )),
          );
        }

        if (widget.juego == 'sentimientos') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AyudaSentimientos(
                      origen: 'menu',
                    )),
          );
        }
      },
    );

    // boton para seguir en el menú principal
    btnSeguir = ImageTextButton(
      image: Image.asset('assets/img/botones/menu.png', width: imgBtnWidth),
      text: Text(
        'Seguir en el menú',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // boton para salir del menú principal
    btnSalir = ImageTextButton(
      image: Image.asset('assets/img/botones/home.png', width: imgBtnWidth),
      text: Text(
        'Salir',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
    );
  }
}
