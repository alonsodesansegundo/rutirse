import 'package:flutter/material.dart';

import '../../widgets/ImageTextButton.dart';

class Informacion extends StatefulWidget {
  @override
  _InformacionState createState() => _InformacionState();
}

class _InformacionState extends State<Informacion> {
  late double titleSize, textSize, espacioPadding, espacioAlto, imgHeight;
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
    }

    return MaterialApp(
      home: Scaffold(
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
                          'Rutirse',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: titleSize,
                          ),
                        ),
                        Text(
                          'Acerca de',
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
                        height: imgHeight,
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
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto),
                Text(
                  "Aplicación diseñada y desarrollada por Lucas Alonso de San Segundo, con la colaboración de Adriana Dapena Janeiro.",
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: espacioAlto),
                Text(
                  'Recursos utilizados:',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: Text(
                    'ComicNeue-Regular',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Diseñadores: Craig Rozynski y Hrant Papazian.\n'
                    'Origen: Google Fonts (https://fonts.google.com). '
                    '\nLicencia: SIL Open Font License (OFL).'
                    '\nPropiedad: Craig Rozynski y Hrant Papazian.',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Pictogramas',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Autor pictogramas: Sergio Palao.\n'
                    'Origen: ARASAAC (http://www.arasaac.org). '
                    '\nLicencia: CC (BY-NC-SA).'
                    '\nPropiedad: Gobierno de Aragón (España)',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                    ),
                  ),
                ),
                SizedBox(height: espacioAlto),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para asignar valores a las variables relacionadas con tamaños de fuente, imágenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // Tamaño del dispositivo

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.width * 0.03;
    imgHeight = screenSize.height / 32;
  }
}
