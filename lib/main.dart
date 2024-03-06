import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutinas/provider/MyProvider.dart';
import 'package:rutinas/screens/rutinas/homeRutinas.dart';
import 'package:rutinas/widgets/ImageTextButton.dart';

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
      imgWidth = 0.0;

  late ImageTextButton btnRutinas, btnIronias, btnAnimo, btnInfo;

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
                // Título Rutinas
                Text(
                  "Apperger",
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                // Explicación pantalla
                Text(
                  '¡Hola! A continuación puedes elegir entre una serie de juegos, con '
                  'ellos tenemos como objetivo ayudarte a mejorar '
                  'en diferentes situaciones que puedes encontrarte en tu día a día.\n'
                  '¡Esperamos haberlo logrado y que puedas disfrutar de esta experiencia!',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                Row(
                  children: [
                    btnRutinas,
                    SizedBox(width: espacioPadding),
                    btnAnimo,
                    SizedBox(width: espacioPadding),
                    btnIronias
                  ],
                ),
                SizedBox(height: imgHeight + espacioAlto * 4),
                btnInfo,
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
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.02;
      espacioJugar = screenSize.height * 0.02;
      imgHeight = screenSize.height / 6;
      imgWidth = screenSize.width / 4;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      espacioJugar = 0;
      imgHeight = screenSize.height / 8;
      imgWidth = screenSize.width / 5;
    }
  }

  void _createButtons() {
    btnRutinas = ImageTextButton(
      image: Image.asset('assets/img/botones/rutinas.png', height: imgHeight),
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
        image: Image.asset('assets/img/botones/sentimientos.png',
            height: imgHeight),
        text: Text(
          '¿Cómo me siento?',
          style: TextStyle(
              fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
        ),
        onPressed: () {});

    btnIronias = ImageTextButton(
      image: Image.asset('assets/img/botones/ironias.png', height: imgHeight),
      text: Text(
        'Ironías',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {},
    );

    btnInfo = ImageTextButton(
      image: Image.asset('assets/img/botones/info.png', height: imgHeight),
      text: Text(
        'Acerca de',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {},
    );
  }
}
