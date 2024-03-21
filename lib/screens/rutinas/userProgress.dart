import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/obj/partida.dart';
import '../../provider/MyProvider.dart';
import '../../widgets/ImageTextButton.dart';

class UserProgress extends StatefulWidget {
  @override
  _UserProgressState createState() => _UserProgressState();
}

class _UserProgressState extends State<UserProgress> {
  late bool loadPartidas;

  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      textHeaderSize = 0.0,
      imgVolverHeight = 0.0,
      imgHeight = 0.0,
      imgWidth = 0.0,
      widthFecha = 0.0,
      widthAciertos = 0.0,
      widthFallos = 0.0,
      widthDuracion = 0.0;

  // botones
  late ImageTextButton btnVolver;

  // lista de partidas
  List<Partida>? partidas;

  @override
  void initState() {
    super.initState();
    loadPartidas = false;
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
                      ' juego \'Rutinas\'.\n'
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
                  SizedBox(width: espacioPadding),
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
              FutureBuilder<void>(
                future: _cargarPartidas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (partidas != null && partidas!.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: partidas!.length,
                      itemBuilder: (context, index) {
                        final partida = partidas![index];
                        return Row(
                          children: [
                            SizedBox(width: espacioPadding),
                            Container(
                              width: widthFecha,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _getFecha(partida.fechaFin),
                                  style: TextStyle(
                                    fontFamily: 'ComicNeue',
                                    fontSize: textSize * 0.8,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: widthAciertos,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  partida.aciertos.toString(),
                                  style: TextStyle(
                                    fontFamily: 'ComicNeue',
                                    fontSize: textSize * 0.8,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: widthFallos,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  partida.fallos.toString(),
                                  style: TextStyle(
                                    fontFamily: 'ComicNeue',
                                    fontSize: textSize * 0.8,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: widthDuracion,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  _getTime(partida.duracionSegundos),
                                  style: TextStyle(
                                    fontFamily: 'ComicNeue',
                                    fontSize: textSize * 0.8,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Text(
                      "Todavía no hay partidas, por lo que no tenemos datos para mostrarte.\n"
                      "¡Te animamos a jugar!",
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getWidthOfText(String text, BuildContext context) {
    final TextSpan span = TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: textHeaderSize,
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

  void _updateVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal) {
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.06;
      espacioAlto = screenSize.height * 0.02;
      imgWidth = screenSize.width / 6;
      imgVolverHeight = screenSize.height / 10;
      textHeaderSize = screenSize.width * 0.015;
      imgHeight = screenSize.width / 5;

      widthFecha = getWidthOfText(
            'Fecha de \nla partida',
            context,
          ) *
          2;
      widthAciertos = getWidthOfText(
            'Rutinas\ncompletadas',
            context,
          ) *
          2;
      widthFallos = getWidthOfText(
            'Intentos\nfallidos',
            context,
          ) *
          3;

      widthDuracion = getWidthOfText(
            'Duración de\nla partida',
            context,
          ) *
          4;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgWidth = screenSize.width / 6;
      imgVolverHeight = screenSize.height / 32;
      textHeaderSize = screenSize.width * 0.02;
      imgHeight = screenSize.width / 5;
      widthFecha = getWidthOfText(
            'Fecha de \nla partida',
            context,
          ) *
          2;
      widthAciertos = getWidthOfText(
            'Rutinas\ncompletadas',
            context,
          ) *
          2;
      widthFallos = getWidthOfText(
            'Intentos\nfallidos',
            context,
          ) *
          2.5;

      widthDuracion = getWidthOfText(
            'Duración de\nla partida',
            context,
          ) *
          2;
    }
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

  Future<void> _cargarPartidas() async {
    if (!loadPartidas) {
      loadPartidas = true;
      try {
        var myProvider = Provider.of<MyProvider>(context);
        // obtengo las partidas del jugador correspondiente
        List<Partida> partidasList =
            await getPartidasByUserId(myProvider.jugador.id!);
        setState(() {
          partidas = partidasList; // actualizo la lista
        });
      } catch (e) {
        // no se debe de producir ningún error al ser una BBDD local
        print("Error al obtener la lista de preguntas: $e"); //
      }
    }
  }

  String _getFecha(String fecha) {
    return fecha.substring(0, 10);
  }

  String _getTime(int duracionSegundos) {
    int horas = duracionSegundos ~/ 3600;
    int minutos = (duracionSegundos % 3600) ~/ 60;
    int segundos = duracionSegundos % 60;

    String tiempoFormateado = '';

    if (horas > 0) {
      tiempoFormateado += '${horas}h ';
      if (minutos <= 0)
        tiempoFormateado += '${minutos.toString().padLeft(2, '0')}min ';
    }

    if (minutos > 0) {
      tiempoFormateado += '${minutos.toString().padLeft(2, '0')}min ';
    }

    tiempoFormateado += '${segundos.toString().padLeft(2, '0')}s';

    return tiempoFormateado;
  }
}
