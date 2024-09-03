import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/obj/partida.dart';
import '../../db/obj/partidaSentimientos.dart';
import '../../provider/MyProvider.dart';
import '../../widgets/ImageTextButton.dart';

///Pantalla que le permite a un jugador ver sus partidas en el juego Sentimientos
class UserProgressSentimientos extends StatefulWidget {
  @override
  _UserProgressSentimientosState createState() =>
      _UserProgressSentimientosState();
}

/// Estado asociado a la pantalla [UserProgressSentimientos] que gestiona la lógica
/// y la interfaz de usuario de la pantalla
class _UserProgressSentimientosState extends State<UserProgressSentimientos> {
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
                        'Sentimientos',
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
                      ' juego \'Sentimientos\'.\n'
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
                          'Situaciones\nacertadas',
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

  ///Método que nos permite obtener el ancho que se supone que ocuparía una cadena de texto
  ///<br><b>Parámetros</b><br>
  ///[text] Cadena de texto de la que queremos obtener el valor de ancho<br>
  ///[context] El contexto de la aplicación, que proporciona acceso a información
  ///sobre el entorno en el que se está ejecutando el widget, incluyendo el tamaño de la pantalla
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

  ///Método que se utiliza para darle valor a las variables relacionadas con tamaños de fuente, imágenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    titleSize = screenSize.width * 0.10;
    textSize = screenSize.width * 0.03;
    espacioPadding = screenSize.height * 0.03;
    espacioAlto = screenSize.width * 0.03;
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
          'Situaciones\ncompletadas',
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

  ///Método encargado de inicializar los botones que tendrá la pantalla
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

  ///Método que nos permite cargar las partidas del juego Sentimientos del jugador actual en la variable [partidas]
  Future<void> _cargarPartidas() async {
    if (!loadPartidas) {
      loadPartidas = true;
      try {
        var myProvider = Provider.of<MyProvider>(context);
        // obtengo las partidas del jugador correspondiente
        List<Partida> partidasList =
            await getPartidasSentimientosByUserId(myProvider.jugador.id!);
        setState(() {
          partidas = partidasList; // actualizo la lista
        });
      } catch (e) {
        // no se debe de producir ningún error al ser una BBDD local
        print("Error al obtener la lista de preguntas: $e"); //
      }
    }
  }

  ///Método que nos permite obtener la fecha DD/MM/AAAA de una cadena que es DD/MM/AAAA hh:mm:ss
  ///<br><b>Parámetros</b><br>
  ///[fecha] Fecha en formato DD/MM/AAAA hh:mm:ss
  ///<br><b>Salida</b><br>
  ///Fecha en formato DD/MM/AAAA
  String _getFecha(String fecha) {
    return fecha.substring(0, 10);
  }

  ///Método que nos permite pasar de segundos a horas, minutos y segundos en total
  ///<br><b>Parámetros</b><br>
  ///[duracionSegundos] Tiempo en segundos que queremos transformar
  ///<br><b>Salida</b><br>
  ///Cadena de texto resultante de la conversión
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
