import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/obj/partidaRutinas.dart';
import '../../provider/MyProvider.dart';
import '../../widgets/ImageTextButton.dart';

class UserProgressRutinas extends StatefulWidget {
  @override
  _UserProgressRutinasState createState() => _UserProgressRutinasState();
}

class _UserProgressRutinasState extends State<UserProgressRutinas> {
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
  List<PartidaRutinas>? partidas;

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
                            Container(
                              width: widthFecha,
                              child: Align(
                                alignment: Alignment.center,
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
                            SizedBox(height: espacioPadding),
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

  Future<void> _cargarPartidas() async {
    if (!loadPartidas) {
      loadPartidas = true;
      try {
        var myProvider = Provider.of<MyProvider>(context);
        // obtengo las partidas del jugador correspondiente
        List<PartidaRutinas> partidasList =
            await getPartidasRutinasByUserId(myProvider.jugador.id!);
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
