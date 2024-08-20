import 'dart:io';

import 'package:Rutirse/widgets/ElementRespuestaSentimientos.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/obj/grupo.dart';
import '../../db/obj/preguntaSentimiento.dart';
import '../../widgets/ArasaacImageDialog.dart';
import '../../widgets/ImageTextButton.dart';
import '../main.dart';

class AddSentimiento extends StatefulWidget {
  @override
  _AddSentimientoState createState() => _AddSentimientoState();
}

class _AddSentimientoState extends State<AddSentimiento> {
  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgVolverHeight,
      textSituacionWidth,
      btnWidth,
      btnHeight,
      imgWidth;

  late ImageTextButton btnVolver;

  late List<Grupo> grupos;

  Grupo? selectedGrupo; // Variable para almacenar el grupo seleccionado

  late String preguntaText, correctText;

  late ElevatedButton btnGaleria, btnArasaac, btnEliminarImage;

  late ArasaacImageDialog arasaacImageDialog;

  late AlertDialog incompletedParamsDialog,
      completedParamsDialog,
      noInternetDialog;

  late bool firstLoad, esIronia, noEsIronia;

  late List<int> image;

  late List<ElementRespuestaSentimientos> respuestas;

  late Color colorSituacion,
      colorGrupo,
      colorCorrectText,
      colorBordeImagen,
      colorCheckbox;

  @override
  void initState() {
    super.initState();
    firstLoad = false;

    grupos = [];
    preguntaText = "";
    correctText = "";
    respuestas = [];
    firstLoad = false;
    image = [];
    selectedGrupo = null;
    colorSituacion = Colors.transparent;
    colorCorrectText = Colors.transparent;
    colorGrupo = Colors.transparent;
    colorBordeImagen = Colors.transparent;
    colorCheckbox = Colors.transparent;
    esIronia = false;
    noEsIronia = false;

    _initializeState();
  }

  Future<void> _initializeState() async {
    await _getGrupos();

    _createDialogs();
  }

  @override
  Widget build(BuildContext context) {
    if (!firstLoad) {
      firstLoad = true;
      _createVariablesSize();
      _createButtons();
    }

    return Scaffold(
      body: DynMouseScroll(
        durationMS: myDurationMS,
        scrollSpeed: myScrollSpeed,
        animationCurve: Curves.easeOutQuart,
        builder: (context, controller, physics) => SingleChildScrollView(
          controller: controller,
          physics: physics,
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
                          'Sentimientos',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: titleSize,
                          ),
                        ),
                        Text(
                          'Añadir pregunta',
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
                SizedBox(height: espacioAlto), // Espacio entre los textos
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Aquí puedes crear nuevas preguntas para el juego de Sentimientos.',
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto), // Espacio
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Grupo*:',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                        SizedBox(width: espacioPadding),
                        Container(
                          decoration: BoxDecoration(
                            color: colorGrupo,
                          ),
                          child: DropdownButton<Grupo>(
                            padding: EdgeInsets.only(
                              left: espacioPadding,
                            ),
                            hint: Text(
                              'Selecciona el grupo',
                              style: TextStyle(
                                fontFamily: 'ComicNeue',
                                fontSize: textSize,
                              ),
                            ),
                            value: selectedGrupo,
                            items: grupos.map((Grupo grupo) {
                              return DropdownMenuItem<Grupo>(
                                value: grupo,
                                child: Text(
                                  grupo.nombre,
                                  style: TextStyle(
                                    fontFamily: 'ComicNeue',
                                    fontSize: textSize,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (Grupo? grupo) {
                              setState(() {
                                selectedGrupo = grupo;
                                respuestas = [];
                                setState(() {
                                  respuestas
                                      .add(new ElementRespuestaSentimientos(
                                    text1: "Respuesta",
                                    isCorrect: true,
                                    textSize: textSize,
                                    espacioPadding: getWidthOfText(
                                            "(máx. 30 caracteres)", context) +
                                        espacioPadding * 1.5,
                                    espacioAlto: espacioAlto,
                                    btnWidth: btnWidth,
                                    btnHeight: btnHeight,
                                    imgWidth: imgWidth,
                                    onPressedGaleria: () =>
                                        _selectNewActionGallery(0),
                                    onPressedArasaac: () =>
                                        _selectNewRespuestaArasaac(0),
                                    showPregunta: false,
                                    flagAdolescencia: (selectedGrupo!.nombre ==
                                        "Adolescencia"),
                                  ));

                                  respuestas
                                      .add(new ElementRespuestaSentimientos(
                                    text1: "Respuesta",
                                    isCorrect: false,
                                    textSize: textSize,
                                    espacioPadding: getWidthOfText(
                                            "(máx. 30 caracteres)", context) +
                                        espacioPadding * 1.5,
                                    espacioAlto: espacioAlto,
                                    btnWidth: btnWidth,
                                    btnHeight: btnHeight,
                                    imgWidth: imgWidth,
                                    onPressedGaleria: () =>
                                        _selectNewActionGallery(1),
                                    onPressedArasaac: () =>
                                        _selectNewRespuestaArasaac(1),
                                    showPregunta: false,
                                    flagAdolescencia: (selectedGrupo!.nombre ==
                                        "Adolescencia"),
                                  ));
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto),
                Text(
                  'Pregunta*:',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto / 2),
                Container(
                  width: textSituacionWidth,
                  decoration: BoxDecoration(
                    color: colorSituacion,
                  ),
                  child: TextField(
                    onChanged: (text) {
                      this.preguntaText = text;
                    },
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize * 0.75,
                    ),
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorBordeImagen, // Color del borde verde
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Container(
                        width: getWidthOfText("(máx. 30 caracteres)", context) +
                            espacioPadding * 1.5,
                        child: Text(
                          'Imagen*:',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          btnGaleria,
                          SizedBox(height: espacioAlto / 3),
                          btnArasaac,
                          if (image.isNotEmpty)
                            Column(
                              children: [
                                SizedBox(height: espacioAlto / 3),
                                btnEliminarImage,
                              ],
                            )
                        ],
                      ),
                      SizedBox(width: espacioPadding),
                      if (image.isNotEmpty)
                        Container(
                          child: Align(
                              alignment: Alignment.center,
                              child: Image.memory(
                                Uint8List.fromList(image),
                                width: imgWidth,
                              )),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: espacioAlto),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: respuestas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: respuestas[index].color),
                          ),
                          child: Row(
                            children: [
                              respuestas[index],
                            ],
                          ),
                        ),
                        SizedBox(height: espacioAlto),
                      ],
                    );
                  },
                ),
                if (selectedGrupo != null)
                  Row(
                    children: [
                      if (selectedGrupo != null &&
                          selectedGrupo!.nombre != "Atención T.")
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            textStyle: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize,
                            ),
                          ),
                          onPressed: _addRespuesta,
                          child: Text("Añadir respuesta"),
                        ),
                      SizedBox(width: espacioPadding),
                      if (respuestas.length > 2)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize,
                              color: Colors.blue,
                            ),
                          ),
                          onPressed: _removeRespuesta,
                          child: Text("Eliminar respuesta"),
                        ),
                    ],
                  ),
                SizedBox(height: espacioAlto),
                Row(
                  children: [
                    const Spacer(), // Agrega un espacio flexible
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(btnWidth, btnHeight),
                        textStyle: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        if (!_completedParams()) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return incompletedParamsDialog;
                            },
                          );
                        } else {
                          _addPreguntaSentimientos();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return completedParamsDialog;
                            },
                          );
                        }
                      },
                      child: Text("Añadir pregunta"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // método para añadir un nuevo ElementAccion
  void _addRespuesta() {
    setState(() {
      respuestas.add(new ElementRespuestaSentimientos(
        text1: "Respuesta",
        textSize: textSize,
        espacioPadding: getWidthOfText("(máx. 30 caracteres)", context) +
            espacioPadding * 1.5,
        espacioAlto: espacioAlto,
        btnWidth: btnWidth,
        btnHeight: btnHeight,
        imgWidth: imgWidth,
        onPressedGaleria: () => _selectNewActionGallery(respuestas.length - 1),
        onPressedArasaac: () =>
            _selectNewRespuestaArasaac(respuestas.length - 1),
        isCorrect: true,
        showPregunta: true,
        flagAdolescencia: (selectedGrupo!.nombre == "Adolescencia"),
      ));
    });
  }

  // método para eliminar el ultimo ElementAccion
  void _removeRespuesta() {
    setState(() {
      respuestas.removeLast();
    });
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

  double getWidthOfText(String text, BuildContext context) {
    final TextSpan span = TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'ComicNeue',
        fontSize: textSize * 0.5,
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
    espacioAlto = screenSize.width * 0.03;
    imgVolverHeight = screenSize.height / 32;
    textSituacionWidth = screenSize.width - espacioPadding * 2;
    btnWidth = screenSize.width / 3;
    btnHeight = screenSize.height / 15;
    imgWidth = screenSize.width / 4.5;
  }

  // Método para crear los botones necesarios
  void _createButtons() {
    // boton para dar volver a la pantalla principal de ironías
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

    btnGaleria = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      child: Text(
        'Nueva imagen\n'
        '(desde galería)',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      onPressed: () {
        _selectNewImageGallery();
      },
    );

    btnArasaac = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        backgroundColor: Colors.lightGreen,
      ),
      child: Text(
        'Nueva imagen\n'
        '(desde ARASAAC)',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      onPressed: () async {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return noInternetDialog;
            },
          );
        } else if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return arasaacImageDialog;
            },
          );
        }
      },
    );

    btnEliminarImage = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight / 2),
        backgroundColor: Colors.redAccent,
      ),
      child: Text(
        'Eliminar imagen',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize * 0.75,
        ),
      ),
      onPressed: () {
        setState(() {
          image = [];
        });
      },
    );
  }

  // Metodo para crear los cuadros de dialogo necesarios
  void _createDialogs() {
    // cuadro de dialogo para escoger un personaje de arasaac
    arasaacImageDialog = ArasaacImageDialog(
      espacioAlto: espacioAlto,
      espacioPadding: espacioPadding,
      btnWidth: btnWidth,
      btnHeigth: btnHeight,
      imgWidth: imgWidth,
      onImageArasaacChanged: (newValue) async {
        final response = await http.get(Uri.parse(newValue));
        List<int> bytes = response.bodyBytes;
        setState(() {
          image = bytes;
        });
      },
    );

    // cuadro de dialogo para cuando no se han completado todos los campos obligatorios
    incompletedParamsDialog = AlertDialog(
      title: Text(
        'Error',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: titleSize * 0.75,
        ),
      ),
      content: Text(
        'La pregunta no se ha podido añadir. Por favor, revisa que has completado todos los campos obligatorios e inténtalo de nuevo.\n',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
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
        )
      ],
    );

    // cuadro de dialogo para cuando ironía añadida con éxito
    completedParamsDialog = AlertDialog(
      title: Text(
        '¡Fántastico!',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: titleSize * 0.75,
        ),
      ),
      content: Text(
        'La pregunta se ha añadido con éxito. Agradecemos tu colaboración, y los jugadores seguro que todavía más!',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
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
        )
      ],
    );

    // cuadro de diálogo para cuando no hay conexión a internet
    noInternetDialog = AlertDialog(
      title: Text(
        'Problema',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: titleSize * 0.75,
        ),
      ),
      content: Text(
        'Hemos detectado que no tienes conexión a internet, y para realizar esta acción es necesario.\nPor favor, inténtalo de nuevo o más tarde.',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
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
        )
      ],
    );
  }

  // Método para seleccionar un nuevo personaje desde la galería
  Future<void> _selectNewImageGallery() async {
    final picker = ImagePicker();
    final imageAux = await picker.pickImage(source: ImageSource.gallery);
    if (imageAux != null) {
      File imageFile = File(imageAux!.path);
      List<int> bytes = await imageFile.readAsBytes();

      setState(() {
        image = bytes;
      });
    }
  }

  // Método para seleccionar una nueva imagen de respuesta desde ARASAAC
  Future<void> _selectNewRespuestaArasaac(int index) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return noInternetDialog;
        },
      );
    } else if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      ArasaacImageDialog aux = ArasaacImageDialog(
        espacioAlto: espacioAlto,
        espacioPadding: espacioPadding,
        btnWidth: btnWidth,
        btnHeigth: btnHeight,
        imgWidth: imgWidth,
        onImageArasaacChanged: (newValue) async {
          final response = await http.get(Uri.parse(newValue));
          List<int> bytes = response.bodyBytes;
          setState(() {
            respuestas[index] = new ElementRespuestaSentimientos(
                text1: respuestas[index].text1,
                textSize: respuestas[index].textSize,
                espacioPadding: respuestas[index].espacioPadding,
                espacioAlto: respuestas[index].espacioAlto,
                btnWidth: respuestas[index].btnWidth,
                btnHeight: respuestas[index].btnHeight,
                imgWidth: respuestas[index].imgWidth,
                onPressedGaleria: () => _selectNewActionGallery(index),
                onPressedArasaac: () => _selectNewRespuestaArasaac(index),
                isCorrect: respuestas[index].isCorrect,
                showPregunta: respuestas[index].showPregunta,
                respuestaText: respuestas[index].respuestaText,
                respuestaImage: bytes,
                flagAdolescencia: respuestas[index].flagAdolescencia);
          });
        },
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return aux;
        },
      );
    }
  }

  // Método para seleccionar una nueva imagen de respuesta desde la galeria
  Future<void> _selectNewActionGallery(int index) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image!.path);
      List<int> bytes = await imageFile.readAsBytes();

      setState(() {
        respuestas[index] = new ElementRespuestaSentimientos(
            text1: respuestas[index].text1,
            textSize: respuestas[index].textSize,
            espacioPadding: respuestas[index].espacioPadding,
            espacioAlto: respuestas[index].espacioAlto,
            btnWidth: respuestas[index].btnWidth,
            btnHeight: respuestas[index].btnHeight,
            imgWidth: respuestas[index].imgWidth,
            onPressedGaleria: () => _selectNewActionGallery(index),
            onPressedArasaac: () => _selectNewRespuestaArasaac(index),
            isCorrect: respuestas[index].isCorrect,
            showPregunta: respuestas[index].showPregunta,
            respuestaText: respuestas[index].respuestaText,
            respuestaImage: bytes,
            flagAdolescencia: respuestas[index].flagAdolescencia);
      });
    }
  }

  // Método para comprobar que los parametros obligatorios están completos
  bool _completedParams() {
    bool correct = true;
    // compruebo que todos los parametros obligatorios están completos
    if (selectedGrupo == null) {
      correct = false;
      setState(() {
        colorGrupo = Colors.red;
      });
    } else
      colorGrupo = Colors.transparent;

    if (preguntaText.trim().isEmpty) {
      correct = false;
      setState(() {
        colorSituacion = Colors.red;
      });
    } else
      colorSituacion = Colors.transparent;

    if (image.isEmpty) {
      correct = false;
      setState(() {
        colorBordeImagen = Colors.red;
      });
    } else
      colorBordeImagen = Colors.transparent;

    // si es el grupo adolescencia, la imagen no puede estar vacia
    // en cualquier otro el texto no puede estar vacio
    for (int i = 0; i < respuestas.length; i++)
      if (respuestas[i].respuestaImage.isEmpty ||
          (respuestas[i].respuestaText.trim().isEmpty &&
              selectedGrupo!.nombre != "Adolescencia")) {
        correct = false;
        setState(() {
          respuestas[i].color = Colors.red;
        });
      } else
        respuestas[i].color = Colors.transparent;

    return correct;
  }

  Future<void> _addRespuestas(int preguntaId) async {
    Database db = await openDatabase('rutinas.db');
    for (int i = 0; i < respuestas.length; i++) {
      if (selectedGrupo!.nombre != "Adolescencia")
        await db.rawInsert(
          'INSERT INTO situacion (texto, correcta, imagen, preguntaSentimientoId) VALUES (?,?,?,?)',
          [
            respuestas[i].respuestaText,
            respuestas[i].isCorrect,
            Uint8List.fromList(respuestas[i].respuestaImage),
            preguntaId
          ],
        );
      else
        await db.rawInsert(
          'INSERT INTO situacion (texto, correcta, imagen, preguntaSentimientoId) VALUES (?,?,?,?)',
          [
            "",
            respuestas[i].isCorrect,
            Uint8List.fromList(respuestas[i].respuestaImage),
            preguntaId
          ],
        );
    }
  }

  // Método para añadir una pregunta y sus acciones
  Future<void> _addPreguntaSentimientos() async {
    int preguntaId = await _addPregunta();
    _addRespuestas(preguntaId);
  }

  // Método para añadir una pregunta a la BBDD
  Future<int> _addPregunta() async {
    int preguntaId;
    Database db = await openDatabase('rutinas.db');

    if (image.isEmpty)
      preguntaId = await insertPreguntaSentimiento(
          db, preguntaText, [], selectedGrupo!.id);
    else
      preguntaId = await insertPreguntaSentimiento(
          db, preguntaText, Uint8List.fromList(image), selectedGrupo!.id);
    return preguntaId;
  }
}
