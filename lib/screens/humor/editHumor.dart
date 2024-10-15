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
import '../../widgets/ArasaacAccionDialog.dart';
import '../../widgets/ArasaacPersonajeDialog.dart';
import '../../widgets/ImageTextButton.dart';
import '../main.dart';

///Pantalla que le permite al terapeuta la edición de una pregunta del juego Humor y sus respuestas
class EditHumor extends StatefulWidget {
  SituacionIronia situacionIronia;
  Grupo grupo;

  EditHumor({required this.situacionIronia, required this.grupo});

  @override
  EditIroniaState createState() => EditIroniaState();
}

/// Estado asociado a la pantalla [EditHumor] que gestiona la lógica
/// y la interfaz de usuario de la pantalla
class EditIroniaState extends State<EditHumor> {
  late ImageTextButton btnVolver;

  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgHeight,
      imgWidth,
      textSituacionWidth,
      btnWidth,
      btnHeight,
      imgVolverHeight,
      widthTextImagen;

  late int sizeAccionesInitial;

  late ElevatedButton btnGaleria, btnArasaac, btnEliminarImage;

  late List<Grupo> grupos;

  late Grupo? selectedGrupo;

  late String situacionText, correctText;

  late List<int> image;

  late Dialog existPersonajeDialog;

  late ArasaacPersonajeDialog arasaacPersonajeDialog;

  late ArasaacAccionDialog arasaacAccionDialog;

  late AlertDialog incompletedParamsDialog,
      completedParamsDialog,
      noInternetDialog,
      removePreguntaOk;

  late bool firstLoad = true, changeGrupo, loadData, esIronia, noEsIronia;

  late Grupo defaultGrupo;

  late List<Respuesta> respuestasIncorrectas;

  late Color colorSituacion,
      colorGrupo,
      colorCorrectText,
      colorBordeImagen,
      colorCheckbox;
  @override
  void initState() {
    super.initState();
    defaultGrupo = widget.grupo;
    loadData = false;
    grupos = [];
    image = [];
    respuestasIncorrectas = [];
    selectedGrupo = null;
    changeGrupo = false;
    colorSituacion = Colors.transparent;
    colorCorrectText = Colors.transparent;
    colorGrupo = Colors.transparent;
    colorBordeImagen = Colors.transparent;
    colorCheckbox = Colors.transparent;
    correctText = "";

    esIronia = false;
    noEsIronia = false;

    if (firstLoad) {
      firstLoad = false;
      _getGrupos();
      situacionText = widget.situacionIronia.enunciado;
      setState(() {
        image = widget.situacionIronia.imagen!;
      });
    }
    _loadRespuestas();
    _initializeState();
  }

  Future<void> _initializeState() async {
    await _getGrupos();
    _createDialogs();
  }

  @override
  Widget build(BuildContext context) {
    if (!loadData) {
      loadData = true;
      _createVariablesSize();
      situacionText = widget.situacionIronia.enunciado;
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
                          'Editar pregunta',
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
                        'Aquí tienes la posibilidad de editar la pregunta y sus respuestas, incluso el grupo al que pertenece.',
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
                              widget.grupo.nombre,
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
                                changeGrupo = true;
                                respuestasIncorrectas = [];
                                if (selectedGrupo!.nombre == "Medio")
                                  respuestasIncorrectas.add(new Respuesta(
                                      texto: "", color: Colors.transparent));
                                if (selectedGrupo!.nombre == "Difícil") {
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
                    controller: TextEditingController(text: this.situacionText),
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
                      color: colorBordeImagen,
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
                if ((!changeGrupo && widget.grupo.nombre == "Fácil") ||
                    (selectedGrupo != null &&
                        selectedGrupo!.nombre == 'Fácil'))
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
                if ((!changeGrupo && widget.grupo.nombre != "Fácil") ||
                    (selectedGrupo != null &&
                        selectedGrupo!.nombre != 'Fácil'))
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
                          controller:
                              TextEditingController(text: this.correctText),
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
                      if ((!changeGrupo && widget.grupo.nombre == "Medio") ||
                          (selectedGrupo != null &&
                              selectedGrupo!.nombre == 'Medio'))
                        Text(
                          "Respuesta incorrecta*:",
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      if ((!changeGrupo &&
                              widget.grupo.nombre == "Difícil") ||
                          (selectedGrupo != null &&
                              selectedGrupo!.nombre == 'Difícil'))
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
                          color: respuestasIncorrectas.isNotEmpty
                              ? respuestasIncorrectas[0].color
                              : Colors.transparent,
                        ),
                        child: TextField(
                          controller: TextEditingController(
                              text: respuestasIncorrectas.isNotEmpty
                                  ? this.respuestasIncorrectas[0].texto
                                  : ""),
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
                      if ((!changeGrupo &&
                              widget.grupo.nombre == "Difícil") ||
                          (selectedGrupo != null &&
                              selectedGrupo!.nombre == 'Difícil'))
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: respuestasIncorrectas.isNotEmpty
                                    ? respuestasIncorrectas[1].color
                                    : Colors.transparent,
                              ),
                              child: TextField(
                                controller: TextEditingController(
                                    text: respuestasIncorrectas.isNotEmpty
                                        ? this.respuestasIncorrectas[1].texto
                                        : ""),
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
                                color: respuestasIncorrectas.isNotEmpty
                                    ? respuestasIncorrectas[2].color
                                    : Colors.transparent,
                              ),
                              child: TextField(
                                controller: TextEditingController(
                                    text: respuestasIncorrectas.isNotEmpty
                                        ? this.respuestasIncorrectas[2].texto
                                        : ""),
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
                          _editIronia();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return completedParamsDialog;
                            },
                          );
                        }
                      },
                      child: Text("Editar pregunta"),
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto / 3),
                Row(
                  children: [
                    const Spacer(), // Agrega un espacio flexible
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(btnWidth, btnHeight / 2),
                        backgroundColor: Colors.red,
                        textStyle: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                        ),
                      ),
                      onPressed: () {
                        AlertDialog aux = AlertDialog(
                          title: Text(
                            'Aviso',
                            style: TextStyle(
                              fontFamily: 'ComicNeue',
                              fontSize: titleSize * 0.75,
                            ),
                          ),
                          content: Text(
                            'Estás a punto de eliminar la siguiente pregunta del grupo ${widget.grupo.nombre}:\n'
                            '${widget.situacionIronia.enunciado}\n'
                            '¿Estás seguro de ello?',
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
                                    _removePregunta(widget.situacionIronia.id!);
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return removePreguntaOk;
                                      },
                                    );
                                  },
                                  child: Text(
                                    'Sí, eliminar',
                                    style: TextStyle(
                                      fontFamily: 'ComicNeue',
                                      fontSize: textSize,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: espacioPadding,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Cancelar',
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

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return aux;
                          },
                        );
                      },
                      child: Text("Eliminar pregunta"),
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
    imgHeight = screenSize.height / 9;
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
    // boton para dar volver a la pantalla principal de humor
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
        _selectNewPersonajeGallery();
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
              return arasaacPersonajeDialog;
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
        'Eliminar personaje',
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
    // cuadro de dialogo para escoger unq imagen de arasaac
    arasaacPersonajeDialog = ArasaacPersonajeDialog(
      espacioAlto: espacioAlto,
      espacioPadding: espacioPadding,
      btnWidth: btnWidth,
      btnHeigth: btnHeight,
      imgWidth: imgWidth,
      onPersonajeArasaacChanged: (newValue) async {
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
        'La pregunta no se ha podido editar, revisa que has completado todos los campos obligatorios\n'
        'Por favor, revisa todos los campos e inténtalo de nuevo.',
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
        'La pregunta se ha editado con éxito. Agradecemos tu colaboración, y los jugadores seguro que todavía más!',
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

  ///Método que nos permite seleccionar una imagen de nuestra galería para la pregunta, dicha imagen se guarda en la variable [image]
  Future<void> _selectNewPersonajeGallery() async {
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

  ///Método que se encarga de comprobar que están rellenados todos los campos y opciones para poder editar una pregunta del juego Humor
  ///<br><b>Salida</b><br>
  ///[true] si los campos obligatorios están completos, [false] en caso contrario
  bool _completedParams() {
    bool correct = true;
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
        selectedGrupo!.nombre == "Fácil" &&
        !esIronia &&
        !noEsIronia) {
      correct = false;
      setState(() {
        colorCheckbox = Colors.red;
      });
    } else
      colorCheckbox = Colors.transparent;

    if (selectedGrupo != null &&
        selectedGrupo!.nombre != "Fácil" &&
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

  ///Método encargado de editar una pregunta y sus respectivas respuestas
  Future<void> _editIronia() async {
    await _editPregunta();
    _editRespuestas();
  }

  ///Método encargado de editar una pregunta al juego Humor
  Future<void> _editPregunta() async {
    Database db = await openDatabase('rutinas.db');
    if (!changeGrupo)
      await updatePreguntaIronia(db, widget.situacionIronia.id!, situacionText,
          Uint8List.fromList(image), widget.grupo!.id);
    else
      await updatePreguntaIronia(db, widget.situacionIronia.id!, situacionText,
          Uint8List.fromList(image), selectedGrupo!.id);
  }

  ///Método encargado de editar las respuestas de la pregunta del juego Humor
  Future<void> _editRespuestas() async {
    Database db = await openDatabase('rutinas.db');
    // elimino las respuestas anteriores
    deleteRespuestasBySituacionIroniaId(db, widget.situacionIronia.id!);

    if ((changeGrupo && selectedGrupo!.nombre == "Fácil") ||
        (!changeGrupo && widget.grupo!.nombre == "Fácil")) {
      int aux, aux2;
      if (esIronia)
        aux = 1;
      else
        aux = 0;
      if (noEsIronia)
        aux2 = 1;
      else
        aux2 = 0;
      insertRespuestaIronia(
          db, "Sí, es una broma.", aux, widget.situacionIronia.id!);
      insertRespuestaIronia(
          db, "No, no es una broma.", aux2, widget.situacionIronia.id!);
      return;
    }
    insertRespuestaIronia(db, correctText, 1, widget.situacionIronia.id!);
    for (int i = 0; i < respuestasIncorrectas.length; i++)
      insertRespuestaIronia(
          db, respuestasIncorrectas[i].texto, 0, widget.situacionIronia.id!);
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

  ///Método que nos permite cargar las respuestas de la pregunta actual
  Future<void> _loadRespuestas() async {
    List<RespuestaIronia> aux =
        await getRespuestasIronia(widget.situacionIronia.id!);

    setState(() {
      if (widget.grupo.nombre == "Fácil") {
        if (aux[0].correcta == 1) {
          if (aux[0].texto == "Sí, es una broma.") {
            esIronia = true;
          }
          if (aux[0].texto == "No, no es una broma.") {
            noEsIronia = true;
          }
        } else {
          if (aux[0].texto == "Sí, es una broma.") {
            noEsIronia = true;
          }
          if (aux[0].texto == "No, no es una broma.") {
            esIronia = true;
          }
        }
      }

      for (int i = 0; i < aux.length; i++) {
        if (aux[i].correcta == 1)
          this.correctText = aux[i].texto;
        else
          respuestasIncorrectas.add(new Respuesta(
              id: aux[i].id, texto: aux[i].texto, color: Colors.transparent));
      }
    });
  }

  ///Metodo que nos permite eliminar una pregunta del juego Humor a partir de su identificador
  ///<br><b>Parámetros</b><br>
  ///[preguntaId] Identificador de la pregunta que queremos eliminar
  void _removePregunta(int preguntaId) {
    removePreguntaIronia(preguntaId);
  }
}
