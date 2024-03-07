import 'package:flutter/material.dart';

import '../../widgets/ImageTextButton.dart';

class MenuTerapeuta extends StatefulWidget {
  @override
  _MenuTerapeutaState createState() => _MenuTerapeutaState();
}

class _MenuTerapeutaState extends State<MenuTerapeuta> {
  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      imgHeight = 0.0,
      imgVolverHeight = 0.0,
      espacioBotones = 0.0,
      btnWidth = 0.0,
      btnHeight = 0.0;

  late ElevatedButton btnAddRutina, btnListRutinas, btnProgresos;
  late ImageTextButton btnVolver;

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
                        'Rutinas',
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
                      'Como terapeuta tienes la posibilidad de añadir nuevas rutinas, editar o eliminar '
                      'las rutinas añadidas y ver el progreso de todos los usuarios.',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio
              Center(
                child: Column(
                  children: [
                    btnAddRutina,
                    SizedBox(height: espacioAlto),
                    btnListRutinas,
                    SizedBox(height: espacioAlto),
                    btnProgresos
                  ],
                ),
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
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.height / 7;
      imgVolverHeight = screenSize.height / 10;
      espacioBotones = screenSize.height * 0.3;
      btnWidth = screenSize.width / 4;
      btnHeight = screenSize.height / 10;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.height / 9;
      imgVolverHeight = screenSize.height / 32;
      espacioBotones = screenSize.height * 0.09;
      btnWidth = screenSize.width / 3;
      btnHeight = screenSize.height / 14;
    }
  }

  // metodo para crear los botones necesarios
  void _createButtons() {
    // boton para dar la opcion de añadir una nueva rutina
    btnAddRutina = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight), // Ajusta el tamaño del botón
        textStyle: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      child: Text(
        'Añadir rutina',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      onPressed: () {},
    );

    // boton para dar la opcion de añadir una nueva rutina
    btnListRutinas = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        textStyle: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.blue),
      ),
      child: Text(
        'Rutinas añadidas',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      onPressed: () {},
    );

    // boton para dar la opcion de ver los progresos de todos los usuarios
    btnProgresos = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        textStyle: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      child: Text(
        'Ver los progresos',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
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
