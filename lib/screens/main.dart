import 'package:TresEnUno/screens/homeTerapeuta.dart';
import 'package:TresEnUno/screens/rutinas/homeRutinas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/MyProvider.dart';
import '../widgets/ImageTextButton.dart';
import 'informacion.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // Wrap tu aplicación con ChangeNotifierProvider
      create: (context) => MyProvider(), // Crea una instancia de tu Provider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutinas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      espacioJugar = 0.0,
      imgHeight = 0.0,
      imgWidth = 0.0,
      espacioAcercaDe = 0.0;

  late ImageTextButton btnRutinas, btnIronias, btnAnimo, btnTerapeuta, btnInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createButtons();

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(espacioPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TresEnUno',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: titleSize,
                          ),
                        ),
                        Image.asset(
                          'assets/img/icon.png',
                          height: imgHeight,
                        ),
                      ],
                    ),
                    Text(
                      'Juegos de Habilidad Social',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: titleSize / 2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                // Explicación pantalla
                Text(
                  '¡Hola! A continuación, puedes elegir entre una serie de juegos. '
                  'Con ellos, tenemos como objetivo ayudarte a mejorar en diferentes '
                  'situaciones que puedes encontrarte en tu día a día.\n¡Esperamos haberlo '
                  'logrado y que disfrutes de esta experiencia!',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                Text(
                  '¿A qué te apetece jugar?',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                Row(
                  children: [btnRutinas, btnAnimo, btnIronias],
                ),

                SizedBox(height: espacioAcercaDe),
                Text(
                  'Otras opciones:',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto),
                Row(
                  children: [btnTerapeuta, btnInfo],
                )
              ],
            ),
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
      espacioAlto = screenSize.height * 0.02;
      espacioJugar = screenSize.height * 0.02;
      imgHeight = screenSize.height / 4;
      espacioAcercaDe = espacioAlto * 4;
      imgWidth = screenSize.width / 3 - espacioPadding * 2.25;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.015;
      espacioJugar = 0;
      imgHeight = screenSize.height / 10;
      espacioAcercaDe = espacioAlto * 2;
      imgWidth = screenSize.width / 3 - espacioPadding * 2;
    }
  }

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
          MaterialPageRoute(builder: (context) => HomeRutinas()),
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

    btnTerapeuta = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/terapeuta.png',
        width: imgWidth,
      ),
      text: Text(
        'Soy terapeuta',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeTerapeuta()),
        );
      },
    );

    btnInfo = ImageTextButton(
      image: Image.asset(
        'assets/img/botones/info.png',
        width: imgWidth,
      ),
      text: Text(
        'Acerca de',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Informacion()),
        );
      },
    );
  }
}
