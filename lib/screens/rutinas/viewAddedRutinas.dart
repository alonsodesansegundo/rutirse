import 'package:flutter/material.dart';

import '../../db/obj/grupo.dart';
import '../../db/obj/pregunta.dart';
import '../../obj/PreguntasPaginacion.dart';
import '../../widgets/ImageTextButton.dart';

class ViewAddedRutinas extends StatefulWidget {
  @override
  _ViewAddedRutinasState createState() => _ViewAddedRutinasState();
}

class _ViewAddedRutinasState extends State<ViewAddedRutinas> {
  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      imgVolverHeight = 0.0,
      textSituacionWidth = 0.0,
      btnWidth = 0.0,
      btnHeight = 0.0,
      imgWidth = 0.0,
      columnText = 0.0,
      celdaText = 0.0,
      enunciadoWidth = 0.0,
      grupoWidth = 0.0,
      espacioCeldas = 0.0;

  late ImageTextButton btnVolver;

  late ElevatedButton btnAnterior, btnSiguiente;

  late int paginaActual, preguntasPagina;

  late List<Pregunta> preguntas;

  late bool hayMasPreguntas;

  @override
  void initState() {
    super.initState();
    paginaActual = 1;
    preguntasPagina = 5;
    preguntas = [];
    hayMasPreguntas = false;
    _loadPreguntas();
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createButtons();
    _createDialogs();

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: espacioPadding, right: espacioPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
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
                            'Rutinas añadidas',
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
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Aquí puedes ver las diferentes preguntas sobre rutinas que han añadido todos los terapeutas. '
                        'Tienes la posibilidad de editarlas o eliminarlas según creas conveniente. Están ordenadas de más recientes a más antiguas.',
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
                    Text(
                      'Grupo',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: columnText,
                      ),
                    ),
                    SizedBox(width: grupoWidth * 0.5),
                    Text(
                      'Pregunta',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: columnText,
                      ),
                    ),
                  ],
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                FutureBuilder<PreguntasPaginacion>(
                  future: getPreguntasCreatedByTerapeuta(
                      paginaActual, preguntasPagina),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final preguntas = snapshot.data!.preguntas;
                      hayMasPreguntas = snapshot.data!.hayMasPreguntas;

                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: preguntasPagina,
                            itemBuilder: (context, index) {
                              if (index < preguntas.length) {
                                final pregunta = preguntas[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: espacioAlto),
                                  child: FutureBuilder<Grupo>(
                                    future: getGrupoById(pregunta.grupoId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error al cargar el grupo');
                                      } else {
                                        final grupo = snapshot.data;
                                        return GestureDetector(
                                          onTap: () {
                                            print(
                                                'Pregunta ID: ${pregunta.id}');
                                          },
                                          child: Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: grupoWidth,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${grupo!.nombre}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'ComicNeue',
                                                          fontSize: celdaText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: enunciadoWidth,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${pregunta.enunciado}',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'ComicNeue',
                                                          fontSize: celdaText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        width: espacioPadding),
                                                    IconButton(
                                                      icon: Icon(Icons.edit),
                                                      onPressed: () {
                                                        print(
                                                            'Editar pregunta con ID: ${pregunta.id}');
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () {
                                                        print(
                                                            'Eliminar pregunta con ID: ${pregunta.id}');
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (paginaActual != 1)
                      Row(
                        children: [
                          btnAnterior,
                          SizedBox(width: espacioPadding)
                        ],
                      ),
                    if (hayMasPreguntas) btnSiguiente,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _updateVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal) {
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.06;
      espacioAlto = screenSize.height * 0.03;
      imgVolverHeight = screenSize.height / 10;
      textSituacionWidth = screenSize.width - espacioPadding * 2;
      btnWidth = screenSize.width / 4;
      btnHeight = screenSize.height / 10;
      imgWidth = screenSize.width / 4;
      columnText = screenSize.width * 0.015;
      celdaText = screenSize.width * 0.0125;
      enunciadoWidth = screenSize.width / 2;
      grupoWidth = screenSize.width / 9;
      espacioCeldas = espacioPadding * 1.75;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgVolverHeight = screenSize.height / 32;
      textSituacionWidth = screenSize.width - espacioPadding * 2;
      btnWidth = screenSize.width / 3;
      btnHeight = screenSize.height / 15;
      imgWidth = screenSize.width / 4;
      columnText = screenSize.width * 0.025;
      celdaText = screenSize.width * 0.02;
      enunciadoWidth = screenSize.width / 2;
      grupoWidth = screenSize.width / 5;
      espacioCeldas = espacioPadding;
    }
  }

  // Método para crear los botones necesarios
  void _createButtons() {
    // boton para dar volver a la pantalla principal de rutinas
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

    btnAnterior = ElevatedButton(
      onPressed: () {
        _previousPage();
      },
      child: Text('Anterior'),
    );

    btnSiguiente = ElevatedButton(
      onPressed: () {
        _nextPage();
      },
      child: Text('Siguiente'),
    );
  }

  // Metodo para crear los cuadros de dialogo necesarios
  void _createDialogs() {}

  Future<void> _loadPreguntas() async {
    PreguntasPaginacion aux =
        await getPreguntasCreatedByTerapeuta(paginaActual, preguntasPagina);

    setState(() {
      this.preguntas = aux.preguntas;
      this.hayMasPreguntas = aux.hayMasPreguntas;
    });
  }

  void _previousPage() {
    if (paginaActual > 1) {
      setState(() {
        paginaActual--;
      });
      _loadPreguntas();
    }
  }

  void _nextPage() {
    setState(() {
      paginaActual++;
    });
    _loadPreguntas();
  }
}
