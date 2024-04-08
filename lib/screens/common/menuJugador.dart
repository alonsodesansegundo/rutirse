import 'package:TresEnUno/screens/ironias/JugarIronias.dart';
import 'package:TresEnUno/screens/ironias/ayuda.dart';
import 'package:TresEnUno/screens/rutinas/userProgress.dart';
import 'package:flutter/material.dart';

import '../../widgets/ExitDialog.dart';
import '../../widgets/ImageTextButton.dart';
import '../ironias/userProgress.dart';
import '../rutinas/ayuda.dart';
import '../rutinas/jugar.dart';
import 'opciones.dart';

class MenuJugador extends StatefulWidget {
  // string que nos indica en que juego estamos
  final String juego;

  MenuJugador({required this.juego});

  @override
  _MenuJugadorState createState() => _MenuJugadorState();
}

class _MenuJugadorState extends State<MenuJugador> {
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
                      if (widget.juego == 'ironias')
                        Text(
                          'Ironías',
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
                  if (widget.juego == 'ironias')
                    Expanded(
                      child: Text(
                        'Aquí tienes diferentes opciones para el juego \'Ironías\'.\n'
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

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioBotones = screenSize.height * 0.09;
    espacioAlto = screenSize.height * 0.03;
    imgVolverHeight = screenSize.height / 32;
    imgBtnWidth = screenSize.width / 5;
  }

  // metodo para crear los cuadro de dialogos
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

  // metodo para crear los botones necesarios
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
        if (widget.juego == 'ironias')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JugarIronias()),
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

        if (widget.juego == 'ironias')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserProgressIronias()),
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

        if (widget.juego == 'ironias')
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Opciones(juego: 'ironias')),
          );
        if (widget.juego == 'sentimientos') {}
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
        if (widget.juego == 'ironias') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AyudaIronias(
                      origen: 'menu',
                    )),
          );
        }

        if (widget.juego == 'sentimientos') {}
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
