import 'package:flutter/material.dart';

import '../../db/obj/grupo.dart';
import '../../db/obj/partidaView.dart';
import '../../obj/PartidasPaginacion.dart';
import '../../widgets/ImageTextButton.dart';

class AllProgress extends StatefulWidget {
  @override
  _AllProgressState createState() => _AllProgressState();
}

class _AllProgressState extends State<AllProgress> {
  late bool loadPartidas;

  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      imgHeight = 0.0,
      textHeaderSize = 0.0,
      imgVolverHeight = 0.0;

  late int paginaActual, preguntasPagina;

  // botones
  late ImageTextButton btnVolver;

  late ElevatedButton btnAnterior, btnSiguiente, btnBuscar;

  // lista de partidas
  List<PartidaView>? partidas;

  // cabeceras de la tabla
  late DataColumn cabeceraFecha,
      cabeceraUsuario,
      cabeceraProgreso,
      cabeceraDuracion;

  Grupo? selectedGrupo, selectedGrupoAux;

  late String txtBuscar, txtBuscarAux;

  late List<Grupo> grupos;

  late bool hayMasPartidas;

  @override
  void initState() {
    super.initState();
    loadPartidas = false;
    selectedGrupo = null;
    selectedGrupoAux = null;
    txtBuscar = "";
    txtBuscarAux = "";
    paginaActual = 1;
    preguntasPagina = 5;
    hayMasPartidas = false;
    _loadProgresos();
    grupos = [];
    _getGrupos();
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rutinas',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: titleSize,
                        ),
                      ),
                      Text(
                        'Todos los progresos',
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
                      'En esta pantalla puedes observar los progresos o resultados en el'
                      ' juego \'Rutinas\' de todos los usuarios.\n'
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
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: espacioPadding / 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        onChanged: (text) {
                          this.txtBuscarAux = text;
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              'Introduce el usuario que quieres buscar...',
                          hintStyle: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize * 0.75,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: espacioPadding),
                  btnBuscar
                ],
              ),
              SizedBox(height: espacioAlto / 2),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: espacioPadding / 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200],
                    ),
                    child: DropdownButton<Grupo>(
                      hint: Text(
                        'Grupo',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize * 0.75,
                        ),
                      ),
                      value: selectedGrupoAux,
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            'Grupo',
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize * 0.75,
                            ),
                          ),
                        ),
                        ...grupos.map((Grupo grupo) {
                          return DropdownMenuItem<Grupo>(
                            value: grupo,
                            child: Text(
                              grupo.nombre,
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: textSize * 0.75,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (Grupo? grupo) {
                        setState(() {
                          if (grupo?.nombre == 'Grupo')
                            selectedGrupoAux = null;
                          else
                            selectedGrupoAux = grupo;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: espacioAlto),
              FutureBuilder<void>(
                future: getAllPartidasView(
                    paginaActual, preguntasPagina, txtBuscar, selectedGrupo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (partidas != null && partidas!.isNotEmpty) {
                    return DataTable(
                      columns: [
                        cabeceraFecha,
                        cabeceraUsuario,
                        cabeceraProgreso,
                        cabeceraDuracion,
                      ],
                      rows: partidas!.map((PartidaView partida) {
                        return DataRow(cells: [
                          DataCell(Text(
                            _getFecha(partida.fechaFin),
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize * 0.6,
                              color: Colors.black,
                            ),
                          )),
                          DataCell(Text(
                            partida.jugadorName +
                                "\n(" +
                                partida.grupoName +
                                ")",
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize * 0.6,
                              color: Colors.black,
                            ),
                          )),
                          DataCell(Text(
                            partida.aciertos.toString() +
                                "/" +
                                (partida.fallos + partida.aciertos).toString(),
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize * 0.6,
                              color: Colors.black,
                            ),
                          )),
                          DataCell(Text(
                            _getTime(partida.duracionSegundos),
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize * 0.6,
                              color: Colors.black,
                            ),
                          )),
                        ]);
                      }).toList(),
                    );
                  } else {
                    return Text(
                      "No hemos encontrado resultados.\n"
                      "¡Ánima a los usuarios a jugar! Así podrás ver como progresan.",
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: espacioAlto),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (paginaActual != 1)
                    Row(
                      children: [btnAnterior, SizedBox(width: espacioPadding)],
                    ),
                  if (hayMasPartidas) btnSiguiente,
                ],
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
      espacioPadding = screenSize.height * 0.06;
      espacioAlto = screenSize.height * 0.02;
      imgHeight = screenSize.height / 4;
      imgVolverHeight = screenSize.height / 10;
      textHeaderSize = screenSize.width * 0.015;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.width / 5;
      imgVolverHeight = screenSize.height / 32;
      textHeaderSize = screenSize.width * 0.019;
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

    btnAnterior = ElevatedButton(
      onPressed: () {
        _previousPage();
      },
      child: Text(
        'Anterior',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.white),
      ),
    );

    btnSiguiente = ElevatedButton(
      onPressed: () {
        _nextPage();
      },
      child: Text(
        'Siguiente',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.white),
      ),
    );

    btnBuscar = ElevatedButton(
      onPressed: () {
        paginaActual = 1;
        selectedGrupo = selectedGrupoAux;
        txtBuscar = txtBuscarAux;
        _loadProgresos();
      },
      child: Text(
        'Buscar',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.white),
      ),
    );
  }

  void _createCabecerasTabla() {
    cabeceraFecha = DataColumn(
      label: Container(
        child: Column(
          children: [
            Text(
              'Fecha de \nla partida',
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textHeaderSize,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    cabeceraUsuario = DataColumn(
      label: Container(
        child: Column(
          children: [
            Text(
              'Usuario\n(grupo)',
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textHeaderSize,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    cabeceraProgreso = DataColumn(
      label: Column(
        children: [
          Text(
            'Progreso\n(completadas/intentos)',
            style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textHeaderSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ],
      ),
    );

    cabeceraDuracion = DataColumn(
      label: Column(
        children: [
          Text(
            'Duración',
            style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textHeaderSize,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ],
      ),
    );
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

  // Método para obtener la lista de grupos de la BBDD
  Future<void> _getGrupos() async {
    try {
      List<Grupo> gruposList = await getGrupos();
      setState(() {
        grupos = gruposList;
      });
    } catch (e) {
      print("Error al obtener la lista de grupos: $e");
    }
  }

  Future<void> _loadProgresos() async {
    PartidasPaginacion aux = await getAllPartidasView(
        paginaActual, preguntasPagina, txtBuscar, selectedGrupo);

    setState(() {
      this.partidas = aux.partidas;
      this.hayMasPartidas = aux.hayMasPartidas;
    });
  }

  void _previousPage() {
    if (paginaActual > 1) {
      setState(() {
        paginaActual--;
      });
      _loadProgresos();
    }
  }

  void _nextPage() {
    setState(() {
      paginaActual++;
    });
    _loadProgresos();
  }
}
