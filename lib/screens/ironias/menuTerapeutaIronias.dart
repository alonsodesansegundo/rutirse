import 'package:TresEnUno/screens/ironias/addIronia.dart';
import 'package:TresEnUno/screens/ironias/allProgressIronias.dart';
import 'package:flutter/material.dart';

import '../../widgets/ImageTextButton.dart';

class MenuTerapeutaIronias extends StatefulWidget {
  @override
  _MenuTerapeutaIroniasState createState() => _MenuTerapeutaIroniasState();
}

class _MenuTerapeutaIroniasState extends State<MenuTerapeutaIronias> {
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
                        'Ironías',
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
                      'Como terapeuta tienes la posibilidad de añadir nuevas ironías, editar o eliminar '
                      'las ironías añadidas y ver el progreso de todos los usuarios.',
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
    btnWidth = screenSize.width / 3;
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
          'Añadir ironía',
          style: TextStyle(
            fontFamily: 'ComicNeue',
            fontSize: textSize,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddIronia()),
          );
        });

    // boton para dar la opcion de ver las ironias añadidas
    btnListIronias = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        backgroundColor: Colors.cyan,
      ),
      child: Text(
        'Ironías añadidas',
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
          MaterialPageRoute(builder: (context) => AllProgressIronia()),
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
