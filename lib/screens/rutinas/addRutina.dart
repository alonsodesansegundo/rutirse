import 'dart:convert';
import 'dart:io';

import 'package:Rutirse/db/obj/accion.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:sqflite/sqflite.dart';

import '../../db/obj/grupo.dart';
import '../../db/obj/situacionRutina.dart';
import '../../widgets/ArasaacAccionDialog.dart';
import '../../widgets/ArasaacPersonajeDialog.dart';
import '../../widgets/ElementAccion.dart';
import '../../widgets/ImageTextButton.dart';
import '../main.dart';

///Pantalla que nos permite añadir una nueva pregunta, con sus correspondientes respuestas al juego Rutinas
class AddRutina extends StatefulWidget {
  @override
  _AddRutinaState createState() => _AddRutinaState();
}

/// Estado asociado a la pantalla [AddRutina] que gestiona la lógica
/// y la interfaz de usuario de la pantalla
class _AddRutinaState extends State<AddRutina> {
  late double titleSize,
      textSize,
      espacioPadding,
      espacioAlto,
      imgVolverHeight,
      textSituacionWidth,
      btnWidth,
      btnHeight,
      imgWidth,
      widthTxtPersonaje;

  late ImageTextButton btnVolver;

  late List<Grupo> grupos;

  Grupo? selectedGrupo; // Variable para almacenar el grupo seleccionado

  late String situacionText, keywords;

  late ElevatedButton btnPersonajeExistente,
      btnGaleria,
      btnArasaac,
      btnEliminarPersonaje;

  late Dialog existPersonajeDialog;

  late ArasaacPersonajeDialog arasaacPersonajeDialog;

  late ArasaacAccionDialog arasaacAccionDialog;

  late AlertDialog incompletedParamsDialog,
      completedParamsDialog,
      noInternetDialog;

  late List<String> personajes;

  late List<ElementAccion> acciones;

  late bool firstLoad;

  late List<int> personajeImage;

  late Color colorSituacion, colorGrupo;

  @override
  void initState() {
    super.initState();
    firstLoad = false;

    grupos = [];
    personajes = [];
    situacionText = "";
    keywords = "";
    firstLoad = false;
    personajeImage = [];
    acciones = [];
    selectedGrupo = null;
    colorSituacion = Colors.transparent;
    colorGrupo = Colors.transparent;

    _initializeState();
  }

  Future<void> _initializeState() async {
    await _getGrupos();
    await _getExistsPersonajes('assets/img/personajes/');

    _createDialogs();
  }

  @override
  Widget build(BuildContext context) {
    if (!firstLoad) {
      firstLoad = true;
      _createVariablesSize();
      _createButtons();
      acciones = [
        ElementAccion(
          text1: 'Acción 1*:',
          numberAccion: 1,
          textSize: textSize,
          espacioPadding: widthTxtPersonaje,
          espacioAlto: espacioAlto,
          btnWidth: btnWidth,
          btnHeight: btnHeight,
          imgWidth: imgWidth,
          onPressedGaleria: () => _selectNewActionGallery(0),
          onPressedArasaac: () => _selectNewActionArasaac(0),
          textSituacionWidth: textSituacionWidth * 0.75,
        ),
        ElementAccion(
          text1: 'Acción 2*:',
          numberAccion: 2,
          textSize: textSize,
          espacioPadding: widthTxtPersonaje,
          espacioAlto: espacioAlto,
          btnWidth: btnWidth,
          btnHeight: btnHeight,
          imgWidth: imgWidth,
          onPressedGaleria: () => _selectNewActionGallery(1),
          onPressedArasaac: () => _selectNewActionArasaac(1),
          textSituacionWidth: textSituacionWidth * 0.75,
        ),
      ];
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
                          'Rutinas',
                          style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: titleSize,
                          ),
                        ),
                        Text(
                          'Añadir rutina',
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
                        'Aquí puedes crear nuevas rutinas para el juego.',
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
                                acciones = acciones.map((accion) {
                                  return ElementAccion(
                                    text1: accion.text1,
                                    numberAccion: accion.numberAccion,
                                    textSize: accion.textSize,
                                    espacioPadding: accion.espacioPadding,
                                    espacioAlto: accion.espacioAlto,
                                    btnWidth: accion.btnWidth,
                                    btnHeight: accion.btnHeight,
                                    textSituacionWidth:
                                        accion.textSituacionWidth,
                                    imgWidth: imgWidth,
                                    onPressedGaleria: accion.onPressedGaleria,
                                    onPressedArasaac: accion.onPressedArasaac,
                                    accionText: accion.accionText,
                                    accionImage: accion.accionImage,
                                    color: accion.color,
                                    flagAdolescencia:
                                        selectedGrupo?.nombre == "Adolescencia",
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
                    onChanged: (text) {
                      this.situacionText = text;
                    },
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
                            )),
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
                          _addRutina();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return completedParamsDialog;
                            },
                          );
                        }
                      },
                      child: Text("Añadir rutina"),
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

  ///Método que nos permite cargar las rutas de las imagenes de los personajes ya existentes
  ///<br><b>Parámetros</b><br>
  ///[folderPath] Ruta en la que se encuentran las imágenes de los personajes
  ///<br><b>Salida</b><br>
  ///Lista con las rutas completas de donde se encuentran las imágenes de los personajes
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

  ///Método que nos permite obtener el ancho que se supone que ocuparía una cadena de texto
  ///<br><b>Parámetros</b><br>
  ///[text] Cadena de texto de la que queremos obtener el valor de ancho<br>
  ///[context] El contexto de la aplicación, que proporciona acceso a información
  ///sobre el entorno en el que se está ejecutando el widget, incluyendo el tamaño de la pantalla
  ///<br><b>Salida</b><br>
  ///Valor double que corresponde al ancho que ocuparía
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
    widthTxtPersonaje =
        getWidthOfText("(máx. 30 caracteres)", context) + espacioPadding * 1.5;
  }

  ///Método encargado de inicializar los botones que tendrá la pantalla
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

  ///Método encargado de inicializar los cuadros de dialogo que tendrá la pantalla
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
        'La rutina no se ha podido añadir, revisa que has completado todos los campos obligatorios'
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
        'La rutina se ha añadido con éxito. Agradecemos tu colaboración, y los jugadores seguro que todavía más!',
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

  ///Método que nos permite seleccionar un personaje existente para la pregunta, dicha imagen se guarda en la variable [personajeImage]
  Future<void> _selectExistPersonaje(
      BuildContext context, String imagePath) async {
    ByteData imageData = await rootBundle.load(imagePath);
    List<int> bytes = imageData.buffer.asUint8List();

    setState(() {
      personajeImage = bytes;
    });
    Navigator.of(context).pop();
  }

  ///Método que nos permite seleccionar una imagen de nuestra galería para el personaje de la pregunta, dicha imagen se guarda en la variable [personajeImage]
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

  ///Método que nos permite seleccionar una imagen para la accion a través de la galería
  ///<br><b>Parámetros</b><br>
  ///[index] Índice de la accion que queremos cambiar la imagen
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

  ///Método que nos permite seleccionar una imagen para la accion a través de un cuadro de diálogo en el
  ///que se muestran pictogramas de ARASAAC, permitiendo filtrar la búsqueda por texto
  ///<br><b>Parámetros</b><br>
  ///[index] Índice de la accion que queremos cambiar la imagen
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

  ///Método que nos permite añadir un nuevo [ElementAccion] para que haya más acciones en la pregunta
  void _addAccion() {
    setState(() {
      String accionText = 'Acción ' + (acciones.length + 1).toString() + "*";

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
        flagAdolescencia: selectedGrupo?.nombre == "Adolescencia",
      ));
    });
  }

  ///Método que nos permite eliminar el útlimo [ElementAccion] para que haya menos acciones en la pregunta
  void _removeAccion() {
    setState(() {
      acciones.removeLast();
    });
  }

  ///Método que se encarga de comprobar que están rellenados todos los campos y opciones para poder añadir una nueva pregunta al juego Rutinas
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

  ///Método encargado de añadir una pregunta y sus respectivas acciones a ordenar
  Future<void> _addRutina() async {
    int preguntaId = await _addPregunta();
    _addAcciones(preguntaId);
  }

  ///Método encargado de añadir una nueva pregunta al juego Rutinas
  ///<br><b>Salida</b><br>
  ///Identificador de la pregunta que se acaba de añadir
  Future<int> _addPregunta() async {
    int preguntaId;
    Database db = await openDatabase('rutinas.db');

    if (personajeImage.isEmpty)
      preguntaId =
          await insertSituacionRutina(db, situacionText, [], selectedGrupo!.id);
    else
      preguntaId = await insertSituacionRutina(db, situacionText,
          Uint8List.fromList(personajeImage), selectedGrupo!.id);
    return preguntaId;
  }

  ///Método encargado de añadir una accion al juego Rutinas
  ///<br><b>Parámetros</b><br>
  ///[preguntaId] Identificador de la pregunta a la que corresponde la accion que queremos añadir
  Future<void> _addAcciones(int preguntaId) async {
    Database db = await openDatabase('rutinas.db');
    for (int i = 0; i < acciones.length; i++) {
      if (selectedGrupo!.nombre != "Adolescencia")
        await insertAccion(db, acciones[i].accionText, i,
            Uint8List.fromList(acciones[i].accionImage), preguntaId);
      else
        await insertAccion(
            db, "", i, Uint8List.fromList(acciones[i].accionImage), preguntaId);
    }
  }
}
