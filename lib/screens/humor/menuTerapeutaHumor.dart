import 'package:TresEnUno/screens/humor/addHumor.dart';
import 'package:TresEnUno/screens/humor/allProgressHumor.dart';
import 'package:TresEnUno/screens/humor/viewAddedHumor.dart';
import 'package:flutter/material.dart';

import '../../widgets/ImageTextButton.dart';

class MenuTerapeutaHumor extends StatefulWidget {
  @override
  _MenuTerapeutaHumorState createState() => _MenuTerapeutaHumorState();
}

class _MenuTerapeutaHumorState extends State<MenuTerapeutaHumor> {
  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgVolverHeight,
      btnWidth,
      btnHeight;

  late ElevatedButton btnAddIronia, btnListIronias, btnProgresos;

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
                        'Humor',
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
                      'Como terapeuta tienes la posibilidad de añadir nuevas situaciones, editar o eliminar '
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
                    btnAddIronia,
                    SizedBox(height: espacioAlto),
                    btnListIronias,
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
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.height * 0.03;
    imgVolverHeight = screenSize.height / 32;
    btnWidth = screenSize.width / 2.5;
    btnHeight = screenSize.height / 14;
  }

  // metodo para crear los botones necesarios
  void _createButtons() {
    // boton para dar la opcion de añadir una nueva ironia
    btnAddIronia = ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(btnWidth, btnHeight),
          backgroundColor: Colors.cyan,
        ),
        child: Text(
          'Añadir situación',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontSize: textSize,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHumor()),
          );
        });

    // boton para dar la opcion de ver las humor añadidas
    btnListIronias = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        backgroundColor: Colors.cyan,
      ),
      child: Text(
        'Situaciones existentes',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewAddedHumor()),
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
          MaterialPageRoute(builder: (context) => AllProgressHumor()),
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
