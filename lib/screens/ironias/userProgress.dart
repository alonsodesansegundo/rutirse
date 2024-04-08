import 'package:flutter/material.dart';

import '../../db/obj/partida.dart';
import '../../widgets/ImageTextButton.dart';

class UserProgressIronias extends StatefulWidget {
  @override
  _UserProgressIroniasState createState() => _UserProgressIroniasState();
}

class _UserProgressIroniasState extends State<UserProgressIronias> {
  late bool loadPartidas, loadData;

  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      textHeaderSize,
      imgVolverHeight,
      imgHeight,
      imgWidth,
      widthFecha,
      widthAciertos,
      widthFallos,
      widthDuracion;

  // botones
  late ImageTextButton btnVolver;

  // lista de partidas
  List<Partida>? partidas;

  @override
  void initState() {
    super.initState();
    loadData = false;
    loadPartidas = false;
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
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Alinea los elementos a la izquierda
                    children: [
                      Text(
                        'Ironias',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize,
                        ),
                      ),
                      Text(
                        'Mis progresos',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize / 2,
                        ),
                      ),
                    ],
                  ),
                  ImageTextButton(
                    image: Image.asset(
                      'assets/img/botones/volver.png',
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: espacioAlto), // Espacio entre los textos
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'En esta pantalla puedes observar tus progresos o resultados en el'
                      ' juego \'Ironias\'.\n'
                      'Dichos resultados están ordenados de más reciente a más antiguo.',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto),

              Row(
                children: [
                  Container(
                    width: widthFecha,
                    child: Column(
                      children: [
                        Image.asset('assets/img/calendario.png',
                            width: imgWidth),
                        SizedBox(height: espacioAlto * 0.25),
                        Text(
                          'Fecha de\nla partida',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textHeaderSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: widthAciertos,
                    child: Column(
                      children: [
                        Image.asset('assets/img/medallas/correcto.png',
                            width: imgWidth),
                        SizedBox(height: espacioAlto * 0.25),
                        Text(
                          'Rutinas\ncompletadas',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textHeaderSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: widthFallos,
                    child: Column(
                      children: [
                        Image.asset('assets/img/medallas/incorrecto.png',
                            width: imgWidth),
                        SizedBox(height: espacioAlto * 0.25),
                        Text(
                          'Intentos\n'
                          'fallidos',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textHeaderSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: widthDuracion,
                    child: Column(
                      children: [
                        Image.asset('assets/img/duracion.png', width: imgWidth),
                        SizedBox(height: espacioAlto * 0.25),
                        Text(
                          'Duración de\nla partida',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textHeaderSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto / 2),
            ],
          ),
        ),
      ),
    );
  }

  double getWidthOfText(String text, double fontSize, BuildContext context) {
    final TextSpan span = TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
    final TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: MediaQuery.of(context).size.width);
    return tp.width;
  }

  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.height * 0.03;
    imgWidth = screenSize.width / 6;
    imgVolverHeight = screenSize.height / 32;
    textHeaderSize = screenSize.width * 0.02;
    imgHeight = screenSize.width / 5;
    widthFecha = getWidthOfText(
          'DD/MM/AAAA',
          textSize * 0.8,
          context,
        ) *
        1.5;
    widthAciertos = getWidthOfText(
          'Rutinas\ncompletadas',
          textHeaderSize,
          context,
        ) *
        2;
    widthFallos = widthAciertos;

    widthDuracion = getWidthOfText(
          'Duración de\nla partida',
          textHeaderSize,
          context,
        ) *
        2;
  }

  void _createButtons() {
    btnVolver = ImageTextButton(
      image: Image.asset('assets/img/botones/volver.png', height: imgHeight),
      text: Text(
        'Volver',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.black),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
