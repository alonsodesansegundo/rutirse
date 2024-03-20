import 'package:TresEnUno/screens/rutinas/menuTerapeuta.dart';
import 'package:flutter/material.dart';

import '../../widgets/ImageTextButton.dart';

class HomeTerapeuta extends StatefulWidget {
  @override
  _HomeTerapeutaState createState() => _HomeTerapeutaState();
}

class _HomeTerapeutaState extends State<HomeTerapeuta> {
  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      imgHeight = 0.0,
      imgVolverHeight = 0.0,
      espacioBotones = 0.0,
      btnWidth = 0.0,
      imgWidth = 0.0,
      btnHeight = 0.0;

  late ImageTextButton btnVolver, btnRutinas, btnAnimo, btnIronias;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createButtons();

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TresEnUno',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize,
                        ),
                      ),
                      Text(
                        'Menú Terapeuta',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize / 2,
                        ),
                      ),
                    ],
                  ),
                  btnVolver,
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio entre los textos
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Como terapeuta tienes la posibilidad de acceder a los distintos juegos, ya '
                      'sea para añadir nuevas preguntas, modificar o eliminar preguntas añadidas'
                      ' por terapeutas o consultar los datos de cualquier jugador para ver su progreso. ',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto),
              Text(
                '¿A qué juego quieres acceder?',
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
              SizedBox(height: espacioAlto), // Espacio
              Row(
                children: [btnRutinas, btnAnimo, btnIronias],
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
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.height / 4;
      imgVolverHeight = screenSize.height / 10;
      espacioBotones = screenSize.height * 0.3;
      btnWidth = screenSize.width / 4;
      btnHeight = screenSize.height / 10;
      imgWidth = screenSize.width / 3 - espacioPadding * 2.25;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.height / 10;
      imgVolverHeight = screenSize.height / 32;
      espacioBotones = screenSize.height * 0.09;
      btnWidth = screenSize.width / 3;
      btnHeight = screenSize.height / 14;
      imgWidth = screenSize.width / 3 - espacioPadding * 2;
    }
  }

  // metodo para crear los botones necesarios
  void _createButtons() {
    btnRutinas = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/rutinas.png',
        width: imgWidth,
      ),
      text: Text(
        'Rutinas',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuTerapeuta()),
        );
      },
    );
    btnAnimo = ImageTextButton(
        image: Image.asset(
          'assets/img/botones/sentimientos.png',
          width: imgWidth,
        ),
        text: Text(
          'Sentimientos',
          style: TextStyle(
              fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
        ),
        onPressed: () {});

    btnIronias = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/ironias.png',
        width: imgWidth,
      ),
      text: Text(
        'Ironías',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {},
    );

    // boton para dar volver a la pantalla principal de rutinas
    btnVolver = ImageTextButton(
      image:
          Image.asset('assets/img/botones/home.png', height: imgVolverHeight),
      text: Text(
        'Volver',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
