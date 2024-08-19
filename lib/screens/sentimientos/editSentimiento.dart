import 'dart:io';

import 'package:Rutirse/widgets/ElementRespuestaSentimientos.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/obj/grupo.dart';
import '../../db/obj/preguntaSentimiento.dart';
import '../../db/obj/situacion.dart';
import '../../widgets/ArasaacImageDialog.dart';
import '../../widgets/ImageTextButton.dart';

class EditSentimiento extends StatefulWidget {
  PreguntaSentimiento preguntaSentimiento;
  Grupo grupo;

  EditSentimiento({required this.preguntaSentimiento, required this.grupo});

  @override
  _EditSentimientoState createState() => _EditSentimientoState();
}

class _EditSentimientoState extends State<EditSentimiento> {
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

  late bool firstLoad = true, changeGrupo;

  late List<int> image;

  late List<ElementRespuestaSentimientos> respuestas, situacionesToDelete;

  late Color colorSituacion,
      colorGrupo,
      colorCorrectText,
      colorBordeImagen,
      colorCheckbox;

  late Grupo defaultGrupo;

  late int sizeRespuestasInitial;

  late AlertDialog removePreguntaOk;

  @override
  void initState() {
    super.initState();
    defaultGrupo = widget.grupo;
    grupos = [];
    preguntaText = "";
    correctText = "";
    respuestas = [];
    situacionesToDelete = [];
    image = [];
    selectedGrupo = null;
    colorSituacion = Colors.transparent;
    colorCorrectText = Colors.transparent;
    colorGrupo = Colors.transparent;
    colorBordeImagen = Colors.transparent;
    colorCheckbox = Colors.transparent;
    changeGrupo = false;

    if (firstLoad) {
      firstLoad = false;
      _getGrupos();
      preguntaText = widget.preguntaSentimiento.enunciado;
      if (widget.preguntaSentimiento.imagen != null) {
        setState(() {
          image = widget.preguntaSentimiento.imagen!;
        });
      } else
        image = [];

      _loadRespuestas();
    }
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
                        'Sentimientos',
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
                      'Aquí tienes la posibilidad de editar la pregunta y sus posibles respuestas, incluso el grupo al que pertenece.',
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
                              changeGrupo = true;
                              selectedGrupo = grupo;
                              respuestas = respuestas.map((respuesta) {
                                return ElementRespuestaSentimientos(
                                  id: respuesta.id,
                                  text1: respuesta.text1,
                                  respuestaText: respuesta.respuestaText,
                                  respuestaImage:
                                      respuesta.respuestaImage!.toList(),
                                  isCorrect: respuesta.isCorrect,
                                  textSize: respuesta.textSize,
                                  espacioPadding: respuesta.espacioPadding,
                                  espacioAlto: respuesta.espacioAlto,
                                  btnWidth: respuesta.btnWidth,
                                  btnHeight: respuesta.btnHeight,
                                  imgWidth: respuesta.imgWidth,
                                  onPressedGaleria: () =>
                                      respuesta.onPressedGaleria,
                                  onPressedArasaac: () =>
                                      respuesta.onPressedArasaac,
                                  showPregunta: respuesta.showPregunta,
                                  flagAdolescencia:
                                      (selectedGrupo!.nombre == "Adolescencia"),
                                );
                              }).toList();
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
                  controller: TextEditingController(text: this.preguntaText),
                  onChanged: (text) {
                    this.preguntaText = text;
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
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
                          children: [respuestas[index]],
                        ),
                      ),
                      SizedBox(height: espacioAlto),
                    ],
                  );
                },
              ),
              if ((changeGrupo && selectedGrupo!.nombre != "Atención T.") ||
                  (!changeGrupo && defaultGrupo!.nombre != "Atención T."))
                Row(
                  children: [
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
                      if (!changeGrupo) {
                        for (Grupo grupo in grupos) {
                          if (grupo.nombre == widget.grupo.nombre) {
                            selectedGrupo = grupo;
                            break;
                          }
                        }
                      }
                      if (!_completedParams()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return incompletedParamsDialog;
                          },
                        );
                      } else {
                        _editSentimiento();
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
                          '${widget.preguntaSentimiento.enunciado}\n'
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
                                  _removePregunta(
                                      widget.preguntaSentimiento.id!);
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
          onPressedGaleria: () =>
              _selectNewActionGallery(respuestas.length - 1),
          onPressedArasaac: () =>
              _selectNewRespuestaArasaac(respuestas.length - 1),
          isCorrect: true,
          showPregunta: true,
          flagAdolescencia:
              (!changeGrupo && defaultGrupo!.nombre == "Adolescencia") ||
                  (changeGrupo && selectedGrupo!.nombre == "Adolescencia")));
    });
  }

  // método para eliminar la ultima respuesta
  void _removeRespuesta() {
    setState(() {
      situacionesToDelete.add(respuestas[respuestas.length - 1]);
      respuestas.removeLast();
    });
  }

  // Método para editar una pregunta y sus respuestas
  Future<void> _editSentimiento() async {
    _editPregunta();
    _editRespuestas();
  }

  void _removePregunta(int preguntaId) {
    removePreguntaSentimiento(preguntaId);
  }

  // Método para editar una pregunta de la BBDD
  Future<void> _editPregunta() async {
    Database db = await openDatabase('rutinas.db');
    await updatePregunta(db, widget.preguntaSentimiento.id!, preguntaText,
        Uint8List.fromList(image), selectedGrupo!.id);
  }

  // Método para editar respuestas de la BBDD
  Future<void> _editRespuestas() async {
    Database db = await openDatabase('rutinas.db');
    for (int i = 0; i < respuestas.length; i++) {
      print("probando: " + respuestas[i].respuestaText);
      if (i < this.sizeRespuestasInitial) {
        if (selectedGrupo!.nombre != "Adolescencia") {
          print("update: " + respuestas[i].respuestaText);

          await db.update(
            'situacion',
            {
              'texto': respuestas[i].respuestaText,
              'correcta': respuestas[i].isCorrect ? 1 : 0,
              'imagen': respuestas[i].respuestaImage,
              'preguntaSentimientoId': widget.preguntaSentimiento.id,
            },
            where: 'id = ?',
            whereArgs: [respuestas[i].id],
          );
        } else {
          print("update : " +
              respuestas[i].id.toString() +
              " - " +
              respuestas[i].respuestaText);

          await db.update(
            'situacion',
            {
              'texto': "",
              'correcta': respuestas[i].isCorrect ? 1 : 0,
              'imagen': respuestas[i].respuestaImage,
              'preguntaSentimientoId': widget.preguntaSentimiento.id,
            },
            where: 'id = ?',
            whereArgs: [respuestas[i].id],
          );
        }
      } else {
        if (selectedGrupo!.nombre != "Adolescencia") {
          await db.insert(
            'situacion',
            {
              'texto': respuestas[i].respuestaText,
              'correcta': respuestas[i].isCorrect ? 1 : 0,
              'imagen': respuestas[i].respuestaImage,
              'preguntaSentimientoId': widget.preguntaSentimiento.id,
            },
          );
        } else {
          await db.insert(
            'situacion',
            {
              'texto': "",
              'correcta': respuestas[i].isCorrect ? 1 : 0,
              'imagen': respuestas[i].respuestaImage,
              'preguntaSentimientoId': widget.preguntaSentimiento.id,
            },
          );
        }
      }
    }
    for (int i = 0; i < situacionesToDelete.length; i++) {
      deleteSituacion(db, situacionesToDelete[i].id!);
    }
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
        'La pregunta no se ha podido editar. Por favor, revisa que has completado todos los campos obligatorios e inténtalo de nuevo.\n',
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

  // Método para cargar las respuestas de la pregunta seleccionada
  void _loadRespuestas() async {
    List<Situacion> aux = await getSituaciones(widget.preguntaSentimiento.id!);
    for (int i = 0; i < aux.length; i++) {
      ElementRespuestaSentimientos elementRespuestaSentimientos =
          new ElementRespuestaSentimientos(
        id: aux[i].id,
        text1: "Respuesta",
        isCorrect: aux[i].correcta == 1,
        textSize: textSize,
        espacioPadding: getWidthOfText("(máx. 30 caracteres)", context) +
            espacioPadding * 1.5,
        espacioAlto: espacioAlto,
        btnWidth: btnWidth,
        btnHeight: btnHeight,
        respuestaText: aux[i].texto,
        respuestaImage: aux[i].imagen!.toList(),
        imgWidth: imgWidth,
        onPressedGaleria: () => _selectNewActionGallery(i),
        onPressedArasaac: () => _selectNewRespuestaArasaac(i),
        showPregunta: (i != 0 && i != 1),
        flagAdolescencia: (widget.grupo.nombre == "Adolescencia"),
      );
      setState(() {
        this.respuestas.add(elementRespuestaSentimientos);
      });
    }
    this.sizeRespuestasInitial = this.respuestas.length;
  }
}
