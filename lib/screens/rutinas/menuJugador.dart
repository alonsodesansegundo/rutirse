import 'package:TresEnUno/screens/rutinas/userProgress.dart';
import 'package:flutter/material.dart';

import '../../widgets/ExitDialog.dart';
import '../../widgets/ImageTextButton.dart';
import 'ayuda.dart';
import 'jugar.dart';
import 'opciones.dart';

class MenuJugador extends StatefulWidget {
  @override
  _MenuJugadorState createState() => _MenuJugadorState();
}

class _MenuJugadorState extends State<MenuJugador> {
  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioBotones = 0.0,
      espacioAlto = 0.0,
      imgVolverHeight = 0.0,
      imgBtnWidth = 0.0;

  late ExitDialog exitDialog;

  late ImageTextButton btnJugar,
      btnProgresos,
      btnOpciones,
      btnAyuda,
      btnSeguir,
      btnSalir;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createButtons();
    _createDialogs();

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
                      Text(
                        'Rutinas',
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
  void _updateVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal) {
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.06;
      espacioBotones = screenSize.height * 0.3;
      espacioAlto = screenSize.height * 0.03;
      imgVolverHeight = screenSize.height / 10;
      imgBtnWidth = screenSize.width / 10;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioBotones = screenSize.height * 0.09;
      espacioAlto = screenSize.height * 0.03;
      imgVolverHeight = screenSize.height / 32;
      imgBtnWidth = screenSize.width / 5;
    }
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Jugar()),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProgress()),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Opciones()),
        );
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Ayuda(
                    origen: 'menu',
                  )),
        );
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
