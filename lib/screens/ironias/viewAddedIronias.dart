import 'package:TresEnUno/obj/SituacionIroniaPaginacion.dart';
import 'package:flutter/material.dart';

import '../../db/obj/grupo.dart';
import '../../db/obj/situacionIronia.dart';
import '../../widgets/ImageTextButton.dart';
import 'editIronia.dart';

class ViewAddedIronias extends StatefulWidget {
  @override
  _ViewAddedIroniasState createState() => _ViewAddedIroniasState();
}

class _ViewAddedIroniasState extends State<ViewAddedIronias> {
  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgVolverHeight,
      textSituacionWidth,
      btnWidth,
      btnHeight,
      imgWidth,
      columnText,
      celdaText,
      enunciadoWidth,
      grupoWidth,
      espacioCeldas;

  late ImageTextButton btnVolver;

  late ElevatedButton btnAnterior, btnSiguiente, btnBuscar;

  late int paginaActual, preguntasPagina;

  late List<SituacionIronia> situaciones;

  late bool hayMasPreguntas, loadGrupos, loadData;

  late List<Grupo> grupos;

  Grupo? selectedGrupo, selectedGrupoAux;

  late String txtBuscar = "", txtBuscarAux;

  late AlertDialog removePreguntaOk;

  @override
  void initState() {
    super.initState();
    loadData = false;
    paginaActual = 1;
    preguntasPagina = 5;
    situaciones = [];
    hayMasPreguntas = false;
    _loadPreguntas();
    selectedGrupo = null;
    selectedGrupoAux = null;
    txtBuscar = "";
    txtBuscarAux = "";
    grupos = [];
    _getGrupos();
  }

  @override
  Widget build(BuildContext context) {
    if (!loadData) {
      loadData = true;
      _createVariablesSize();
      _createButtons();
      _createDialogs();
    }

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
                            'Ironías',
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: titleSize,
                            ),
                          ),
                          Text(
                            'Ironías añadidas',
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
                        'Aquí puedes ver las diferentes preguntas sobre ironías que han añadido todos los terapeutas. '
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
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: espacioPadding / 2),
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
                                'Introduce el texto por el que quieres buscar...',
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

                Row(
                  children: [
                    Container(
                      width: grupoWidth,
                      child: Text(
                        'Grupo',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: columnText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: enunciadoWidth,
                      child: Text(
                        'Pregunta',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: columnText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),

                Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
                FutureBuilder<SituacionIroniaPaginacion>(
                  future: getSituacionesIroniasCreatedByTerapeuta(
                      paginaActual, preguntasPagina, txtBuscar, selectedGrupo),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (situaciones.isNotEmpty) {
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: preguntasPagina,
                            itemBuilder: (context, index) {
                              if (index < situaciones.length) {
                                final situacion = situaciones[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: espacioAlto),
                                  child: FutureBuilder<Grupo>(
                                    future: getGrupoById(situacion.grupoId),
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditIronia(
                                                  situacionIronia: situacion,
                                                  grupo: grupo,
                                                ),
                                              ),
                                            ).then((value) {
                                              _loadPreguntas();
                                            });
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
                                                        '${situacion.enunciado}',
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
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    EditIronia(
                                                              situacionIronia:
                                                                  situacion,
                                                              grupo: grupo,
                                                            ),
                                                          ),
                                                        ).then((value) {
                                                          _loadPreguntas();
                                                        });
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () {
                                                        AlertDialog aux =
                                                            AlertDialog(
                                                          title: Text(
                                                            'Aviso',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'ComicNeue',
                                                              fontSize:
                                                                  titleSize *
                                                                      0.75,
                                                            ),
                                                          ),
                                                          content: Text(
                                                            'Estás a punto de eliminar la siguiente pregunta del grupo ${grupo.nombre}:\n'
                                                            '${situacion.enunciado}\n'
                                                            '¿Estás seguro de ello?',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'ComicNeue',
                                                              fontSize:
                                                                  textSize,
                                                            ),
                                                          ),
                                                          actions: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _removePreguntaSelected(
                                                                        situacion
                                                                            .id!);
                                                                    setState(
                                                                        () {
                                                                      _loadPreguntas();
                                                                    });

                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return removePreguntaOk;
                                                                      },
                                                                    );
                                                                  },
                                                                  child: Text(
                                                                    'Sí, eliminar',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'ComicNeue',
                                                                      fontSize:
                                                                          textSize,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      espacioPadding,
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    'Cancelar',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'ComicNeue',
                                                                      fontSize:
                                                                          textSize,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );

                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return aux;
                                                          },
                                                        );
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
                    } else {
                      return Text(
                        "No hemos encontrado resultados.\n"
                        "¡Te ánimamos a que crees nuevas preguntas sobre ironías!",
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                          color: Colors.black,
                        ),
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

  double getWidthOfText(String text, BuildContext context) {
    final TextSpan span = TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: columnText,
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

  // Método para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _createVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

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

    grupoWidth = getWidthOfText(
          'Grupo',
          context,
        ) +
        espacioPadding * 2;

    enunciadoWidth =
        screenSize.width - (grupoWidth + 48 * 2 + espacioPadding * 3);
    espacioCeldas = espacioPadding;
  }

  // Método para crear los botones necesarios
  void _createButtons() {
    // boton para dar volver a la pantalla principal de ironias
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
      ),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey,
      ),
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
        FocusScope.of(context).unfocus();
        _loadPreguntas();
      },
      child: Text(
        'Buscar',
        style: TextStyle(
            fontFamily: 'ComicNeue', fontSize: textSize, color: Colors.white),
      ),
    );
  }

  // Metodo para crear los cuadros de dialogo necesarios
  void _createDialogs() {
    removePreguntaOk = AlertDialog(
      title: Text(
        'Éxito',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: titleSize * 0.75,
        ),
      ),
      content: Text(
        'La pregunta ha sido eliminada correctamente.\n'
        '¡Muchas gracias por tu colaboración!',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Aceptar',
                style: TextStyle(
                  fontFamily: 'ComicNeue',
                  fontSize: textSize,
                ),
              ),
            ),
          ],
        ),
      ],
    );
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

  Future<void> _loadPreguntas() async {
    SituacionIroniaPaginacion aux =
        await getSituacionesIroniasCreatedByTerapeuta(
            paginaActual, preguntasPagina, txtBuscar, selectedGrupo);

    setState(() {
      this.situaciones = aux.situaciones;
      this.hayMasPreguntas = aux.hayMasSituaciones;
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

  void _removePreguntaSelected(int preguntaId) {
    removePreguntaIronia(preguntaId);
  }
}
