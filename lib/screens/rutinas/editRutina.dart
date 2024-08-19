import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/obj/accion.dart';
import '../../db/obj/grupo.dart';
import '../../db/obj/situacionRutina.dart';
import '../../widgets/ArasaacAccionDialog.dart';
import '../../widgets/ArasaacPersonajeDialog.dart';
import '../../widgets/ElementAccion.dart';
import '../../widgets/ImageTextButton.dart';

class EditRutina extends StatefulWidget {
  SituacionRutina situacionRutina;
  Grupo grupo;

  EditRutina({required this.situacionRutina, required this.grupo});

  @override
  _EditRutinaState createState() => _EditRutinaState();
}

class _EditRutinaState extends State<EditRutina> {
  late ImageTextButton btnVolver;

  late Color colorSituacion, colorGrupo;

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
      widthTxtPersonaje;

  late int sizeAccionesInitial;

  late ElevatedButton btnPersonajeExistente,
      btnGaleria,
      btnArasaac,
      btnEliminarPersonaje;

  late List<Grupo> grupos;

  late List<ElementAccion> acciones, accionesToDelete;

  late Grupo? selectedGrupo;

  late String situacionText;

  late List<String> personajes;

  late List<int> personajeImage;

  late Dialog existPersonajeDialog;

  late ArasaacPersonajeDialog arasaacPersonajeDialog;

  late ArasaacAccionDialog arasaacAccionDialog;

  late AlertDialog incompletedParamsDialog,
      completedParamsDialog,
      noInternetDialog,
      removePreguntaOk;

  late bool firstLoad = true, changeGrupo, loadData;

  late Grupo defaultGrupo;

  @override
  void initState() {
    super.initState();
    defaultGrupo = widget.grupo;
    loadData = false;
    grupos = [];
    acciones = [];
    accionesToDelete = [];
    personajes = [];
    _getExistsPersonajes('assets/img/personajes/');
    selectedGrupo = null;
    colorSituacion = Colors.transparent;
    colorGrupo = Colors.transparent;
    changeGrupo = false;

    if (firstLoad) {
      firstLoad = false;
      _getGrupos();
      situacionText = widget.situacionRutina.enunciado;
      if (widget.situacionRutina.personajeImg != null) {
        setState(() {
          personajeImage = widget.situacionRutina.personajeImg!;
        });
      } else
        personajeImage = [];

      _loadAcciones();
    }
    _initializeState();
  }

  Future<void> _initializeState() async {
    await _getGrupos();
    await _getExistsPersonajes('assets/img/personajes/');

    _createDialogs();
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
                        'Editar rutina',
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
                      'Aquí tienes la posibilidad de editar la pregunta sobre la rutina y sus opciones o acciones, incluso el grupo al que pertenece.',
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
                              acciones = acciones.map((accion) {
                                return ElementAccion(
                                  id: accion.id,
                                  text1: accion.text1,
                                  numberAccion: accion.numberAccion,
                                  textSize: accion.textSize,
                                  espacioPadding: accion.espacioPadding,
                                  espacioAlto: accion.espacioAlto,
                                  btnWidth: accion.btnWidth,
                                  btnHeight: accion.btnHeight,
                                  textSituacionWidth: accion.textSituacionWidth,
                                  imgWidth: imgWidth,
                                  onPressedGaleria: accion.onPressedGaleria,
                                  onPressedArasaac: accion.onPressedArasaac,
                                  accionText: accion.accionText,
                                  accionImage: accion.accionImage,
                                  color: accion.color,
                                  flagAdolescencia:
                                      selectedGrupo!.nombre == "Adolescencia",
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
                'Situación*:',
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Container(
                    width: widthTxtPersonaje,
                    child: Text(
                      'Personaje:',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      btnPersonajeExistente,
                      SizedBox(height: espacioAlto / 3),
                      btnGaleria,
                      SizedBox(height: espacioAlto / 3),
                      btnArasaac,
                      if (personajeImage.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(height: espacioAlto / 3),
                            btnEliminarPersonaje,
                          ],
                        )
                    ],
                  ),
                  SizedBox(width: espacioPadding),
                  if (personajeImage.isNotEmpty)
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.memory(
                          Uint8List.fromList(personajeImage),
                          width: imgWidth,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: espacioAlto),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: acciones.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: acciones[index].color),
                        ),
                        child: Row(
                          children: [
                            acciones[index],
                          ],
                        ),
                      ),
                      SizedBox(height: espacioAlto * 2),
                    ],
                  );
                },
              ),
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
                    onPressed: _addAccion,
                    child: Text("Añadir acción"),
                  ),
                  SizedBox(width: espacioPadding),
                  if (acciones.length > 2)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        textStyle: TextStyle(
                          fontFamily: 'ComicNeue',
                          fontSize: textSize,
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: _removeAccion,
                      child: Text("Eliminar acción"),
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
                        _editRutina();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return completedParamsDialog;
                          },
                        );
                      }
                    },
                    child: Text("Editar rutina"),
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
                          '${widget.situacionRutina.enunciado}\n'
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
                                  _removePregunta(widget.situacionRutina.id!);
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
                    child: Text("Eliminar rutina"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
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
    widthTxtPersonaje =
        getWidthOfText("(máx. 30 caracteres)", context) + espacioPadding * 1.5;
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

    btnPersonajeExistente = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        backgroundColor: Colors.blueGrey,
        textStyle: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
          color: Colors.blue,
        ),
      ),
      child: Text(
        'Personaje\n '
        'existente',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return existPersonajeDialog;
          },
        );
      },
    );

    btnGaleria = ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(btnWidth, btnHeight),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      child: Text(
        'Nuevo personaje\n'
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
        'Nuevo personaje\n'
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

    btnEliminarPersonaje = ElevatedButton(
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
          personajeImage = [];
        });
      },
    );
  }

  // Metodo para crear los cuadros de dialogo necesarios
  void _createDialogs() {
    // cuadro de dialogo para escoger un personaje ya existente
    existPersonajeDialog = Dialog(
      child: Column(
        children: [
          SizedBox(height: espacioAlto),
          Center(
            child: Text(
              'Escoge un personaje',
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textSize,
              ),
            ),
          ),
          SizedBox(height: espacioAlto),
          Expanded(
            child: ListView(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: espacioAlto * 2,
                    mainAxisSpacing: espacioAlto * 2,
                  ),
                  itemCount: personajes.length,
                  itemBuilder: (BuildContext context, int index) {
                    String imagePath = personajes[index];
                    return GestureDetector(
                      onTap: () {
                        _selectExistPersonaje(context, imagePath);
                      },
                      child: Image.asset(imagePath),
                    );
                  },
                ),
                SizedBox(height: espacioAlto * 2),
              ],
            ),
          ),
          SizedBox(height: espacioAlto),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(btnWidth / 2, btnHeight),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: textSize,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: espacioAlto),
        ],
      ),
    );

    // cuadro de dialogo para escoger un personaje de arasaac
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
          personajeImage = bytes;
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
        'La rutina no se ha podido editar, revisa que has completado todos los campos obligatorios'
        ' y recuerda que la descripción de una acción no puede'
        ' tener una longitud mayor a 30 caracteres.\n\n'
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

    // cuadro de dialogo para cuando rutina añadida con éxito
    completedParamsDialog = AlertDialog(
      title: Text(
        '¡Fántastico!',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: titleSize * 0.75,
        ),
      ),
      content: Text(
        'La rutina se ha editado con éxito. Agradecemos tu colaboración, y los jugadores seguro que todavía más!',
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

  // Método para seleccionar un nuevo personaje desde la galería
  Future<void> _selectNewPersonajeGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image!.path);
      List<int> bytes = await imageFile.readAsBytes();

      setState(() {
        personajeImage = bytes;
      });
    }
  }

  // Método para seleccionar una nueva imagen de accion desde la galeria
  Future<void> _selectNewActionGallery(int index) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image!.path);
      List<int> bytes = await imageFile.readAsBytes();

      setState(() {
        acciones[index] = ElementAccion(
          id: acciones[index].id,
          text1: acciones[index].text1,
          numberAccion: acciones[index].numberAccion,
          textSize: acciones[index].textSize,
          espacioPadding: acciones[index].espacioPadding,
          espacioAlto: acciones[index].espacioAlto,
          btnWidth: acciones[index].btnWidth,
          btnHeight: acciones[index].btnHeight,
          textSituacionWidth: acciones[index].textSituacionWidth,
          imgWidth: imgWidth,
          onPressedGaleria: acciones[index].onPressedGaleria,
          onPressedArasaac: acciones[index].onPressedArasaac,
          accionText: acciones[index].accionText,
          accionImage: bytes,
          color: acciones[index].color,
          flagAdolescencia: acciones[index].flagAdolescencia,
        );
      });
    }
  }

  // Método para seleccionar una nueva imagen de accion desde ARASAAC
  // Método para seleccionar una nueva imagen de accion desde ARASAAC
  Future<void> _selectNewActionArasaac(int index) async {
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
      ArasaacAccionDialog aux = ArasaacAccionDialog(
        espacioAlto: espacioAlto,
        espacioPadding: espacioPadding,
        btnWidth: btnWidth,
        btnHeigth: btnHeight,
        imgWidth: imgWidth,
        onAccionArasaacChanged: (newValue) async {
          final response = await http.get(Uri.parse(newValue));
          List<int> bytes = response.bodyBytes;
          setState(() {
            acciones[index] = ElementAccion(
              id: acciones[index].id,
              text1: acciones[index].text1,
              numberAccion: acciones[index].numberAccion,
              textSize: acciones[index].textSize,
              espacioPadding: acciones[index].espacioPadding,
              espacioAlto: acciones[index].espacioAlto,
              btnWidth: acciones[index].btnWidth,
              btnHeight: acciones[index].btnHeight,
              textSituacionWidth: acciones[index].textSituacionWidth,
              imgWidth: imgWidth,
              onPressedGaleria: acciones[index].onPressedGaleria,
              onPressedArasaac: acciones[index].onPressedArasaac,
              accionText: acciones[index].accionText,
              accionImage: bytes,
              color: acciones[index].color,
              flagAdolescencia: acciones[index].flagAdolescencia,
            );
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

  // Método para cuando selecciono un personaje ya existente
  Future<void> _selectExistPersonaje(
      BuildContext context, String imagePath) async {
    ByteData imageData = await rootBundle.load(imagePath);
    List<int> bytes = imageData.buffer.asUint8List();

    setState(() {
      personajeImage = bytes;
    });
    Navigator.of(context).pop();
  }

  // método para añadir un nuevo ElementAccion
  void _addAccion() {
    setState(() {
      String accionText = 'Acción ' + (acciones.length + 1).toString() + "*";

      bool flag;
      if (!changeGrupo)
        flag = defaultGrupo.nombre == "Adolescencia";
      else
        flag = selectedGrupo!.nombre == "Adolescencia";

      acciones.add(ElementAccion(
        text1: accionText,
        numberAccion: acciones.length + 1,
        textSize: textSize,
        espacioPadding: widthTxtPersonaje,
        espacioAlto: espacioAlto,
        btnWidth: btnWidth,
        btnHeight: btnHeight,
        textSituacionWidth: textSituacionWidth,
        imgWidth: imgWidth,
        onPressedGaleria: () => _selectNewActionGallery(acciones.length - 1),
        onPressedArasaac: () => _selectNewActionArasaac(acciones.length - 1),
        flagAdolescencia: flag,
      ));
    });
  }

  // método para eliminar el ultimo ElementAccion
  Future<void> _removeAccion() async {
    setState(() {
      accionesToDelete.add(acciones[acciones.length - 1]);
      acciones.removeLast();
    });
  }

  // Método para comprobar que los parametros obligatorios están completos
  bool _completedParams() {
    bool correct = true;

    if (situacionText.trim().isEmpty) {
      correct = false;
      setState(() {
        colorSituacion = Colors.red;
      });
    } else
      colorSituacion = Colors.transparent;

    for (int i = 0; i < acciones.length; i++) {
      if (acciones[i].accionImage.isEmpty ||
          (acciones[i].accionText.isEmpty &&
              selectedGrupo?.nombre != "Adolescencia") ||
          acciones[i].accionText.characters.length > 30) {
        correct = false;
        setState(() {
          acciones[i].color = Colors.red;
        });
      } else
        acciones[i].color = Colors.transparent;
    }
    return correct;
  }

  // Método para editar una pregunta y sus acciones
  Future<void> _editRutina() async {
    _editPregunta();
    _editAcciones();
  }

  // Método para editar una pregunta de la BBDD
  Future<void> _editPregunta() async {
    Database db = await openDatabase('rutinas.db');
    await updatePregunta(db, widget.situacionRutina.id!, situacionText,
        Uint8List.fromList(personajeImage), selectedGrupo!.id);
  }

  // Método para editar acciones de la BBDD
  Future<void> _editAcciones() async {
    Database db = await openDatabase('rutinas.db');
    for (int i = 0; i < acciones.length; i++) {
      if (i < this.sizeAccionesInitial) {
        if (selectedGrupo!.nombre != "Adolescencia") {
          await db.update(
            'accion',
            {
              'texto': acciones[i].accionText,
              'orden': i,
              'imagen': acciones[i].accionImage,
              'preguntaId': widget.situacionRutina.id,
            },
            where: 'id = ?',
            whereArgs: [acciones[i].id],
          );
        } else {
          await db.update(
            'accion',
            {
              'texto': "",
              'orden': i,
              'imagen': acciones[i].accionImage,
              'preguntaId': widget.situacionRutina.id,
            },
            where: 'id = ?',
            whereArgs: [acciones[i].id],
          );
        }
      } else {
        if (selectedGrupo!.nombre != "Adolescencia") {
          await db.insert(
            'accion',
            {
              'texto': acciones[i].accionText,
              'orden': i,
              'imagen': acciones[i].accionImage,
              'preguntaId': widget.situacionRutina.id,
            },
          );
        } else {
          await db.insert(
            'accion',
            {
              'texto': "",
              'orden': i,
              'imagen': acciones[i].accionImage,
              'preguntaId': widget.situacionRutina.id,
            },
          );
        }
      }
    }
    for (int i = 0; i < accionesToDelete.length; i++)
      deleteAccion(db, accionesToDelete[i].id!);
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

  // Método para cargar las acciones de la pregunta seleccionada
  void _loadAcciones() async {
    List<Accion> aux = await getAcciones(widget.situacionRutina.id!);

    for (int i = 0; i < aux.length; i++) {
      String txt;
      if (i == 0 || i == 1)
        txt = "Acción ${i + 1}*:";
      else
        txt = "Acción ${i + 1}:";

      ElementAccion elementAccion = new ElementAccion(
        id: aux[i].id,
        text1: txt,
        numberAccion: i + 1,
        textSize: textSize,
        espacioPadding: widthTxtPersonaje,
        espacioAlto: espacioAlto,
        btnWidth: btnWidth,
        btnHeight: btnHeight,
        textSituacionWidth: textSituacionWidth,
        imgWidth: imgWidth,
        onPressedGaleria: () => _selectNewActionGallery(i),
        onPressedArasaac: () => _selectNewActionArasaac(i),
        accionText: aux[i].texto,
        flagAdolescencia: widget.grupo.nombre == "Adolescencia",
        accionImage: aux[i].imagen!.toList(),
      );
      setState(() {
        this.acciones.add(elementAccion);
      });
    }
    this.sizeAccionesInitial = this.acciones.length;
  }

  void _removePregunta(int preguntaId) {
    removePreguntaRutinas(preguntaId);
  }

  // Método para obtener todos los path de los personajes
  Future<List<String>> _getExistsPersonajes(String folderPath) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final List<String> imagePaths = manifestMap.keys
        .where((String key) => key.startsWith(folderPath))
        .toList();

    setState(() {
      personajes = imagePaths;
    });

    return imagePaths;
  }
}
