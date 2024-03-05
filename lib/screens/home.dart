import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutinas/provider/MyProvider.dart';

import '../db/obj/grupo.dart';
import '../db/obj/jugador.dart';
import '../widgets/ImageTextButton.dart';
import 'ayuda.dart';
import 'jugar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Grupo> gruposList; // lista de grupos obtenidos de la BBDD
  late String txtGrupo; // texto del grupo seleccionado
  late List<bool>
      btnGruposFlags; // para tener en cuenta que boton ha sido pulsado

  double titleSize = 0.0,
      textSize = 0.0,
      espacioPadding = 0.0,
      espacioAlto = 0.0,
      imgHeight = 0.0,
      imgWidth = 0.0;

  // Datos que se deben de completar para empezar a jugar
  String nombre = "Introduce tu nombre";
  Grupo? selectedGrupo = null;

  late AlertDialog dialogoCamposIncompletos;

  @override
  void initState() {
    super.initState();
    _getGrupos();
    gruposList = [];
    txtGrupo = "";
    btnGruposFlags = [false, false, false];
  }

  @override
  Widget build(BuildContext context) {
    _updateVariablesSize();
    _createDialogs();

    var myProvider = Provider.of<MyProvider>(context);

    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(espacioPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título Rutinas
                Text(
                  "Rutinas",
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: titleSize,
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                // Explicación pantalla
                Text(
                  'Antes de empezar, ¿puedes decirnos tu nombre y de qué grupo eres? '
                  'Esto nos va a ayudar a seguir tu progreso. '
                  '¡Muchas gracias!',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                SizedBox(height: espacioAlto), // Espacio entre los textos
                // Fila para el nombre
                Row(
                  children: [
                    Text(
                      'Nombre:',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                    SizedBox(width: espacioAlto),
                    Expanded(
                      child: TextField(
                        onChanged: (text) {
                          this.nombre = text;
                        },
                        decoration: InputDecoration(
                          hintText: 'Introduce tu nombre',
                          hintStyle: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: espacioAlto),
                  ],
                ),
                SizedBox(height: espacioAlto),
                // Fila para el grupo
                Row(
                  children: [
                    Text(
                      'Grupo:',
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                    SizedBox(width: espacioAlto + espacioAlto / 1.5),
                    Text(
                      txtGrupo,
                      style: TextStyle(
                        fontFamily: 'ComicNeue',
                        fontSize: textSize,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: espacioAlto),
                // Fila para los botones de seleccionar grupo
                Row(
                  children: gruposList.isNotEmpty
                      ? gruposList.asMap().entries.map((entry) {
                          int index = entry.key;
                          Grupo grupo = entry.value;
                          return Row(
                            children: [
                              ImageTextButton(
                                image: Image.asset(
                                  'assets/img/grupos/' +
                                      grupo.nombre.toLowerCase() +
                                      '.png',
                                  width: imgWidth,
                                  height: imgHeight,
                                ),
                                text: Text(
                                  grupo.nombre + '\n' + grupo.edades,
                                  style: TextStyle(
                                    fontFamily: 'ComicNeue',
                                    fontSize: textSize,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectGroup(index);
                                  });
                                },
                                buttonColor: btnGruposFlags[index]
                                    ? Colors.grey
                                    : Colors.transparent,
                              ),
                              if (index < gruposList.length - 1)
                                SizedBox(width: espacioPadding),
                            ],
                          );
                        }).toList()
                      : [Center(child: Text('No hay grupos disponibles'))],
                ),
                SizedBox(height: espacioAlto * 2),
                Text(
                  '¿Qué quieres hacer?',
                  style: TextStyle(
                    fontFamily: 'ComicNeue',
                    fontSize: textSize,
                  ),
                ),
                // Fila para los botones de Jugar, Ayuda y Terapeuta
                Row(
                  children: [
                    ImageTextButton(
                      image: Image.asset('assets/img/botones/jugar.png',
                          width: imgWidth, height: imgHeight),
                      text: Text(
                        'Jugar',
                        style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black),
                      ),
                      onPressed: () async {
                        if (this.nombre.trim() != "" &&
                            this.nombre != "Introduce tu nombre" &&
                            selectedGrupo != null) {
                          Jugador jugador = new Jugador(
                              nombre: nombre.toString(),
                              grupoId: selectedGrupo!.id);

                          myProvider.jugador = await insertJugador(jugador);
                          myProvider.grupo = selectedGrupo!;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Jugar()),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return dialogoCamposIncompletos;
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(width: espacioAlto),
                    ImageTextButton(
                      image: Image.asset('assets/img/botones/ayuda.png',
                          width: imgWidth, height: imgHeight),
                      text: Text(
                        'Ir a ayuda',
                        style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Ayuda(origen: 'home')),
                        );
                      },
                    ),
                    SizedBox(width: espacioAlto),
                    ImageTextButton(
                      image: Image.asset('assets/img/botones/terapeuta.png',
                          width: imgWidth, height: imgHeight),
                      text: Text(
                        'Soy terapeuta',
                        style: TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: textSize,
                            color: Colors.black),
                      ),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // metodo para darle valor a las variables relacionadas con tamaños de fuente, imagenes, etc.
  void _updateVariablesSize() {
    Size screenSize = MediaQuery.of(context).size; // tamaño del dispositivo

    final isHorizontal =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isHorizontal) {
      titleSize = screenSize.width * 0.08;
      textSize = screenSize.width * 0.02;
      espacioPadding = screenSize.height * 0.02;
      espacioAlto = screenSize.height * 0.02;
      imgHeight = screenSize.height / 4;
      imgWidth = screenSize.width / 4;
    } else {
      titleSize = screenSize.width * 0.10;
      textSize = screenSize.width * 0.03;
      espacioPadding = screenSize.height * 0.03;
      espacioAlto = screenSize.height * 0.03;
      imgHeight = screenSize.height / 5;
      imgWidth = screenSize.width / 5;
    }
  }

  // metodo para crear los cuadro de dialogos
  void _createDialogs() {
    // CUADROS DE DIALOGO
    // cuadro de dialogo para cuando quiere jugar pero los datos son incompletos
    dialogoCamposIncompletos = AlertDialog(
      title: Text(
        'Aviso',
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: titleSize,
        ),
      ),
      content: Text(
        "Por favor, recuerda indicarnos tu nombre y grupo para poder medir tu progreso. "
        "Mientras no tengamos esos datos, no podemos dejarte jugar. "
        "\n¡Lo sentimos!",
        style: TextStyle(
          fontFamily: 'ComicNeue',
          fontSize: textSize,
        ),
      ),
      actions: [
        Row(
          children: [
            ImageTextButton(
                image: Image.asset('assets/img/botones/volver.png',
                    width: imgWidth, height: imgHeight),
                text: Text(
                  'Volver',
                  style: TextStyle(
                      fontFamily: 'ComicNeue',
                      fontSize: textSize,
                      color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ],
    );
  }

  // Método para obtener la lista de grupos de la BBDD
  Future<void> _getGrupos() async {
    try {
      List<Grupo> grupos = await getGrupos();
      setState(() {
        gruposList = grupos;
      });
    } catch (e) {
      print("Error al obtener la lista de grupos: $e");
    }
  }

  // Método para cuando se selecciona un grupo
  void _selectGroup(int index) {
    btnGruposFlags[index] = !btnGruposFlags[index]; // se actualiza su pulsación
    if (btnGruposFlags[index]) {
      // si está activado
      txtGrupo = gruposList[index].nombre; // se muestra el nombre
      selectedGrupo = gruposList[index]; // se actualiza el id seleccionado
      for (int i = 0; i < btnGruposFlags.length; i++) // pongo los demás a false
        if (index != i) btnGruposFlags[i] = false;
    } else {
      // si con la pulsación ha sido deseleccionado
      txtGrupo = "";
      selectedGrupo = null;
    }
  }
}
