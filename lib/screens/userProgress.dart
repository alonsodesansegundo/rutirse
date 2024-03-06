import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutinas/db/obj/partida.dart';

import '../provider/MyProvider.dart';
import '../widgets/ImageTextButton.dart';

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
      imgHeight = 0.0,
      imgVolverHeight = 0.0;

  // botones
  late ImageTextButton btnVolver;

  // lista de partidas
  List<Partida>? partidas;

  // cabeceras de la tabla
  late DataColumn cabeceraFecha,
      cabeceraAciertos,
      cabeceraFallos,
      cabeceraDuracion;
  @override
  void initState() {
    super.initState();
    loadPartidas = false;
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createButtons();
    _createCabecerasTabla();

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
                  Text(
                    'Mis progresos',
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: titleSize,
                    ),
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
              SizedBox(height: espacioAlto), // Espacio entre los textos
              FutureBuilder<List<Partida>>(
                future: _cargarPartidas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return DataTable(
                      headingRowHeight: imgHeight / 1.2,
                      columns: [
                        cabeceraFecha,
                        cabeceraAciertos,
                        cabeceraFallos,
                        cabeceraDuracion,
                      ],
                      rows: snapshot.data!.map((Partida partida) {
                        return DataRow(cells: [
                          DataCell(Text(
                            _getFecha(partida.fechaFin),
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize,
                              color: Colors.black,
                            ),
                          )),
                          DataCell(Text(
                            partida.aciertos.toString(),
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize,
                              color: Colors.black,
                            ),
                          )),
                          DataCell(Text(
                            partida.fallos.toString(),
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize,
                              color: Colors.black,
                            ),
                          )),
                          DataCell(Text(
                            _getTime(partida.duracionSegundos),
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize,
                              color: Colors.black,
                            ),
                          )),
                        ]);
                      }).toList(),
                    );
                  } else {
                    return Text(
                      "Todavía no hay partidas, por lo que no tenemos datos para mostrarte.\n¡Te animamos a jugar!",
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

  void _updateVariablesSize() {
    Size screenSize = MediaQuery.of(context).size;

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal) {
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.02;
      espacioAlto = screenSize.height * 0.02;
      imgHeight = screenSize.height / 4;
      imgVolverHeight = screenSize.height / 10;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.height / 5;
      imgVolverHeight = screenSize.height / 32;
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

  void _createCabecerasTabla() {
    cabeceraFecha = DataColumn(
      label: Container(
        child: Column(
          children: [
            Image.asset('assets/img/calendario.png', height: imgHeight / 2),
            SizedBox(height: 8),
            Text(
              'Fecha',
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textSize,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );

    cabeceraAciertos = DataColumn(
      label: Column(
        children: [
          Image.asset('assets/img/medallas/correcto.png',
              height: imgHeight / 2),
          SizedBox(height: 8),
          Text(
            'Aciertos',
            style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textSize,
                color: Colors.black),
          ),
        ],
      ),
    );

    cabeceraFallos = DataColumn(
      label: Column(
        children: [
          Image.asset('assets/img/medallas/incorrecto.png',
              height: imgHeight / 2),
          SizedBox(height: 8),
          Text(
            'Fallos',
            style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textSize,
                color: Colors.black),
          ),
        ],
      ),
    );

    cabeceraDuracion = DataColumn(
      label: Column(
        children: [
          Image.asset('assets/img/duracion.png', height: imgHeight / 2),
          SizedBox(height: 8),
          Text(
            'Duracion',
            style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textSize,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  Future<List<Partida>> _cargarPartidas() async {
    if (!loadPartidas) {
      loadPartidas = true;
      try {
        var myProvider = Provider.of<MyProvider>(context);
        return await getPartidasByUserId(myProvider.jugador.id!);
      } catch (e) {
        print("Error al obtener la lista de partidas: $e");
        return [];
      }
    }
    return partidas ?? [];
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
