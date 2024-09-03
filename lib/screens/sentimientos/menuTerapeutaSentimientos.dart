import 'package:Rutirse/screens/sentimientos/viewAddedSentimiento.dart';
import 'package:flutter/material.dart';

import '../../widgets/ImageTextButton.dart';
import 'addSentimiento.dart';
import 'allProgressSentimiento.dart';

///Pantalla menú para el terapeuta en el juego Sentimientos
class MenuTerapeutaSentimientos extends StatefulWidget {
  @override
  MenuTerapeutaSentimientosState createState() =>
      MenuTerapeutaSentimientosState();
}

/// Estado asociado a la pantalla [MenuTerapeutaSentimientos] que gestiona la lógica
/// y la interfaz de usuario de la pantalla
class MenuTerapeutaSentimientosState extends State<MenuTerapeutaSentimientos> {
  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgVolverHeight,
      btnWidth,
      btnHeight;

  late ElevatedButton btnAddSentimiento, btnListSentimiento, btnProgresos;

  late ImageTextButton btnVolver;

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sentimientos',
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
                      'Como terapeuta tienes la posibilidad de añadir nuevas preguntas, editar o eliminar '
                      'las situaciones existentes y ver el progreso de todos los usuarios.',
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
                    btnAddSentimiento,
                    SizedBox(height: espacioAlto),
                    btnListSentimiento,
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

  ///Método que se utiliza para darle valor a las variables relacionadas con tamaños de fuente, imágenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.width * 0.03;
    imgVolverHeight = screenSize.height / 32;
    btnWidth = screenSize.width / 2.5;
    btnHeight = screenSize.height / 14;
  }

  ///Método encargado de inicializar los botones de esta pantalla
  void _createButtons() {
    // boton para dar la opcion de añadir una nueva ironia
    btnAddSentimiento = ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(btnWidth, btnHeight),
          backgroundColor: Colors.cyan,
        ),
        child: Text(
          'Añadir pregunta',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontSize: textSize,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSentimiento()),
          );
        });

    // boton para dar la opcion de ver las preguntas añadidas
    btnListSentimiento = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        backgroundColor: Colors.cyan,
      ),
      child: Text(
        'Preguntas existentes',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewAddedSentimiento()),
        );
      },
    );

    // boton para dar la opcion de ver los progresos de todos los usuarios
    btnProgresos = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        backgroundColor: Colors.cyan,
      ),
      child: Text(
        'Ver los progresos',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllProgressSentimiento()),
        );
      },
    );

    // boton para dar volver a la pantalla principal
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
