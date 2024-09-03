import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/obj/grupo.dart';
import '../../db/obj/respuestaIronia.dart';
import '../../db/obj/situacionIronia.dart';
import '../../obj/Respuesta.dart';
import '../../widgets/ArasaacImageDialog.dart';
import '../../widgets/ImageTextButton.dart';
import '../main.dart';

///Pantalla que nos permite añadir una nueva pregunta, con sus correspondientes respuestas al juego Humor
class AddHumor extends StatefulWidget {
  @override
  _AddHumorState createState() => _AddHumorState();
}

/// Estado asociado a la pantalla [AddHumor] que gestiona la lógica
/// y la interfaz de usuario de la pantalla
class _AddHumorState extends State<AddHumor> {
  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgVolverHeight,
      textSituacionWidth,
      btnWidth,
      btnHeight,
      imgWidth,
      widthTextImagen;

  late ImageTextButton btnVolver;

  late List<Grupo> grupos;

  Grupo? selectedGrupo; // Variable para almacenar el grupo seleccionado

  late String situacionText, correctText;

  late ElevatedButton btnGaleria, btnArasaac, btnEliminarImage;

  late ArasaacImageDialog arasaacImageDialog;

  late AlertDialog incompletedParamsDialog,
      completedParamsDialog,
      noInternetDialog;

  late bool firstLoad, esIronia, noEsIronia;

  late List<int> image;

  late List<Respuesta> respuestasIncorrectas;

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
    situacionText = "";
    correctText = "";
    respuestasIncorrectas = [];
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
                          'Humor',
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
                        'Aquí puedes crear nuevas preguntas para el juego de Humor.',
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
                                respuestasIncorrectas = [];
                                if (selectedGrupo!.nombre == "Infancia")
                                  respuestasIncorrectas.add(new Respuesta(
                                      texto: "", color: Colors.transparent));
                                if (selectedGrupo!.nombre == "Adolescencia") {
                                  respuestasIncorrectas.add(new Respuesta(
                                      texto: "", color: Colors.transparent));
                                  respuestasIncorrectas.add(new Respuesta(
                                      texto: "", color: Colors.transparent));
                                  respuestasIncorrectas.add(new Respuesta(
                                      texto: "", color: Colors.transparent));
                                }
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
                      this.situacionText = text;
                    },
                    style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize * 0.75,
                    ),
                    maxLines: 5,
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
                        width: widthTextImagen,
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
                if (selectedGrupo != null &&
                    selectedGrupo!.nombre == 'Atención T.')
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorCheckbox, // Color del borde verde
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '¿Es una broma?*',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                        CheckboxListTile(
                          title: Text(
                            "Sí, es una broma.",
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize * 0.75,
                            ),
                          ),
                          value: esIronia,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (newValue) {
                            setState(() {
                              esIronia = !esIronia;
                              noEsIronia = false;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(
                            "No, no es una broma.",
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: textSize * 0.75,
                            ),
                          ),
                          value: noEsIronia,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (newValue) {
                            setState(() {
                              noEsIronia = !noEsIronia;
                              esIronia = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                if (selectedGrupo != null &&
                    selectedGrupo!.nombre != 'Atención T.')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "Respuesta correcta*:",
                        style: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                      SizedBox(
                        height: espacioAlto / 2,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: colorCorrectText,
                        ),
                        child: TextField(
                          onChanged: (text) {
                            this.correctText = text;
                          },
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize * 0.75,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: espacioAlto / 2,
                      ),
                      if (selectedGrupo!.nombre == 'Infancia')
                        Text(
                          "Respuesta incorrecta*:",
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      if (selectedGrupo!.nombre == 'Adolescencia')
                        Text(
                          "Respuestas incorrectas*:",
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      SizedBox(
                        height: espacioAlto / 2,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: respuestasIncorrectas[0].color,
                        ),
                        child: TextField(
                          onChanged: (text) {
                            this.respuestasIncorrectas[0].texto = text;
                          },
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize * 0.75,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: espacioAlto / 2,
                      ),
                      if (selectedGrupo!.nombre == 'Adolescencia')
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: respuestasIncorrectas[1].color,
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  this.respuestasIncorrectas[1].texto = text;
                                },
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: 'ComicNeue',
                                  fontSize: textSize * 0.75,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: espacioAlto / 2,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: respuestasIncorrectas[2].color,
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  this.respuestasIncorrectas[2].texto = text;
                                },
                                maxLines: 2,
                                style: TextStyle(
                                  fontFamily: 'ComicNeue',
                                  fontSize: textSize * 0.75,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        )
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
                          _addIronia();
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

  ///Método que nos permite obtener los grupos con los que cuenta la aplicación y almacenarlos en la variable [grupos]
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

  ///Método que nos permite obtener el ancho que se supone que ocuparía una cadena de texto
  ///<br><b>Parámetros</b><br>
  ///[text] Cadena de texto de la que queremos obtener el valor de ancho<br>
  ///[context] El contexto de la aplicación, que proporciona acceso a información
  ///sobre el entorno en el que se está ejecutando el widget, incluyendo el tamaño de la pantalla
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

  ///Método que se utiliza para darle valor a las variables relacionadas con tamaños de fuente, imágenes, etc.
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
    widthTextImagen =
        getWidthOfText("Imagen*: ", context) + espacioPadding * 2.5;
  }

  ///Método encargado de inicializar los botones que tendrá la pantalla
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

  ///Método encargado de inicializar los cuadros de dialogo que tendrá la pantalla
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

  ///Método que nos permite seleccionar una imagen de nuestra galería para la pregunta, dicha imagen se guarda en la variable [image]
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

  ///Método que se encarga de comprobar que están rellenados todos los campos y opciones para poder añadir una nueva pregunta al juego Humor
  ///<br><b>Salida</b><br>
  ///[true] si los campos obligatorios están completos, [false] en caso contrario
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

    if (situacionText.trim().isEmpty) {
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

    if (selectedGrupo != null &&
        selectedGrupo!.nombre == "Atención T." &&
        !esIronia &&
        !noEsIronia) {
      correct = false;
      setState(() {
        colorCheckbox = Colors.red;
      });
    } else
      colorCheckbox = Colors.transparent;

    if (selectedGrupo != null &&
        selectedGrupo!.nombre != "Atención T." &&
        correctText.trim().isEmpty) {
      correct = false;
      setState(() {
        colorCorrectText = Colors.red;
      });
    } else
      colorCorrectText = Colors.transparent;

    for (int i = 0; i < respuestasIncorrectas.length; i++)
      if (respuestasIncorrectas[i].texto.trim().isEmpty) {
        correct = false;
        setState(() {
          respuestasIncorrectas[i].color = Colors.red;
        });
      } else
        respuestasIncorrectas[i].color = Colors.transparent;

    return correct;
  }

  ///Método encargado de añadir una pregunta y sus respectivas respuestas
  Future<void> _addIronia() async {
    int ironiaId = await _addPregunta();
    _addRespuestas(ironiaId);
  }

  ///Método encargado de añadir una nueva pregunta al juego Humor
  ///<br><b>Salida</b><br>
  ///Identificador de la pregunta que se acaba de añadir
  Future<int> _addPregunta() async {
    int preguntaId;
    Database db = await openDatabase('rutinas.db');
    preguntaId = await insertSituacionIronia(
        db, situacionText, Uint8List.fromList(image), selectedGrupo!.id);
    return preguntaId;
  }

  ///Método encargado de añadir una respuesta al juego Humor
  ///<br><b>Parámetros</b><br>
  ///[ironiaId] Identificador de la pregunta a la que corresponde la respuesta que queremos añadir
  Future<void> _addRespuestas(int ironiaId) async {
    Database db = await openDatabase('rutinas.db');

    if (selectedGrupo!.nombre == "Atención T.") {
      int aux, aux2;
      if (esIronia)
        aux = 1;
      else
        aux = 0;
      if (noEsIronia)
        aux2 = 1;
      else
        aux2 = 0;
      insertRespuestaIronia(db, "Sí, es una broma.", aux, ironiaId);
      insertRespuestaIronia(db, "No, no es una broma.", aux2, ironiaId);
      return;
    }
    insertRespuestaIronia(db, correctText, 1, ironiaId);
    for (int i = 0; i < respuestasIncorrectas.length; i++)
      insertRespuestaIronia(db, respuestasIncorrectas[i].texto, 0, ironiaId);
  }
}
